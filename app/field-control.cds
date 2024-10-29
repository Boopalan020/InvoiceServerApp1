using { tablemodel.srv.InvoiceService } from '../srv/services';

annotate InvoiceService.InvoiceHeader {
    
} actions {
    threeWayCheckUI @(
        Core.OperationAvailable : { $edmJson: { $Eq: [{ $Path: 'in/StatusCode_code' }, '64'] } },
        Common : {
            SideEffects : {
                $Type : 'Common.SideEffectsType',
                TargetProperties : [
                    'in/StatusCode_code',
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
