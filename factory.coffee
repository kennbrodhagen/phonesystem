class TestStore
	constructor: (@calls) ->
	findAllCalls: (callback) ->
		callback null, @calls

class Factory
	createLogWithNameAndStreams: (name,streams) =>
		Logger = require("bunyan")
		log = new Logger(
			name: name
			streams: streams
			serializers:
				req: Logger.stdSerializers.req
				res: Logger.stdSerializers.res
		)
		return log	

	createProductionLog: () =>
		name = "phonesystem-prod"
		streams = [
			{stream: process.stdout, level: "debug"}
			{path: "#{name}.log", level: "info"}]

		log = @createLogWithNameAndStreams(name,streams)
		return log	

	createTestLog: () =>
		name = "phonesystem-test"
		streams = [{path: "#{name}.log", level: "debug"}]

		log = @createLogWithNameAndStreams(name,streams)
		return log	

	createProductionStore: () =>
		return @createTestStore()

	createTestStore: (todos) =>
		return new TestStore(todos)


module.exports = new Factory()
