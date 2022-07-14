Parse.Cloud.define("signup", async (request) => {
    let user = new Parse.User();
    user.set("username", request.params.username);
    user.set("password", request.params.password);
    await user.signUp(null, { useMasterKey: true });
    return user; // This will be reached if the above operations don't throw exceptions.
},{
  fields: ["username", "password"],
  requireUser: false
});
