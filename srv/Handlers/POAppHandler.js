const cds = require("@sap/cds");
const {
  aHeaderFieldLists,
  aHeaderAccuracyLists,
  aItemFieldLists,
  aItemAccuracyLists,
} = require("../Utils/Fields");

module.exports = class POAppService extends cds.ApplicationService {
  async init() {
    let hana_db,
      aidox,
      { POHeader, POItem, PO_Log } = cds.entities("tablemodel.srv.POServices");
    try {
      hana_db = await cds.connect.to("db");
      aidox = await cds.connect.to("aidox");
    } catch (err) {
      console.log("Some instances are not connected properly", err);
    }

    this.on("extract_and_save_po_data", async (req) => {
      // console.log(req.data.data);
      let payload = req.data.data,
        options = {
          schemaName: "SAP_purchaseOrder_schema",
          clientId: "default",
          documentType: "purchaseOrder",
          templateID: "Invoice_JH_Template",
        };

      let header_insert_resp,
        log_insert_resp,
        iSequence = 0;
      const tx = cds.transaction(req),
        ID = cds.utils.uuid(),
        userId = req.user.id;
      try {
        await hana_db.run(
          INSERT.into(POHeader).entries({
            ID: ID,
            extraction_status: "Pending",
          })
        );
        iSequence += 1;
        await hana_db.run(
          INSERT.into(PO_Log).entries({
            Parent_PO_ID: ID,
            EventType: "PO Received",
            EventDetails: `PO from MailID : ${req.data.data.emailid} received`,
            PerformedBy: userId,
            Sequence: iSequence,
          })
        );
      } catch (error) {
        console.log(error.message);
        return {
          Message: "Failed to update life cycle log table",
        };
      }

      // convert base64 to BLOB
      const blob = base64ToBlob(payload.content, payload.mimeType);

      // Prepare Formdata
      let formData = new FormData();

      formData.append("file", blob, payload.filename);
      formData.append("options", JSON.stringify(options));

      let oAidox, INSERT_resp, inserted_id;

      try {
        iSequence += 1;
        await hana_db.run(
          INSERT.into(PO_Log).entries({
            Parent_PO_ID: ID,
            EventType: "Extraction service",
            EventDetails: `Data Extraction from PO Document Started`,
            PerformedBy: userId,
            Sequence: iSequence,
          })
        );

        oAidox = await aidox.send({
          method: "POST",
          path: "/document/jobs",
          headers: {
            "Content-Type": "multipart/form-data",
            Accept: "multipart/mixed",
          },
          data: formData,
        });

        iSequence += 1;
        await hana_db.run(
          INSERT.into(PO_Log).entries({
            Parent_PO_ID: ID,
            EventType: "Extraction service",
            EventDetails: `Data Extraction from PO Document completed`,
            PerformedBy: userId,
            Sequence: iSequence,
          })
        );

        // console.log(oAidox);
      } catch (err) {
        console.log("Error at AI.Dox Call service section ->", err);
        iSequence += 1;
        await hana_db.run(
          INSERT.into(PO_Log).entries({
            Parent_PO_ID: ID,
            EventType: "Extraction service",
            EventDetails: `${err.message}`,
            PerformedBy: userId,
            Sequence: iSequence,
          })
        );

        return { status: "Error", message: err.message };
      }
      let oHeaderData;
      if (oAidox !== null || oAidox !== undefined) {
        oHeaderData = {
          mailDateTime: payload.mailDateTime,
          emailid: payload.emailid,
          mailSubject: payload.mailSubject,
          dox_id: oAidox.id,
          extraction_status: "Pending",
        };

        // Update HANA Cloud database
        try {
          // Save the status in the execution log table
          INSERT_resp = await UPDATE("db.tables.POHeader")
            .set(oHeaderData)
            .where({ ID: ID });
          console.log("Data Insert Result :", INSERT_resp);

          iSequence += 1;
          await hana_db.run(
            INSERT.into(PO_Log).entries({
              Parent_PO_ID: ID,
              EventType: "Extraction service",
              EventDetails: `Extracted PO Data saved in database`,
              PerformedBy: userId,
              Sequence: iSequence,
            })
          );
        } catch (err) {
          console.log("Error while inserting data ->", err);

          iSequence += 1;
          await hana_db.run(
            INSERT.into(PO_Log).entries({
              Parent_PO_ID: ID,
              EventType: "Extraction service",
              EventDetails: `${err.message}`,
              PerformedBy: userId,
              Sequence: iSequence,
            })
          );

          return { status: "custom_error", message: err.message };
        }

        // insert statement record ID
        if (INSERT_resp !== null || INSERT_resp !== undefined) {
          inserted_id = ID;
          console.log(inserted_id);
        }

        // Execute after 15 secs after uploading the document to DOX
        sleep(15000).then(async () => {
          // Get the extraction result from the DOX service
          await refresh_extraction_result(oAidox.id, inserted_id);
        });
      }

      return {
        id: oAidox.id != null ? oAidox.id : "",
        status: "Success",
        message: "Document submitted for data extraction",
      };
    });

    this.after("READ", "POHeader", async (data) => {
      let oDB,
        aHeaders,
        oHeader,
        Items,
        aItem,
        iOverall_ac = 0,
        iOverall_item_ac = 0,
        iAvg_Counter = 0,
        { POHeader, PoItems } = cds.entities("tablemodel.srv.POServices");
      try {
        // DB - Service
        oDB = await cds.connect.to("db");
        // console.log(oDB);

        // Get the Header details
        aHeaders = await oDB.run(SELECT.from(POHeader));

        // Get the item details
        Items = await SELECT.from("db.Tables.PoItems");

        // Loop the fetched header details and calculate the overall accuracy percentage
        for (const d of data) {
          oHeader = aHeaders.find((head) => head.ID == d.ID);
          aItem = Items.filter((it) => it.Parent_ID == d.ID);

          iOverall_ac =
            parseFloat(oHeader.documentNumber_ac) +
            parseFloat(oHeader.netAmount_ac) +
            parseFloat(oHeader.currencyCode_ac) +
            parseFloat(oHeader.documentDate_ac);
          iAvg_Counter = 4;
          iOverall_item_ac = 0;

          for (const item of aItem) {
            iOverall_item_ac +=
              parseFloat(item.customerMaterialNumber_ac) +
              parseFloat(item.quantity_ac) +
              parseFloat(item.unitOfMeasure_ac) +
              parseFloat(item.netAmount_ac) +
              parseFloat(item.unitPrice_ac) +
              parseFloat(item.description_ac);
            iAvg_Counter += 6;
          }

          iOverall_ac = (iOverall_ac + iOverall_item_ac) / iAvg_Counter;

          d.overall_ac = parseInt(iOverall_ac.toFixed(2));
        }
      } catch (err) {
        console.log(
          'Error in this.after("READ", "POHeader", async (data))',
          err
        );
      }
    });

    /**
     * Function to convert the base64 large string value to blob object
     * @param {*} base64String - Base64 large string value
     * @param {*} contentType - type of the content eg. PDF, jpeg, png
     * @returns blob object
     */
    function base64ToBlob(base64String, contentType = "") {
      const byteCharacters = atob(base64String);
      const byteArrays = [];

      for (let i = 0; i < byteCharacters.length; i++) {
        byteArrays.push(byteCharacters.charCodeAt(i));
      }

      const byteArray = new Uint8Array(byteArrays);
      return new Blob([byteArray], { type: contentType });
    }

    /**
     * halt the execution for specified time period in milleseconds
     * @param {*} ms - Mille-second value
     * @returns resolved promise
     */
    function sleep(ms) {
      return new Promise((resolve) => setTimeout(resolve, ms));
    }

    /**
     * Checks out the extracted values and accuracy and saves them in HANA cloud system
     * @param {*} ai_dox_id AI-Doc.Extraction ID
     * @param {*} inserted_id Inserted DB record's ID
     * @returns nothing
     */
    async function refresh_extraction_result(ai_dox_id, inserted_id) {
      let oAidox_get,
        aHeaderValues,
        aItemValues,
        oHeaderData = {};
      try {
        oAidox_get = await aidox.send({
          method: "GET",
          path: `/document/jobs/${ai_dox_id}`,
        });
        console.log(oAidox_get);
      } catch (err) {
        console.log(
          "Error in getting the extracted values from DOX service ->",
          err
        );
        return {
          status: "Error in getting the extracted values from DOX service",
          message: err.message,
        };
      }
      if (oAidox_get.status === "DONE") {
        // Hit the DOX api to get the schema structure using the schema ID
        let oDox_schema,
          sSchemaId = "fbab052e-6f9b-4a5f-b42f-29a8162eb1bf"; // Purchase Order schema
        try {
          oDox_schema = await aidox.send({
            method: "GET",
            path: `/schemas/${sSchemaId}?clientId=default`,
          });
        } catch (err) {
          console.log("Error at taking schema structure ->", err);
          return {
            status: "Error at taking schema structure",
            message: err.message,
          };
        }

        if (oDox_schema !== null || oDox_schema !== undefined) {
          if (oDox_schema.hasOwnProperty("headerFields")) {
            console.log("Reading header fields using structure");

            // Assign the extracted headerfield for search
            aHeaderValues = oAidox_get?.extraction?.headerFields;
            console.log(aHeaderValues);

            // iterate the Header structure to find the values from extracted data
            for (const key in oDox_schema.headerFields) {
              if (
                Object.prototype.hasOwnProperty.call(
                  oDox_schema.headerFields,
                  key
                )
              ) {
                const schemaElement = oDox_schema.headerFields[key];

                if (
                  schemaElement.hasOwnProperty("name") &&
                  aHeaderFieldLists.includes(schemaElement.name)
                ) {
                  console.log("Header schema Element -->", schemaElement);

                  // Find the matched field from extraction result
                  let oExtracted = aHeaderValues.find(
                    (f) => f?.name === schemaElement.name
                  );
                  if (oExtracted) {
                    oHeaderData[schemaElement.name] =
                      (oExtracted?.value).toString();

                    // Logic to include the accuracy fields that are maintained in table
                    let sAcc_property = schemaElement.name + "_ac";
                    if (aHeaderAccuracyLists.includes(sAcc_property)) {
                      oHeaderData[sAcc_property] = (
                        oExtracted?.confidence * 100
                      )
                        .toFixed(2)
                        .toString();
                    }
                  }
                }
              }
            }
          }

          // Check if item field structure exists
          if (oDox_schema.hasOwnProperty("lineItemFields")) {
            console.log("Reading item fields using structure");
            let aNewItems = [];

            // Assign the extracted item fields for search
            aItemValues = oAidox_get?.extraction?.lineItems;
            console.log(aItemValues);

            for (let i = 0; i < aItemValues.length; i++) {
              const oItem = aItemValues[i];
              let oNewItem = {};

              // iterate the Item structure to find the values from extracted data
              for (const key in oDox_schema.lineItemFields) {
                if (
                  Object.prototype.hasOwnProperty.call(
                    oDox_schema.lineItemFields,
                    key
                  )
                ) {
                  const schemaElement = oDox_schema.lineItemFields[key];

                  if (
                    schemaElement.hasOwnProperty("name") &&
                    aItemFieldLists.includes(schemaElement.name)
                  ) {
                    console.log("Element schema -->", schemaElement);

                    // Find the matched field from extraction result
                    let oExtracted = oItem.find(
                      (f) => f?.name === schemaElement.name
                    );
                    if (oExtracted) {
                      oNewItem[schemaElement.name] =
                        (oExtracted?.value).toString();

                      // Logic to include the accuracy fields that are maintained in table
                      let sAcc_property = schemaElement.name + "_ac";
                      if (aItemAccuracyLists.includes(sAcc_property)) {
                        oNewItem[sAcc_property] = (oExtracted?.confidence * 100)
                          .toFixed(2)
                          .toString();
                      }
                    }
                  }
                }
              }
              aNewItems.push(oNewItem);
            }
            oHeaderData["PoItems"] = aNewItems;
          }
          console.log("Complete data --> ", oHeaderData);
        }

        // Update the data table with the extracted values
        let UPDATE_resp;
        try {
          oHeaderData["extraction_status"] = "Done";
          UPDATE_resp = await UPDATE(POHeader, inserted_id).with(oHeaderData);
        } catch (err) {
          console.log("Error updating the table ->", err);
        }
      } else {
        console.log(
          "DOX extraction status us still pending. Try refreshing from UI"
        );
      }
    }

    this.on("refresh_extractions", "POHeader", async (req) => {
      let sRecordID = req.params[0],
        oRecord,
        { POHeader, PO_Log } = cds.entities("tablemodel.srv.POServices");
      console.log("Selected Record ID", sRecordID);

      let iSequence;
      try {
        // Build a CQN that counts all rows in InvoiceLog where ParentInvoice_ID = invoiceID
        const [{ cnt }] = await cds.run(
          SELECT.from(PO_Log)
            .columns([
              {
                func: "count",
                args: ["*"],
                as: "cnt",
              },
            ])
            .where({
              Parent_PO_ID: sRecordID,
            })
        );
        iSequence = cnt;

        iSequence += 1;
        await hana_db.run(
          INSERT.into(PO_Log).entries({
            Parent_PO_ID: sRecordID,
            EventType: "Manual Refresh",
            EventDetails: `Refresh extraction service for PO Data`,
            PerformedBy: req.user.id,
            Sequence: iSequence,
          })
        );
      } catch (error) {
        console.log(error.message);
      }
      try {
        oRecord = await hana_db.run(
          SELECT.from(POHeader, (po) => {
            po("dox_id");
          }).where({ ID: sRecordID })
        );
        console.log(oRecord);
        await refresh_extraction_result(oRecord[0].dox_id, sRecordID);

        iSequence += 1;
        await hana_db.run(
          INSERT.into(PO_Log).entries({
            Parent_PO_ID: sRecordID,
            EventType: "Manual Refresh",
            EventDetails: `Response PO Data received from extraction service`,
            PerformedBy: req.user.id,
            Sequence: iSequence,
          })
        );
      } catch (err) {
        console.log("Error ->", err);
      }
    });

    this.on("post_so", "POHeader", async (req) => {
      let sRecordID = req.params[0],
        oheader,
        oItem,
        osalesService,
        oS4Resp,
        oreq,
        iSequence,
        { POHeader, POItem } = cds.entities("tablemodel.srv.POServices");
      console.log("Selected Record ID", sRecordID);
      try {
        oheader = await hana_db.run(
          SELECT.from(POHeader).where({ ID: sRecordID })
        );
        oItem = await hana_db.run(
          SELECT.from(POItem).where({ Parent_ID: sRecordID })
        );
      } catch (error) {
        console.log("Error ->", error);
      }

        let SalesOrderNumber = oheader[0].SalesOrderNumber;

      if (SalesOrderNumber === '' && SalesOrderNumber === undefined && SalesOrderNumber === null) {
        //Build Item Data
        let aItemData = [];


        oItem.forEach((element) => {
          console.log(element);
          let oTemp = {
            Material:
              element.materialNumber === ""
                ? element.customerMaterialNumber
                : element.materialNumber,
            RequestedQuantity: element.quantity,
          };
          aItemData.push(oTemp);
        });

        //Build Header Data

        oreq = {
          SalesOrderType: "OR",
          SalesOrganization: "1710",
          DistributionChannel: "10",
          OrganizationDivision: "00",
          SoldToParty: "17100003",
          PurchaseOrderByCustomer: oheader[0].documentNumber,
          to_Item: aItemData,
        };
          console.log(oreq);
        try {
            // Connecting to Sales Order Service
            osalesService = await cds.connect.to("saleordersrv");
            console.log("Sales Order Service : ", osalesService);
            
            // Posting invoice to S/4 System
            oS4Resp = await osalesService.send({
                method: "POST",
                path: "A_SalesOrder",
                headers: {
                    contentType: "application/json",
                    "x-Requested-With": "X",
                },
                data: oreq,
            });
            console.log("API Respponse ----> ", oS4Resp);

            // SalesOrder created successfully ? Yes

            if (oS4Resp.SalesOrder !== undefined &&
                oS4Resp.SalesOrder !== "" &&
                oS4Resp.SalesOrder !== null) {
                
                
                // Build a CQN that counts all rows in InvoiceLog where ParentInvoice_ID = invoiceID
                const [{
                    cnt
                }] = await cds.run(
                    SELECT.from(PO_Log)
                    .columns([{
                        func: "count",
                        args: ["*"],
                        as: "cnt",
                    }, ])
                    .where({
                        Parent_PO_ID: sRecordID,
                    })
                );
                iSequence = cnt;

                iSequence += 1;
                await cds.run(
                    INSERT.into(PO_Log).entries({
                        Parent_PO_ID: sRecordID,
                        EventType: "Sale Order Posting",
                        EventDetails: `Sale Order posted successfully. Order Number is ${oS4Resp.SalesOrder}`,
                        Sequence: iSequence,
                    })
                );    
                let UPDATE_resp;
                // Save the status in the execution log table
                UPDATE_resp = await UPDATE("db.tables.POHeader")
                    .set({
                        SalesOrderNumber: oS4Resp.SalesOrder,
                        Message : 'Sales Order Created'
                    })
                    .where({
                        ID: sRecordID
                    });
                console.log("Data Insert Result :", UPDATE_resp);

                return {
                    Message: "Sales Order Created and Updated Table Record",
                    RecordUpdated: oS4Resp,
                };
                
            } else {
                iSequence += 1;
                await cds.run(
                    INSERT.into(PO_Log).entries({
                        Parent_PO_ID: sRecordID,
                        EventType: "Sale Order Posting",
                        EventDetails: `Sales order cannot be created in S/4HANA`,
                        Sequence: iSequence,
                    })
                );

                return {
                    Message: "Sales order cannot be created in S/4HANA",
                    RecordUpdated: oS4Resp,
                };
            }

        } catch (error) {
            iSequence += 1;
            await cds.run(
                INSERT.into(PO_Log).entries({
                    Parent_PO_ID: sRecordID,
                    EventType: "Sale Order Posting",
                    EventDetails: `Error in Sale Order posting service in S/4HANA`,
                    Sequence: iSequence,
                })
            );

            return {
                Message: "Error in Sale Order posting service in S/4HANA",
                RecordUpdated: oS4Resp,
            };
        }
      } else {
          console.log('Sales order already created')
        return {
            Message: "Sales Order already created for this lineitem",
        };
      }
    });

    return super.init();
  }
};
