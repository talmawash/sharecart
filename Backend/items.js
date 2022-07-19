Parse.Cloud.define("getItems", async (request) => {
  const relation = await request.user.get("lists");
  const list = await relation.query().equalTo("objectId", request.params.listId).find({ useMasterKey: true });
  if (list.length == 1) { // User is indeed a member of that list
    const query = new Parse.Query("SharecartItem").equalTo("list", list[0]).descending("createdAt");
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
    let item = new Parse.Object("SharecartItem");
    item = await item.save({
      name: request.params.name,
      list: list[0]
    }, { useMasterKey: true });
    
    const users = await list[0].relation("users").query().find({ useMasterKey:true }) // Lookup all users in list
    list[0].increment("lastUpdate").save(null, { useMasterKey: true }); // Increment and save lastUpdate value of the list
    for (let i = 0; i < users.length; i++) {
      await new Parse.Object("SharecartUpdate").save({ // save an update object for list user i
        type: "itemAdded",
        after: item.toJSON(),
        accessibleBy: users[i],
        number: list[0].get("lastUpdate")
      }, { useMasterKey: true });
    }
    
    return item;
  }
},{
  fields: ["name", "listId"],
  requireUser: true
});
