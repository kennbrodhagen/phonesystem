# HTTP 	Verb		Path								action			used for
# GET						/todos							index				display a list of all todos
# GET						/todos/new					new					return an HTML form for creating a new todo
# POST					/todos							create			create a new todo
# GET						/todos/:id					show				display a specific todo
# GET						/todos/:id/edit			edit				return an HTML form for editing a todo
# PUT/POST			/todos/:id					update			update a specific todo
# DELETE				/todos/:id					destroy			delete a specific todo

router = (app) ->
	app.log.info {store: app.store}, "router init store = #{app.store}"
	HomeController =  require("./controllers/home")
	homeController =  new HomeController(app)

	CallsController = require("./controllers/calls")
	callsController = new CallsController(app)


	app.server.get '/', (req, res) ->
		res.redirect '/home'

	app.server.get '/home', homeController.index
	app.server.get '/calls', callsController.index
	app.server.post '/callevents', callsController.callevents

module.exports = router
