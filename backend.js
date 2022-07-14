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
