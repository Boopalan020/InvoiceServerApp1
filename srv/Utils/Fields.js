// List of header field and item field values that needs to stored in database after DOX extraction
const aHeaderFieldLists = [
  "documentNumber",
  "mailDateTime",
  "emailId",
  "mailSubject",
  "dox_id",
  "extraction_status",
  "netAmount",
  "grossAmount",
  "currencyCode",
  "documentDate",
  "deliveryDate",
  "senderName",
  "senderEmail",
  "StatusCode",
  "taxId",
  "paymentTerms",
  "senderBankAccount",
  "senderAddress",
  "taxIdNumber",
  "receiverId",
  "shipToAddress",
  "shippingTerms",
  "quantity",
  "senderId",
  "senderStreet",
  "senderCity",
  "senderHouseNumber",
  "senderPostalCode",
  "senderCountryCode",
  "senderPhone",
  "senderFax",
  "senderState",
  "senderDistrict",
  "senderExtraAddressPart",
  "shipToName",
  "shipToStreet",
  "shipToCity",
  "shipToHouseNumber",
  "shipToPostalCode",
  "shipToCountryCode",
  "shipToPhone",
  "shipToFax",
  "shipToEmail",
  "shipToState",
  "shipToDistrict",
  "shipToExtraAddressPart"
];

const aHeaderAccuracyLists = [
  "documentNumber_ac",
  "netAmount_ac",
  "grossAmount_ac",
  "currencyCode_ac",
  "documentDate_ac",
  "senderName_ac"
];

const aItemFieldLists = [
  "description",
  "netAmount",
  "quantity",
  "unitPrice",
  "materialNumber",
  "documentDate",
  "itemNumber",
  "currencyCode",
  "senderMaterialNumber",
  "supplierMaterialNumber",
  "customerMaterialNumber",
  "unitOfMeasure"
];

const aItemAccuracyLists = [
  "description_ac",
  "netAmount_ac",
  "quantity_ac",
  "unitPrice_ac",
  "materialNumber_ac",
  "senderMaterialNumber_ac",
  "supplierMaterialNumber_ac",
  "unitOfMeasure_ac",
  "customerMaterialNumber_ac"
];

// Export both arrays
module.exports = {
  aHeaderFieldLists,
  aHeaderAccuracyLists,
  aItemFieldLists,
  aItemAccuracyLists
};
