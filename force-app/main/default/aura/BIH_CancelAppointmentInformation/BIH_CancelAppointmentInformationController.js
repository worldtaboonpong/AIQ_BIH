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
				//console.log('state: ',state);
				
				if (state === "SUCCESS") {
					// console.log('----');
					
					// console.log(JSON.stringify(response.getReturnValue()));
					var caseObj = response.getReturnValue();
					component.set("v.caseObj", caseObj);
					// if (caseObj.Cancellation_Appointment__c == true){
					// 	console.log('WHAT');
					// 	component.set('v.isCancel',true);
					// }
					//console.log('v.CASEOBJ:',response.getReturnValue());
					
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
	changeState2: function changeState(component) {
		component.set('v.isexpanded2', !component.get('v.isexpanded2'));
	},
})