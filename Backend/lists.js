Parse.Cloud.define("getLists", async (request) => {
  let mainQuery;
  const relation = await request.user.get("lists");
  return await relation.query().find({ useMasterKey: true });
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
