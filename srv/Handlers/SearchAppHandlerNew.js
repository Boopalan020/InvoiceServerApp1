const cds = require("@sap/cds");
const { transformEmailItems } = require("../Utils/Utilities");

module.exports = class SearchService extends cds.ApplicationService {
    async init() {
        let hana_db;

        try {
            hana_db = await cds.connect.to('db');
        } catch (err) {
            console.log("Some instances are not connected properly", err);
        }

        this.on("getSearchConfig", async (req) => {
            let {
                Searchheader,
                Searchitem
            } = cds.entities('tablemodel.srv.SearchService'),
                aHeaderData,
                aItemData,
                resp_Data = [];

            try {
                console.log("Req Body : ", req.data);
                
                // Header Data for search
                aHeaderData = await hana_db.run(SELECT.one.from(Searchheader).where({
                    Status: "Active",
                    machine_name: req.data.machinename,
                    Name: req.data.username
                }));
                console.log("Search Header : ", aHeaderData);

                if (aHeaderData) {
                    aItemData = await hana_db.run(SELECT.from(Searchitem).where({
                        parent: aHeaderData.ID
                    }));

                    resp_Data = transformEmailItems(aItemData);
                    return resp_Data;
                }
            } catch (err) {
                console.log(err);
                return {
                    status: "Error",
                    message: err.message
                };
            }

            return {
                message : "No data found with 'Name' and 'machinename'."
            }
        });

        return super.init()
    }

}