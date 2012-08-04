should				= require "should"

describe "Controllers", ->
	app = null
	before ->
		factory = require "../factory"
		App = require "../app"
		testCalls = [{id: 1, start:"1976-08-18 21:00:00.000-04", duration:180, callingParty:"6789826238"}, {id: 2, start:"1970-08-20 00:00:00.000-04", duration:180, callingParty:"7709928775"}]
		app = new App(factory.createTestLog(), factory.createTestStore(testCalls))

	describe "Calls Controller", ->

		class ControllerInspector
			constructor: ->
				@redirectedUrl = null
				@renderedTemplate = ""
				@renderedArgs = null
				@req = 
					body: {}
					params: {}

				@res =
					redirect: (url) =>
						@redirectedUrl = url
					render: (template, args) =>
						app.log.info {template: template, args: args}, "ControllerInspector.res.render:"
						@renderedTemplate = template
						@renderedArgs = args

				@items = {}

		_controllerInspector = null
		_controller = null

		beforeEach ->
			app.log.info "Re-creating inspector and controller"
			_controllerInspector = new ControllerInspector
			_controller = new (require "../controllers/calls")(app)
			

		it "should render index for calls", ->
			_controller.index _controllerInspector.req, _controllerInspector.res
			should.exist _controllerInspector.renderedTemplate, "Should render template"
			_controllerInspector.renderedTemplate.should.equal 'calls-index', "Should render calls template"









