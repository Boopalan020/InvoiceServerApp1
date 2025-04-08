sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/app/po/poui/test/integration/FirstJourney',
		'ns/app/po/poui/test/integration/pages/POHeaderMain'
    ],
    function(JourneyRunner, opaJourney, POHeaderMain) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/app/po/poui') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onThePOHeaderMain: POHeaderMain
                }
            },
            opaJourney.run
        );
    }
);