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
        SupplierName_ac  : String(20) default ''         @Common.Label: 'Supplier Name - Accuracy';
        PONumber_ac      : String(20) default ''         @Common.Label: 'Pur.Ord Number - Accuracy';
        PODate_ac        : String(20) default ''         @Common.Label: 'Pur.Ord Date - Accuracy';
        Curr_ac          : String(20) default ''         @Common.Label: 'Currency - Accuracy';
        SupInvNumber_ac  : String(20) default ''         @Common.Label: 'Supplier Inv.Number - Accuracy';
        GrossAmount_ac   : String(20) default ''         @Common.Label: 'Gross Amount - Accuracy';
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
        Quantity                    : String(10) default ''            @Common.Label: 'Quantity';
        UoM                         : String(5) default ''             @Common.Label: 'Unit of Measure';
        UnitPrice                   : String(15) default ''            @Common.Label: 'Unit Price';
        NetAmount                   : String(15) default ''            @Common.Label: 'Total Amount';
        MatNum_ac                   : String(20) default ''                @Common.Label: 'Material Number - Accuracy';
        Quantity_ac                 : String(20) default ''                @Common.Label: 'Quantity - Accuracy';
        UoM_ac                      : String(20) default ''                @Common.Label: 'UoM - Accuracy';
        UnitPrice_ac                : String(20) default ''                @Common.Label: 'Unit Price - Accuracy';
        NetAmount_ac                : String(20) default ''                @Common.Label: 'Total Amount - Accuracy';
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
            Failed = '60';
            InProgress = '61';
            Completed = '62';
            Error = '63';
            Saved = '64';
        };
        status_critics : Integer enum {
            Unknown = 0;
            Red = 1;
            Yellow = 2;
            Green = 3;
            Blue = 5;
        }
};
// -------------------------- Entity for Monitoring App -----------------------------------------


// -------------------------- Entity for Configuration App - Search Criteria -----------------------------------------
entity Searchheader : cuid, managed {
    Name         : String(255)                 @Common.Label: 'User Name';
    Status       : Association to Statuscode_s @Common.Label: 'Status';
    machine_name : String(100)                 @Common.Label: 'Machine Name';
    Items_s      : Composition of many Searchitem
                       on Items_s.parent = $self;
}

entity Searchitem : cuid {
    key parent    : Association to Searchheader;
        Sequence  : String(50)                     @Common.Label: 'Sequence';
        elements1 : Association to one elementlist @Common.Label: 'Element';
        operand   : Association to Operands        @Common.Label: 'Operand';
        Value     : String                         @Common.Label: 'Value';
}

entity elementlist : CodeList {
    key code : String(20) enum {
            IsRead = '01';
            Subject = '02';
            Sender_Name = '03';
            HasAttachment = '04';
        };
}

entity Statuscode_s : CodeList {
    key code : String(10) enum {
            Active = '101';
            InActive = '102';
        }
}

entity Operands : CodeList {
    key code : String(10) enum {
            equals = '301';
            contains = '302';
        };
}
// -------------------------- Entity for Configuration App - Search Criteria -----------------------------------------


// -------------------------- Entity for Purchase Order App -----------------------------------------
entity POHeader : cuid, managed {
    key ID                     : UUID;
        documentNumber         : String(10) default ''        @Common.Label: 'Pur.Ord Number';
        mailDateTime           : DateTime                     @Common.Label: 'Mail Date & Time';
        emailid                : String(50) default ''        @Common.Label: 'Supplier MailID';
        mailSubject            : String(60) default ''        @Common.Label: 'EMail Subject';
        dox_id                 : String(40) default ''        @Common.Label: 'DOX-ID';
        extraction_status      : String(15) default 'Pending' @Common.Label: 'Extraction Status';
        netAmount              : String(20) default ''        @Common.Label: 'Net Amount';
        grossAmount            : String(20) default ''        @Common.Label: 'Gross Amount';
        currencyCode           : String(5) default ''         @Common.Label: 'Currency Code';
        documentDate           : Date default ''              @Common.Label: 'Document Date';
        deliveryDate           : Date default ''              @Common.Label: 'Delivery Date';
        senderName             : String(60) default ''        @Common.Label: 'Ship To Address';
        senderEmail            : String(60) default ''        @Common.Label: 'Sender Email';
        StatusCode             : Association to one Status    @Common.Label: 'Status';
        taxId                  : String(15) default ''        @Common.Label: 'Tax ID';
        paymentTerms           : String(15) default ''        @Common.Label: 'Payment Terms';
        senderBankAccount      : String(60) default ''        @Common.Label: 'Sender Bank Account';
        senderAddress          : String(60) default ''        @Common.Label: 'Sender Address';
        taxIdNumber            : String(60) default ''        @Common.Label: 'Tax ID number';
        receiverId             : String(60) default ''        @Common.Label: 'Sender Name';
        shipToAddress          : String(100) default ''       @Common.Label: 'Receive ID';
        shippingTerms          : String(60) default ''        @Common.Label: 'Shipping Terms';
        quantity               : String(10) default ''        @Common.Label: 'Quantity';
        senderId               : String(60) default ''        @Common.Label: 'Sender ID';
        senderStreet           : String(60) default ''        @Common.Label: 'Sender Street';
        senderCity             : String(60) default ''        @Common.Label: 'Sender City';
        senderHouseNumber      : String(60) default ''        @Common.Label: 'Sender House Number';
        senderPostalCode       : String(10) default ''        @Common.Label: 'Sender Postal Code';
        senderCountryCode      : String(5) default ''         @Common.Label: 'Sender Country Code';
        senderPhone            : String(15) default ''        @Common.Label: 'Sender Phone';
        senderFax              : String(60) default ''        @Common.Label: 'Sender Fax';
        senderState            : String(60) default ''        @Common.Label: 'Sender State';
        senderDistrict         : String(60) default ''        @Common.Label: 'Sender District';
        senderExtraAddressPart : String(60) default ''        @Common.Label: 'Sender Extra Address Part';
        shipToName             : String(60) default ''        @Common.Label: 'Ship To Name';
        shipToStreet           : String(60) default ''        @Common.Label: 'Ship To Street';
        shipToCity             : String(60) default ''        @Common.Label: 'Ship To City';
        shipToHouseNumber      : String(60) default ''        @Common.Label: 'Ship To House Number';
        shipToPostalCode       : String(10) default ''        @Common.Label: 'Ship To Postal Code';
        shipToCountryCode      : String(5) default ''         @Common.Label: 'Ship To Country Code';
        shipToPhone            : String(15) default ''        @Common.Label: 'Ship To Phone';
        shipToFax              : String(15) default ''        @Common.Label: 'Ship To Fax';
        shipToEmail            : String(60) default ''        @Common.Label: 'Ship To Email';
        shipToState            : String(60) default ''        @Common.Label: 'Ship To State';
        shipToDistrict         : String(60) default ''        @Common.Label: 'Ship To District';
        shipToExtraAddressPart : String(60) default ''        @Common.Label: 'Ship To Extra Address Part';
        documentNumber_ac      : String(8) default '0.00'     @Common.Label: 'Doc.Number - Accuracy';
        netAmount_ac           : String(8) default '0.00'     @Common.Label: 'Net Amount - Accuracy';
        grossAmount_ac         : String(8) default '0.00'     @Common.Label: 'Gross Amount - Accuracy';
        currencyCode_ac        : String(8) default '0.00'     @Common.Label: 'Currency - Accuracy';
        documentDate_ac        : String(8) default '0.00'     @Common.Label: 'Doc.Date - Accuracy';
        senderName_ac          : String(8) default '0.00'     @Common.Label: 'Sender Name - Accuracy';
        PoItems                : Composition of many PoItems
                                     on PoItems.Parent = $self;
}

entity PoItems : cuid {
    key ID                        : UUID;
    key Parent                    : Association to one POHeader @Common.Label: 'Parent_ID';
        description               : String(60) default ''       @Common.Label: 'Description';
        netAmount                 : String(20) default ''       @Common.Label: 'Net Amount';
        quantity                  : String(10) default ''       @Common.Label: 'Quantity';
        unitPrice                 : String(15) default ''       @Common.Label: 'Unit Price';
        materialNumber            : String(40) default ''       @Common.Label: 'Material Number';
        documentDate              : Date default ''             @Common.Label: 'Document Date';
        itemNumber                : String(6) default ''        @Common.Label: 'Item Number';
        currencyCode              : String(5) default ''        @Common.Label: 'Currency Code';
        senderMaterialNumber      : String(40) default ''       @Common.Label: 'Sender Material Number';
        supplierMaterialNumber    : String(40) default ''       @Common.Label: 'Supplier Material Number';
        customerMaterialNumber    : String(40) default ''       @Common.Label: 'Custom Material Number';
        unitOfMeasure             : String(5) default ''        @Common.Label: 'Unit of Measure';
        description_ac            : String(8) default '0.00'    @Common.Label: 'Description - Accuracy';
        netAmount_ac              : String(8) default '0.00'    @Common.Label: 'Net Amount - Accuracy';
        quantity_ac               : String(8) default '0.00'    @Common.Label: 'Quantity - Accuracy';
        unitPrice_ac              : String(8) default '0.00'    @Common.Label: 'Unit Price - Accuracy';
        materialNumber_ac         : String(8) default '0.00'    @Common.Label: 'Material Number - Accuracy';
        senderMaterialNumber_ac   : String(8) default '0.00'    @Common.Label: 'Sender.Mat Numb - Accuracy';
        supplierMaterialNumber_ac : String(8) default '0.00'    @Common.Label: 'Suppl.Mat Numb - Accuracy';
        unitOfMeasure_ac          : String(8) default '0.00'    @Common.Label: 'UoM - Accuracy';
        customerMaterialNumber_ac : String(8) default '0.00'    @Common.Label: 'Cust.Mat Number - Accuracy';
}
// -------------------------- Entity for Purchase Order App -----------------------------------------
