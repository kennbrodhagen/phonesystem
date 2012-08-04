require('coffee-script');
factory = require('./factory');

var App = require("./app");
var testCalls = [{id: 1, start:"1976-08-18 21:00:00.000-04", duration:180, callingParty:"6789826238"}, {id: 2, start:"1970-08-20 00:00:00.000-04", duration:180, callingParty:"7709928775"}];
var app = new App(factory.createProductionLog(), factory.createProductionStore(testCalls));

app.server.listen(app.server.settings.port);
app.log.info("Express server listening on port %d in %s mode", app.server.settings.port, app.server.settings.env);
