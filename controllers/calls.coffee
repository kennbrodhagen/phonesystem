# HTTP 	Verb		Path								action			used for
# GET						/calls							index				display a list of all calls
# GET						/calls/new					new					return an HTML form for creating a new todo
# POST					/calls							create			create a new todo
# GET						/calls/:id					show				display a specific todo
# GET						/calls/:id/edit			edit				return an HTML form for editing a todo
# PUT/POST			/calls/:id					update			update a specific todo
# DELETE				/calls/:id					destroy			delete a specific todo

class CallsController
	constructor: (app) ->
		@app = app

	index: (req, res) =>
		#@app.log.info {req: req}, "callsController#index"
		app = @app
		app.store.findAllCalls (err, calls) ->
			renderArgs = {title: 'calls', calls:calls}
			#app.log.info renderArgs, "CallsController.index:"
			res.render 'calls-index', renderArgs 

	callevents: (req, res) =>
		app = @app
		app.log.info {body: req.body}, "CallsController.callevents"
		renderArgs = {call: {number: 1}}
		res.render 'twiml/callevents', renderArgs

module.exports = CallsController