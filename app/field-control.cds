using { tablemodel.srv.InvoiceService } from '../srv/services';

annotate InvoiceService.InvoiceHeader {

} actions {
    threeWayCheckUI @(
        Core.OperationAvailable : { $edmJson: { $Eq: [{ $Path: 'in/StatusCode' }, 'S'] } },
        Common : {
            SideEffects : {
                $Type : 'Common.SideEffectsType',
                TargetProperties : [
                    'in/StatusCode',
                    'in/SupplierNumber',
                    'in/Items/Message',
                    'in/Message'
                ],
                TargetEntities : [
                    '/tablemodel.srv.InvoiceService.EntityContainer/InvoiceHeader'
                ],
            },
        }
        
    );
};
