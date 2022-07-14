Parse.Cloud.define("getItems", async (request) => {
  const relation = await request.user.get("lists");
  const list = await relation.query().equalTo("objectId", request.params.listId).find({ useMasterKey: true });
  if (list.length == 1) { // User is indeed a member of that list
    const query = new Parse.Query("SharecartItem").equalTo("list", list[0]);
    return await query.find({ useMasterKey: true });
  }
},{
  fields: ["listId"],
  requireUser: true
});

Parse.Cloud.define("newItem", async (request) => {
  const relation = await request.user.get("lists");
  const list = await relation.query().equalTo("objectId", request.params.listId).find({ useMasterKey: true });
  if (list.length == 1) { // User is indeed a member of that list
    const item = new Parse.Object("SharecartItem");
    return await item.save({
      name: request.params.name,
      list: list[0]
    }, { useMasterKey: true });
  }
},{
  fields: ["name", "listId"],
  requireUser: true
});
