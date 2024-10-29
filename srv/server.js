const cds = require("@sap/cds");
const express = require("express");

cds.on("bootstrap", (app) => {
  // Workaround Incident 291152/2022
  app.use(express.json({ limit: "5MB" }));
  // cds.serve("CatalogService").in(app).to("rest").at("rest");
});

module.exports = cds.server;