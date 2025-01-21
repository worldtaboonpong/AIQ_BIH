({
	init: function (component, event, helper) {
		// console.log(JSON.parse(JSON.stringify(component.get('v.caseObj'))));
		if (component.get('v.caseObj') == null || component.get('v.caseObj') == undefined){
			helper.startSpinner(component);
			var recordId = component.get("v.recordId");
			var action = component.get("c.getCaseInformation");
			action.setParams({
				"caseId": recordId,
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					// console.log('----');
					
					// console.log(JSON.stringify(response.getReturnValue()));

					component.set("v.caseObj", response.getReturnValue());
					// console.log(response.getReturnValue());
					
					// response.getReturnValue().forEach(function (item, index) {
					// 	console.dir(item.doctorName);

					// });
					helper.stopSpinner(component);

					// helper.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
				}
				// helper.stopSpinner(component);
			});
			$A.enqueueAction(action);
		}


	},
	changeState: function changeState(component) {
		component.set('v.isexpanded', !component.get('v.isexpanded'));
	},
})