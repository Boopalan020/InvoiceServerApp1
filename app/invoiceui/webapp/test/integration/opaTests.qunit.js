sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/invoiceui/test/integration/FirstJourney',
		'ns/invoiceui/test/integration/pages/InvoiceHeaderMain'
    ],
    function(JourneyRunner, opaJourney, InvoiceHeaderMain) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/invoiceui') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheInvoiceHeaderMain: InvoiceHeaderMain
                }
            },
            opaJourney.run
        );
    }
);