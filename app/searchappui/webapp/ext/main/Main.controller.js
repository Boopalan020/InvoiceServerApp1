sap.ui.define(
    [
        'sap/fe/core/PageController', "sap/m/MessageToast", "sap/ui/model/json/JSONModel"
    ],
    function (PageController, MessageToast, JSONModel) {
        'use strict';

        return PageController.extend('ns.app.searchappui.ext.main.Main', {

            onInit: function () {
                // this.getView().getModel("ui").setProperty("/isEditable", true);
            },


            onAfterRendering: function (oEvent) {
                var oView = this.getView();
                var mFBConditions = new JSONModel({
                    allFilters: "",
                    expanded: false,
                    filtersTextInfo: oView.byId("FilterBar1").getActiveFiltersText()
                });
                oView.setModel(mFBConditions, "fbConditions");
            },
            handlers: {
                onFiltersChanged: function (oEvent) {
                    var oView = this.getView();
                    var filterBar = oView.byId("FilterBar1");
                    var allFilters = filterBar.getFilters();

                    var oSource = oEvent.getSource();
                    var mFBConditions = oSource.getModel("fbConditions");
                    mFBConditions.setProperty("/allFilters", JSON.stringify(allFilters, null, "  "));

                    if (Object.keys(allFilters).length > 0) {
                        mFBConditions.setProperty("/expanded", true);
                    }
                    // MessageToast.show("FilterBar filters are changed!");
                    mFBConditions.setProperty("/filtersTextInfo", oSource.getActiveFiltersText());
                }
            },
            /**
             * Called when a controller is instantiated and its View controls (if available) are already created.
             * Can be used to modify the View before it is displayed, to bind event handlers and do other one-time initialization.
             * @memberOf ns.app.searchappui.ext.main.Main
             */
            //  onInit: function () {
            //      PageController.prototype.onInit.apply(this, arguments); // needs to be called to properly initialize the page controller
            //  },

            /**
             * Similar to onAfterRendering, but this hook is invoked before the controller's View is re-rendered
             * (NOT before the first rendering! onInit() is used for that one!).
             * @memberOf ns.app.searchappui.ext.main.Main
             */
            //  onBeforeRendering: function() {
            //
            //  },

            /**
             * Called when the View has been rendered (so its HTML is part of the document). Post-rendering manipulations of the HTML could be done here.
             * This hook is the same one that SAPUI5 controls get after being rendered.
             * @memberOf ns.app.searchappui.ext.main.Main
             */
            //  onAfterRendering: function() {
            //
            //  },

            /**
             * Called when the Controller is destroyed. Use this one to free resources and finalize activities.
             * @memberOf ns.app.searchappui.ext.main.Main
             */
            //  onExit: function() {
            //
            //  }
        });
    }
);