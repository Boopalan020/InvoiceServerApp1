using tablemodel.srv.InvoiceService as service from '../../srv/services';
using from '../../srv/services';
using from '../../db/schema';

annotate service.InvoiceHeader with @(
    odata.draft.enabled,
    UI.DeleteHidden : { 
        $edmJson: {               
            $Or: [  { $Eq: [ { $Path: 'StatusCode' }, '52'  ] },
                    { $Eq: [ { $Path: 'StatusCode' }, '61'  ] }         
            ]
        }
     },
    UI.UpdateHidden : { 
        $edmJson: {               
        $If: [
                {                         
                    $Or: [  { $Eq: [ { $Path: 'StatusCode' }, '52'  ] },
                            { $Eq: [ { $Path: 'StatusCode' }, '61'  ] }         
                    ]
                },
                true,
                false
            ]
        } 
    },
    UI.SelectionFields : [
        Comp_Code,
        PONumber,
        SupplierMail,
        SupInvNumber,
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : ID,
            ![@UI.Hidden],
        },
        {
            $Type : 'UI.DataField',
            Value : PONumber,
            Label : '{i18n>PurordNumber}',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : SupNoName,
            Label : '{i18n>Supplier}',
        },
        {
            $Type : 'UI.DataField',
            Value : SupplierMail,
            Label : '{i18n>SupplierMailid}',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : MailSubject,
            Label : '{i18n>EmailSubject}',
            ![@UI.Importance] : #Low,
        },
        {
            $Type : 'UI.DataField',
            Value : SupInvNumber,
            Label : '{i18n>SupplierInvnumber}',
            ![@UI.Importance] : #Medium,
        },
        {
            $Type : 'UI.DataField',
            Value : GrossAmount,
            Label : '{i18n>GrossAmount}',
        },
        {
            $Type : 'UI.DataField',
            Value : Message,
            ![@UI.Importance] : #Medium,
            Label : '{i18n>Message}',
            Criticality : Criticality_code,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'tablemodel.srv.InvoiceService.threeWayCheckUI',
            Label : '{i18n>CheckSend1}',
        },   
    ],
    UI.HeaderInfo : {
        TypeName : '{i18n>Invoice}',
        TypeNamePlural : '{i18n>Invoices}',
        Title : {
            $Type : 'UI.DataField',
            Value : SupplierMail,
        },
        Description : {
            $Type : 'UI.DataField',
            Value : 'EMail-ID',
        },
        TypeImageUrl : 'sap-icon://supplier',
    },
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Mail Info',
            ID : 'MailInfo',
            Target : '@UI.FieldGroup#MailInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Automation Info',
            ID : 'AutomationInfo',
            Target : '@UI.FieldGroup#AutomationInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'overall_ac',
            Target : '@UI.Chart#overall_ac',
        },
    ],
    UI.DataPoint #Message : {
        $Type : 'UI.DataPointType',
        Value : Message,
        Title : 'Message',
        Criticality : Criticality_code,
        ![@Common.QuickInfo] : 'Refers to what is the status by the automation',
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'General Info',
            ID : 'GeneralInfo',
            Target : '@UI.FieldGroup#GeneralInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Material(s)',
            ID : 'Materials',
            Target : 'Items/@UI.LineItem#Materials',
        },
    ],
    UI.FieldGroup #GeneralInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected',
                Label : 'Purch.Ord Number - Accuracy',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected2',
                Label : 'Supplier Invoice Number - Accuracy',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected3',
                Label : 'Currency - Accuracy',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected4',
                Label : 'Gross Amount - Accuracy',
            },
        ],
    },
    UI.ConnectedFields #connected : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{PONumber} - {PONumber_ac}',
        Data : {
            $Type : 'Core.Dictionary',
            PONumber : {
                $Type : 'UI.DataField',
                Value : PONumber,
            },
            PONumber_ac : {
                $Type : 'UI.DataField',
                Value : PONumber_ac_text,
                Criticality : PONumber_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected1 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{SupplierName}-{SupplierName_ac}',
        Data : {
            $Type : 'Core.Dictionary',
            SupplierName : {
                $Type : 'UI.DataField',
                Value : SupplierName,
            },
            SupplierName_ac : {
                $Type : 'UI.DataField',
                Value : SupplierName_ac_text,
            },
        },
    },
    UI.ConnectedFields #connected2 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{SupInvNumber}-{SupInvNumber_ac}',
        Data : {
            $Type : 'Core.Dictionary',
            SupInvNumber : {
                $Type : 'UI.DataField',
                Value : SupInvNumber,
            },
            SupInvNumber_ac : {
                $Type : 'UI.DataField',
                Value : SupInvNumber_ac_text,
                Criticality : SupInvNumber_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected3 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{Currency}-{Curr_ac}',
        Data : {
            $Type : 'Core.Dictionary',
            Currency : {
                $Type : 'UI.DataField',
                Value : Currency,
            },
            Curr_ac : {
                $Type : 'UI.DataField',
                Value : Curr_ac_text,
                Criticality : Curr_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected4 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{GrossAmount}-{GrossAmount_ac}',
        Data : {
            $Type : 'Core.Dictionary',
            GrossAmount : {
                $Type : 'UI.DataField',
                Value : GrossAmount,
            },
            GrossAmount_ac : {
                $Type : 'UI.DataField',
                Value : GrossAmount_ac_text,
                Criticality : GrossAmount_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.FieldGroup #MailInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : MailDateTime,
            },
            {
                $Type : 'UI.DataField',
                Value : MailSubject,
            },
            {
                $Type : 'UI.DataField',
                Value : SupplierNumber,
            },
            {
                $Type : 'UI.DataField',
                Value : SupplierName,
            },
        ],
    },
    UI.FieldGroup #AutomationInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : Message,
                Criticality : Criticality_code,
            },
            {
                $Type : 'UI.DataField',
                Value : CreatedInvNumber,
                Criticality : Criticality_code,
                CriticalityRepresentation : #WithoutIcon,
            },
            {
                $Type : 'UI.DataField',
                Value : ProcessFlowID,
            },
            {
                $Type : 'UI.DataField',
                Value : Comp_Code,
            },
        ],
    },
    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'tablemodel.srv.InvoiceService.threeWayCheckUI',
            Label : '{i18n>CheckSend1}',
            Determining : false,
        },
    ],
    UI.DataPoint #overall_ac : {
        Value : overall_ac,
        TargetValue : overall_target,
        Criticality : overall_acc,
    },
    UI.Chart #overall_ac : {
        ChartType : #Donut,
        Title : 'Overall Accuracy',
        Measures : [
            overall_ac,
        ],
        MeasureAttributes : [
            {
                DataPoint : '@UI.DataPoint#overall_ac',
                Role : #Axis1,
                Measure : overall_ac,
            },
        ],
        Description : 'of all Key Fields',
    },
);

annotate service.InvoiceItems with @(
    
    UI.LineItem #Materials : [
        {
            $Type : 'UI.DataField',
            Value : Material,
            Criticality : MatNum_acc,
            CriticalityRepresentation : #WithoutIcon,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : QuantityUnit,
            Label : 'Quantity',
            Criticality : Quantity_acc,
            CriticalityRepresentation : #WithoutIcon,
        },
        {
            $Type : 'UI.DataField',
            Value : UnitPriceCur,
            Label : 'Unit Price',
            Criticality : UnitPrice_acc,
            CriticalityRepresentation : #WithoutIcon,
        },
        {
            $Type : 'UI.DataField',
            Value : NetamountCur,
            Label : 'Net Amount',
            Criticality : NetAmount_acc,
            CriticalityRepresentation : #WithoutIcon,
        },
        {
            $Type : 'UI.DataField',
            Value : Message,
            Criticality : Criticality_code_item,
            CriticalityRepresentation : #WithoutIcon,
            ![@UI.Importance] : #Medium,
        },
    ],
    UI.HeaderInfo : {
        TypeName : '{i18n>LineItem}',
        TypeNamePlural : '{i18n>Lineitems}',
        Title : {
            $Type : 'UI.DataField',
            Value : MaterialNumber,
        },
        TypeImageUrl : 'sap-icon://product',
    },
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'Reference',
            Target : '@UI.FieldGroup#Reference',
            Label : 'S/4 Reference Details',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'Message',
            Target : '@UI.DataPoint#Message2',
        },
    ],
    UI.FieldGroup #Reference : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : ReferenceDocument,
            },
            {
                $Type : 'UI.DataField',
                Value : ReferenceDocumentItem,
            },
            {
                $Type : 'UI.DataField',
                Value : ReferenceDocumentFiscalYear,
            },
            {
                $Type : 'UI.DataField',
                Value : POItem,
            },
        ],
    },
    UI.DataPoint #Message : {
        $Type : 'UI.DataPointType',
        Value : Message,
        Title : 'Message',
        Criticality : Criticality_code_item,
    },
    UI.DataPoint #Criticality_code_item : {
        $Type : 'UI.DataPointType',
        Value : Criticality_code_item,
        Title : 'Criticality_code_item',
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Info',
            ID : 'Info',
            Target : '@UI.Identification',
        },
    ],
    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.ConnectedFields#connected',
            Label : 'Material Number',
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.ConnectedFields#connected1',
            Label : 'Quantity - Accuracy',
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.ConnectedFields#connected4',
            Label : 'Unit of Measure',
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.ConnectedFields#connected2',
            Label : 'Unit Price - Accuracy',
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.ConnectedFields#connected3',
            Label : 'Net Amount - Accuracy',
        },
    ],
    UI.ConnectedFields #connected : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{MaterialNumber}-{MatNum_ac}',
        Data : {
            $Type : 'Core.Dictionary',
            MaterialNumber : {
                $Type : 'UI.DataField',
                Value : MaterialNumber,
            },
            MatNum_ac : {
                $Type : 'UI.DataField',
                Value : MatNum_ac_text,
                Criticality : MatNum_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected1 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{Quantity}-{Quantity_ac}',
        Data : {
            $Type : 'Core.Dictionary',
            Quantity : {
                $Type : 'UI.DataField',
                Value : Quantity,
            },
            Quantity_ac : {
                $Type : 'UI.DataField',
                Value : Quantity_ac_text,
                Criticality : Quantity_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected2 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{UnitPrice}-{UnitPrice_ac}',
        Data : {
            $Type : 'Core.Dictionary',
            UnitPrice : {
                $Type : 'UI.DataField',
                Value : UnitPrice,
            },
            UnitPrice_ac : {
                $Type : 'UI.DataField',
                Value : UnitPrice_ac_text,
                Criticality : UnitPrice_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected3 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{NetAmount}-{NetAmount_ac}',
        Data : {
            $Type : 'Core.Dictionary',
            NetAmount : {
                $Type : 'UI.DataField',
                Value : NetAmount,
            },
            NetAmount_ac : {
                $Type : 'UI.DataField',
                Value : NetAmount_ac_text,
                Criticality : NetAmount_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected4 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{UoM}-{UoM_ac}',
        Data : {
            $Type : 'Core.Dictionary',
            UoM : {
                $Type : 'UI.DataField',
                Value : UoM,
            },
            UoM_ac : {
                $Type : 'UI.DataField',
                Value : UoM_ac_text,
                Criticality : UoM_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.DataPoint #Message1 : {
        $Type : 'UI.DataPointType',
        Value : Message,
        Title : 'Message',
        Criticality : Criticality_code_item,
    },
    UI.DataPoint #Message2 : {
        $Type : 'UI.DataPointType',
        Value : Message,
        Title : 'Message',
        Criticality : Criticality_code_item,
    },
);

annotate service.InvoiceItems with {
    MaterialNumber @Common.FieldControl : #Mandatory
};

annotate service.InvoiceHeader with {
    MailDateTime @Common.FieldControl : #ReadOnly
};
annotate service.InvoiceHeader with {
    PONumber_ac @Common.FieldControl : #ReadOnly
};

annotate service.InvoiceHeader with {
    SupInvNumber_ac @Common.FieldControl : #ReadOnly
};

annotate service.InvoiceHeader with {
    Curr_ac @Common.FieldControl : #ReadOnly
};

annotate service.InvoiceHeader with {
    GrossAmount_ac @Common.FieldControl : #ReadOnly
};

annotate service.InvoiceItems with {
    MatNum_ac @Common.FieldControl : #ReadOnly
};

annotate service.InvoiceItems with {
    Quantity_ac @Common.FieldControl : #ReadOnly
};

annotate service.InvoiceItems with {
    UoM_ac @Common.FieldControl : #ReadOnly
};

annotate service.InvoiceItems with {
    UnitPrice_ac @Common.FieldControl : #ReadOnly
};

annotate service.InvoiceItems with {
    NetAmount_ac @Common.FieldControl : #ReadOnly
};

annotate service.InvoiceItems with {
    Message @Common.FieldControl : #ReadOnly
};

