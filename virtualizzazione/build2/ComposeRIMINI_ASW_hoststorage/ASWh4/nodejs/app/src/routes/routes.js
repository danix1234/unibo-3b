module.exports = function(app) {
	var controller = require('../controllers/controller');

	app.route('/')
		.get(controller.get_index)

	app.route('/submit')
		.post(controller.align_sequences);

	app.route('/show')
		.get(controller.get_all_align_sequences);


};
