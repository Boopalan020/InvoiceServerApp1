const cds = require("@sap/cds");
const { transformEmailItems } = require("../Utils/Utilities");
const { status_config, machine_config } = require('../valuehelpdata');

module.exports = class SearchService extends cds.ApplicationService {
  async init() {
    let hana_db;

    try {
      hana_db = await cds.connect.to("db");
    } catch (err) {
      console.log("Some instances are not connected properly", err);
    }

    // Custom logic for getSearchConfig
    this.on("getSearchConfig", async (req) => {
      const { Searchheader, Searchitem } = cds.entities("tablemodel.srv.SearchService");
      let aHeaderData, aItemData, resp_Data = [];

      try {
        console.log("Req Body : ", req.data);

        // Fetch Header
        aHeaderData = await hana_db.run(
          SELECT.one.from(Searchheader).where({
            Status: "Active",
            machine_name: req.data.machinename,
            Name: req.data.username,
          })
        );
        console.log("Search Header : ", aHeaderData);

        // Fetch Items if Header exists
        if (aHeaderData) {
          aItemData = await hana_db.run(
            SELECT.from(Searchitem).where({
              parent: aHeaderData.ID,
            })
          );

          resp_Data = transformEmailItems(aItemData);
          return resp_Data;
        }
      } catch (err) {
        console.log(err);
        return {
          status: "Error",
          message: err.message,
        };
      }

      return {
        message: "No data found with 'Name' and 'machinename'.",
      };
    });

    /*******************************************************************************************
     * Custom Handlers for Value helps services
     *******************************************************************************************/
    this.on("READ", "StatusVH", async (req) => {
        // const statusTypes = Array.from(new Set(status_config.map(s => s.type))); // Remove duplicate status types
        return status_config.map(rec => ({
            type: rec.type
        }));

    //   return [
    //     { type: "Active", description: "Active Status" },
    //     { type: "Inactive", description: "Inactive Status" },
    //   ];
    });

    this.on("READ", "MachineVH", async (req) => {
        // const machineData = Array.from(new Set(machine_config.map(s => s.type))); // Remove duplicate status types
        return machine_config.map(rec => ({
            machine_name: rec.machine_name
        }));
    });

    return super.init();
  }
};
