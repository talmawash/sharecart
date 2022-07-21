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

Parse.Cloud.define("joinList", async (request) => {
  const invitations = await new Parse.Query("SharecartInvitation").equalTo("objectId", request.params.code).find({ useMasterKey: true });
  if (invitations.length == 1) {
      const invitation = invitations[0];
      
      if (invitation.used) {
          throw("Invitation already used!");
      }
      
      const hourDifference = (Date.now() - invitation.createdAt) / (1000 * 60 * 60)
      if (hourDifference >= 24) {
          throw("Invitation exipred!");
      }
      
      const list = invitation.get("list");
      const listInUserLists = await request.user.get("lists").query().equalTo("objectId", list.id).find({ useMasterKey:true })
      if (listInUserLists.length > 0) {
          throw("Already in list!");
      }
      
      await invitation.save({ "used": true }, { useMasterKey: true });
      
      request.user.get("lists").add(list);
      await request.user.save(null, { useMasterKey:true });
      
      list.fetch({ useMasterKey: true }); // Get missing paramaters such as name before sending to user
      list.relation("users").add(request.user);
      return await list.save(null, { useMasterKey: true });
  }
  throw("Invitation not found");
},{
  fields: ["code"],
  requireUser: true
});
