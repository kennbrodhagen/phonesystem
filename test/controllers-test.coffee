should				= require "should"

describe "Controllers", ->
	app = null
	before (done)->
		factory = require "../factory"
		App = require "../app"
		testCalls = [{id: 1, start:"1976-08-18 21:00:00.000-04", duration:180, callingParty:"6789826238"}, {id: 2, start:"1970-08-20 00:00:00.000-04", duration:180, callingParty:"7709928775"}]
		app = new App(factory.createTestLog(), factory.createTestStore(testCalls))
		done()

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
			_controllerInspector = new ControllerInspector
			_controller = new (require "../controllers/calls")(app)
			
		describe "CallsController.index method tests", ->		

			it "should render calls-index template", ->
				_controller.index _controllerInspector.req, _controllerInspector.res
				should.exist _controllerInspector.renderedTemplate, "Should render template"
				_controllerInspector.renderedTemplate.should.equal 'calls-index', "Should render calls template"

			it "should include calls in rendered args", ->
				_controller.index _controllerInspector.req, _controllerInspector.res
				should.exist _controllerInspector.renderedArgs, "Should have renderedArgs"
				should.exist _controllerInspector.renderedArgs.calls, "Should have renderedArgs.calls"
				_controllerInspector.renderedArgs.calls.should.be.an.instanceOf(Array)


		describe "CallsController.callevents method tests", ->		

			it "should render twilio/callevents template", ->
				_controller.callevents _controllerInspector.req, _controllerInspector.res
				should.exist _controllerInspector.renderedTemplate, "Should assign template"
				_controllerInspector.renderedTemplate.should.equal 'twiml/callevents', "Should render twilio/callevents template"







