using tablemodel.srv.POServices as service from '../../srv/services';
using from '../../srv/services';


annotate service.POHeader with @(
    UI.SelectionFields: [
        StatusCode_code,
        documentNumber,
        extraction_status,
    ],
    UI.LineItem       : [
        {
            $Type: 'UI.DataField',
            Value: documentNumber,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : senderName,
            Label : '{i18n>SenderName}',
            ![@UI.Importance] : #High,
        },
        {
            $Type: 'UI.DataField',
            Value: documentDate,
            ![@UI.Importance] : #High,
        },
        {
            $Type: 'UI.DataField',
            Value: grossAmount,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : createdAt,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : extraction_status,
            Label : 'Status',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'tablemodel.srv.POServices.refresh_extractions',
            Label : '{i18n>Refresh}',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'tablemodel.srv.POServices.post_so',
            Label : 'Post Sale Order',
        },
    ],
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'General Info',
            ID : 'GeneralInfo',
            Target : '@UI.FieldGroup#GeneralInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>Items}',
            ID : 'i18nItems',
            Target : 'PoItems/@UI.LineItem#i18nItems',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Process Logs',
            ID : 'ProcessLogs',
            Target : 'Logs/@UI.LineItem#ProcessLogs3',
        },
    ],
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Mail Info',
            ID : 'MailInfo',
            Target : '@UI.FieldGroup#MailInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>DocumentInfo}',
            ID : 'DocumentExtractionInfo',
            Target : '@UI.FieldGroup#DocumentExtractionInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'overall_ac',
            Target : '@UI.Chart#overall_ac1',
        },
    ],
    UI.FieldGroup #MailInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : emailid,
                Label : '{i18n>SupplierMailId}',
            },
            {
                $Type : 'UI.DataField',
                Value : mailDateTime,
                Label : '{i18n>MailDateTime}',
            },
            {
                $Type : 'UI.DataField',
                Value : mailSubject,
                Label : '{i18n>EmailSubject1}',
            },
        ],
    },
    UI.HeaderInfo : {
        Title : {
            $Type : 'UI.DataField',
            Value : senderName,
        },
        TypeName : '',
        TypeNamePlural : '',
        Description : {
            $Type : 'UI.DataField',
            Value : '{i18n>SenderName}',
        },
        TypeImageUrl : 'sap-icon://sales-document',
    },
    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'tablemodel.srv.POServices.refresh_extractions',
            Label : '{i18n>Refresh}',
        },
    ],
    UI.FieldGroup #DocumentExtractionInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : extraction_status,
                Label : 'Status',
            },
            {
                $Type : 'UI.DataField',
                Value : Message,
            },
            {
                $Type : 'UI.DataField',
                Value : SalesOrderNumber,
                Label : 'S/4 Sales Order Number',
            },
        ],
    },
    UI.DataPoint #progress : {
        $Type : 'UI.DataPointType',
        Value : overall_ac,
        Title : 'overall_ac',
        TargetValue : 100,
        Visualization : #Progress,
    },
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
    UI.FieldGroup #GeneralInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected',
                Label : 'Document Number',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected1',
                Label : 'Document Date',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected3',
                Label : 'Net Amount',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected6',
                Label : 'Currency Code',
            },
            {
                $Type : 'UI.DataField',
                Value : paymentTerms,
            },
            {
                $Type : 'UI.DataField',
                Value : shipToAddress,
                Label : 'Ship To Address',
            },
        ],
    },
    UI.ConnectedFields #connected : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{documentNumber}-{documentNumber_ac_text}',
        Data : {
            $Type : 'Core.Dictionary',
            documentNumber : {
                $Type : 'UI.DataField',
                Value : documentNumber,
            },
            documentNumber_ac_text : {
                $Type : 'UI.DataField',
                Value : documentNumber_ac_text,
                Criticality : documentNumber_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected1 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{documentDate}-{documentDate_ac_text}',
        Data : {
            $Type : 'Core.Dictionary',
            documentDate : {
                $Type : 'UI.DataField',
                Value : documentDate,
            },
            documentDate_ac_text : {
                $Type : 'UI.DataField',
                Value : documentDate_ac_text,
                Criticality : documentDate_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected2 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{grossAmount}-{grossAmount_ac_text}',
        Data : {
            $Type : 'Core.Dictionary',
            grossAmount : {
                $Type : 'UI.DataField',
                Value : grossAmount,
            },
            grossAmount_ac_text : {
                $Type : 'UI.DataField',
                Value : grossAmount_ac_text,
                Criticality : grossAmount_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected3 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{netAmount}-{netAmount_ac_text}',
        Data : {
            $Type : 'Core.Dictionary',
            netAmount : {
                $Type : 'UI.DataField',
                Value : netAmount,
            },
            netAmount_ac_text : {
                $Type : 'UI.DataField',
                Value : netAmount_ac_text,
                Criticality              : netAmount_acc,
                CriticalityRepresentation: #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected4 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{currencyCode}-{currencyCode_ac_text}',
        Data : {
            $Type : 'Core.Dictionary',
            currencyCode : {
                $Type : 'UI.DataField',
                Value : currencyCode,
            },
            currencyCode_ac_text : {
                $Type : 'UI.DataField',
                Value : currencyCode_ac_text,
                Criticality              : currencyCode_acc,
                CriticalityRepresentation: #WithoutIcon,
            },
        },
    },
    UI.DataPoint #overall_ac1 : {
        Value : overall_ac,
        TargetValue : overall_target,
        Criticality : overall_acc,
    },
    UI.Chart #overall_ac1 : {
        ChartType : #Donut,
        Title : 'Overall Accuracy',
        Measures : [
            overall_ac,
        ],
        MeasureAttributes : [
            {
                DataPoint : '@UI.DataPoint#overall_ac1',
                Role : #Axis1,
                Measure : overall_ac,
            },
        ],
        Description : 'of all Key Fields',
    },
    Communication.Contact #contact : {
        $Type : 'Communication.ContactType',
        fn : currencyCode,
    },
    UI.ConnectedFields #connected5 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{currencyCode}-{currencyCode_ac}',
        Data : {
            $Type : 'Core.Dictionary',
            currencyCode : {
                $Type : 'UI.DataField',
                Value : currencyCode,
            },
            currencyCode_ac : {
                $Type : 'UI.DataField',
                Value : currencyCode_ac,
                Criticality : currencyCode_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected6 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{currencyCode}-{currencyCode_ac_text}',
        Data : {
            $Type : 'Core.Dictionary',
            currencyCode : {
                $Type : 'UI.DataField',
                Value : currencyCode,
            },
            currencyCode_ac_text : {
                $Type : 'UI.DataField',
                Value : currencyCode_ac_text,
                Criticality : currencyCode_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
);
annotate service.POItem with @(
    UI.LineItem #i18nItems : [
        {
            $Type : 'UI.DataField',
            Value : customerMaterialNumber,
            Criticality : customerMaterialNumber_acc,
            CriticalityRepresentation : #WithoutIcon,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : description,
            Criticality : description_acc,
            CriticalityRepresentation : #WithoutIcon,
            ![@UI.Importance] : #Low,
        },
        {
            $Type : 'UI.DataField',
            Value : quantity,
            Criticality : quantity_acc,
            CriticalityRepresentation : #WithoutIcon,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : unitOfMeasure,
            Criticality : unitOfMeasure_acc,
            CriticalityRepresentation: #WithoutIcon,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : unitPrice,
            Criticality              : unitPrice_acc,
            CriticalityRepresentation: #WithoutIcon,
            ![@UI.Importance]        : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : netAmount,
            Criticality : netAmount_acc,
            CriticalityRepresentation : #WithoutIcon,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : Parent.PoItems.currencyCode,
        },
    ],
    UI.HeaderInfo : {
        Title : {
            $Type : 'UI.DataField',
            Value : customerMaterialNumber,
        },
        TypeName : '',
        TypeNamePlural : '',
        TypeImageUrl : 'sap-icon://product',
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Item Info',
            ID : 'ItemInfo',
            Target : '@UI.FieldGroup#ItemInfo',
        },
    ],
    UI.FieldGroup #ItemInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected',
                Label : 'Customer Material Number',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected1',
                Label : 'Description',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected3',
                Label : 'Quantity',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected5',
                Label : 'UoM',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected4',
                Label : 'Unit Price',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected2',
                Label : 'Net Amount',
            },
        ],
    },
    UI.ConnectedFields #connected : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{customerMaterialNumber}-{customerMaterialNumber_ac_text}',
        Data : {
            $Type : 'Core.Dictionary',
            customerMaterialNumber : {
                $Type : 'UI.DataField',
                Value : customerMaterialNumber,
            },
            customerMaterialNumber_ac_text : {
                $Type : 'UI.DataField',
                Value : customerMaterialNumber_ac_text,
                Criticality : customerMaterialNumber_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected1 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{description}-{description_ac_text}',
        Data : {
            $Type : 'Core.Dictionary',
            description : {
                $Type : 'UI.DataField',
                Value : description,
            },
            description_ac_text : {
                $Type : 'UI.DataField',
                Value : description_ac_text,
                Criticality : description_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected2 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{netAmount}-{netAmount_ac_text}',
        Data : {
            $Type : 'Core.Dictionary',
            netAmount : {
                $Type : 'UI.DataField',
                Value : netAmount,
            },
            netAmount_ac_text : {
                $Type : 'UI.DataField',
                Value : netAmount_ac_text,
                Criticality : netAmount_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected3 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{quantity}-{quantity_ac_text}',
        Data : {
            $Type : 'Core.Dictionary',
            quantity : {
                $Type : 'UI.DataField',
                Value : quantity,
            },
            quantity_ac_text : {
                $Type : 'UI.DataField',
                Value : quantity_ac_text,
                Criticality : quantity_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected4 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{unitPrice}-{unitPrice_ac_text}',
        Data : {
            $Type : 'Core.Dictionary',
            unitPrice : {
                $Type : 'UI.DataField',
                Value : unitPrice,
            },
            unitPrice_ac_text : {
                $Type : 'UI.DataField',
                Value : unitPrice_ac_text,
                Criticality : unitPrice_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected5 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{unitOfMeasure}-{unitOfMeasure_ac_text}',
        Data : {
            $Type : 'Core.Dictionary',
            unitOfMeasure : {
                $Type : 'UI.DataField',
                Value : unitOfMeasure,
            },
            unitOfMeasure_ac_text : {
                $Type : 'UI.DataField',
                Value : unitOfMeasure_ac_text,
                Criticality : unitOfMeasure_acc,
                CriticalityRepresentation : #WithoutIcon,
            },
        },
    },
    UI.ConnectedFields #connected6 : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{materialNumber}-{materialNumber_ac}',
        Data : {
            $Type : 'Core.Dictionary',
            materialNumber : {
                $Type : 'UI.DataField',
                Value : materialNumber,
            },
            materialNumber_ac : {
                $Type : 'UI.DataField',
                Value : materialNumber_ac,
            },
        },
    },
);

annotate service.POHeader with {
    grossAmount @Common.Text : {
        $value : currencyCode,
        ![@UI.TextArrangement] : #TextLast
    }
};

annotate service.PO_Log with @(
    UI.LineItem #ProcessLogs : [
    ],
    UI.LineItem #ProcessLogs1 : [
        {
            $Type : 'UI.DataField',
            Value : EventTimestamp,
        },
        {
            $Type : 'UI.DataField',
            Value : EventType,
        },
        {
            $Type : 'UI.DataField',
            Value : EventDetails,
        },
        {
            $Type : 'UI.DataField',
            Value : PerformedBy,
        },
    ],
    UI.LineItem #ProcessLogs2 : [
        {
            $Type : 'UI.DataField',
            Value : EventDetails,
        },
        {
            $Type : 'UI.DataField',
            Value : EventTimestamp,
        },
        {
            $Type : 'UI.DataField',
            Value : EventType,
        },
        {
            $Type : 'UI.DataField',
            Value : PerformedBy,
        },
    ],
    UI.LineItem #ProcessLogs3 : [
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

