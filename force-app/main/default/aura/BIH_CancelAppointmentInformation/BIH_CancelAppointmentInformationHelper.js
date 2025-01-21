({
	
	startSpinner: function (component) {
		component.set('v.loading', true);
	},
	stopSpinner: function (component) {
		component.set('v.loading', false);
	}
})