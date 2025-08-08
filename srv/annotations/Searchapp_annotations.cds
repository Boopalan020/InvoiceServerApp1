using {tablemodel.srv.SearchService.Searchheader} from '../services';

annotate Searchheader with @UI: {
    SelectionFields: [
        'machine_name',
        'Status'
    ],
    LineItem       : [
        {
            Value: Name,
            Label: 'User Name'
        },
        {
            Value: machine_name,
            Label: 'Machine Name'
        },
        {
            Value: Status,
            Label: 'Status'
        }
    ]
};

annotate Searchheader with @(Capabilities: {FilterRestrictions: {
    $Type                       : 'Capabilities.FilterRestrictionsType',
    RequiredProperties          : ['Status'],
    FilterExpressionRestrictions: [
        {
            Property          : 'Status',
            AllowedExpressions: 'SingleValue'
        },
        {
            Property          : 'machine_name',
            AllowedExpressions: 'SingleValue'
        }
    ]
}});

annotate Searchheader with {
    Status @Common: {
        ValueListWithFixedValues: true,
        ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'StatusVH',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                ValueListProperty: 'type',
                LocalDataProperty: 'Status'
            }],
            Label         : 'Status Help'
        }
    }
};

annotate Searchheader with {
    machine_name @Common: {
        ValueListWithFixedValues: true,
        ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'MachineVH',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                ValueListProperty: 'machine_name',
                LocalDataProperty: 'machine_name'
            }],
            Label         : 'Machine Help'
        }
    }
};
