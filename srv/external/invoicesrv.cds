/* checksum : e95e752df93e28a41aa93712ed011397 */
@cds.external : true
@m.IsDefaultEntityContainer : 'true'
@sap.message.scope.supported : 'true'
@sap.supported.formats : 'atom json xlsx'
service invoicesrv {};

@cds.external : true
@cds.persistence.skip : true
@sap.creatable : 'false'
@sap.updatable : 'false'
@sap.deletable : 'false'
@sap.content.version : '1'
@sap.label : 'Withholding Tax Data'
entity invoicesrv.A_SuplrInvcHeaderWhldgTax {
  @sap.display.format : 'UpperCase'
  @sap.label : 'Invoice Document No.'
  @sap.quickinfo : 'Document Number of an Invoice Document'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  key SupplierInvoice : String(10) not null;
  @sap.display.format : 'NonNegative'
  @sap.label : 'Fiscal Year'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  key FiscalYear : String(4) not null;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Withholding Tax Type'
  @sap.quickinfo : 'Indicator for Withholding Tax Type'
  key WithholdingTaxType : String(2) not null;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Currency'
  @sap.quickinfo : 'Currency Key'
  @sap.semantics : 'currency-code'
  DocumentCurrency : String(5);
  @sap.display.format : 'UpperCase'
  @sap.label : 'W/Tax Code'
  @sap.quickinfo : 'Withholding Tax Code'
  WithholdingTaxCode : String(2);
  @sap.unit : 'DocumentCurrency'
  @sap.label : 'W/Tax Base FC'
  @sap.quickinfo : 'Withholding Tax Base Amount in Document Currency'
  WithholdingTaxBaseAmount : Decimal(16, 3);
  @sap.unit : 'DocumentCurrency'
  @sap.label : 'Manual W/Tax in FC'
  @sap.quickinfo : 'Withholding Tax Amount Entered Manually in Document Currency'
  ManuallyEnteredWhldgTaxAmount : Decimal(16, 3);
};

@cds.external : true
@cds.persistence.skip : true
@sap.creatable : 'false'
@sap.updatable : 'false'
@sap.deletable : 'false'
@sap.content.version : '1'
@sap.label : 'Account Assignment Data'
entity invoicesrv.A_SuplrInvcItemAcctAssgmt {
  @sap.display.format : 'UpperCase'
  @sap.label : 'Document Number'
  @sap.quickinfo : 'Document Number of an Accounting Document'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  key SupplierInvoice : String(10) not null;
  @sap.display.format : 'NonNegative'
  @sap.label : 'Fiscal Year'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  key FiscalYear : String(4) not null;
  @sap.display.format : 'NonNegative'
  @sap.label : 'Invoice Item'
  @sap.quickinfo : 'Document Item in Invoice Document'
  key SupplierInvoiceItem : String(6) not null;
  @sap.display.format : 'NonNegative'
  @sap.label : 'Sequence Number'
  @sap.quickinfo : 'Four Character Sequential Number for Coding Block'
  key OrdinalNumber : String(4) not null;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Cost Center'
  CostCenter : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Controlling Area'
  ControllingArea : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Business Area'
  BusinessArea : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Profit Center'
  ProfitCenter : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Functional Area'
  FunctionalArea : String(16);
  @sap.display.format : 'UpperCase'
  @sap.label : 'G/L Account'
  @sap.quickinfo : 'G/L Account Number'
  GLAccount : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'SD Document'
  @sap.quickinfo : 'Sales and Distribution Document Number'
  SalesOrder : String(10);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Sales document item'
  SalesOrderItem : String(6);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Cost Object'
  CostObject : String(12);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Activity Type'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  CostCtrActivityType : String(6);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Business Process'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  BusinessProcess : String(12);
  @sap.display.format : 'NonNegative'
  @sap.label : 'WBS Element'
  @sap.quickinfo : 'Work Breakdown Structure Element (WBS Element)'
  WBSElement : String(24);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Currency'
  @sap.quickinfo : 'Currency Key'
  @sap.semantics : 'currency-code'
  DocumentCurrency : String(5);
  @sap.unit : 'DocumentCurrency'
  @sap.label : 'Amount'
  @sap.quickinfo : 'Amount in Document Currency'
  SuplrInvcAcctAssignmentAmount : Decimal(14, 3);
  @sap.label : 'Order Unit'
  @sap.quickinfo : 'Purchase Order Unit of Measure'
  @sap.semantics : 'unit-of-measure'
  PurchaseOrderQuantityUnit : String(3);
  @sap.label : 'Order Unit'
  @sap.quickinfo : 'Purchase Order Unit of Measure'
  @sap.semantics : 'unit-of-measure'
  PurchaseOrderQtyUnitSAPCode : String(3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'ISO Code'
  @sap.quickinfo : 'ISO Code for Unit of Measurement'
  PurchaseOrderQtyUnitISOCode : String(3);
  @sap.unit : 'PurchaseOrderQtyUnitSAPCode'
  @sap.label : 'Quantity'
  Quantity : Decimal(13, 3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Code'
  @sap.quickinfo : 'Tax on sales/purchases code'
  TaxCode : String(2);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Account Assgmt No.'
  @sap.quickinfo : 'Sequential Number of Account Assignment'
  AccountAssignmentNumber : String(2);
  @sap.display.format : 'UpperCase'
  @sap.label : 'UAcctAssignment'
  @sap.quickinfo : 'Unplanned Account Assignment from Invoice Verification'
  AccountAssignmentIsUnplanned : Boolean;
  @sap.display.format : 'NonNegative'
  @sap.label : 'Personnel Number'
  PersonnelNumber : String(8);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Work Item ID'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  WorkItem : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Asset'
  @sap.quickinfo : 'Main Asset Number'
  MasterFixedAsset : String(12);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Sub-number'
  @sap.quickinfo : 'Asset Subnumber'
  FixedAsset : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Debit/Credit ind'
  @sap.quickinfo : 'Debit/Credit Indicator'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  DebitCreditCode : String(1);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Jurisdiction'
  TaxJurisdiction : String(15);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Order'
  @sap.quickinfo : 'Order Number'
  InternalOrder : String(12);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Opertn task list no.'
  @sap.quickinfo : 'Routing number of operations in the order'
  ProjectNetworkInternalID : String(10);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Opertn task list no.'
  @sap.quickinfo : 'Routing number of operations in the order'
  NetworkActivityInternalID : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Network'
  @sap.quickinfo : 'Network Number for Account Assignment'
  ProjectNetwork : String(12);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Activity'
  @sap.quickinfo : 'Operation/Activity Number'
  NetworkActivity : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Commitment item'
  @sap.quickinfo : 'Commitment Item'
  CommitmentItem : String(24);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Funds Center'
  FundsCenter : String(16);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Fund'
  Fund : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Grant'
  GrantID : String(20);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Trading Part.BA'
  @sap.quickinfo : 'Trading partner''s business area'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  PartnerBusinessArea : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Company Code'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  CompanyCode : String(4);
  @sap.label : 'Text'
  @sap.quickinfo : 'Item Text'
  SuplrInvcAccountAssignmentText : String(50);
  @sap.label : 'Order Price Unit'
  @sap.quickinfo : 'Order Price Unit (Purchasing)'
  @sap.semantics : 'unit-of-measure'
  PurchaseOrderPriceUnit : String(3);
  @sap.label : 'Order Price Unit'
  @sap.quickinfo : 'Order Price Unit (Purchasing)'
  @sap.semantics : 'unit-of-measure'
  PurchaseOrderPriceUnitSAPCode : String(3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'ISO Code'
  @sap.quickinfo : 'ISO Code for Unit of Measurement'
  PurchaseOrderPriceUnitISOCode : String(3);
  @sap.unit : 'PurchaseOrderPriceUnitSAPCode'
  @sap.label : 'Qty in OPUn'
  @sap.quickinfo : 'Quantity in Purchase Order Price Unit'
  QuantityInPurchaseOrderUnit : Decimal(13, 3);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Profitab. Segmt No.'
  @sap.quickinfo : 'Profitability Segment Number (CO-PA)'
  ProfitabilitySegment : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Budget Period'
  BudgetPeriod : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Ctry/Reg.'
  @sap.quickinfo : 'Tax Reporting Country/Region'
  TaxCountry : String(3);
};

@cds.external : true
@cds.persistence.skip : true
@sap.creatable : 'false'
@sap.updatable : 'false'
@sap.deletable : 'false'
@sap.content.version : '1'
@sap.label : 'Item with Purchase Order Reference'
entity invoicesrv.A_SuplrInvcItemPurOrdRef {
  @sap.display.format : 'UpperCase'
  @sap.label : 'Document Number'
  @sap.quickinfo : 'Document Number of an Accounting Document'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  key SupplierInvoice : String(10) not null;
  @sap.display.format : 'NonNegative'
  @sap.label : 'Fiscal Year'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  key FiscalYear : String(4) not null;
  @sap.display.format : 'NonNegative'
  @sap.label : 'Invoice Item'
  @sap.quickinfo : 'Document Item in Invoice Document'
  key SupplierInvoiceItem : String(6) not null;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Purchasing Document'
  @sap.quickinfo : 'Purchasing Document Number'
  PurchaseOrder : String(10);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Item'
  @sap.quickinfo : 'Item Number of Purchasing Document'
  PurchaseOrderItem : String(5);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Plant'
  Plant : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Reference Document'
  @sap.quickinfo : 'Document No. of a Reference Document'
  ReferenceDocument : String(10);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Year current period'
  @sap.quickinfo : 'Fiscal Year of Current Period'
  ReferenceDocumentFiscalYear : String(4);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Reference Doc. Item'
  @sap.quickinfo : 'Item of a Reference Document'
  ReferenceDocumentItem : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Subseq. Debit/Credit'
  @sap.quickinfo : 'Indicator: Subsequent Debit/Credit'
  IsSubsequentDebitCredit : String(1);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Code'
  @sap.quickinfo : 'Tax on sales/purchases code'
  TaxCode : String(2);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Jurisdiction'
  TaxJurisdiction : String(15);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Currency'
  @sap.quickinfo : 'Currency Key'
  @sap.semantics : 'currency-code'
  DocumentCurrency : String(5);
  @sap.unit : 'DocumentCurrency'
  @sap.label : 'Amount'
  @sap.quickinfo : 'Amount in Document Currency'
  SupplierInvoiceItemAmount : Decimal(14, 3);
  @sap.label : 'Order Unit'
  @sap.quickinfo : 'Purchase Order Unit of Measure'
  @sap.semantics : 'unit-of-measure'
  PurchaseOrderQuantityUnit : String(3);
  @sap.label : 'Order Unit'
  @sap.quickinfo : 'Purchase Order Unit of Measure'
  @sap.semantics : 'unit-of-measure'
  PurchaseOrderQtyUnitSAPCode : String(3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'ISO Code'
  @sap.quickinfo : 'ISO Code for Unit of Measurement'
  PurchaseOrderQtyUnitISOCode : String(3);
  @sap.unit : 'PurchaseOrderQtyUnitSAPCode'
  @sap.label : 'Quantity'
  QuantityInPurchaseOrderUnit : Decimal(13, 3);
  @sap.label : 'Order Price Unit'
  @sap.quickinfo : 'Order Price Unit (Purchasing)'
  @sap.semantics : 'unit-of-measure'
  PurchaseOrderPriceUnit : String(3);
  @sap.label : 'Order Price Unit'
  @sap.quickinfo : 'Order Price Unit (Purchasing)'
  @sap.semantics : 'unit-of-measure'
  PurchaseOrderPriceUnitSAPCode : String(3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'ISO Code'
  @sap.quickinfo : 'ISO Code for Unit of Measurement'
  PurchaseOrderPriceUnitISOCode : String(3);
  @sap.unit : 'PurchaseOrderPriceUnitSAPCode'
  @sap.label : 'Qty in OPUn'
  @sap.quickinfo : 'Quantity in Purchase Order Price Unit'
  QtyInPurchaseOrderPriceUnit : Decimal(13, 3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Condition Type'
  SuplrInvcDeliveryCostCndnType : String(4);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Step Number'
  SuplrInvcDeliveryCostCndnStep : String(3);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Counter'
  @sap.quickinfo : 'Condition Counter'
  SuplrInvcDeliveryCostCndnCount : String(3);
  @sap.label : 'Text'
  @sap.quickinfo : 'Item Text'
  SupplierInvoiceItemText : String(50);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Supplier'
  @sap.quickinfo : 'Account Number of Supplier'
  FreightSupplier : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'W/o Cash Dscnt'
  @sap.quickinfo : 'Indicator: Line Item Not Liable to Cash Discount?'
  IsNotCashDiscountLiable : Boolean;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Item Category'
  @sap.quickinfo : 'Item category in purchasing document'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  PurchasingDocumentItemCategory : String(1);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Product Type Group'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  ProductType : String(2);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Entry Sheet'
  @sap.quickinfo : 'Entry Sheet Number'
  @sap.sortable : 'false'
  @sap.filterable : 'false'
  ServiceEntrySheet : String(10);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Line Number'
  @sap.sortable : 'false'
  @sap.filterable : 'false'
  ServiceEntrySheetItem : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Ctry/Reg.'
  @sap.quickinfo : 'Tax Reporting Country/Region'
  TaxCountry : String(3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Final Invoice'
  @sap.quickinfo : 'Final Invoice Indicator'
  IsFinallyInvoiced : Boolean;
  @sap.display.format : 'UpperCase'
  @sap.label : 'HSN/SAC Code'
  @sap.quickinfo : 'HSN or SAC Code'
  IN_HSNOrSACCode : String(16);
  @sap.unit : 'DocumentCurrency'
  @sap.label : 'Assessable Value'
  IN_CustomDutyAssessableValue : Decimal(14, 3);
  to_SupplierInvoiceItmAcctAssgmt : Association to many invoicesrv.A_SuplrInvcItemAcctAssgmt {  };
};

@cds.external : true
@cds.persistence.skip : true
@sap.creatable : 'false'
@sap.updatable : 'false'
@sap.deletable : 'false'
@sap.content.version : '1'
@sap.label : 'Additional Data'
entity invoicesrv.A_SuplrInvoiceAdditionalData {
  @sap.display.format : 'UpperCase'
  @sap.label : 'Invoice Document No.'
  @sap.quickinfo : 'Document Number of an Invoice Document'
  key SupplierInvoice : String(10) not null;
  @sap.display.format : 'NonNegative'
  @sap.label : 'Fiscal Year'
  key FiscalYear : String(4) not null;
  @sap.label : 'Name'
  @sap.quickinfo : 'Name 1'
  InvoicingPartyName1 : String(35);
  @sap.label : 'Name 2'
  InvoicingPartyName2 : String(35);
  @sap.label : 'Name 3'
  InvoicingPartyName3 : String(35);
  @sap.label : 'Name 4'
  InvoicingPartyName4 : String(35);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Postal Code'
  PostalCode : String(10);
  @sap.label : 'City'
  CityName : String(35);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Country/Region Key'
  Country : String(3);
  @sap.label : 'Street'
  @sap.quickinfo : 'Street and House Number'
  StreetAddressName : String(35);
  @sap.display.format : 'UpperCase'
  @sap.label : 'PO Box'
  POBox : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'P.O. Box Postal Code'
  POBoxPostalCode : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Curr.Acct or Ref.No.'
  @sap.quickinfo : 'PO Bank Current Acct No. or Building Society Ref. No.'
  PostOfficeBankAccount : String(16);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Bank Account'
  @sap.quickinfo : 'Bank account number'
  BankAccount : String(18);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Bank Number'
  Bank : String(15);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Bank Country/Region'
  @sap.quickinfo : 'Bank Country/Region Key'
  BankCountry : String(3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Number 1'
  TaxID1 : String(16);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Number 2'
  TaxID2 : String(11);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Liable for VAT'
  OneTmeAccountIsVATLiable : Boolean;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Checkbox'
  @sap.heading : ''
  OneTmeAcctIsEqualizationTxSubj : Boolean;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Region'
  @sap.quickinfo : 'Region (State, Province, County)'
  Region : String(3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Bank Control Key'
  BankControlKey : String(2);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Instruction Key'
  @sap.quickinfo : 'Instruction Key for Data Medium Exchange'
  DataExchangeInstructionKey : String(2);
  @sap.display.format : 'UpperCase'
  @sap.label : 'DME Recipient Code'
  @sap.quickinfo : 'Recipient Code for Data Medium Exchange'
  DataMediumExchangeIndicator : String(1);
  @sap.label : 'Language Key'
  LanguageCode : String(2);
  @sap.display.format : 'UpperCase'
  @sap.label : 'One-time account'
  @sap.quickinfo : 'Indicator: Is the account a one-time account?'
  IsOneTimeAccount : Boolean;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Payment Recipient'
  @sap.quickinfo : 'Payment Recipient Code'
  PaymentRecipient : String(16);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Type'
  AccountTaxType : String(2);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax number type'
  @sap.quickinfo : 'Tax Number Type'
  TaxNumberType : String(2);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Checkbox'
  @sap.heading : ''
  IsNaturalPerson : Boolean;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Number 3'
  TaxID3 : String(18);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Number 4'
  TaxID4 : String(18);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Reference Details'
  @sap.quickinfo : 'Reference Details for Bank Details'
  BankDetailReference : String(20);
  @sap.label : 'Rep''s Name'
  @sap.quickinfo : 'Name of Representative'
  RepresentativeName : String(10);
  @sap.label : 'Type of Business'
  BusinessType : String(30);
  @sap.label : 'Type of Industry'
  IndustryType : String(30);
  @sap.label : 'Title'
  FormOfAddressName : String(15);
  @sap.display.format : 'UpperCase'
  @sap.label : 'VAT Registration No.'
  @sap.quickinfo : 'VAT Registration Number'
  VATRegistration : String(20);
  @sap.label : 'Country/Region Specific Reference 1'
  @sap.quickinfo : 'Country/Region specific Ref. in the One Time Account Data'
  OneTimeAcctCntrySpecificRef1 : String(140);
  @sap.display.format : 'UpperCase'
  @sap.label : 'IBAN'
  @sap.quickinfo : 'IBAN (International Bank Account Number)'
  @sap.sortable : 'false'
  @sap.filterable : 'false'
  IBAN : String(34);
  @sap.display.format : 'UpperCase'
  @sap.label : 'SWIFT/BIC'
  @sap.quickinfo : 'SWIFT/BIC for International Payments'
  SWIFTCode : String(11);
};

@cds.external : true
@cds.persistence.skip : true
@sap.updatable : 'false'
@sap.content.version : '1'
@sap.label : 'Header Data'
entity invoicesrv.A_SupplierInvoice {
  @sap.display.format : 'UpperCase'
  @sap.label : 'Invoice Document No.'
  @sap.quickinfo : 'Document Number of an Invoice Document'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  key SupplierInvoice : String(10) not null;
  @sap.display.format : 'NonNegative'
  @sap.label : 'Fiscal Year'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  key FiscalYear : String(4) not null;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Company Code'
  CompanyCode : String(4);
  @sap.display.format : 'Date'
  @sap.label : 'Invoice Date'
  @sap.quickinfo : 'Invoice Date in Document'
  DocumentDate : Date;
  @sap.display.format : 'Date'
  @sap.label : 'Posting Date'
  @sap.quickinfo : 'Posting Date in the Document'
  PostingDate : Date;
  @sap.display.format : 'Date'
  @sap.label : 'Entry Date'
  @sap.quickinfo : 'Day On Which Accounting Document Was Entered'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  CreationDate : Date;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Reference'
  @sap.quickinfo : 'Reference Document Number'
  SupplierInvoiceIDByInvcgParty : String(16);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Invoicing Party'
  @sap.quickinfo : 'Different Invoicing Party'
  InvoicingParty : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Currency'
  @sap.quickinfo : 'Currency Key'
  @sap.semantics : 'currency-code'
  DocumentCurrency : String(5);
  @sap.unit : 'DocumentCurrency'
  @sap.label : 'Gross Invoice Amount'
  @sap.quickinfo : 'Gross Invoice Amount in Document Currency'
  InvoiceGrossAmount : Decimal(14, 3);
  @sap.unit : 'DocumentCurrency'
  @sap.label : 'Unplanned Del. Costs'
  @sap.quickinfo : 'Unplanned Delivery Costs'
  UnplannedDeliveryCost : Decimal(14, 3);
  @sap.label : 'Document Header Text'
  DocumentHeaderText : String(25);
  @sap.unit : 'DocumentCurrency'
  @sap.label : 'CD Amount'
  @sap.quickinfo : 'Cash Discount Amount in Document Currency'
  ManualCashDiscount : Decimal(14, 3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Terms of Payment'
  @sap.quickinfo : 'Terms of Payment Key'
  PaymentTerms : String(4);
  @sap.display.format : 'Date'
  @sap.label : 'Baseline Date'
  @sap.quickinfo : 'Baseline Date for Due Date Calculation'
  DueCalculationBaseDate : Date;
  @sap.label : 'CD Percentage 1'
  @sap.quickinfo : 'Cash Discount Percentage 1'
  CashDiscount1Percent : Decimal(5, 3);
  @sap.label : 'Days 1'
  @sap.quickinfo : 'Cash discount days 1'
  CashDiscount1Days : Decimal(3, 0);
  @sap.label : 'CD Percentage 2'
  @sap.quickinfo : 'Cash Discount Percentage 2'
  CashDiscount2Percent : Decimal(5, 3);
  @sap.label : 'Days 2'
  @sap.quickinfo : 'Cash discount days 2'
  CashDiscount2Days : Decimal(3, 0);
  @sap.label : 'Days Net'
  @sap.quickinfo : 'Net Payment Terms Period'
  NetPaymentDays : Decimal(3, 0);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Payment block'
  @sap.quickinfo : 'Payment Block Key'
  PaymentBlockingReason : String(1);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Document Type'
  AccountingDocumentType : String(2);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Part.bank type'
  @sap.quickinfo : 'Partner bank type'
  BPBankAccountInternalID : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Invoice doc. status'
  @sap.quickinfo : 'Invoice document status'
  SupplierInvoiceStatus : String(1);
  @sap.label : 'Ind. quot. exch.rate'
  @sap.quickinfo : 'Indirect Quoted Exchange Rate'
  IndirectQuotedExchangeRate : Decimal(9, 5);
  @sap.label : 'Dir. quot.exch.rate'
  @sap.quickinfo : 'Direct Quoted Exchange Rate'
  DirectQuotedExchangeRate : Decimal(9, 5);
  @sap.display.format : 'UpperCase'
  @sap.label : 'SCB Indicator'
  @sap.quickinfo : 'State Central Bank Indicator'
  StateCentralBankPaymentReason : String(3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Supply Ctry/Reg'
  @sap.quickinfo : 'Supplying Country/Region'
  SupplyingCountry : String(3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Payment Method'
  PaymentMethod : String(1);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Pmt Meth. Supplement'
  @sap.quickinfo : 'Payment method supplement'
  PaymentMethodSupplement : String(2);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Payment Reference'
  PaymentReference : String(30);
  @sap.display.format : 'UpperCase'
  @sap.label : 'InR.Reference number'
  @sap.quickinfo : 'Invoice reference: Document number for invoice reference'
  InvoiceReference : String(10);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Fiscal Year'
  @sap.quickinfo : 'Fiscal Year of the Relevant Invoice (for Credit Memo)'
  InvoiceReferenceFiscalYear : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Fixed'
  @sap.quickinfo : 'Fixed Payment Terms'
  FixedCashDiscount : String(1);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Code'
  UnplannedDeliveryCostTaxCode : String(2);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Jurisdiction'
  UnplndDelivCostTaxJurisdiction : String(15);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Ctry/Reg.'
  @sap.quickinfo : 'Tax Reporting Country/Region'
  UnplndDeliveryCostTaxCountry : String(3);
  @sap.label : 'Assignment'
  @sap.quickinfo : 'Assignment number'
  AssignmentReference : String(18);
  @sap.label : 'Item Text'
  SupplierPostingLineItemText : String(50);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Calculate Tax'
  @sap.quickinfo : 'Calculate Tax Automatically'
  TaxIsCalculatedAutomatically : Boolean;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Business place'
  @sap.quickinfo : 'Business Place'
  BusinessPlace : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Section Code'
  BusinessSectionCode : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Business Area'
  BusinessArea : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Single-Character Flag'
  @sap.heading : ''
  SupplierInvoiceIsCreditMemo : String(1);
  @sap.display.format : 'UpperCase'
  @sap.label : 'PBC/ISR Number'
  @sap.quickinfo : 'ISR Subscriber Number'
  PaytSlipWthRefSubscriber : String(11);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Check digit'
  @sap.quickinfo : 'POR check digit'
  PaytSlipWthRefCheckDigit : String(2);
  @sap.display.format : 'UpperCase'
  @sap.label : 'ISR/QR Reference No.'
  @sap.quickinfo : 'ISR/QR Reference Number'
  PaytSlipWthRefReference : String(27);
  @sap.display.format : 'Date'
  @sap.label : 'Tax Date'
  @sap.quickinfo : 'Date for Determining Tax Rates'
  TaxDeterminationDate : Date;
  @sap.display.format : 'Date'
  @sap.label : 'Tax Reporting Date'
  TaxReportingDate : Date;
  @sap.display.format : 'Date'
  @sap.label : 'Tax Fulfill. Date'
  @sap.quickinfo : 'Tax Fulfillment Date'
  TaxFulfillmentDate : Date;
  @sap.display.format : 'Date'
  @sap.label : 'Invoice Receipt Date'
  InvoiceReceiptDate : Date;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Reporting Ctry/Reg'
  @sap.quickinfo : 'Reporting Country/Region for Delivery of Goods Within the EU'
  DeliveryOfGoodsReportingCntry : String(3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'VAT Registration No.'
  @sap.quickinfo : 'VAT Registration Number'
  SupplierVATRegistration : String(20);
  @sap.display.format : 'UpperCase'
  @sap.label : 'EU Triangular Deal'
  @sap.quickinfo : 'Indicator: Triangular Deal Within the EU'
  IsEUTriangularDeal : Boolean;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Delivery(Inv/Cr)'
  @sap.quickinfo : 'Posting logic for delivery items (invoice/credit memo)'
  SuplrInvcDebitCrdtCodeDelivery : String(1);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Returns(Inv/Cr)'
  @sap.quickinfo : 'Posting logic for returns items (invoice/credit memo)'
  SuplrInvcDebitCrdtCodeReturns : String(1);
  @sap.display.format : 'UpperCase'
  @sap.label : 'IV category'
  @sap.quickinfo : 'Origin of a Logistics Invoice Verification Document'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  SupplierInvoiceOrigin : String(1);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Reversed by'
  @sap.quickinfo : 'Reversal document number'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  ReverseDocument : String(10);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Year'
  @sap.quickinfo : 'Fiscal year of reversal document'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  ReverseDocumentFiscalYear : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Is Reversal'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.sortable : 'false'
  @sap.filterable : 'false'
  IsReversal : Boolean;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Is Reversed'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.sortable : 'false'
  @sap.filterable : 'false'
  IsReversed : Boolean;
  @sap.display.format : 'UpperCase'
  @sap.label : 'GST Partner'
  IN_GSTPartner : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Place of Supply'
  IN_GSTPlaceOfSupply : String(3);
  @sap.label : 'Invoice Ref. Number'
  @sap.quickinfo : 'Invoice Reference Number'
  IN_InvoiceReferenceNumber : String(64);
  @sap.label : 'Country/Region Specific Reference 1'
  @sap.quickinfo : 'Country/Region Specific Reference 1 in the Document'
  JrnlEntryCntrySpecificRef1 : String(80);
  @sap.display.format : 'Date'
  @sap.label : 'Country/Region Specific Date 1'
  @sap.quickinfo : 'Country/Region Specific Date 1 in the Document'
  JrnlEntryCntrySpecificDate1 : Date;
  @sap.label : 'Country/Region Specific Reference 2'
  @sap.quickinfo : 'Country/Region Specific Reference 2 in the Document'
  JrnlEntryCntrySpecificRef2 : String(25);
  @sap.display.format : 'Date'
  @sap.label : 'Country/Region Specific Date 2'
  @sap.quickinfo : 'Country/Region Specific Date 2 in the Document'
  JrnlEntryCntrySpecificDate2 : Date;
  @sap.label : 'Country/Region Specific Reference 3'
  @sap.quickinfo : 'Country/Region Specific Reference 3 in the Document'
  JrnlEntryCntrySpecificRef3 : String(25);
  @sap.display.format : 'Date'
  @sap.label : 'Country/Region Specific Date 3'
  @sap.quickinfo : 'Country/Region Specific Date 3 in the Document'
  JrnlEntryCntrySpecificDate3 : Date;
  @sap.label : 'Country/Region Specific Reference 4'
  @sap.quickinfo : 'Country/Region Specific Reference 4 in the Document'
  JrnlEntryCntrySpecificRef4 : String(50);
  @sap.display.format : 'Date'
  @sap.label : 'Country/Region Specific Date 4'
  @sap.quickinfo : 'Country/Region Specific Date 4 in the Document'
  JrnlEntryCntrySpecificDate4 : Date;
  @sap.label : 'Country/Region Specific Reference 5'
  @sap.quickinfo : 'Country/Region Specific Reference 5 in the Document'
  JrnlEntryCntrySpecificRef5 : String(50);
  @sap.display.format : 'Date'
  @sap.label : 'Country/Region Specific Date 5'
  @sap.quickinfo : 'Country/Region Specific Date 5 in the Document'
  JrnlEntryCntrySpecificDate5 : Date;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Ctry/Reg. Specific Business Partner 1'
  @sap.quickinfo : 'Country/Region specific Business Partner 1 in the Document'
  JrnlEntryCntrySpecificBP1 : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Ctry/Reg. Specific Business Partner 2'
  @sap.quickinfo : 'Country/Region Specific Business Partner 2 in the Document'
  JrnlEntryCntrySpecificBP2 : String(10);
  to_SuplrInvcItemPurOrdRef : Association to many invoicesrv.A_SuplrInvcItemPurOrdRef {  };
  to_SuplrInvoiceAdditionalData : Association to invoicesrv.A_SuplrInvoiceAdditionalData {  };
  to_SupplierInvoiceItemGLAcct : Association to many invoicesrv.A_SupplierInvoiceItemGLAcct {  };
  to_SupplierInvoiceTax : Association to many invoicesrv.A_SupplierInvoiceTax {  };
  to_SupplierInvoiceWhldgTax : Association to many invoicesrv.A_SuplrInvcHeaderWhldgTax {  };
};

@cds.external : true
@cds.persistence.skip : true
@sap.creatable : 'false'
@sap.updatable : 'false'
@sap.deletable : 'false'
@sap.content.version : '1'
@sap.label : 'Item for G/L Account Posting'
entity invoicesrv.A_SupplierInvoiceItemGLAcct {
  @sap.display.format : 'UpperCase'
  @sap.label : 'Document Number'
  @sap.quickinfo : 'Document Number of an Accounting Document'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  key SupplierInvoice : String(10) not null;
  @sap.display.format : 'NonNegative'
  @sap.label : 'Fiscal Year'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  key FiscalYear : String(4) not null;
  @sap.display.format : 'NonNegative'
  @sap.label : 'Sequence Number'
  @sap.quickinfo : 'Four Character Sequential Number for Coding Block'
  key SupplierInvoiceItem : String(4) not null;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Company Code'
  CompanyCode : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Cost Center'
  CostCenter : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Controlling Area'
  ControllingArea : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Business Area'
  BusinessArea : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Profit Center'
  ProfitCenter : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Functional Area'
  FunctionalArea : String(16);
  @sap.display.format : 'UpperCase'
  @sap.label : 'G/L Account'
  @sap.quickinfo : 'G/L Account Number'
  GLAccount : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'SD Document'
  @sap.quickinfo : 'Sales and Distribution Document Number'
  SalesOrder : String(10);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Sales document item'
  SalesOrderItem : String(6);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Cost Object'
  CostObject : String(12);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Activity Type'
  CostCtrActivityType : String(6);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Business Process'
  BusinessProcess : String(12);
  @sap.display.format : 'NonNegative'
  @sap.label : 'WBS Element'
  @sap.quickinfo : 'Work Breakdown Structure Element (WBS Element)'
  WBSElement : String(24);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Currency'
  @sap.quickinfo : 'Currency Key'
  @sap.semantics : 'currency-code'
  DocumentCurrency : String(5);
  @sap.unit : 'DocumentCurrency'
  @sap.label : 'Amount'
  @sap.quickinfo : 'Amount in Document Currency'
  SupplierInvoiceItemAmount : Decimal(14, 3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Code'
  @sap.quickinfo : 'Tax on sales/purchases code'
  TaxCode : String(2);
  @sap.display.format : 'NonNegative'
  @sap.label : 'Personnel Number'
  PersonnelNumber : String(8);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Work Item ID'
  WorkItem : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Debit/Credit ind'
  @sap.quickinfo : 'Debit/Credit Indicator'
  DebitCreditCode : String(1);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Jurisdiction'
  TaxJurisdiction : String(15);
  @sap.label : 'Text'
  @sap.quickinfo : 'Item Text'
  SupplierInvoiceItemText : String(50);
  @sap.label : 'Assignment'
  @sap.quickinfo : 'Assignment number'
  AssignmentReference : String(18);
  @sap.display.format : 'UpperCase'
  @sap.label : 'W/o Cash Dscnt'
  @sap.quickinfo : 'Indicator: Line Item Not Liable to Cash Discount?'
  IsNotCashDiscountLiable : Boolean;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Order'
  @sap.quickinfo : 'Order Number'
  InternalOrder : String(12);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Network'
  @sap.quickinfo : 'Network Number for Account Assignment'
  ProjectNetwork : String(12);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Activity'
  @sap.quickinfo : 'Operation/Activity Number'
  NetworkActivity : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Commitment item'
  @sap.quickinfo : 'Commitment Item'
  CommitmentItem : String(24);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Funds Center'
  FundsCenter : String(16);
  @sap.unit : 'DocumentCurrency'
  @sap.label : 'Tax Base Amount'
  @sap.quickinfo : 'Tax Base Amount in Document Currency'
  TaxBaseAmountInTransCrcy : Decimal(14, 3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Fund'
  Fund : String(10);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Grant'
  GrantID : String(20);
  @sap.label : 'Base Unit of Measure'
  @sap.semantics : 'unit-of-measure'
  QuantityUnit : String(3);
  @sap.label : 'Base Unit of Measure'
  @sap.semantics : 'unit-of-measure'
  SuplrInvcItmQtyUnitSAPCode : String(3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'ISO Code'
  @sap.quickinfo : 'ISO Code for Unit of Measurement'
  SuplrInvcItmQtyUnitISOCode : String(3);
  @sap.unit : 'SuplrInvcItmQtyUnitSAPCode'
  @sap.label : 'Quantity'
  Quantity : Decimal(13, 3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Trading Part.BA'
  @sap.quickinfo : 'Trading partner''s business area'
  PartnerBusinessArea : String(4);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Transaction type'
  FinancialTransactionType : String(3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Ctry/Reg.'
  @sap.quickinfo : 'Tax Reporting Country/Region'
  TaxCountry : String(3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Budget Period'
  BudgetPeriod : String(10);
};

@cds.external : true
@cds.persistence.skip : true
@sap.creatable : 'false'
@sap.updatable : 'false'
@sap.deletable : 'false'
@sap.content.version : '1'
@sap.label : 'Tax Data'
entity invoicesrv.A_SupplierInvoiceTax {
  @sap.display.format : 'UpperCase'
  @sap.label : 'Invoice Document No.'
  @sap.quickinfo : 'Document Number of an Invoice Document'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  key SupplierInvoice : String(10) not null;
  @sap.display.format : 'NonNegative'
  @sap.label : 'Fiscal Year'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  key FiscalYear : String(4) not null;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Code'
  @sap.quickinfo : 'Tax code'
  key TaxCode : String(2) not null;
  @sap.display.format : 'NonNegative'
  @sap.label : 'Invoice Item'
  @sap.quickinfo : 'Document Item in Invoice Document'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  key SupplierInvoiceTaxCounter : String(6) not null;
  @sap.display.format : 'UpperCase'
  @sap.label : 'Currency'
  @sap.quickinfo : 'Currency Key'
  @sap.semantics : 'currency-code'
  DocumentCurrency : String(5);
  @sap.unit : 'DocumentCurrency'
  @sap.label : 'Value-Added Tax Amt'
  @sap.quickinfo : 'Tax Amount in Document Currency with +/- Sign'
  TaxAmount : Decimal(14, 3);
  @sap.unit : 'DocumentCurrency'
  @sap.label : 'Tax Base Amount'
  @sap.quickinfo : 'Tax Base Amount in Document Currency'
  TaxBaseAmountInTransCrcy : Decimal(16, 3);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Jurisdiction'
  TaxJurisdiction : String(15);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Tax Ctry/Reg.'
  @sap.quickinfo : 'Tax Reporting Country/Region'
  TaxCountry : String(3);
};

@cds.external : true
type invoicesrv.CancelInvoiceExportParameters {
  @sap.label : 'Reversed With'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.sortable : 'false'
  @sap.filterable : 'false'
  ReverseDocument : String(10) not null;
  @sap.label : 'Fiscal Year'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.sortable : 'false'
  @sap.filterable : 'false'
  FiscalYear : String(4) not null;
  @sap.label : 'TRUE'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.sortable : 'false'
  @sap.filterable : 'false'
  Success : Boolean not null;
};

@cds.external : true
type invoicesrv.ReleaseInvoiceExportParameters {
  @sap.label : 'TRUE'
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.sortable : 'false'
  @sap.filterable : 'false'
  Success : Boolean not null;
};

@cds.external : true
action invoicesrv.Release(
  SupplierInvoice : String(10),
  FiscalYear : String(4),
  @sap.label : 'Indicator'
  DiscountDaysHaveToBeShifted : Boolean
) returns invoicesrv.ReleaseInvoiceExportParameters;

@cds.external : true
action invoicesrv.Cancel(
  @odata.Type : 'Edm.DateTime'
  @sap.label : 'Time Stamp'
  PostingDate : DateTime,
  ReversalReason : String(2),
  FiscalYear : String(4),
  SupplierInvoice : String(10)
) returns invoicesrv.CancelInvoiceExportParameters;

