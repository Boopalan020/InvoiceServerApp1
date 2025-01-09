sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/app/searchappui/test/integration/FirstJourney',
		'ns/app/searchappui/test/integration/pages/SearchheaderMain'
    ],
    function(JourneyRunner, opaJourney, SearchheaderMain) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/app/searchappui') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheSearchheaderMain: SearchheaderMain
                }
            },
            opaJourney.run
        );
    }
);