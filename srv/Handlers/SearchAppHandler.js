const cds = require("@sap/cds");

module.exports = class SearchAppService extends cds.ApplicationService {
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
            } = cds.entities('tablemodel.srv.SearchAppService'),
                aHeaderData,
                aItemData,
                aOperandData,
                aElementData,
                resp_Data = [],
                sOperandTable = 'db.tables.Operands',
                sElementTable = 'db.tables.elementlist';

            try {
                console.log("Req Body : ", req.data);

                // Search Help Data for operands
                aOperandData = await hana_db.run(SELECT.from(sOperandTable));
                console.log(aOperandData);

                // Search Help Data for elementlist
                aElementData = await hana_db.run(SELECT.from(sElementTable));
                console.log(aElementData);

                // Header Data for search
                aHeaderData = await hana_db.run(SELECT.one.from(Searchheader).where({
                    Status_code: "Active",
                    machine_name: req.data.machinename,
                    Name: req.data.username
                }));
                console.log("Search Header : ", aHeaderData);

                if (aHeaderData) {
                    aItemData = await hana_db.run(SELECT.from(Searchitem).where({
                        parent: aHeaderData.ID
                    }));

                    console.log(aItemData);
                    aItemData = aItemData.sort((a, b) => parseInt(a.Sequence) - parseInt(b.Sequence) );
                    for (const item of aItemData) {
                        const ele = aElementData.find(({
                            code,
                            name
                        }) => {
                            if (code === item.elements1_code) return name
                        });
                        resp_Data.push({
                            element: aElementData.find(({
                                code,
                                name
                            }) => code === item.elements1_code).name,
                            operand: aOperandData.find(({
                                code
                            }) => code === item.operand_code).name,
                            value: item.Value
                        });
                    }
                }

            } catch (err) {
                console.log(err);
            }

            // resp_Data = resp_Data.sort((a, b) => parseInt(a.Sequence) - parseInt(b.Sequence) );
            return resp_Data;
        });

        return super.init()
    }

}