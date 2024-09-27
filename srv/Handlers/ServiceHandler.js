const cds = require("@sap/cds");

module.exports = class InvoiceService extends cds.ApplicationService {
    init() {

        ///////////////////////////////////// --- UI - Action Call //////////////////////////////////////////////////////////
        
        // Update Event for invoice Header
        this.before("UPDATE", "InvoiceHeader", async (req, next) => {
            
            for (const item of req.data.Items) {
                item.MatNum_ac = '99';
                item.Quantity_ac = '99';
                item.UoM_ac = '99';
                item.UnitPrice_ac = '99';
                item.NetAmount_ac = '99';
            }
            
            // Changing the accuracy to 99%
            req.data.PONumber_ac = '99';
            req.data.Curr_ac = '99';
            req.data.GrossAmount_ac = '99';
            req.data.SupplierName_ac = '99';
            req.data.PODate_ac = '99';
            req.data.SupInvNumber_ac = '99';

            // Changing the status
            req.data.StatusCode = 'S';
            req.data.Message = 'Saved';

            console.log("Correction Accuracy :", req.data);

        });


        // Check & Send Action
        this.on("threeWayCheckUI", "InvoiceHeader", async (req) => {
            console.log("This is an action call and the data is,", req.params[0]);
            let Record_ID = req.params[0].ID,
                oDB,
                oMatDocService,
                oSPA_api,
                oHeaderData,
                HeaderData,
                Items,
                bHFlag = '',
                UPDATE_result;

            let { InvoiceHeader, InvoiceItems } = cds.entities('tablemodel.srv.InvoiceService');

            // Connecting to necessary services in BTP
            try {

                // DB - Service
                oDB = await cds.connect.to('db');
                console.log(oDB);

                // Get the Current Entity Record details - Header
                oHeaderData = await oDB.run(SELECT.from(InvoiceHeader).where({ID : Record_ID}));
                console.log(oHeaderData);

                // Get the item details
                Items = await  SELECT.from(InvoiceItems).where({Parent_ID : Record_ID});
                console.log(Items);

                HeaderData = oHeaderData[0];

                // Material Document - Destination Service
                oMatDocService = await cds.connect.to("materialDoc");
                console.log(oMatDocService);

                // BPA API - Destination service
                oSPA_api = await cds.connect.to("spa_api");
                console.log(oSPA_api);

            } catch (err) {
                console.log("Error while connecting to one of the  services", err);
                return {
                    StatusCode : "XXX",
                    Message : "Error while Connecting to necessary Services"
                };
            }

            // --------------START of Three-Way Check --------------------------------------------
            
            // Entity
            let {
                ZICDS_MATDOC_2
            } = oMatDocService.entities,
            aMaterialDocs;

            // Querying Material document for PO number
            try {
                aMaterialDocs = await oMatDocService.run(SELECT(ZICDS_MATDOC_2).where({
                    Ebeln: HeaderData.PONumber
                }));
                console.log("Material Doc. data -->", aMaterialDocs);
            } catch (err) {
                console.log("Error while fetching data", err);
                return {
                    StatusCode : "XXX",
                    Message : "Tech.Error while fetching data from Mat.Doc Destination Service"
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
                    let oS4Item = aMaterialDocs.find((matdoc) => matdoc.Matnr == item.MaterialNumber);

                    // if item found in s4 ?
                    if (oS4Item !== undefined) {

                        // Three-Way Check - Amount Check
                        if (item.NetAmount == oS4Item.Dmbtr.toString() && item.Quantity == oS4Item.Menge) {
                            item.Message = '';
                            item.UoM = oS4Item.Meins;
                            item.POItem = oS4Item.Ebelp;
                            item.ReferenceDocument = oS4Item.Mblnr;
                            item.ReferenceDocumentFiscalYear = oS4Item.Mjahr;
                            item.ReferenceDocumentItem = oS4Item.Zeile;
                            item.SuplInvItem = oS4Item.Zeile;
                            item.FiscalYear = oS4Item.Lfbja;
                        } else {
                            bHFlag = 'X';
                            item.Message = `Amount or Quantity mismatch for Material:${item.MaterialNumber}`;
                        }
                    }
                    // Else
                    else {
                        bHFlag = 'X';
                        item.Message = `Mat.Doc. doesn't exists for Material ${item.MaterialNumber}`;
                    }
                }
            }
            // No
            else {
                bHFlag = 'X';
                HeaderData.StatusCode = '20';
                HeaderData.Message = `Check Failed! Invalid PO or No Mat.Doc. Exists for PO:${HeaderData.PONumber}`;
            }

            // three way check successful ? Yes
            if (bHFlag !== 'X') {
                HeaderData.Items = Items;
                // Building the Payload for workflow
                let payload_spa = {
                    "definitionId": "us10.itr-internal-2hco92jx.invoiceautomationpocpackage20.extractionAndPostingInvoices",
                    "context": {
                        "data": HeaderData
                    }
                };
                console.log("Workflow Payload Data : ",payload_spa)
    
                let bpa_api;
                try {
                    // Trigger BPA workflow
                    bpa_api = await oSPA_api.send({
                        method: "POST",
                        path: "/workflow/rest/v1/workflow-instances",
                        headers: {
                            "contentType": "application/json"
                        },
                        data: payload_spa
                    });
                    console.log(bpa_api);

                    HeaderData.ProcessFlowID = bpa_api.id;
                    HeaderData.StatusCode = '52';
                    HeaderData.Message = 'InProgress';

                } catch (err) {
                    console.log("Error while triggering Workflow", err);
                    
                    HeaderData.StatusCode = "30";
                    HeaderData.Message = "Workflow trigger Failed!";
                }
            } else {
                // TODO: create one more field in the entity to store additional message in the table
                HeaderData.StatusCode = '20';
                HeaderData.Message = HeaderData.Message === '' ? '3-Way Check failed' : HeaderData.Message;
            }

            try {

                // Update Header table
                HeaderData.Items = Items;
                UPDATE_result = await UPDATE(InvoiceHeader, HeaderData.ID).with(HeaderData);
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
            console.log("PONumber -->", req.data.data.PONumber);
            console.log("MailDate -->", req.data.data.MailDateTime);
            console.log("SupplierMail -->", req.data.data.SupplierMail);
            console.log("MailSubject -->", req.data.data.MailSubject);

            // Initialization
            let HeaderData = req.data.data,
                Items = HeaderData.Items,
                bACFlag = '',
                bHFlag = '',
                INSERT_resp,
                oDB,
                oMatDocService, 
                oSPA_api;

            // Connecting to necessary services in BTP
            try {
                // DB - Service
                oDB = await cds.connect.to('db');
                console.log(oDB);

                // Material Document - Destination Service
                oMatDocService = await cds.connect.to("materialDoc");
                console.log(oMatDocService);

                // BPA API - Destination service
                oSPA_api = await cds.connect.to("spa_api");
                console.log(oSPA_api);

            } catch (err) {
                console.log("Error while connecting to one of the  services", err);
                return {
                    StatusCode : "XXX",
                    Message : "Error while Connecting to necessary Services"
                };
            }

            // ------------- START of Accuracy Check ---------------------------------------------

            // Header Level Accuracy ? Good
            
            if (parseInt(HeaderData.PONumber_ac) > 80 &&
                parseInt(HeaderData.Curr_ac) > 80 &&
                parseInt(HeaderData.GrossAmount_ac) > 80 &&
                parseInt(HeaderData.PODate_ac) > 80
            ) 
            {
                console.log('Header data Accuracy Level - Passed');

                // Item Level Accuracy
                for (let i = 0; i < Items.length; i++) {
                    const item = Items[i];

                    if (parseInt(item.MatNum_ac) > 80 &&
                        parseInt(item.Quantity_ac) > 80 &&
                        parseInt(item.NetAmount_ac) > 80
                    ) {
                        console.log("Item Data Accuracy Level - Passed")
                    } else {
                        bACFlag = 'X';
                        item.Message = 'Less Accuracy';
                        // break;
                    }
                }
            }
            // Not Good
            else bACFlag = 'X';

            // Accuracy descripancy ? Yes
            if (bACFlag === 'X') {
                // Save the log in table and return the response
                HeaderData.StatusCode = '10'
                HeaderData.Message = 'Less Accuracy';

                // Insert Into execution log table
                try {
                    INSERT_resp = await INSERT.into('db.tables.InvoiceHeader').entries(HeaderData);
                    console.log('Data Insert Result :', INSERT_resp);
                    
                    // Return Failed Response
                    return {
                        StatusCode: "10",
                        Message: `Accuracy check failed! Saved the record ID:${INSERT_resp.query.INSERT.entries[0].ID}`
                    };
                } catch (err) {
                    console.log("Error while Inserting Execution Log data : ",err)
                    return {
                        StatusCode : "12",
                        Message : "Error while Inserting execution log data"
                    };
                }
            }
            // No
            else {
                console.log("Accuracy check completed successfully");
                req.reply({
                    StatusCode: "11",
                    Message: "Accuracy check completed successfully"
                });
            }

            // --------------START of Three-Way Check --------------------------------------------
            
            // Entity
            let {
                ZICDS_MATDOC_2
            } = oMatDocService.entities,
            aMaterialDocs;

            // Querying Material document for PO number
            try {
                aMaterialDocs = await oMatDocService.run(SELECT(ZICDS_MATDOC_2).where({
                    Ebeln: HeaderData.PONumber
                }));
                console.log("Material Doc. data -->", aMaterialDocs);
            } catch (err) {
                console.log("Error while fetching data", err);
                return {
                    StatusCode : "XXX",
                    Message : "Tech.Error while fetching data from Mat.Doc Destination Service"
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
                    let oS4Item = aMaterialDocs.find((matdoc) => matdoc.Matnr == item.MaterialNumber);

                    // if item found in s4 ?
                    if (oS4Item !== undefined) {

                        // Three-Way Check - Amount Check
                        if (item.NetAmount == oS4Item.Dmbtr.toString() && item.Quantity == oS4Item.Menge) {
                            item.Message = '';
                            item.UoM = oS4Item.Meins;
                            item.POItem = oS4Item.Ebelp;
                            item.ReferenceDocument = oS4Item.Mblnr;
                            item.ReferenceDocumentFiscalYear = oS4Item.Mjahr;
                            item.ReferenceDocumentItem = oS4Item.Zeile;
                            item.SuplInvItem = oS4Item.Zeile;
                            item.FiscalYear = oS4Item.Lfbja;
                        } else {
                            bHFlag = 'X';
                            item.Message = `Amount or Quantity mismatch for Material:${item.MaterialNumber}`;
                        }
                    }
                    // Else
                    else {
                        bHFlag = 'X';
                        item.Message = `Mat.Doc. doesn't exists for Material ${item.MaterialNumber}`;
                    }
                }
            }
            // No
            else {
                bHFlag = 'X';
                HeaderData.StatusCode = '20';
                HeaderData.Message = `Check Failed! Invalid PO or No Mat.Doc. Exists for PO:${HeaderData.PONumber}`;
            }

            // three way check successful ? Yes
            if (bHFlag !== 'X') {
                // Building the Payload for workflow
                let payload_spa = {
                    "definitionId": "us10.itr-internal-2hco92jx.invoiceautomationpocpackage20.extractionAndPostingInvoices",
                    "context": {
                        "data": HeaderData
                    }
                };
    
                let bpa_api;
                try {
                    // Trigger BPA workflow
                    bpa_api = await oSPA_api.send({
                        method: "POST",
                        path: "/workflow/rest/v1/workflow-instances",
                        headers: {
                            "contentType": "application/json"
                        },
                        data: payload_spa
                    });
                    console.log(bpa_api);

                    HeaderData.ProcessFlowID = bpa_api.id;
                    HeaderData.StatusCode = '52';
                    HeaderData.Message = 'InProgress';

                    // Response
                    req.reply({
                        StatusCode: '31',
                        Message: "Workflow Triggered"
                    });
                } catch (err) {
                    console.log("Error while triggering Workflow", err);
                    
                    HeaderData.StatusCode = "30";
                    HeaderData.Message = "Workflow trigger Failed!";
                }
            } else {
                // TODO: create one more field in the entity to store additional message in the table
                HeaderData.StatusCode = '20';
                HeaderData.Message = HeaderData.Message === '' ? '3-Way Check failed' : HeaderData.Message;
            }

            try {
                // Save the status in the execution log table
                INSERT_resp = await INSERT.into('db.tables.InvoiceHeader').entries(HeaderData);
                console.log('Data Insert Result :', INSERT_resp);

                if (HeaderData.StatusCode === '20' || HeaderData.StatusCode === '30') 
                    return {
                        StatusCode : HeaderData.StatusCode,
                        Message : HeaderData.Message
                    };
                else 
                    return {
                        StatusCode : HeaderData.StatusCode,
                        Message : "Good Accuracy -> 3-Way check Completed -> Workflow trigered -> Approval InProgress"
                    };
            } catch (err) {
                console.log("Error while saving execution Logs", err);
                return {
                    StatusCode : "40",
                    Message : "All OK. However Execution log is not saved!"
                }
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
                oResp;

            try {
                // Invoice Creation Approved
                if(req.data.data.StatusCode === '53') {
                    // Document Date - Header field value
                    dDats = new Date(req.data.data.PODate);
                    sUsableDate1 = `${dDats.getFullYear()}-${dDats.getMonth()+1}-${dDats.getDate()}T00:00`;

                    //Posting Date - Header field value
                    dDats = new Date();
                    sUsableDate2 = `${dDats.getFullYear()}-${dDats.getMonth()+1}-${dDats.getDate()}T00:00`;

                    // Building Item Data
                    for (let i = 0; i < req.data.data.Items.length; i++) {
                        const element = req.data.data.Items[i];
                        
                        oTempItem = {
                            "FiscalYear": element.FiscalYear,
                            "SupplierInvoiceItem": element.ReferenceDocumentItem,
                            "PurchaseOrder": element.PONumber,
                            "PurchaseOrderItem": element.POItem,
                            "ReferenceDocument": element.ReferenceDocument,
                            "ReferenceDocumentFiscalYear": element.ReferenceDocumentFiscalYear,
                            "ReferenceDocumentItem": element.ReferenceDocumentItem,
                            "DocumentCurrency": req.data.data.Currency,
                            "SupplierInvoiceItemAmount": element.NetAmount,
                            "PurchaseOrderQuantityUnit": element.UoM,
                            "QuantityInPurchaseOrderUnit": element.Quantity,
                            "SupplierInvoiceItemText": ""
                        };

                        aItemData.push(oTempItem);
                    }

                    // Building Header Data
                    oHeaderData = {
                        "FiscalYear": aItemData[0].FiscalYear,
                        "CompanyCode": req.data.data.Comp_Code,
                        "DocumentDate": sUsableDate1,
                        "PostingDate": sUsableDate2,
                        "SupplierInvoiceIDByInvcgParty": req.data.data.SupInvNumber,
                        "InvoicingParty": req.data.data.SupplierNumber,
                        "DocumentCurrency": req.data.data.Currency,
                        "InvoiceGrossAmount": req.data.data.GrossAmount,
                        "to_SuplrInvcItemPurOrdRef": aItemData
                    };

                    // Connecting to Invoice Service
                    oInvService = await cds.connect.to("invoicesrv");
                    console.log("invoice Service : ", oInvService);

                    // Posting invoice to S/4 System
                    oS4Resp = await oInvService.send({
                        method: "POST",
                        path: "A_SupplierInvoice",
                        headers: {
                            "contentType": "application/json",
                            "x-Requested-With" : "X"
                        },
                        data: oHeaderData
                    });
                    console.log("API Respponse ----> ", oS4Resp);

                    // Invoice Number created successfully ? Yes
                    if (oS4Resp.SupplierInvoice !== undefined && oS4Resp.SupplierInvoice !== '' && oS4Resp.SupplierInvoice !== null) {
                        console.log("Invoice Created Successfully : ", oS4Resp.SupplierInvoice);
                        
                        // Update the status in the execution log table
                        req.data.data.CreatedInvNumber = oS4Resp.SupplierInvoice;
                        req.data.data.StatusCode = "61";
                        req.data.data.Message = "Invoice Created";

                        // // Take the record ID by passing Processflow ID
                        // let oRecord = await SELECT .columns `ID` .from `db.tables.InvoiceHeader` .where({ProcessFlowID : req.data.data.ProcessFlowID});
                        // console.log(oRecord);

                        // Update the record of processflowID with invoice number from S/4 System
                        oResp = await UPDATE `db.tables.InvoiceHeader` 
                                        .set({StatusCode : req.data.data.StatusCode, Message : 'Invoice Created', CreatedInvNumber : req.data.data.CreatedInvNumber }) 
                                        .where({ProcessFlowID : req.data.data.ProcessFlowID});
                        console.log("Saved record", oResp);

                        return {
                            StatusCode : "61",
                            Message : "Invoice Created and Updated Table Record",
                            RecordUpdated : oResp
                        };
                    } 
                    // No
                    else {

                        // Update the Status as 'Failed'
                        oResp = await UPDATE `db.tables.InvoiceHeader` 
                                    .set({StatusCode : '60', Message : 'Inv.Posting failed'}) 
                                    .where({ProcessFlowID : req.data.data.ProcessFlowID});

                        // Send Failed Response
                        return {
                            StatusCode : "60",
                            Message : "Invoice Creation failed! and Updated the status",
                            RecordUpdated : oResp
                        };
                    }
                } 
                // Invoice Creation Rejected
                else {
                    // Update the record of processflowID with Status message as 'Rejected'
                    oResp = await UPDATE `db.tables.InvoiceHeader` 
                                .set({StatusCode : req.data.data.StatusCode, Message : req.data.data.Message, CreatedInvNumber : "" }) 
                                .where({ProcessFlowID : req.data.data.ProcessFlowID});
                    console.log("Saved Rejected status in the record", oResp);

                    return {
                        StatusCode : "54",
                        Message : "Execution log updated with status Rejected",
                        RecordUpdated : oResp
                    };
                }
            } catch (err) {
                // Technical Errors or DB Connection errors
                console.log("Backend Error ----> ", err);
            }
        });
        ///////////////////////////////////// --- BPA - API call ////////////////////////////////////////////////////////////

        return super.init() // if no handlers found or after successful handler execution , proceed with 'managed' capability
    }
}