//@ui5-bundle ns/invoiceui/Component-preload.js
sap.ui.require.preload({
	"ns/invoiceui/Component.js":function(){
sap.ui.define(["sap/fe/core/AppComponent"],function(e){"use strict";return e.extend("ns.invoiceui.Component",{metadata:{manifest:"json"}})});
},
	"ns/invoiceui/ext/main/Main.controller.js":function(){
sap.ui.define(["sap/fe/core/PageController","sap/m/MessageToast","sap/ui/model/json/JSONModel"],function(e,t,r){"use strict";return e.extend("ns.invoiceui.ext.main.Main",{onAfterRendering:function(e){var t=this.getView();var i=new r({allFilters:"",expanded:false,filtersTextInfo:t.byId("FilterBar1").getActiveFiltersText()});t.setModel(i,"fbConditions")},handlers:{onFiltersChanged:function(e){var t=this.getView();var r=t.byId("FilterBar1");var i=r.getFilters();var n=e.getSource();var s=n.getModel("fbConditions");s.setProperty("/allFilters",JSON.stringify(i,null,"  "));if(Object.keys(i).length>0){s.setProperty("/expanded",true)}s.setProperty("/filtersTextInfo",n.getActiveFiltersText())}}})});
},
	"ns/invoiceui/ext/main/Main.view.xml":'<mvc:View xmlns:core="sap.ui.core" xmlns:l="sap.ui.layout" xmlns:f="sap.f" xmlns:mvc="sap.ui.core.mvc" xmlns="sap.m" xmlns:macros="sap.fe.macros" xmlns:html="http://www.w3.org/1999/xhtml" controllerName="ns.invoiceui.ext.main.Main"><f:DynamicPage id="FilterBarDefault" class="sapUiResponsiveContentPadding"><f:title><f:DynamicPageTitle id="_IDGenDynamicPageTitle1"><f:heading><Title id="_IDGenTitle1" text="Invoice Automation Logs" level="H2"/></f:heading><f:snappedContent><Text id="text-01" text="{fbConditions>/filtersTextInfo}"/></f:snappedContent></f:DynamicPageTitle></f:title><f:header><f:DynamicPageHeader id="_IDGenDynamicPageHeader1" pinnable="true"><VBox id="_IDGenVBox1"><macros:FilterBar id="FilterBar1" metaPath="@com.sap.vocabularies.UI.v1.SelectionFields" liveMode="true" search=".handlers.onFiltersChanged" filterChanged=".handlers.onFiltersChanged" showClearButton="true" showMessages="true"/></VBox></f:DynamicPageHeader></f:header><f:content><macros:Table id="table-1" metaPath="@com.sap.vocabularies.UI.v1.LineItem" filterBar="FilterBar1" readOnly="true" enableAutoColumnWidth="true" header="List of Mails" headerVisible="true" isSearchable="true" selectionMode="Multi" type="ResponsiveTable" personalization="false"/></f:content></f:DynamicPage></mvc:View>\n',
	"ns/invoiceui/i18n/i18n.properties":'# This is the resource bundle for ns.invoiceui\n\n#Texts for manifest.json\n\n#XTIT: Application name\nappTitle=Invoice Log\n\n#YDES: Application description\nappDescription=An SAP Fiori application.\n#XTIT: Custom view title\nMainTitle=Main\n\n#XFLD,51\nflpTitle=Invoice Dashboard\n',
	"ns/invoiceui/manifest.json":'{"_version":"1.65.0","sap.app":{"id":"ns.invoiceui","type":"application","i18n":"i18n/i18n.properties","applicationVersion":{"version":"0.0.1"},"title":"{{appTitle}}","description":"{{appDescription}}","resources":"resources.json","sourceTemplate":{"id":"@sap/generator-fiori:fpm","version":"1.15.0","toolsId":"57594eea-c65e-4bee-9328-c4cadcce83f7"},"dataSources":{"mainService":{"uri":"invoiceAutomation-srv/","type":"OData","settings":{"annotations":[],"odataVersion":"4.0"}}},"crossNavigation":{"inbounds":{"invoices-display":{"semanticObject":"invoices","action":"display","title":"{{flpTitle}}","signature":{"parameters":{},"additionalParameters":"allowed"}}}}},"sap.ui":{"technology":"UI5","icons":{"icon":"","favIcon":"","phone":"","phone@2":"","tablet":"","tablet@2":""},"deviceTypes":{"desktop":true,"tablet":true,"phone":true}},"sap.ui5":{"flexEnabled":true,"dependencies":{"minUI5Version":"1.128.1","libs":{"sap.m":{},"sap.ui.core":{},"sap.fe.core":{},"sap.fe.templates":{},"sap.f":{}}},"contentDensities":{"compact":true,"cozy":true},"models":{"i18n":{"type":"sap.ui.model.resource.ResourceModel","settings":{"bundleName":"ns.invoiceui.i18n.i18n"}},"":{"dataSource":"mainService","preload":true,"settings":{"operationMode":"Server","autoExpandSelect":true,"earlyRequests":true}},"@i18n":{"type":"sap.ui.model.resource.ResourceModel","uri":"i18n/i18n.properties"}},"resources":{"css":[]},"routing":{"config":{"flexibleColumnLayout":{"defaultTwoColumnLayoutType":"TwoColumnsMidExpanded","defaultThreeColumnLayoutType":"ThreeColumnsMidExpanded"},"routerClass":"sap.f.routing.Router"},"routes":[{"name":"InvoiceHeaderMain","pattern":":?query:","target":["InvoiceHeaderMain"]},{"name":"InvoiceHeaderObjectPage","pattern":"InvoiceHeader({InvoiceHeaderKey}):?query:","target":["InvoiceHeaderMain","InvoiceHeaderObjectPage"]},{"name":"InvoiceHeader_ItemsObjectPage","pattern":"InvoiceHeader({InvoiceHeaderKey})/Items({ItemsKey}):?query:","target":["InvoiceHeaderMain","InvoiceHeaderObjectPage","InvoiceHeader_ItemsObjectPage"]}],"targets":{"InvoiceHeaderMain":{"type":"Component","id":"InvoiceHeaderMain","name":"sap.fe.core.fpm","options":{"settings":{"viewName":"ns.invoiceui.ext.main.Main","contextPath":"/InvoiceHeader","navigation":{"InvoiceHeader":{"detail":{"route":"InvoiceHeaderObjectPage"}}}}},"controlAggregation":"beginColumnPages","contextPattern":""},"InvoiceHeaderObjectPage":{"type":"Component","id":"InvoiceHeaderObjectPage","name":"sap.fe.templates.ObjectPage","options":{"settings":{"navigation":{"Items":{"detail":{"route":"InvoiceHeader_ItemsObjectPage"}}},"contextPath":"/InvoiceHeader","editableHeaderContent":false}},"controlAggregation":"midColumnPages","contextPattern":"/InvoiceHeader({InvoiceHeaderKey})"},"InvoiceHeader_ItemsObjectPage":{"type":"Component","id":"InvoiceHeader_ItemsObjectPage","name":"sap.fe.templates.ObjectPage","controlAggregation":"endColumnPages","options":{"settings":{"navigation":{},"contextPath":"/InvoiceHeader/Items","editableHeaderContent":false}},"contextPattern":"/InvoiceHeader({InvoiceHeaderKey})/Items({ItemsKey})"}}},"rootView":{"viewName":"sap.fe.templates.RootContainer.view.Fcl","type":"XML","async":true,"id":"appRootView"}},"sap.cloud":{"public":true,"service":"invoices"}}'
});
//# sourceMappingURL=Component-preload.js.map