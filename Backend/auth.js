Parse.Cloud.define("signup", async (request) => {
    let user = new Parse.User();
    user.set("username", request.params.username);
    user.set("password", request.params.password);
    return await user.signUp(null, { useMasterKey: true });
},{
  fields: ["username", "password"],
  requireUser: false
});
