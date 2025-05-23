using {
    tablemodel.srv.InvoiceService,
    tablemodel.srv.POServices
} from '../srv/services';

// -------------------------- Entity for Monitoring App -----------------------------------------
annotate InvoiceService.InvoiceHeader {

} actions {
    threeWayCheckUI @(
        Core.OperationAvailable: {$edmJson: {$Eq: [
            {$Path: 'in/StatusCode_code'},
            '64'
        ]}},
        Common                 : {SideEffects: {
            $Type           : 'Common.SideEffectsType',
            TargetProperties: [
                'in/StatusCode_code',
                'in/SupplierNumber',
                'in/Items/Message',
                'in/Message'
            ],
            TargetEntities  : ['/tablemodel.srv.InvoiceService.EntityContainer/InvoiceHeader'],
        }, }

    );
};
// -------------------------- Entity for Monitoring App -----------------------------------------

// -------------------------- PO Header Entity Side-effects -------------------------------------
annotate POServices.POHeader {

} actions {
    refresh_extractions @(Common: {SideEffects: {
        $Type         : 'Common.SideEffectsType',
        TargetEntities: [
            '/tablemodel.srv.POServices.EntityContainer/POHeader',
            '/tablemodel.srv.POServices.EntityContainer/POItem'
        ]
    }});
};
// -------------------------- PO Header Entity Side-effects -------------------------------------
