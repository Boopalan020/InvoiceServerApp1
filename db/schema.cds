namespace db.tables;

using {
    cuid,
    managed,
    sap.common.CodeList as CodeList
} from '@sap/cds/common';
using {Attachments} from '@cap-js/sdm';
using {poextsrv.A_PurchaseOrder as A_PurchaseOrder} from '../srv/external/poextsrv';
using {suppl_api.ZC_Supplier_1 as suppl_api} from '../srv/external/suppl_api';

// -------------------------- Entity for Monitoring App -----------------------------------------
entity InvoiceHeader : cuid, managed {
    key ID               : UUID;
        PONumber         : String(10) default ''     @Common.Label: 'Pur.Ord Number';
        MailDateTime     : DateTime                  @Common.Label: 'Mail Date & Time';
        Comp_Code        : String(5) default ''      @Common.Label: 'Company Code';
        SupplierMail     : String(50) default ''     @Common.Label: 'Supplier MailID';
        MailSubject      : String(60) default ''     @Common.Label: 'EMail Subject';
        SupInvNumber     : String(20) default ''     @Common.Label: 'Supplier Inv.number';
        CreatedInvNumber : String(20) default ''     @Common.Label: 'S/4 Invoice Number';
        SupplierNumber   : String(20) default ''     @Common.Label: 'Supplier Number';
        SupplierName     : String(40) default ''     @Common.Label: 'Supplier Name';
        PODate           : Date                      @Common.Label: 'Pur.Ord Date';
        Currency         : String(3) default ''      @Common.Label: 'Currency';
        GrossAmount      : String(15) default ''     @Common.Label: 'Gross Amount';
        StatusCode       : Association to one Status @Common.Label: 'Status';
        Message          : String(100) default ''    @Common.Label: 'Message';
        Reason           : String default ''         @Common.Label: 'Error-Reason';
        ProcessFlowID    : String(40) default ''     @Common.Label: 'Workflow ID';
        SupplierName_ac  : String(5) default ''      @Common.Label: 'Supplier Name - Accuracy';
        PONumber_ac      : String(5) default ''      @Common.Label: 'Pur.Ord Number - Accuracy';
        PODate_ac        : String(5) default ''      @Common.Label: 'Pur.Ord Date - Accuracy';
        Curr_ac          : String(5) default ''      @Common.Label: 'Currency - Accuracy';
        SupInvNumber_ac  : String(5) default ''      @Common.Label: 'Supplier Inv.Number - Accuracy';
        GrossAmount_ac   : String(5) default ''      @Common.Label: 'Gross Amount - Accuracy';

        Items            : Composition of many Items
                               on Items.Parent = $self;
// // Below part is on development
// attachments : Composition of many C_Attachment on attachments.Parent = $self; <--- uncomment to enable attachment feature
// attachments : Composition of many Attachments;
}

// // Below part is on development
// entity C_Attachment : Attachments {
//     key Parent : Association to one InvoiceHeader;
// };

entity Items : cuid {
    key ID                          : UUID;
    key Parent                      : Association to one InvoiceHeader @Common.Label: 'Parent_ID';
        PONumber                    : String(10) default ''            @Common.Label: 'Pur.Ord Number';
        MaterialNumber              : String(40) default ''            @Common.Label: 'Material Number';
        Quantity                    : String(5) default ''             @Common.Label: 'Quantity';
        UoM                         : String(5) default ''             @Common.Label: 'Unit of Measure';
        UnitPrice                   : String(15) default ''            @Common.Label: 'Unit Price';
        NetAmount                   : String(15) default ''            @Common.Label: 'Total Amount';
        MatNum_ac                   : String(5) default ''             @Common.Label: 'Material Number - Accuracy';
        Quantity_ac                 : String(5) default ''             @Common.Label: 'Quantity - Accuracy';
        UoM_ac                      : String(5) default ''             @Common.Label: 'UoM - Accuracy';
        UnitPrice_ac                : String(5) default ''             @Common.Label: 'Unit Price - Accuracy';
        NetAmount_ac                : String(5) default ''             @Common.Label: 'Total Amount - Accuracy';
        Message                     : String(100) default ''           @Common.Label: 'Message';
        SuplInvItem                 : String(5) default ''             @Common.Label: 'Sup.Inv Item';
        POItem                      : String(5) default ''             @Common.Label: 'Item Number';
        ReferenceDocument           : String(20) default ''            @Common.Label: 'Ref.Document';
        ReferenceDocumentFiscalYear : String(20) default ''            @Common.Label: 'Ref.Doc.Year';
        ReferenceDocumentItem       : String(20) default ''            @Common.Label: 'Ref.Doc.Item';
        FiscalYear                  : String(5) default ''             @Common.Label: 'Fiscal Year';
}

// For ValueHelp Feature - Purchase Order Number
entity PurchaseOrderTable as
    projection on A_PurchaseOrder {
        key PurchaseOrder     @(Common.Label: 'Purchase Order'),
            PurchaseOrderDate @(Common.Label: 'Order Date'),
            PurchaseOrderType @(Common.Label: 'Order Type'),
            CompanyCode       @(Common.Label: 'Comp.Code'),
            CreatedByUser     @(Common.Label: 'Created By'),
            CreationDate      @(Common.Label: 'Created Date'),
            Supplier          @(Common.Label: 'Supplier')
    };

// For ValueHelp Feature - Supplier Number
entity Supplier           as
    projection on suppl_api {
        *
    };

entity Status : CodeList {
    key code           : String(10) enum {
            Failed     = '60';
            InProgress = '61';
            Completed  = '62';
            Error      = '63';
            Saved      = '64';
        };
        status_critics : Integer enum {
            Unknown    = 0;
            Red        = 1;
            Yellow     = 2;
            Green      = 3;
            Blue       = 5;
        }
};
// -------------------------- Entity for Monitoring App -----------------------------------------


// -------------------------- Entity for Configuration App - Search Criteria -----------------------------------------
entity Searchheader : cuid {
    Name         : String(255)                          @Common.Label: 'Name';
    Status       : Association to Statuscode_s          @Common.Label: 'Status';
    machine_name : String(100)                          @Common.Label: 'Machine Name';
    Items_s        : Composition of many Searchitem
                       on Items_s.parent = $self;
}

entity Searchitem : cuid {
    key parent    : Association to Searchheader;
        Sequence  : String(50)                          @Common.Label: 'Sequence';
        elements1 : Association to one elementlist      @Common.Label: 'Element';
        operand   : Association to Operands             @Common.Label: 'Operand';
        Value     : String                              @Common.Label: 'Value';
}

entity elementlist : CodeList {
    key code : String(20) enum {
            IsRead        = '01';
            Subject       = '02';
            Sender_Name   = '03';
            HasAttachment = '04';
        };
}

entity Statuscode_s : CodeList {
    key code : String(10) enum {
            Active   = 'Active';
            InActive = 'Inactive';
        }
}

entity Operands : CodeList {
    key code : String(10) enum {
            Equals   = 'equals';
            Contains = 'contains';
        };
}
// -------------------------- Entity for Configuration App - Search Criteria -----------------------------------------