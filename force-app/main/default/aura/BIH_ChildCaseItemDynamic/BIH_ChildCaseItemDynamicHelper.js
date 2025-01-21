({
	getLeadSourcePicklistValue : function(component) {
        var plist = component.get('c.getPickListValuesChannel');
		plist.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				// console.log(returnValues);
				
				component.set('v.channel', returnValues);			
				
			} else {
				var error = response.getError();
				console.log(error[0].message);
			}
		});
		$A.enqueueAction(plist);
    }
})