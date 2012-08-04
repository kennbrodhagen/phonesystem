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
		@app.store.findAllCalls (err, calls) ->
			res.render 'calls-index', {title: 'calls', calls:calls}

module.exports = CallsController