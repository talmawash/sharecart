Parse.Cloud.define("getItems", async (request) => {
  const relation = await request.user.get("lists");
  const list = await relation.query().equalTo("objectId", request.params.listId).find({ useMasterKey: true });
  if (list.length == 1) {
    let query = new Parse.Query("SharecartItem").equalTo("list", list[0]);
    return await query.find({ useMasterKey: true });
  }
},{
  fields: ["listId"],
  requireUser: true
});

