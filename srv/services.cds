namespace tablemodel.srv;

using db.tables as Tables from '../db/schema';

@impl : '/srv/Handlers/ServiceHandler.js'
@path : '/invoiceAutomation-srv'
service InvoiceService
{
    // -------------------- Service Entities
    entity InvoiceHeader as
        projection on Tables.InvoiceHeader actions {
            action threeWayCheckUI();
        };

    entity InvoiceItems as projection on Tables.Items;

    type threeWayCheck_RespObject {
        StatusCode : String;
        Flag : String;
        Message : String;
        RecordUpdated : String;
    }

    // -------------------- Three Way Check - Action Import
    // Item Structure
    type ItemsObject_threewaycheck {
        PONumber : String(10);
        MaterialNumber : String(40);
        Quantity : String(5);
        UoM : String(5);
        UnitPrice : String(15);
        NetAmount : String(15);
        MatNum_ac : String(5);
        Quantity_ac : String(5);
        UoM_ac : String(5);
        UnitPrice_ac : String(5);
        NetAmount_ac : String(5);
        Message : String;
    }

    // Header Structure
    type threeWayCheck_payload {
        PONumber : String(10);
        MailDateTime : String(30);
        SupplierMail : String(50);
        MailSubject : String(60);
        SupInvNumber : String(20);
        CreatedInvNumber : String(20);
        SupplierNumber : String(20);
        SupplierName : String(40);
        PODate : Date;
        Currency : String(3);
        GrossAmount : String(15);
        StatusCode : String(3);
        Message : String;
        ProcessFlowID : String(40);
        SupplierName_ac : String(5);
        PONumber_ac : String;
        PODate_ac : String(5);
        Curr_ac : String(5);
        SupInvNumber_ac : String(5);
        GrossAmount_ac : String(5);
        Items : array of ItemsObject_threewaycheck
    }
    action threeWayCheck(data : threeWayCheck_payload) returns threeWayCheck_RespObject;

    // -------------------- Invoice Posting - Action Import
    type ItemsObject_invpost {
        PONumber : String(10);
        MaterialNumber : String(40);
        Quantity : String(5);
        UoM : String(5);
        UnitPrice : String(15);
        NetAmount : String(15);
        MatNum_ac : String(5);
        Quantity_ac : String(5);
        UoM_ac : String(5);
        UnitPrice_ac : String(5);
        NetAmount_ac : String(5);
        Message : String;
        SuplInvItem : String(5);
        POItem : String(5);
        ReferenceDocument : String(20);
        ReferenceDocumentFiscalYear : String(20);
        ReferenceDocumentItem : String(20);
        FiscalYear : String(5);
    }

    // Header Structure
    type invpost_payload {
        PONumber : String(10);
        MailDateTime : String(30);
        Comp_Code : String(5);
        SupplierMail : String(50);
        MailSubject : String(60);
        SupInvNumber : String(20);
        CreatedInvNumber : String(20);
        SupplierNumber : String(20);
        SupplierName : String(40);
        PODate : Date;
        Currency : String(3);
        GrossAmount : String(15);
        StatusCode : String(3);
        Message : String;
        ProcessFlowID : String(40);
        SupplierName_ac : String(5);
        PONumber_ac : String;
        PODate_ac : String(5);
        Curr_ac : String(5);
        SupInvNumber_ac : String(5);
        GrossAmount_ac : String(5);
        Items : array of ItemsObject_invpost
    }
    action PostInvoice(data : invpost_payload) returns threeWayCheck_RespObject;

}

// Role Name
// annotate InvoiceService with @(requires: 'Invoice_Admin');


// Entending the Entities - Delta
extend Tables.InvoiceHeader with {
    Criticality_code : Integer = case 
                                    when ( StatusCode = '10' or StatusCode = '20' or StatusCode = '30' or StatusCode = '60' or StatusCode = '54' ) then 1
                                    when ( StatusCode = '61' or StatusCode = 'S' ) then 3
                                    when ( StatusCode = '52' ) then 2
                                    when ( StatusCode = '50' ) then 5
                                    else 0
                                end;
    PONumber_ac_text : String = PONumber_ac || ' %';
    PONumber_acc : Integer = case 
                                when ( PONumber_ac < '80' ) then 1
                                else 5
                            end;
    SupplierName_ac_text : String = SupplierName_ac || ' %';
    SupplierName_acc : Integer = case 
                                    when ( SupplierName_ac < '80' ) then 1
                                    else 5
                                end;
    SupInvNumber_ac_text : String = SupInvNumber_ac || ' %';
    SupInvNumber_acc : Integer = case 
                                    when ( SupInvNumber_ac < '80' ) then 1
                                    else 5
                                end;
    Curr_ac_text : String = Curr_ac || ' %';
    Curr_acc : Integer = case 
                            when ( Curr_ac < '80' ) then 1
                            else 5
                        end;
    GrossAmount_ac_text : String = GrossAmount_ac || ' %';
    GrossAmount_acc : Integer = case 
                            when ( GrossAmount_ac < '80' ) then 1
                            else 5
                        end;
    SupNoName : String = SupplierNumber || '-' || SupplierName @Common.Label : 'Supplier';

};

extend Tables.Items with {
    Criticality_code_item : Integer = case 
                                        when Message <> '' then 1
                                        when Message = '' then 0
                                      end;
    MatNum_ac_text : String = MatNum_ac || ' %';
    MatNum_acc : Integer = case 
                            when ( MatNum_ac < '80' ) then 1
                            else 5
                        end;
    Quantity_ac_text : String = Quantity_ac || ' %';
    Quantity_acc : Integer = case 
                            when ( Quantity_ac < '80' ) then 1
                            else 5
                        end;
    UnitPrice_ac_text : String = UnitPrice_ac || ' %';
    UnitPrice_acc : Integer = case 
                            when ( UnitPrice_ac < '80' ) then 1
                            else 5
                        end;
    UoM_ac_text : String = UoM_ac || ' %';
    UoM_acc : Integer = case 
                            when ( UoM_ac < '80' ) then 1
                            else 5
                        end;
    NetAmount_ac_text : String = NetAmount_ac || ' %';
    NetAmount_acc : Integer = case 
                            when ( NetAmount_ac < '80' ) then 1
                            else 5
                        end;
    Material : String = MaterialNumber || ''                        @Common.Label : 'Material';
    QuantityUnit : String = Quantity || ' ' || UoM                  @Common.Label : 'Quantity';
    UnitPriceCur : String = UnitPrice || ' ' || Parent.Currency     @Common.Label : 'Unit Price';
    NetamountCur : String = NetAmount || ' ' || Parent.Currency     @Common.Label : 'Net Amount';
};