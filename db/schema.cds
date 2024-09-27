namespace db.tables;

using { cuid, managed } from '@sap/cds/common';

entity InvoiceHeader : cuid, managed {
    key ID : UUID;
    PONumber : String(10)           default ''               @Common.Label : 'Pur.Ord Number';
    MailDateTime : DateTime                                  @Common.Label : 'Mail Date & Time';
    Comp_Code : String(5)           default ''               @Common.Label : 'Company Code';
    SupplierMail : String(50)       default ''               @Common.Label : 'Supplier MailID';  
    MailSubject : String(60)        default ''               @Common.Label : 'EMail Subject';
    SupInvNumber : String(20)       default ''               @Common.Label : 'Supplier Inv.number';
    CreatedInvNumber : String(20)   default ''               @Common.Label : 'S/4 Invoice Number';
    SupplierNumber : String(20)     default ''               @Common.Label : 'Supplier Number';
    SupplierName : String(40)       default ''               @Common.Label : 'Supplier Name';
    PODate : Date                                            @Common.Label : 'Pur.Ord Date';
    Currency : String(3)            default ''               @Common.Label : 'Currency';
    GrossAmount : String(15)        default ''               @Common.Label : 'Gross Amount';
    StatusCode : String(3)          default ''               @Common.Label : 'Status';
    Message : String(100)           default ''               @Common.Label : 'Message';
    ProcessFlowID : String(40)      default ''               @Common.Label : 'Workflow ID';
    SupplierName_ac : String(5)     default ''               @Common.Label : 'Supplier Name - Accuracy';
    PONumber_ac : String(5)         default ''               @Common.Label : 'Pur.Ord Number - Accuracy';
    PODate_ac : String(5)           default ''               @Common.Label : 'Pur.Ord Date - Accuracy';
    Curr_ac : String(5)             default ''               @Common.Label : 'Currency - Accuracy';
    SupInvNumber_ac : String(5)     default ''               @Common.Label : 'Supplier Inv.Number - Accuracy';        
    GrossAmount_ac : String(5)      default ''               @Common.Label : 'Gross Amount - Accuracy';

    Items : Composition of many Items on Items.Parent = $self;
}

entity Items : cuid {
    key ID : UUID;  
    key Parent : Association to one InvoiceHeader               @Common.Label : 'Parent_ID';
    PONumber : String(10)                       default ''      @Common.Label : 'Pur.Ord Number';
    MaterialNumber : String(40)                 default ''      @Common.Label : 'Material Number';
    Quantity : String(5)                        default ''      @Common.Label : 'Quantity';
    UoM : String(5)                             default ''      @Common.Label : 'Unit of Measure';
    UnitPrice : String(15)                      default ''      @Common.Label : 'Unit Price';
    NetAmount : String(15)                      default ''      @Common.Label : 'Total Amount';
    MatNum_ac : String(5)                       default ''      @Common.Label : 'Material Number - Accuracy';
    Quantity_ac : String(5)                     default ''      @Common.Label : 'Quantity - Accuracy';
    UoM_ac : String(5)                          default ''      @Common.Label : 'UoM - Accuracy';
    UnitPrice_ac : String(5)                    default ''      @Common.Label : 'Unit Price - Accuracy';
    NetAmount_ac : String(5)                    default ''      @Common.Label : 'Total Amount - Accuracy';
    Message : String(100)                       default ''      @Common.Label : 'Message';
    SuplInvItem : String(5)                     default ''      @Common.Label : 'Sup.Inv Item';
    POItem : String(5)                          default ''      @Common.Label : 'Item Number';
    ReferenceDocument : String(20)              default ''      @Common.Label : 'Ref.Document'; 
    ReferenceDocumentFiscalYear : String(20)    default ''      @Common.Label : 'Ref.Doc.Year';
    ReferenceDocumentItem : String(20)          default ''      @Common.Label : 'Ref.Doc.Item';
    FiscalYear : String(5)                      default ''      @Common.Label : 'Fiscal Year';
}