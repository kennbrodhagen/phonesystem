# Factory functions to build the parts of our app
createServer = (port) ->
	express = require("express")
	server = express.createServer()
	server.configure ->
		server.set "views", __dirname + "/views"
		server.set "view engine", "jade"
		server.set "port", port
		server.use express.bodyParser()
		server.use express.methodOverride()
		server.use express.cookieParser()
		server.use express.session(secret: "your secret here")
		server.use require("stylus").middleware(src: __dirname + "/public")
		server.use server.router
		server.use express.static(__dirname + "/public")

	server.configure "development", ->
		server.use express.errorHandler(
			dumpExceptions: true
			showStack: true
		)

	server.configure "test", ->
		server.use express.logger("default")

	server.configure "production", ->
		server.use express.errorHandler()

	return server



determinePort = ->
	defaultPort = 3003
	switch process.env.NODE_ENV
		when "production" then defaultPort = 3000
		when "development" then defaultPort = 3001
		when "test" then defaultPort = 3002
		else defaultPort = 3003

	port = process.env.PORT or defaultPort
	return port

class App
	constructor: (log,store) ->
		@server = createServer(determinePort())
		@log = log
		@store = store
		require("./routes") @

module.exports = App