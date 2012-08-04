libxmljs			= require "libxmljs"
request				= require "request"
should				= require "should"


# Test the main page navigation
describe 'Page Navigation', ->
	app = null

	# Helper for the root uri to be used in various functions
	uriRoot = () ->
		"http://localhost:#{app.server.settings.port}/"

	# Start and stop the web server on the boundaries of this test suite.
	before (done) ->
		factory = require "../factory"
		App = require "../app"
		testCalls = [{id: 1, start:"1976-08-18 21:00:00.000-04", duration:180, callingParty:"6789826238"}, {id: 2, start:"1970-08-20 00:00:00.000-04", duration:180, callingParty:"7709928775"}]
		app = new App factory.createTestLog(), factory.createTestStore(testCalls)
		app.server.listen app.server.settings.port, () ->
			app.log.info "Test server listening on port #{app.server.settings.port} in #{app.server.settings.env} mode"
			done()

	after (done) ->
		app.log.info "Test server shutting down."
		app.server.close()
		app = null
		done()


	# Helper method to make a request, confirm it was successful, and parse the body
	_requestConfirmAndParse = (uri, callback) ->
			#app.log.info "*** REQUESTING URI: #{uri}"
			request.get {uri:uri}, (err, response, body) ->
				_confirmRequestStatusAndParse err, response, body, callback


	# Helper method to confirm a response was successful
	# Parses and save the body as an html dom object.
	# It's nice to provide the additional description argument since these functions are called from many places.
	_confirmRequestStatusAndParse = (expectedStatus, err, response, body, callback) ->
		should.not.exist err, "Request returned an error: #{JSON.stringify(err)}."
		should.exist  response, "Response is null."
		response.should.have.status expectedStatus, "Response did not return expected status."
		should.exist body, "Body is null."
		bodyDoc = libxmljs.parseHtmlString body
		should.exist bodyDoc, "Body parsed into null document."
		#app.log.info "*** REQUEST SUCCESSFUL.  \n*** RESPONSE:\n"
		#app.log.info "*** REQUEST SUCCESSFUL.  \n*** BODY:\n #{JSON.stringify(body)}\n"
		#app.log.info "*** REQUEST SUCCESSFUL.  \n*** BODYDOC:\n #{JSON.stringify(bodyDoc)}\n"
		callback(bodyDoc)

	# Helper method returns true if the xpath has at least one node containing text value text
	_containsTextUnderElement = (text, bodyDoc, xpath) ->
		elementsMatchingXpath = bodyDoc.find(xpath)
		should.exist elementsMatchingXpath, "Document find(#{xpath}) returned null."
		#app.log.info "\n *** text = #{text} xpath = #{xpath}"
		elementsMatchingXpath.length.should.be.greaterThan 0, "XPath #{xpath} did not match any elements."
		for element in elementsMatchingXpath
			#app.log.info "\n *** element = \n#{JSON.stringify(element)} \n *** element.text = \n#{element.text()}\n "
			if element.text() is text 
				return true
		return false

	# returns the text of the first element matching the xpath.
	# does a bunch of extra asserst along the way to help you debug when it doesn't find what you want
	_textOfElement = (bodyDoc, xpath) ->
		elementsMatchingXpath = bodyDoc.find(xpath)
		should.exist elementsMatchingXpath, "Document find() returned null."
		elementsMatchingXpath.length.should.be.greaterThan 0, "XPath #{xpath} did not match any elements."
		should.exist elementsMatchingXpath[0].text, "First element matching xpath #{xpath} does not have text property."
		textMatchingXmlpath = elementsMatchingXpath[0].text()
		should.exist textMatchingXmlpath, "Text method of matching element to xpath #{xpath} returned null."
		return textMatchingXmlpath

	# Tests for the various page navigation
	describe 'View the root page /', ->

		it "Should redirect to the home page for more Google juice", (done) ->
			request.get {uri:"#{uriRoot()}", followRedirect:false}, (err, response, body) ->
				_confirmRequestStatusAndParse 302, err, response, body, () ->
					done()

	describe 'View the home page /home', ->

		it "Should have should have the site name in the title", (done) ->
			#app.log.info "\n\n*** BODYDOC:\n #{JSON.stringify(_bodyDoc)}\n\n"
			request.get {uri:"#{uriRoot()}home"}, (err, response, body) ->
				_confirmRequestStatusAndParse 200, err, response, body, (bodyDoc) ->
					_textOfElement(bodyDoc, '//head/title').should.match /Site Name/
					done()

		it "Should have a link to the todo list", (done) ->
			request.get {uri:"#{uriRoot()}home"}, (err, response, body) ->
				_confirmRequestStatusAndParse 200, err, response, body, (bodyDoc) ->
					_textOfElement(bodyDoc, "//a[@id='todos-index' and @href='/todos']").should.match /Todos/
					done()

	describe "View the calls page /calls", ->
		_bodyDoc = null

		before (done) ->
			request.get {uri:"#{uriRoot()}calls"}, (err, response, body) ->
				_confirmRequestStatusAndParse 200, err, response, body, (bodyDoc) ->	
					_bodyDoc = bodyDoc	
					done()	

		it "should have calls in the title", ->
			_textOfElement(_bodyDoc, "//head/title").should.match /Calls/i

		it "should have a grid of calls", ->
			listItems = _bodyDoc.find("//section[@id='callsGrid']")
			should.exist listItems
			listItems.length.should.be.greaterThan 0, "failed to find nodes matching xpath"

		it "should have a calls with the calling party 6789826238", ->
			_containsTextUnderElement("6789826238", _bodyDoc, "//td").should.equal true, "test number not shown"

describe "Handle new inbound call", ->


