namespace tablemodel.srv;

using db.tables as Tables from '../db/schema';

@impl: '/srv/Handlers/ServiceHandler.js'
@path: '/invoiceAutomation-srv'
service InvoiceService {
    // -------------------- Service Entities
    entity InvoiceHeader  as projection on Tables.InvoiceHeader
        actions {
            action threeWayCheckUI();
        };

    entity InvoiceItems   as projection on Tables.Items;

    @cds.odata.valuelist
    entity PurchaseOrders as projection on Tables.PurchaseOrderTable;

    @cds.odata.valuelist
    entity Suppliers      as projection on Tables.Supplier;

    type threeWayCheck_RespObject {
        StatusCode    : String;
        Flag          : String;
        Message       : String;
        RecordUpdated : String;
    };

    // -------------------- Three Way Check - Action Import
    // Item Structure
    type ItemsObject_threewaycheck {
        PONumber       : String(10);
        MaterialNumber : String(40);
        Quantity       : String(5);
        UoM            : String(5);
        UnitPrice      : String(15);
        NetAmount      : String(15);
        MatNum_ac      : String(5);
        Quantity_ac    : String(5);
        UoM_ac         : String(5);
        UnitPrice_ac   : String(5);
        NetAmount_ac   : String(5);
        Message        : String;
    };

    // Attachment structure
    type AttachmentObject {
        content  : LargeBinary;
        name     : String;
        filename : String;
        mimeType : String default 'application/pdf';
    };

    // Header Structure
    type threeWayCheck_payload {
        PONumber         : String(10);
        MailDateTime     : String(30);
        SupplierMail     : String(50);
        MailSubject      : String(60);
        SupInvNumber     : String(20);
        CreatedInvNumber : String(20);
        SupplierNumber   : String(20);
        SupplierName     : String(40);
        PODate           : Date;
        Currency         : String(3);
        GrossAmount      : String(15);
        StatusCode_code  : String(3);
        Message          : String;
        Reason           : String;
        ProcessFlowID    : String(40);
        SupplierName_ac  : String(5);
        PONumber_ac      : String;
        PODate_ac        : String(5);
        Curr_ac          : String(5);
        SupInvNumber_ac  : String(5);
        GrossAmount_ac   : String(5);
        Items            : array of ItemsObject_threewaycheck;
        attachments      : array of AttachmentObject;
    };

    action   threeWayCheck(data : threeWayCheck_payload) returns threeWayCheck_RespObject;

    // -------------------- Invoice Posting - Action Import
    type ItemsObject_invpost {
        PONumber                    : String(10);
        MaterialNumber              : String(40);
        Quantity                    : String(5);
        UoM                         : String(5);
        UnitPrice                   : String(15);
        NetAmount                   : String(15);
        MatNum_ac                   : String(5);
        Quantity_ac                 : String(5);
        UoM_ac                      : String(5);
        UnitPrice_ac                : String(5);
        NetAmount_ac                : String(5);
        Message                     : String;
        SuplInvItem                 : String(5);
        POItem                      : String(5);
        ReferenceDocument           : String(20);
        ReferenceDocumentFiscalYear : String(20);
        ReferenceDocumentItem       : String(20);
        FiscalYear                  : String(5);
    };

    // Header Structure
    type invpost_payload {
        PONumber         : String(10);
        MailDateTime     : String(30);
        Comp_Code        : String(5);
        SupplierMail     : String(50);
        MailSubject      : String(60);
        SupInvNumber     : String(20);
        CreatedInvNumber : String(20);
        SupplierNumber   : String(20);
        SupplierName     : String(40);
        PODate           : Date;
        Currency         : String(3);
        GrossAmount      : String(15);
        StatusCode_code  : String(3);
        Message          : String;
        Reason           : String;
        ProcessFlowID    : String(40);
        SupplierName_ac  : String(5);
        PONumber_ac      : String;
        PODate_ac        : String(5);
        Curr_ac          : String(5);
        SupInvNumber_ac  : String(5);
        GrossAmount_ac   : String(5);
        Items            : array of ItemsObject_invpost
    };

    action   PostInvoice(data : invpost_payload)         returns threeWayCheck_RespObject;

    type DynamicAppLauncher {
        subtitle  : String;
        title     : String;
        icon      : String;
        info      : String;
        infoState : String;
        number    : Decimal(9, 2);
    // numberDigits : Integer;
    // numberFactor : String;
    // numberState  : String;
    // numberUnit   : String;
    // stateArrow   : String;
    };

    function getTileInfo(tileType : String)              returns DynamicAppLauncher;

}

// Extending the Entities - Delta
extend Tables.InvoiceHeader with {
    PONumber_ac_text     : String  = PONumber_ac || ' %'                   @Consumption.filter.hidden: true;
    PONumber_acc         : Integer = case
                                         when
                                             (
                                                 PONumber_ac < '80'
                                             )
                                         then
                                             1
                                         else
                                             3
                                     end                                   @Consumption.filter.hidden: true;
    SupplierName_ac_text : String  = SupplierName_ac || ' %';
    SupplierName_acc     : Integer = case
                                         when
                                             (
                                                 SupplierName_ac < '80'
                                             )
                                         then
                                             1
                                         else
                                             3
                                     end                                   @Consumption.filter.hidden: true;
    SupInvNumber_ac_text : String  = SupInvNumber_ac || ' %';
    SupInvNumber_acc     : Integer = case
                                         when
                                             (
                                                 SupInvNumber_ac < '80'
                                             )
                                         then
                                             1
                                         else
                                             3
                                     end                                   @Consumption.filter.hidden: true;
    Curr_ac_text         : String  = Curr_ac || ' %';
    Curr_acc             : Integer = case
                                         when
                                             (
                                                 Curr_ac < '80'
                                             )
                                         then
                                             1
                                         else
                                             3
                                     end                                   @Consumption.filter.hidden: true;
    GrossAmount_ac_text  : String  = GrossAmount_ac || ' %';
    GrossAmount_acc      : Integer = case
                                         when
                                             (
                                                 GrossAmount_ac < '80'
                                             )
                                         then
                                             1
                                         else
                                             3
                                     end                                   @Consumption.filter.hidden: true;
    SupNoName            : String  = SupplierNumber || '-' || SupplierName @Common.Label             : 'Supplier';
    overall_ac           : Integer;
    overall_acc          : Integer = case
                                         when
                                             (
                                                 overall_ac     < 80
                                                 and overall_ac > 60
                                             )
                                         then
                                             2
                                         when
                                             (
                                                 overall_ac < 60
                                             )
                                         then
                                             1
                                         else
                                             3
                                     end                                   @Consumption.filter.hidden: true;
    overall_target       : Integer = 100                                   @Consumption.filter.hidden: true;

};

extend Tables.Items with {
    Criticality_code_item : Integer = case
                                          when
                                              Message <> ''
                                          then
                                              1
                                          when
                                              Message = ''
                                          then
                                              0
                                      end;
    MatNum_ac_text        : String  = MatNum_ac || ' %';
    MatNum_acc            : Integer = case
                                          when
                                              (
                                                  MatNum_ac < '80'
                                              )
                                          then
                                              1
                                          else
                                              3
                                      end;
    Quantity_ac_text      : String  = Quantity_ac || ' %';
    Quantity_acc          : Integer = case
                                          when
                                              (
                                                  Quantity_ac < '80'
                                              )
                                          then
                                              1
                                          else
                                              3
                                      end;
    UnitPrice_ac_text     : String  = UnitPrice_ac || ' %';
    UnitPrice_acc         : Integer = case
                                          when
                                              (
                                                  UnitPrice_ac < '80'
                                              )
                                          then
                                              1
                                          else
                                              3
                                      end;
    UoM_ac_text           : String  = UoM_ac || ' %';
    UoM_acc               : Integer = case
                                          when
                                              (
                                                  UoM_ac < '80'
                                              )
                                          then
                                              1
                                          else
                                              3
                                      end;
    NetAmount_ac_text     : String  = NetAmount_ac || ' %';
    NetAmount_acc         : Integer = case
                                          when
                                              (
                                                  NetAmount_ac < '80'
                                              )
                                          then
                                              1
                                          else
                                              3
                                      end;
    Material              : String  = MaterialNumber || ''                @Common.Label: 'Material';
    QuantityUnit          : String  = Quantity || ' ' || UoM              @Common.Label: 'Quantity';
    UnitPriceCur          : String  = UnitPrice || ' ' || Parent.Currency @Common.Label: 'Unit Price';
    NetamountCur          : String  = NetAmount || ' ' || Parent.Currency @Common.Label: 'Net Amount';
};


// -------------------------- Entity for Configuration App - Search Criteria -----------------------------------------
@path: '/SearchApp-srv'
@impl: '/srv/Handlers/SearchAppHandler.js'
service SearchAppService {

    entity Searchheader as projection on Tables.Searchheader;
    entity Searchitem   as projection on Tables.Searchitem;

    type ty_search_item {
        element : String(50);
        operand : String(50);
        value   : String(50);
    };

    function getSearchConfig(username : String, machinename : String) returns array of ty_search_item;

}
// -------------------------- Entity for Configuration App - Search Criteria -----------------------------------------


///////// ----------------------- START Entity for Purchase Order App -----------------------------------//////////////
@path: '/PO-App-srv'
@impl: '/srv/Handlers/POAppHandler.js'
service POServices {

    entity POHeader as projection on Tables.POHeader;
    entity POItem   as projection on Tables.PoItems;

    // Structure
    type po_payload {
        mailDateTime : String(30);
        emailid      : String(100);
        mailSubject  : String(60);
        content      : LargeBinary;
        name         : String;
        filename     : String;
        mimeType     : String default 'application/pdf';
    };

    type po_payload_resp {
        status  : String;
        message : String;
        id      : String;
    };


    //  Un-bound Action
    action extract_and_save_po_data(data : po_payload) returns po_payload_resp;


}

///////// ----------------------- END Entity for Purchase Order App -----------------------------------//////////////
