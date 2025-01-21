({
	startSpinner: function (component) {
        component.set('v.loading', true);
    },
    stopSpinner: function (component) {
        component.set('v.loading', false);
    },
    getLeadSourcePicklistValue : function(component) {
        var plist = component.get('c.getPickListValuesLeadSource');
		plist.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				component.set('v.lead_source', returnValues);			

			} else {
				var error = response.getError();
				console.log(error[0].message);
			}
		});
		$A.enqueueAction(plist);
    },
    displayToast: function (component, type, message) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            type: type,
            message: message
        });
        toastEvent.fire();
    }
})