using tablemodel.srv.SearchAppService as service from '../../srv/services';
using from '../../db/schema';

annotate service.Searchheader with @(
    odata.draft.enabled : true,
    UI.SelectionFields : [
        machine_name,
        Status_code
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : ID,
            ![@UI.Hidden],
        },
        {
            $Type : 'UI.DataField',
            Value : Name,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : createdBy,
            ![@UI.Importance] : #Medium,
        },
        {
            $Type : 'UI.DataField',
            Value : createdAt,
            ![@UI.Importance] : #Low,
        },
        {
            $Type : 'UI.DataField',
            Value : modifiedAt,
            ![@UI.Importance] : #Low,
        },
        {
            $Type : 'UI.DataField',
            Value : machine_name,
            ![@UI.Importance] : #Medium,
        },
        {
            $Type : 'UI.DataField',
            Value : Status_code,
            ![@UI.Importance] : #High,
        },
    ],
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Settings',
            ID : 'Settings',
            Target : 'Items_s/@UI.LineItem#Settings',
        },
    ],
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'BPASetting',
            Target : '@UI.FieldGroup#BPASetting',
        },
    ],
    UI.FieldGroup #BPASetting : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : createdBy,
            },
            {
                $Type : 'UI.DataField',
                Value : createdAt,
            },
            {
                $Type : 'UI.DataField',
                Value : modifiedBy,
            },
            {
                $Type : 'UI.DataField',
                Value : Status_code,
            },
        ],
    },
    UI.HeaderInfo : {
        TypeName : '{i18n>Setting}',
        TypeNamePlural : 'Settings',
        Title : {
            $Type : 'UI.DataField',
            Value : machine_name,
        },
        Description : {
            $Type : 'UI.DataField',
            Value : Name,
        },
    },
);

annotate service.Searchheader with {
    machine_name @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Searchheader',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : machine_name,
                    ValueListProperty : 'Name',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'machine_name',
                },
            ],
        },
        Common.ValueListWithFixedValues : false
)};

annotate service.Searchheader with {
    Name @Common.Text : {
        $value : machine_name,
        ![@UI.TextArrangement] : #TextFirst,
    }
};

annotate service.Searchitem with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : elements1.name,
        },
        {
            $Type : 'UI.DataField',
            Value : elements1.descr,
        },
        {
            $Type : 'UI.DataField',
            Value : Value,
        },
    ],
    UI.LineItem #Settings : [
        {
            $Type : 'UI.DataField',
            Value : elements1_code,
        },
        {
            $Type : 'UI.DataField',
            Value : operand_code,
        },
        {
            $Type : 'UI.DataField',
            Value : Value,
        },
    ],
);

annotate service.Searchheader with @Common.SemanticKey: [Name];

annotate service.elementlist with {
    name @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'elementlist',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : name,
                    ValueListProperty : 'code',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name',
                },
            ],
        },
        Common.ValueListWithFixedValues : true
)};

annotate service.elementlist with {
    code @Common.Text : {
        $value : name,
        ![@UI.TextArrangement] : #TextFirst,
    }
};

annotate service.Searchitem with {
    operand @(
        Common.ValueListWithFixedValues : true,
        Common.Text : operand.name,
    )
};

annotate service.Searchitem with {
    elements1 @(
        Common.Text : elements1.name,
        Common.ValueListWithFixedValues : true,
    )
};

annotate service.Statuscode_s with {
    name @Common.FieldControl : #ReadOnly
};

annotate service.Searchheader with {
    Status @(
        Common.Text : Status.name,
        Common.FieldControl : #ReadOnly,
    )
};

