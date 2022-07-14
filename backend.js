Parse.Cloud.define("getLists", async (request) => {
  if (request.user) {
    var mainQuery;
    var relation = await request.user.get("lists", {useMasterKey: true});
    var lists = await relation.query().find({useMasterKey: true});
    for (var i = 0; i < lists.length; i++) {
      var subQuery = new Parse.Query("SharecartList");
      subQuery.equalTo("id", lists.id);
      if (!mainQuery) {
        mainQuery = subQuery;
      } else {
        mainQuery = Parse.Query.or(mainQuery, subQuery);
      }
    }
    return await mainQuery.find({useMasterKey: true});
  } else {
    throw ("Must be signed in");
  }
});
