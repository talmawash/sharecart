Parse.Cloud.define("getLists", async (request) => {
  const relation = await request.user.get("lists");
  return await relation.query().descending("createdAt").find({ useMasterKey: true });
},{
  requireUser: true
});

Parse.Cloud.define("newList", async (request) => {
  let list = new Parse.Object("SharecartList");
  list = await list.save({
    name: request.params.name,
    creator: request.user
  }, { useMasterKey: true });
  list.relation("users").add(request.user);
  await list.save(null, { useMasterKey: true});
  
  request.user.get("lists").add(list);
  await request.user.save(null, { useMasterKey:true });
  
  return list;
},{
  fields: ["name"],
  requireUser: true
});

Parse.Cloud.define("createInvitation", async (request) => {
  const relation = await request.user.get("lists");
  const lists = await relation.query().equalTo("objectId", request.params.listId).find({ useMasterKey: true });
  if (lists.length == 1) {
      return await new Parse.Object("SharecartInvitation").save({
        list: lists[0]
      }, { useMasterKey: true });
  }
},{
  fields: ["listId"],
  requireUser: true
});
