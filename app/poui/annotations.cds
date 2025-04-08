using tablemodel.srv.POServices as service from '../../srv/services';
annotate service.POHeader with @(
    UI.SelectionFields : [
        StatusCode_code,
    ]
);

