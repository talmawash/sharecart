Parse.Cloud.define("getLists", async (request) => {
  let mainQuery;
  const relation = await request.user.get("lists");
  const lists = await relation.query().find({ useMasterKey: true });
  for (let i = 0; i < lists.length; i++) {
    let subQuery = new Parse.Query("SharecartList");
    subQuery.equalTo("objectId", lists[i]._getId());
    if (!mainQuery) {
      mainQuery = subQuery;
    } else {
      mainQuery = Parse.Query.or(mainQuery, subQuery);
    }
  }
  return await mainQuery.find({ useMasterKey: true });
},{
  requireUser: true
});

Parse.Cloud.define("newList", async (request) => {
  let list = new Parse.Object("SharecartList");
  list = await list.save({
    name: request.params.name,
    creator: request.user
  }, { useMasterKey: true });
  
  request.user.get("lists").add(list);
  await request.user.save(null, { useMasterKey:true });
  
  return list; // This will be reached if the above operations don't throw exceptions.
},{
  fields: ["name"],
  requireUser: true
});

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

