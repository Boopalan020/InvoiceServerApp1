const cds = require("@sap/cds");

module.exports = class InvoiceService extends cds.ApplicationService {
    async init() {
        const {
            InvoiceHeader,
            InvoiceLog
        } = this.entities("db.tables");

        const po_api = await cds.connect.to("poextsrv");
        const suppl_api = await cds.connect.to("suppl_api");
        let hana_db;

        try {
            hana_db = await cds.connect.to("db");
        } catch (err) {
            console.log("Some instances are not connected properly", err);
        }

        // Reading Purchase Order data from External system
        this.on("READ", "PurchaseOrders", async (req) => {
            return po_api.run(req.query);
        });

        // Reading Supplier data from External system
        this.on("READ", "Suppliers", async (req) => {
            return suppl_api.run(req.query);
        });

        // Dynamic App launcher call
        this.on("getTileInfo", async (req) => {
            console.log("Dynamic Log -->", req);

            let {
                InvoiceHeader,
                InvoiceItems
            } = cds.entities(
                    "tablemodel.srv.InvoiceService"
                ),
                aData,
                iCount = 0;

            try {
                aData = await hana_db.run(
                    SELECT.from(InvoiceHeader).where({
                        StatusCode_code: "62",
                    })
                );
                iCount = aData.length;
            } catch (err) {
                console.log(err);
            }

            return {
                subtitle: "Manage process",
                title: "Invoice Processing",
                icon: "sap-icon://collections-insight",
                info: "Task(s) Completed",
                infoState: "Positive",
                number: iCount.toString(),
                // numberDigits: 1,
                // numberFactor: "k",
                // numberState: "Negative",
                // numberUnit: "EUR",
                // stateArrow: "Down"
            };
        });

        ///////////////////////////////////// --- UI - Action Call //////////////////////////////////////////////////////////

        // Update Event for invoice Header
        this.before("UPDATE", "InvoiceHeader", async (req, next) => {
            // // Cancel the workflow, if processflowid has a value!
            // if (req.data.ProcessFlowID != '') {

            //     console.log("Need to cancel the triggered workflow");
            //     try {
            //         // BPA API - Destination service
            //         let oSPA_api = await cds.connect.to("spa_api");

            //         // Payload
            //         let payload_spa = {
            //             "status": "CANCELED",
            //             "cascade": false
            //         };

            //         let bpa_api = await oSPA_api.send({
            //             method: "PATCH",
            //             path: `/workflow/rest/v1/workflow-instances/${req.data.ProcessFlowID}`,
            //             headers: {
            //                 "contentType": "application/json"
            //             },
            //             data: payload_spa
            //         });
            //         console.log(bpa_api);
            //     } catch (err) {
            //         console.log("Error while cancelling Workflow trigger", err);
            //     }

            //     req.data.ProcessFlowID = '';
            // } else {
            //     console.log("No workflow has been triggered");
            // }
            let oDB,
                aHeaders,
                aPreviouseItems,
                oPrevItem, {
                    InvoiceHeader,
                    InvoiceItems
                } = cds.entities(
                    "tablemodel.srv.InvoiceService"
                );

            try {
                // DB - Service
                oDB = await cds.connect.to("db");
                // console.log(oDB);

                // Get the Header details
                aHeaders = await oDB.run(
                    SELECT.from(InvoiceHeader).where({
                        ID: req.data.ID,
                    })
                );
                // console.log(aHeaders);

                // Get the item details
                aPreviouseItems = await SELECT.from(InvoiceItems).where({
                    Parent_ID: req.data.ID,
                });
                // console.log(aPreviouseItems);

                // Changing the accuracy to 99%, if the field value has been touched
                req.data.PONumber_ac =
                    aHeaders[0].PONumber !== req.data.PONumber ?
                    "99" :
                    req.data.PONumber_ac;
                req.data.Curr_ac =
                    aHeaders[0].Currency !== req.data.Currency ? "99" : req.data.Curr_ac;
                req.data.GrossAmount_ac =
                    aHeaders[0].GrossAmount !== req.data.GrossAmount ?
                    "99" :
                    req.data.GrossAmount_ac;
                req.data.SupplierName_ac =
                    aHeaders[0].SupplierName !== req.data.SupplierName ?
                    "99" :
                    req.data.SupplierName_ac;
                req.data.PODate_ac =
                    aHeaders[0].PODate !== req.data.PODate ? "99" : req.data.PODate_ac;
                req.data.SupInvNumber_ac =
                    aHeaders[0].SupInvNumber !== req.data.SupInvNumber ?
                    "99" :
                    req.data.SupInvNumber_ac;

                // Updaing the Accuracy to 99%, if the field value has been touched
                for (const item of req.data.Items) {
                    oPrevItem = aPreviouseItems.find((itm) => itm.ID == item.ID);

                    item.MatNum_ac =
                        oPrevItem.MaterialNumber !== item.MaterialNumber ?
                        "99" :
                        item.MatNum_ac;
                    item.Quantity_ac =
                        oPrevItem.Quantity !== item.Quantity ? "99" : item.Quantity_ac;
                    item.UoM_ac = oPrevItem.UoM !== item.UoM ? "99" : item.UoM_ac;
                    item.UnitPrice_ac =
                        oPrevItem.UnitPrice !== item.UnitPrice ? "99" : item.UnitPrice_ac;
                    item.NetAmount_ac =
                        oPrevItem.NetAmount !== item.NetAmount ? "99" : item.NetAmount_ac;
                }

                // Changing the status
                req.data.StatusCode_code = "64";
                req.data.Message = "Saved";
                req.data.Reason = "Manually corrected";

                // Updating the log table
                const ID = req.data.ID;
                let sDetails,
                    valuechange = [],
                    iSequence;

                for (const field of Object.keys(req.data)) {
                    // skip unwanted fields
                    if (
                        [
                            "modifiedAt",
                            "modifiedBy",
                            "createdAt",
                            "createdBy",
                            "StatusCode_code",
                            "Message",
                            "Reason",
                            "PONumber_ac",
                            "SupInvNumber_ac",
                            "PODate_ac",
                            "SupplierName_ac",
                            "GrossAmount_ac",
                            "Curr_ac",
                            "NetAmount_ac",
                            "PONumber_ac_text",
                            "SupplierName_ac_text",
                            "SupInvNumber_ac_text",
                            "Curr_ac_text",
                            "GrossAmount_ac_text",
                            "PONumber_acc",
                            "SupplierName_acc",
                            "SupInvNumber_acc",
                            "Curr_acc",
                            "GrossAmount_acc",
                            "overall_acc",
                            "overall_ac",
                            "SupNoName",
                            "Items",
                        ].includes(field)
                    ) {
                        continue;
                    }
                    const oldVal = aHeaders[0][field];
                    const newVal = req.data[field];
                    if (oldVal !== newVal) {
                        valuechange.push({
                            FieldName: field,
                            OldValue: oldVal != null ? String(oldVal) : null,
                            NewValue: newVal != null ? String(newVal) : null,
                        });
                    }
                }

                for (let index = 0; index < req.data.Items.length; index++) {
                    const element = req.data.Items[index];
                    const pre_record = aPreviouseItems.find(
                        (i) => i.Seq === element.Seq
                    );
                    for (const field of Object.keys(element)) {
                        // skip unwanted fields
                        if (
                            [
                                "modifiedAt",
                                "modifiedBy",
                                "createdAt",
                                "createdBy",
                                "Criticality_code_item",
                                "MatNum_ac_text",
                                "MatNum_ac",
                                "MatNum_acc",
                                "Quantity_ac_text",
                                "Quantity_ac",
                                "Quantity_acc",
                                "UnitPrice_ac_text",
                                "UnitPrice_ac",
                                "UnitPrice_acc",
                                "UoM_ac_text",
                                "UoM_ac",
                                "UoM_acc",
                                "NetAmount_ac_text",
                                "NetAmount_ac",
                                "NetAmount_acc",
                                "UnitPriceCur",
                                "NetamountCur",
                                "QuantityUnit",
                            ].includes(field)
                        ) {
                            continue;
                        }
                        const oldVal = pre_record[field];
                        const newVal = element[field];
                        if (oldVal !== newVal) {
                            valuechange.push({
                                ItemNo: index + 1,
                                FieldName: field,
                                OldValue: oldVal != null ? String(oldVal) : null,
                                NewValue: newVal != null ? String(newVal) : null,
                            });
                        }
                    }
                }

                if (valuechange.length === 0) {
                    sDetails = 'Saved successfully';
                } else {
                    sDetails = JSON.stringify(valuechange);
                }

                // Build a CQN that counts all rows in InvoiceLog where ParentInvoice_ID = invoiceID
                const [{
                    cnt
                }] = await cds.run(
                    SELECT.from(InvoiceLog)
                    .columns([{
                        func: "count",
                        args: ["*"],
                        as: "cnt",
                    }, ])
                    .where({
                        ParentInvoice_ID: ID,
                    })
                );
                iSequence = cnt + 1;
                await cds.run(
                    INSERT.into(InvoiceLog).entries({
                        ParentInvoice: {
                            ID: ID,
                        },
                        EventType: "Manual update",
                        EventDetails: sDetails,
                        Sequence: iSequence,
                    })
                );
            } catch (err) {
                console.log("Error --> ", err);
            }
        });

        // // Update Event for invoice Header
        // this.after("UPDATE", "InvoiceHeader", async (req, next) => {
        //     const ID = req.ID;
        //     let iSequence;
        //     try {
        //         // Build a CQN that counts all rows in InvoiceLog where ParentInvoice_ID = invoiceID
        //         const [{
        //             cnt
        //         }] = await cds.run(
        //             SELECT.from(InvoiceLog)
        //             .columns([{
        //                 func: "count",
        //                 args: ["*"],
        //                 as: "cnt",
        //             }, ])
        //             .where({
        //                 ParentInvoice_ID: ID,
        //             })
        //         );
        //         iSequence = cnt + 1;
        //         await cds.run(
        //             INSERT.into(InvoiceLog).entries({
        //                 ParentInvoice: {
        //                     ID: ID,
        //                 },
        //                 EventType: "Manual update",
        //                 EventDetails: "Details updated successfully",
        //                 Sequence: iSequence,
        //             })
        //         );
        //     } catch (err) {
        //         console.log(err);
        //     }
        // });

        // Logic while reading the Header Entity
        this.after("READ", "InvoiceHeader", async (data) => {
            // console.log('Read Data ====>', data);

            let oDB,
                aHeaders,
                oHeader,
                Items,
                aItem,
                iOverall_ac = 0,
                iOverall_item_ac = 0,
                iAvg_Counter = 0,
                {
                    InvoiceHeader,
                    InvoiceItems
                } = cds.entities(
                    "tablemodel.srv.InvoiceService"
                );

            try {
                // DB - Service
                oDB = await cds.connect.to("db");
                // console.log(oDB);

                // Get the Header details
                aHeaders = await oDB.run(SELECT.from(InvoiceHeader));

                // Get the item details
                Items = await SELECT.from(InvoiceItems);
                // console.log("Total Items --> ",Items.length);

                // Loop the fetched header details and calculate the overall accuracy percentage
                for (const d of data) {
                    oHeader = aHeaders.find((head) => head.ID == d.ID);
                    aItem = Items.filter((it) => it.Parent_ID == d.ID);
                    // console.log("Item Found --> ",aItem.length);

                    iOverall_ac =
                        parseFloat(oHeader.PONumber_ac) +
                        parseFloat(oHeader.SupInvNumber_ac) +
                        parseFloat(oHeader.GrossAmount_ac) +
                        parseFloat(oHeader.Curr_ac);
                    iAvg_Counter = 4;
                    iOverall_item_ac = 0;

                    for (const item of aItem) {
                        iOverall_item_ac +=
                            parseFloat(item.MatNum_ac) +
                            parseFloat(item.Quantity_ac) +
                            parseFloat(item.UoM_ac) +
                            parseFloat(item.NetAmount_ac);
                        iAvg_Counter += 4;
                    }
                    iOverall_ac = (iOverall_ac + iOverall_item_ac) / iAvg_Counter;
                    // console.log(`Overall Accuracy for ${d.ID} is ${iOverall_ac}`);
                    d.overall_ac = parseInt(iOverall_ac.toFixed(2));
                    // console.log("Final Data --> ",d.overall_ac);
                }
            } catch (err) {
                console.log(
                    'Error in this.after("READ", "InvoiceHeader", async (data))',
                    err
                );
            }
        });

        // Check & Send Action
        this.on("threeWayCheckUI", "InvoiceHeader", async (req) => {
            // console.log("This is an action call and the data is,", req.params[0]);
            console.log("This is an action call");
            let Record_ID = req.params[0].ID,
                oDB,
                oMatDocService,
                oSPA_api,
                oHeaderData,
                HeaderData,
                Items,
                bHFlag = "",
                UPDATE_result,
                iSequence;

            const tx = cds.transaction(req),
                userId = req.user.id;

            let {
                InvoiceHeader,
                InvoiceItems
            } = cds.entities(
                "tablemodel.srv.InvoiceService"
            );

            // Connecting to necessary services in BTP
            try {
                // DB - Service
                oDB = await cds.connect.to("db"); // keep this connection on top - Best Practise
                // console.log(oDB);

                // Get the Current Entity Record details - Header
                oHeaderData = await oDB.run(
                    SELECT.from(InvoiceHeader).where({
                        ID: Record_ID,
                    })
                );
                // console.log("Fetched Header Data", oHeaderData);
                console.log("Fetched Header Data");

                // Get the item details
                Items = await SELECT.from(InvoiceItems).where({
                    Parent_ID: Record_ID,
                });
                console.log("Total Items --->", Items.length);

                HeaderData = oHeaderData[0];

                // Material Document - Destination Service
                oMatDocService = await cds.connect.to("materialDoc"); // keep this connection on top - Best Practise
                // console.log(oMatDocService);
                console.log("Connected to External service");

                // BPA API - Destination service
                oSPA_api = await cds.connect.to("spa_api");
                console.log(oSPA_api);
            } catch (err) {
                console.log("Error while connecting to one of the  services", err);
                return {
                    StatusCode: "XXX",
                    Message: "Error while Connecting to necessary Services",
                };
            }

            // Updating the log table
            try {
                // Build a CQN that counts all rows in InvoiceLog where ParentInvoice_ID = invoiceID
                const [{
                    cnt
                }] = await cds.run(
                    SELECT.from(InvoiceLog)
                    .columns([{
                        func: "count",
                        args: ["*"],
                        as: "cnt",
                    }, ])
                    .where({
                        ParentInvoice_ID: Record_ID,
                    })
                );
                iSequence = cnt + 1;
                await tx.run(
                    INSERT.into(InvoiceLog).entries({
                        ParentInvoice: {
                            ID: Record_ID,
                        },
                        EventType: "Three-way check",
                        EventDetails: "Three-way check initiated manually",
                        PerformedBy: userId,
                        Sequence: iSequence,
                    })
                );
                console.log(userId);
            } catch (err) {
                console.log(err);
            }

            // ---- Updating item number
            let item_no = 0;
            for (const item of Items) {
                item_no += 1;
                item.Seq = item_no.toString();
            }

            // --------------START of Three-Way Check --------------------------------------------

            // Entity
            let {
                ZICDS_MATDOC_2
            } = oMatDocService.entities,
                aMaterialDocs;

            // Querying Material document for PO number
            try {
                aMaterialDocs = await oMatDocService.run(
                    SELECT(ZICDS_MATDOC_2).where({
                        Ebeln: HeaderData.PONumber,
                    })
                );
                // console.log("Material Doc. data -->", aMaterialDocs);
                console.log("Fetched Material Doc. data");
            } catch (err) {
                console.log("Error while fetching data", err);
                return {
                    StatusCode: "XXX",
                    Message: "Tech.Error while fetching data from Mat.Doc Destination Service",
                };
            }

            // if Material Document Exists ? Yes
            if (aMaterialDocs.length != 0) {
                HeaderData.Comp_Code = aMaterialDocs[0].Bukrs;
                HeaderData.SupplierNumber = aMaterialDocs[0].Lifnr;
                console.log("Supplier Number Header -->", HeaderData.SupInvNumber);

                // Iterating incoming Item data
                for (const item of Items) {
                    // Find the current Item in S/4 Data
                    let oS4Item = aMaterialDocs.find(
                        (matdoc) => matdoc.Matnr == item.MaterialNumber
                    );

                    // if item found in s4 ?
                    if (oS4Item !== undefined) {
                        // Three-Way Check - Amount Check
                        if (
                            item.NetAmount == oS4Item.Dmbtr.toString() &&
                            item.Quantity == oS4Item.Menge
                        ) {
                            item.Message = "3-way check passed at item level";
                            item.UoM = oS4Item.Meins;
                            item.POItem = oS4Item.Ebelp;
                            item.ReferenceDocument = oS4Item.Mblnr;
                            item.ReferenceDocumentFiscalYear = oS4Item.Mjahr;
                            item.ReferenceDocumentItem = oS4Item.Zeile;
                            item.SuplInvItem = oS4Item.Zeile;
                            item.FiscalYear = oS4Item.Lfbja;
                        } else {
                            bHFlag = "X";
                            item.Message = `Amount or Quantity mismatch for Material:${item.MaterialNumber}`;
                        }
                    }
                    // Else
                    else {
                        bHFlag = "X";
                        item.Message = `Mat.Doc. doesn't exists for Material ${item.MaterialNumber}`;
                    }
                }
            }
            // No
            else {
                bHFlag = "X";
                HeaderData.StatusCode_code = "60";
                HeaderData.Message = `Check Failed!`;
                HeaderData.Reason = `Invalid PO or No Mat.Doc. Exists for PO:${HeaderData.PONumber}`;

                try {
                    iSequence += 1;
                    await tx.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: Record_ID,
                            },
                            EventType: "Three-way check",
                            EventDetails: "Check failed due to PO/Mat.Doc not found",
                            PerformedBy: userId,
                            Sequence: iSequence,
                        })
                    );
                } catch (err) {
                    console.log("Failed to update the accuracy failure in log table");
                    return {
                        Message: "Failed to update the invoice log table",
                    };
                }
            }

            // three way check successful ? Yes
            if (bHFlag !== "X") {
                try {
                    iSequence += 1;
                    await tx.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: Record_ID,
                            },
                            EventType: "Three-way check",
                            EventDetails: "Check Passed",
                            PerformedBy: userId,
                            Sequence: iSequence,
                        })
                    );
                } catch (err) {
                    console.log("Failed to update the accuracy failure in log table");
                }

                HeaderData.Items = Items;
                // Building the Payload for workflow
                let payload_spa = {
                    definitionId: "us10.itr-internal-2hco92jx.invoiceautomationpocpackage20.extractionAndPostingInvoices",
                    context: {
                        data: HeaderData,
                    },
                };
                // console.log("Workflow Payload Data : ", payload_spa);
                console.log("Workflow Payload Data has been generated");

                let bpa_api;
                try {
                    // Trigger BPA workflow
                    bpa_api = await oSPA_api.send({
                        method: "POST",
                        path: "/workflow/rest/v1/workflow-instances",
                        headers: {
                            contentType: "application/json",
                        },
                        data: payload_spa,
                    });
                    console.log("Workflow triggered");

                    HeaderData.ProcessFlowID = bpa_api.id;
                    HeaderData.StatusCode_code = "61";
                    HeaderData.Message = "InProgress";
                    HeaderData.Reason = "Sent for approval";

                    iSequence += 1;
                    await tx.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: Record_ID,
                            },
                            EventType: "Workflow",
                            EventDetails: "Workflow started and sent for approval",
                            PerformedBy: userId,
                            Sequence: iSequence,
                        })
                    );
                } catch (err) {
                    console.log("Error while triggering Workflow", err);

                    HeaderData.StatusCode_code = "60";
                    HeaderData.Message = "Workflow trigger Failed!";
                    HeaderData.Reason = err.message;

                    iSequence += 1;
                    await tx.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: Record_ID,
                            },
                            EventType: "Workflow Re-initiation",
                            EventDetails: "Workflow not started",
                            PerformedBy: userId,
                            Sequence: iSequence,
                        })
                    );
                }
            } else {
                // TODO: create one more field in the entity to store additional message in the table
                HeaderData.StatusCode_code = "60";
                HeaderData.Message =
                    HeaderData.Message === "" ? "3-Way Check failed" : HeaderData.Message;
                try {
                    iSequence += 1;
                    await tx.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: Record_ID,
                            },
                            EventType: "Three-way check",
                            EventDetails: "Check failed due to PO/Mat.Doc not found",
                            PerformedBy: userId,
                            Sequence: iSequence,
                        })
                    );
                } catch (err) {
                    console.log(err);
                }
            }

            try {
                // Update Header table
                HeaderData.Items = Items;
                UPDATE_result = await UPDATE(InvoiceHeader, HeaderData.ID).with(
                    HeaderData
                );
                console.log("Action Update Completed : ", UPDATE_result);
            } catch (err) {
                console.log("Error at Update", err);
            }
        });

        ///////////////////////////////////// --- UI - Action Call //////////////////////////////////////////////////////////

        ///////////////////////////////////// --- BPA - API call ////////////////////////////////////////////////////////////
        // Action Import
        this.on("threeWayCheck", async (req) => {
            console.log("Request Body : ", req.data.data);

            // Initialization
            let HeaderData = req.data.data,
                Items = HeaderData.Items,
                bACFlag = "",
                bHFlag = "",
                INSERT_resp,
                oDB,
                oMatDocService,
                oSPA_api,
                iSequence = 0;

            const tx = cds.transaction(req),
                ID = cds.utils.uuid(),
                userId = req.user.id;

            // Connecting to necessary services in BTP
            try {
                // DB - Service
                oDB = await cds.connect.to("db"); // keep this connection on top - Best Practise
                // console.log(oDB);

                // Material Document - Destination Service
                oMatDocService = await cds.connect.to("materialDoc"); // keep this connection on top - Best Practise
                // console.log(oMatDocService);

                // BPA API - Destination service
                oSPA_api = await cds.connect.to("spa_api"); // keep this connection on top - Best Practise
                // console.log(oSPA_api);
            } catch (err) {
                console.log("Error while connecting to one of the  services", err);
                return {
                    StatusCode: "XXX",
                    Message: "Error while Connecting to necessary Services",
                };
            }

            // try {
            //     // let test = await oDB.tx(req.data.data).create('DB_TABLES_C_ATTACHMENT').entries([{
            //     //     name : 'Boopalan.text'
            //     // }]);
            //     console.log(test);
            // } catch (err) {
            //     console.log("Error from attachment steps :", err);
            // }

            // --- Update item number of all items
            let item_no = 0;
            for (const item of Items) {
                item_no += 1;
                item.Seq = item_no.toString();
            }

            // Update the log table
            try {
                INSERT_resp = await tx.run(
                    INSERT.into(InvoiceHeader).entries({
                        ID: ID,
                        Message: "Document created",
                    })
                );

                iSequence += 1;
                await tx.run(
                    INSERT.into(InvoiceLog).entries({
                        ParentInvoice: {
                            ID: ID,
                        },
                        EventType: "Invoice Found",
                        EventDetails: `Invoice from MailID : ${HeaderData.SupplierMail}`,
                        PerformedBy: userId,
                        Sequence: iSequence,
                    })
                );
                console.log(INSERT_resp);
            } catch (err) {
                console.log(err.message);
                return {
                    Message: "Failed to update life cycle log table",
                };
            }

            // ------------- START of Accuracy Check ---------------------------------------------

            // Header Level Accuracy ? Good
            if (
                parseInt(HeaderData.PONumber_ac) > 80 &&
                parseInt(HeaderData.Curr_ac) > 80 &&
                parseInt(HeaderData.GrossAmount_ac) > 80 &&
                parseInt(HeaderData.PODate_ac) > 80
            ) {
                console.log("Header data Accuracy Level - Passed");

                // Item Level Accuracy
                for (let i = 0; i < Items.length; i++) {
                    const item = Items[i];

                    if (
                        parseInt(item.MatNum_ac) > 80 &&
                        parseInt(item.Quantity_ac) > 80 &&
                        parseInt(item.NetAmount_ac) > 80
                    ) {
                        console.log("Item Data Accuracy Level - Passed");
                    } else {
                        bACFlag = "X";
                        item.Message = "Less Accuracy";
                        // break;
                    }
                }
            }
            // Not Good
            else bACFlag = "X";

            // Accuracy descripancy ? Yes
            if (bACFlag === "X") {
                // Save the log in table and return the response
                HeaderData.StatusCode_code = "60";
                HeaderData.Message = "Less Accuracy";

                // Insert Into execution log table
                try {
                    INSERT_resp = await tx.run(
                        UPDATE(InvoiceHeader).set(HeaderData).where({
                            ID: ID,
                        })
                    );
                    // console.log('Data Insert Result :', INSERT_resp);
                    iSequence += 1;
                    await tx.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: ID,
                            },
                            EventType: "Accuracy Check",
                            EventDetails: "Accuracy check failed - Low accuracy",
                            PerformedBy: userId,
                            Sequence: iSequence,
                        })
                    );

                    // Return Failed Response
                    return {
                        StatusCode: "60",
                        Message: `Accuracy check failed! Saved the record`,
                    };
                } catch (err) {
                    console.log("Error while Inserting Execution Log data : ", err);
                    return {
                        StatusCode: "12",
                        Message: "Error while Inserting execution log data",
                    };
                }
            }
            // No
            else {
                console.log("Accuracy check completed successfully");
                try {
                    iSequence += 1;
                    await tx.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: ID,
                            },
                            EventType: "Accuracy Check",
                            EventDetails: "Good accuracy",
                            PerformedBy: userId,
                            Sequence: iSequence,
                        })
                    );
                } catch (err) {
                    console.log("Failed to update the accuracy failure in log table");
                }
            }

            // --------------START of Three-Way Check --------------------------------------------

            // Entity
            let {
                ZICDS_MATDOC_2
            } = oMatDocService.entities,
                aMaterialDocs;

            // Querying Material document for PO number
            try {
                aMaterialDocs = await oMatDocService.run(
                    SELECT(ZICDS_MATDOC_2).where({
                        Ebeln: HeaderData.PONumber,
                    })
                );
                console.log("Material Doc. data -->", aMaterialDocs);
            } catch (err) {
                console.log("Error while fetching data", err);
                HeaderData.Message = err.message;
            }

            // if Material Document Exists ? Yes
            if (aMaterialDocs && aMaterialDocs.length != 0) {
                HeaderData.Comp_Code = aMaterialDocs[0].Bukrs;
                HeaderData.SupplierNumber = aMaterialDocs[0].Lifnr;
                console.log("Supplier Number Header -->", HeaderData.SupInvNumber);

                // Iterating incoming Item data
                for (const item of Items) {
                    // Find the current Item in S/4 Data
                    let oS4Item = aMaterialDocs.find(
                        (matdoc) => matdoc.Matnr == item.MaterialNumber
                    );

                    // if item found in s4 ?
                    if (oS4Item !== undefined) {
                        // Three-Way Check - Amount Check
                        if (
                            item.NetAmount == oS4Item.Dmbtr.toString() &&
                            item.Quantity == oS4Item.Menge
                        ) {
                            item.Message = "3-way check passed at item level";
                            item.UoM = oS4Item.Meins;
                            item.POItem = oS4Item.Ebelp;
                            item.ReferenceDocument = oS4Item.Mblnr;
                            item.ReferenceDocumentFiscalYear = oS4Item.Mjahr;
                            item.ReferenceDocumentItem = oS4Item.Zeile;
                            item.SuplInvItem = oS4Item.Zeile;
                            item.FiscalYear = oS4Item.Lfbja;
                        } else {
                            bHFlag = "X";
                            item.Message = `Amount or Quantity mismatch for Material:${item.MaterialNumber}`;
                        }
                    }
                    // Else
                    else {
                        bHFlag = "X";
                        item.Message = `Mat.Doc. doesn't exists for Material ${item.MaterialNumber}`;
                    }
                }
            }
            // No
            else {
                bHFlag = "X";
                HeaderData.StatusCode_code = "60";
                // HeaderData.Message = `Check Failed!`;
                HeaderData.Reason = `Invalid PO or No Mat.Doc. Exists for PO:${HeaderData.PONumber}`;
                try {
                    iSequence += 1;
                    await tx.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: ID,
                            },
                            EventType: "Three-way check",
                            EventDetails: "Check failed due to PO not found",
                            PerformedBy: userId,
                            Sequence: iSequence,
                        })
                    );
                } catch (err) {
                    console.log("Failed to update the accuracy failure in log table");
                    return {
                        Message: "Failed to update the invoice log table",
                    };
                }
            }

            // three way check successful ? Yes
            if (bHFlag !== "X") {
                try {
                    iSequence += 1;
                    await tx.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: ID,
                            },
                            EventType: "Three-way check",
                            EventDetails: "Check Passed",
                            PerformedBy: userId,
                            Sequence: iSequence,
                        })
                    );
                } catch (err) {
                    console.log("Failed to update the accuracy failure in log table");
                }

                // Building the Payload for workflow
                let payload_spa = {
                    definitionId: "us10.itr-internal-2hco92jx.invoiceautomationpocpackage20.extractionAndPostingInvoices",
                    context: {
                        data: HeaderData,
                    },
                };

                let bpa_api;
                try {
                    // Trigger BPA workflow
                    bpa_api = await oSPA_api.send({
                        method: "POST",
                        path: "/workflow/rest/v1/workflow-instances",
                        headers: {
                            contentType: "application/json",
                        },
                        data: payload_spa,
                    });
                    console.log(bpa_api);

                    HeaderData.ProcessFlowID = bpa_api.id;
                    HeaderData.StatusCode_code = "61";
                    HeaderData.Message = "InProgress";
                    HeaderData.Reason = "Sent for approval";

                    iSequence += 1;
                    await tx.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: ID,
                            },
                            EventType: "Workflow",
                            EventDetails: "Workflow started and sent for approval",
                            PerformedBy: userId,
                            Sequence: iSequence,
                        })
                    );
                } catch (err) {
                    console.log("Error while triggering Workflow", err);

                    HeaderData.StatusCode_code = "63";
                    HeaderData.Message = "Workflow trigger Failed!";
                    HeaderData.Reason = err.message;

                    iSequence += 1;
                    await tx.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: ID,
                            },
                            EventType: "Workflow",
                            EventDetails: "Workflow not started",
                            PerformedBy: userId,
                            Sequence: iSequence,
                        })
                    );
                }
            } else {
                HeaderData.StatusCode_code = "60";
                HeaderData.Message =
                    HeaderData.Message === "" ? "3-Way Check failed" : HeaderData.Message;
                try {
                    iSequence += 1;
                    await tx.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: ID,
                            },
                            EventType: "Three-way check",
                            EventDetails: "Check failed due to PO/Mat.Doc not found",
                            PerformedBy: userId,
                            Sequence: iSequence,
                        })
                    );
                } catch (err) {
                    console.log(err);
                }
            }

            try {
                // Save the status in the execution log table
                INSERT_resp = await tx.run(
                    UPDATE(InvoiceHeader).set(HeaderData).where({
                        ID: ID,
                    })
                );
                // INSERT_resp = await INSERT.into("db.tables.InvoiceHeader").entries(
                //     HeaderData
                // );
                console.log("Data Insert Result :", INSERT_resp);

                if (HeaderData.StatusCode_code !== "60")
                    return {
                        StatusCode: HeaderData.StatusCode_code,
                        Message: HeaderData.Message,
                    };
                else
                    return {
                        StatusCode: HeaderData.StatusCode_code,
                        Message: HeaderData.Message !== "" ?
                            HeaderData.Message : "Accuracy Passed -> 3-Way check Passed -> Sent for approval",
                    };
            } catch (err) {
                console.log("Error while saving execution Logs", err);
                return {
                    StatusCode: "40",
                    Message: "Failed! Execution log is not saved!",
                };
            }
        });

        // POST - Invoice Posting
        this.on("PostInvoice", async (req, next) => {
            console.log("Data from Workflow :", req.data.data);

            // Initialisation
            let oHeaderData,
                aItemData = [],
                oTempItem,
                dDats,
                sUsableDate1,
                sUsableDate2,
                oInvService,
                oS4Resp,
                oResp,
                iSequence,
                IDs;

            try {

                // Run a CQN to select only the ID where ProcessFlowID matches
                const [{
                    ID
                }] = await cds.run(
                    SELECT.from(InvoiceHeader)
                    .columns(['ID'])
                    .where({
                        ProcessFlowID: req.data.data.ProcessFlowID
                    })
                    );
                IDs = ID;

                // Build a CQN that counts all rows in InvoiceLog where ParentInvoice_ID = invoiceID
                const [{
                    cnt
                }] = await cds.run(
                    SELECT.from(InvoiceLog)
                    .columns([{
                        func: "count",
                        args: ["*"],
                        as: "cnt",
                    }])
                    .where({
                        ParentInvoice_ID: ID,
                    })
                );
                iSequence = cnt;

                // Invoice Creation Approved
                if (req.data.data.StatusCode_code === "62") {

                    // Updating log table
                    iSequence += 1;
                    await cds.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: ID,
                            },
                            EventType: "Workflow",
                            EventDetails: "Invoice approved for posting",
                            Sequence: iSequence,
                        })
                    );

                    // Document Date - Header field value
                    dDats = new Date(req.data.data.PODate);
                    sUsableDate1 = `${dDats.getFullYear()}-${
                        dDats.getMonth() + 1
                    }-${dDats.getDate()}T00:00`;

                    //Posting Date - Header field value
                    dDats = new Date();
                    sUsableDate2 = `${dDats.getFullYear()}-${
                        dDats.getMonth() + 1
                    }-${dDats.getDate()}T00:00`;

                    // Building Item Data
                    for (let i = 0; i < req.data.data.Items.length; i++) {
                        const element = req.data.data.Items[i];

                        oTempItem = {
                            FiscalYear: element.FiscalYear,
                            SupplierInvoiceItem: element.ReferenceDocumentItem,
                            PurchaseOrder: element.PONumber,
                            PurchaseOrderItem: element.POItem,
                            ReferenceDocument: element.ReferenceDocument,
                            ReferenceDocumentFiscalYear: element.ReferenceDocumentFiscalYear,
                            ReferenceDocumentItem: element.ReferenceDocumentItem,
                            DocumentCurrency: req.data.data.Currency,
                            SupplierInvoiceItemAmount: element.NetAmount,
                            PurchaseOrderQuantityUnit: element.UoM,
                            QuantityInPurchaseOrderUnit: element.Quantity,
                            SupplierInvoiceItemText: "",
                        };

                        aItemData.push(oTempItem);
                    }

                    // Building Header Data
                    oHeaderData = {
                        FiscalYear: aItemData[0].FiscalYear,
                        CompanyCode: req.data.data.Comp_Code,
                        DocumentDate: sUsableDate1,
                        PostingDate: sUsableDate2,
                        SupplierInvoiceIDByInvcgParty: req.data.data.SupInvNumber,
                        InvoicingParty: req.data.data.SupplierNumber,
                        DocumentCurrency: req.data.data.Currency,
                        InvoiceGrossAmount: req.data.data.GrossAmount,
                        to_SuplrInvcItemPurOrdRef: aItemData,
                    };

                    // Connecting to Invoice Service
                    oInvService = await cds.connect.to("invoicesrv");
                    console.log("invoice Service : ", oInvService);

                    // Posting invoice to S/4 System
                    oS4Resp = await oInvService.send({
                        method: "POST",
                        path: "A_SupplierInvoice",
                        headers: {
                            contentType: "application/json",
                            "x-Requested-With": "X",
                        },
                        data: oHeaderData,
                    });
                    console.log("API Respponse ----> ", oS4Resp);

                    // Invoice Number created successfully ? Yes
                    if (
                        oS4Resp.SupplierInvoice !== undefined &&
                        oS4Resp.SupplierInvoice !== "" &&
                        oS4Resp.SupplierInvoice !== null
                    ) {
                        iSequence += 1;
                        await cds.run(
                            INSERT.into(InvoiceLog).entries({
                                ParentInvoice: {
                                    ID: ID,
                                },
                                EventType: "Invoice Posting",
                                EventDetails: `Invoice posted successfully. Invoice number saved is ${oS4Resp.SupplierInvoice}`,
                                Sequence: iSequence,
                            })
                        );
                        console.log(
                            "Invoice Created Successfully : ",
                            oS4Resp.SupplierInvoice
                        );

                        // Update the status in the execution log table
                        req.data.data.CreatedInvNumber = oS4Resp.SupplierInvoice;
                        req.data.data.StatusCode_code = "62";
                        req.data.data.Message = "Completed";
                        req.data.data.Reason = "Invoice Created";

                        // Update the record of processflowID with invoice number from S/4 System
                        oResp = await UPDATE `db.tables.InvoiceHeader`
                            .set({
                                StatusCode_code: req.data.data.StatusCode_code,
                                Message: req.data.data.Message,
                                Reason: "Invoice Created",
                                CreatedInvNumber: req.data.data.CreatedInvNumber,
                            })
                            .where({
                                ProcessFlowID: req.data.data.ProcessFlowID,
                            });
                        console.log("Saved record", oResp);

                        return {
                            StatusCode: "62",
                            Message: "Invoice Created and Updated Table Record",
                            RecordUpdated: oResp,
                        };
                    }
                    // No
                    else {

                        iSequence += 1;
                        await cds.run(
                            INSERT.into(InvoiceLog).entries({
                                ParentInvoice: {
                                    ID: ID,
                                },
                                EventType: "Invoice Posting",
                                EventDetails: `Invoice posting failed. Refer the logs of 'API_SUPPLIERINVOICE_PROCESS_SRV' or use ${
                                    req.data.data.PONumber
                                } in S/4 for more details`,
                                Sequence: iSequence,
                            })
                        );
                        // Update the Status as 'Failed'
                        oResp = await UPDATE `db.tables.InvoiceHeader`
                            .set({
                                StatusCode_code: "60",
                                Message: "Error",
                                Reason: "Invoice Creation Failed",
                            })
                            .where({
                                ProcessFlowID: req.data.data.ProcessFlowID,
                            });

                        // Send Failed Response
                        return {
                            StatusCode: "60",
                            Message: "Invoice Creation failed! and Updated the status",
                            RecordUpdated: oResp,
                        };
                    }
                }
                // Invoice Creation Rejected
                else {
                    // Update the record of processflowID with Status message as 'Rejected'
                    oResp = await UPDATE `db.tables.InvoiceHeader`
                        .set({
                            StatusCode_code: '65',
                            Message: req.data.data.Message,
                            Reason: req.data.data.Reason,
                            CreatedInvNumber: "",
                        })
                        .where({
                            ProcessFlowID: req.data.data.ProcessFlowID,
                        });
                    console.log("Saved Rejected status in the record", oResp);

                    iSequence += 1;
                    await cds.run(
                        INSERT.into(InvoiceLog).entries({
                            ParentInvoice: {
                                ID: ID,
                            },
                            EventType: "Workflow",
                            EventDetails: `Invoice is rejected from posting on S/4 system`,
                            Sequence: iSequence,
                        })
                    );

                    return {
                        StatusCode: "60",
                        Message: "Execution log updated with status Rejected",
                        RecordUpdated: oResp,
                    };
                }
            } catch (err) {
                // Technical Errors or DB Connection errors
                console.log("Backend Error ----> ", err);

                iSequence += 1;
                await cds.run(
                    INSERT.into(InvoiceLog).entries({
                        ParentInvoice: {
                            ID: IDs,
                        },
                        EventType: "S/4 Error",
                        EventDetails: `Error from S/4 System. ${err.message}`,
                        Sequence: iSequence,
                    })
                );

                // Update the record of processflowID with Status message as 'Rejected'
                oResp = await UPDATE `db.tables.InvoiceHeader`
                    .set({
                        StatusCode_code: "63",
                        Message: "Technical Error",
                        Reason: err.message,
                    })
                    .where({
                        ProcessFlowID: req.data.data.ProcessFlowID,
                    });
                console.log("Technical Error ", oResp);
            }
        });
        ///////////////////////////////////// --- BPA - API call ////////////////////////////////////////////////////////////

        return super.init(); // if no handlers found or after successful handler execution , proceed with 'managed' capability
    }
};