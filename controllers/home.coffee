class HomeController
	constructor: (@app) ->

	index: (req, res) =>
		res.render 'home-index', { title: 'Site Name' }

module.exports = HomeController
