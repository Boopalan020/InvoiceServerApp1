const cds = require("@sap/cds");
const {aHeaderFieldLists, aHeaderAccuracyLists, aItemFieldLists, aItemAccuracyLists} = require('../Utils/Fields');

module.exports = class POAppService extends cds.ApplicationService {
    async init() {
        let hana_db,
            aidox, {POHeader, PoItems} = cds.entities("tablemodel.srv.POServices");

        try {
            hana_db = await cds.connect.to("db");
            aidox = await cds.connect.to("aidox");
        } catch (err) {
            console.log("Some instances are not connected properly", err);
        }

        this.on("extract_and_save_po_data", async (req) => { // console.log(req.data.data);
            let payload = req.data.data,
                options = {
                    schemaName: "SAP_purchaseOrder_schema",
                    clientId: "default",
                    documentType: "purchaseOrder",
                    templateID: "Invoice_JH_Template"
                };

            // convert base64 to BLOB
            const blob = base64ToBlob(payload.content, payload.mimeType);

            // Prepare Formdata
            let formData = new FormData();

            formData.append("file", blob, payload.filename);
            formData.append("options", JSON.stringify(options));

            let oAidox,
                INSERT_resp,
                inserted_id;

            try {
                oAidox = await aidox.send({
                    method: "POST",
                    path: "/document/jobs",
                    headers: {
                        "Content-Type": "multipart/form-data",
                        Accept: "multipart/mixed"
                    },
                    data: formData
                });
                // console.log(oAidox);
            } catch (err) {
                console.log("Error at AI.Dox Call service section ->", err);
                return {status: "Error", message: err.message};
            }

            if (oAidox !== null || oAidox !== undefined) {
                let oHeaderData = {
                    mailDateTime: payload.mailDateTime,
                    emailid: payload.emailid,
                    mailSubject: payload.mailSubject,
                    dox_id: oAidox.id,
                    extraction_status: "Pending"
                };

                // Update HANA Cloud database
                try { // Save the status in the execution log table
                    INSERT_resp = await INSERT.into("db.tables.POHeader").entries(oHeaderData);
                    console.log("Data Insert Result :", INSERT_resp);
                } catch (err) {
                    console.log("Error while inserting data ->", err);
                    return {status: "custom_error", message: err.message};
                }

                // insert statement record ID
                if (INSERT_resp !== null || INSERT_resp !== undefined) {
                    inserted_id = INSERT_resp.query.INSERT.entries[0].ID;
                    console.log(inserted_id);
                }

                // Execute after 15 secs after uploading the document to DOX
                sleep(15000).then(async () => { // Get the extraction result from the DOX service
                    await refresh_extraction_result(oAidox.id, inserted_id);
                });
            } else {
                console.log("error in uploading the document");
                return {status: "custom_error", message: "Error in uploading the document"};
            }

            return {
                id: oAidox.id != null ? oAidox.id : "",
                status: "Success",
                message: "Document submitted for data extraction"
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
                iAvg_Counter = 0, {POHeader, PoItems} = cds.entities('tablemodel.srv.POServices');
            try { // DB - Service
                oDB = await cds.connect.to('db');
                // console.log(oDB);

                // Get the Header details
                aHeaders = await oDB.run(SELECT.from(POHeader));

                // Get the item details
                Items = await SELECT.from('db.Tables.PoItems');

                // Loop the fetched header details and calculate the overall accuracy percentage
                for (const d of data) {
                    oHeader = aHeaders.find((head) => head.ID == d.ID);
                    aItem = Items.filter((it) => it.Parent_ID == d.ID);

                    iOverall_ac = parseFloat(oHeader.documentNumber_ac) + parseFloat(oHeader.netAmount_ac) + parseFloat(oHeader.grossAmount_ac) + parseFloat(oHeader.currencyCode_ac) + parseFloat(oHeader.documentDate_ac);
                    iAvg_Counter = 5;
                    iOverall_item_ac = 0;

                    for (const item of aItem) {
                        iOverall_item_ac += (parseFloat(item.customerMaterialNumber_ac) + parseFloat(item.quantity_ac) + parseFloat(item.unitOfMeasure_ac) + parseFloat(item.netAmount_ac) + parseFloat(item.unitPrice_ac) + parseFloat(item.description_ac));
                        iAvg_Counter += 6;
                    }

                    iOverall_ac = (iOverall_ac + iOverall_item_ac) / iAvg_Counter;

                    d.overall_ac = parseInt(iOverall_ac.toFixed(2));

                }
            } catch (err) {
                console.log("Error in this.after(\"READ\", \"POHeader\", async (data))", err);
            }
        })

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
            return new Blob([byteArray], {type: contentType});
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
                        method: "GET", path: `/document/jobs/${
                        ai_dox_id
                    }`
                });
                console.log(oAidox_get);
            } catch (err) {
                console.log("Error in getting the extracted values from DOX service ->", err);
                return {status: "Error in getting the extracted values from DOX service", message: err.message};
            }
            if (oAidox_get.status === "DONE") { // Hit the DOX api to get the schema structure using the schema ID
                let oDox_schema,
                    sSchemaId = "fbab052e-6f9b-4a5f-b42f-29a8162eb1bf"; // Purchase Order schema
                try {
                    oDox_schema = await aidox.send({method: "GET", path: `/schemas/${sSchemaId}?clientId=default`});
                } catch (err) {
                    console.log("Error at taking schema structure ->", err);
                    return {status: "Error at taking schema structure", message: err.message};
                }

                if (oDox_schema !== null || oDox_schema !== undefined) {
                    if (oDox_schema.hasOwnProperty("headerFields")) {
                        console.log("Reading header fields using structure");

                        // Assign the extracted headerfield for search
                        aHeaderValues = oAidox_get ?.extraction ?.headerFields;
                        console.log(aHeaderValues);

                        // iterate the Header structure to find the values from extracted data
                        for (const key in oDox_schema.headerFields) {
                            if (Object.prototype.hasOwnProperty.call(oDox_schema.headerFields, key)) {
                                const schemaElement = oDox_schema.headerFields[key];

                                if (schemaElement.hasOwnProperty("name") && aHeaderFieldLists.includes(schemaElement.name)) {
                                    console.log('Header schema Element -->', schemaElement);

                                    // Find the matched field from extraction result
                                    let oExtracted = aHeaderValues.find(f => f ?.name === schemaElement.name);
                                    if (oExtracted) {
                                        oHeaderData[schemaElement.name] = (oExtracted ?.value).toString();

                                        // Logic to include the accuracy fields that are maintained in table
                                        let sAcc_property = schemaElement.name + "_ac";
                                        if (aHeaderAccuracyLists.includes(sAcc_property)) {
                                            oHeaderData[sAcc_property] = (oExtracted ?.confidence * 100).toFixed(2).toString();
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
                        aItemValues = oAidox_get ?.extraction ?.lineItems;
                        console.log(aItemValues);

                        for (let i = 0; i < aItemValues.length; i++) {
                            const oItem = aItemValues[i];
                            let oNewItem = {};

                            // iterate the Item structure to find the values from extracted data
                            for (const key in oDox_schema.lineItemFields) {
                                if (Object.prototype.hasOwnProperty.call(oDox_schema.lineItemFields, key)) {
                                    const schemaElement = oDox_schema.lineItemFields[key];

                                    if (schemaElement.hasOwnProperty("name") && aItemFieldLists.includes(schemaElement.name)) {
                                        console.log('Element schema -->', schemaElement);

                                        // Find the matched field from extraction result
                                        let oExtracted = oItem.find(f => f ?.name === schemaElement.name);
                                        if (oExtracted) {
                                            oNewItem[schemaElement.name] = (oExtracted ?.value).toString();

                                            // Logic to include the accuracy fields that are maintained in table
                                            let sAcc_property = schemaElement.name + "_ac";
                                            if (aItemAccuracyLists.includes(sAcc_property)) {
                                                oNewItem[sAcc_property] = (oExtracted ?.confidence * 100).toFixed(2).toString();
                                            }
                                        }
                                    }
                                }
                            }
                            aNewItems.push(oNewItem);
                        }
                        oHeaderData['PoItems'] = aNewItems;
                    }
                    console.log("Complete data --> ", oHeaderData);
                }

                // Update the data table with the extracted values
                let UPDATE_resp;
                try {
                    oHeaderData['extraction_status'] = 'Done';
                    UPDATE_resp = await UPDATE(POHeader, inserted_id).with(oHeaderData) 
                    ;
                } catch (err) {
                    console.log("Error updating the table ->", err);
                }
            } else {
                console.log("DOX extraction status us still pending. Try refreshing from UI");
            }
        }

        this.on("refresh_extractions", "POHeader", async (req) => {
            let sRecordID = req.params[0],
                oRecord, {POHeader} = cds.entities('tablemodel.srv.POServices');;
            console.log("Selected Record ID", sRecordID);
            try {
                oRecord = await hana_db.run(SELECT.from(POHeader, po => {
                    po('dox_id')
                }).where({ID: sRecordID}));
                console.log(oRecord);
                await refresh_extraction_result(oRecord[0].dox_id, sRecordID);
            } catch (err) {
                console.log("Error ->", err);
            }
        });

        return super.init();
    }
};
