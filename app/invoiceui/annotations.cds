using tablemodel.srv.InvoiceService as service from '../../srv/services';
using from '../../srv/services';
using from '../../db/schema';

annotate service.InvoiceHeader with @(
    odata.draft.enabled,
    UI.DeleteHidden : { 
        $edmJson: {
            $Or: [  { $Eq: [ { $Path: 'StatusCode/code' }, '61'  ] },
                    { $Eq: [ { $Path: 'StatusCode/code' }, '62'  ] }         
            ]
        }
     },
    UI.UpdateHidden : { 
        $edmJson: {               
        $If: [
                {                         
                    $Or: [  { $Eq: [ { $Path: 'StatusCode/code' }, '61'  ] },
                            { $Eq: [ { $Path: 'StatusCode/code' }, '62'  ] }         
                    ]
                },
                true,
                false
            ]
        } 
    },
    UI.SelectionFields : [
        PONumber,
        SupplierNumber,
        StatusCode.code,
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : PONumber,
            Label : '{i18n>PurordNumber}',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'tablemodel.srv.InvoiceService.threeWayCheckUI',
            Label : '{i18n>CheckSend1}',
        },
        {
            $Type : 'UI.DataField',
            Value : SupplierName,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : createdAt,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : modifiedBy,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : modifiedAt,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : GrossAmount,
            Label : '{i18n>GrossAmount}',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : StatusCode_code,
            Criticality : StatusCode.status_critics,
            CriticalityRepresentation : #WithIcon,
            Label : 'Status',
            ![@UI.Importance] : #High
        },
         
    ],
    UI.FilterFacets: [
        {
            Target : '@UI.FieldGroup#FilterFacet1',
            Label : '{i18n>Allowed Filters}',
        },
    ],

    UI.FieldGroup #FilterFacet1 : {
        Data : [
            {Value: Comp_Code},
            {Value: PONumber},
            {Value: SupplierNumber},
            {Value: Message},
            {Value: Currency},
        ]
    },
    UI.HeaderInfo : {
        TypeName : '{i18n>Invoice}',
        TypeNamePlural : '{i18n>Invoices}',
        Title : {
            $Type : 'UI.DataField',
            Value : SupplierName,
        },
        Description : {
            $Type : 'UI.DataField',
            Value : 'Supplier Name',
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
        ![@Common.QuickInfo] : 'Refers to what is the status by the automation',
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>Header}',
            ID : 'GeneralInfo',
            Target : '@UI.FieldGroup#GeneralInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>Items1}',
            ID : 'Materials',
            Target : 'Items/@UI.LineItem#Materials',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Process Log',
            ID : 'ProcessLog',
            Target : 'Logs/@UI.LineItem#ProcessLog',
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
                Value : SupplierMail,
            },
            {
                $Type : 'UI.DataField',
                Value : MailDateTime,
            },
            {
                $Type : 'UI.DataField',
                Value : MailSubject,
            },
        ],
    },
    UI.FieldGroup #AutomationInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : Message,
                Criticality : StatusCode.status_critics,
                Label : '{i18n>Status}',
            },
            {
                $Type : 'UI.DataField',
                Value : Reason,
                Label : '{i18n>Message}',
                Criticality : StatusCode.status_critics,
                CriticalityRepresentation : #WithoutIcon,
            },
            {
                $Type : 'UI.DataField',
                Value : CreatedInvNumber,
                CriticalityRepresentation : #WithoutIcon,
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
        TypeImageUrl : '',
    },
    UI.HeaderFacets : [
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

annotate service.InvoiceHeader with {
    PONumber @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'PurchaseOrders',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : PONumber,
                    ValueListProperty : 'PurchaseOrder',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'CreatedByUser',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'CreationDate',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'CompanyCode',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'PurchaseOrderType',
                },
            ],
            Label : 'Purchase Order - Help',
            PresentationVariantQualifier : 'vh_InvoiceHeader_PONumber',
        },
        Common.ValueListWithFixedValues : false
)};

annotate service.PurchaseOrders with @(
    UI.PresentationVariant #vh_InvoiceHeader_PONumber : {
        $Type : 'UI.PresentationVariantType',
        SortOrder : [
            {
                $Type : 'Common.SortOrderType',
                Property : PurchaseOrder,
                Descending : false,
            },
        ],
    }
);
annotate service.InvoiceHeader with {
    StatusCode @(
        Common.Label : 'StatusCode',
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Status',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : StatusCode_code,
                    ValueListProperty : 'code',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name',
                },
            ],
            Label : 'Status',
        },
        Common.ValueListWithFixedValues : true,
        Common.Text : {
            $value : StatusCode.name,
            ![@UI.TextArrangement] : #TextOnly
        },
    )
};

annotate service.InvoiceHeader with @Common.SemanticKey: [PONumber];


annotate service.Status with {
    code @(
        Common.Text : {
            $value : name,
            ![@UI.TextArrangement] : #TextOnly
        },
        Common.Label : 'Status',
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Status',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : code,
                    ValueListProperty : 'code',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name',
                },
            ],
            Label : 'Status',
            PresentationVariantQualifier : 'vh_Status_code',
        },
        Common.ValueListWithFixedValues : true,
    )
};

annotate service.InvoiceHeader with {
    SupplierNumber @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Suppliers',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : SupplierNumber,
                    ValueListProperty : 'Supplier',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'SupplierFullName',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'Region',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'CreationDate',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'Country',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'SupplierPlant',
                },
            ],
            Label : 'Supplier',
        },
        Common.ValueListWithFixedValues : false
)};

annotate service.Suppliers with {
    Supplier @Common.Text : SupplierFullName
};

annotate service.Status with @(
    UI.PresentationVariant #vh_Status_code : {
        $Type : 'UI.PresentationVariantType',
        SortOrder : [
            {
                $Type : 'Common.SortOrderType',
                Property : code,
                Descending : false,
            },
        ],
    }
);

annotate service.InvoiceHeader with {
    GrossAmount @Common.Text : {
        $value : Currency,
        ![@UI.TextArrangement] : #TextLast
    }
};

annotate service.InvoiceLog with @(
    UI.LineItem #i18nProcessLogs : [
        {
            $Type : 'UI.DataField',
            Value : EventTimestamp,
            Label : 'EventTimestamp',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : EventType,
            Label : 'EventType',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : EventDetails,
            Label : 'EventDetails',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : PerformedBy,
            Label : 'PerformedBy',
            ![@UI.Importance] : #High,
        },
    ],
    UI.LineItem #ProcessLog : [
        {
            $Type : 'UI.DataField',
            Value : EventTimestamp,
            Label : '{i18n>DateTime}',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : EventType,
            Label : '{i18n>LogType}',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : EventDetails,
            Label : '{i18n>LogDetails}',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : PerformedBy,
            Label : '{i18n>PerformedBy}',
            ![@UI.Importance] : #High,
        },
    ],
);

