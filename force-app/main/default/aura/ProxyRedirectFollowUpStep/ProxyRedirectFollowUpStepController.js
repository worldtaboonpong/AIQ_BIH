({
	onInit : function(component, event, helper) {
		var recordId;
		var followupService = component.find("followupService");
		
		// var recordTypeId;
		
		var pageRef = JSON.parse(JSON.stringify(component.get("v.pageReference").state));
		var recordId = pageRef.c__recordId;
		console.log('recordId',recordId);
		
        console.log('State ',JSON.parse(JSON.stringify(component.get("v.pageReference").state)));
        // console.log('State ',JSON.parse(JSON.stringify(component.get("v.pageReference").state.recordTypeId == undefined)));
		var action = component.get('c.getTopLevelFollowUp');
		action.setParams({
			"caseId": recordId
		});
		action.setCallback(this, function (response){
			var state = response.getState();
			console.log('STATE: ',state);
			if (state === 'SUCCESS'){
				var returnValues = response.getReturnValue();
				console.log('returnValues',returnValues);
				var createFollowUpStepEvent = $A.get("e.force:createRecord");
				createFollowUpStepEvent.setParams({
    				"entityApiName": "Follow_Up_Step__c",
					"defaultFieldValues": {'Step__c' : returnValues.defaultLevel,'Case__c': recordId},
				});
				helper.closeFocusedTab(component, event, helper);
				setTimeout(() => {
					createFollowUpStepEvent.fire();
				}, 100);

				// var pageReference = {    
				// 	"type": "standard__objectPage",
				// 	"attributes": {
				// 		"objectApiName": "Follow_Up_Step__c",
				// 		"actionName": "new"
				// 	},
				// 	"defaultFieldValues": {'Step__c' : returnValues.defaultLevel,'Case__c': recordId}
				// 	"state": {
				// 		"Case__c": recordId,
				// 		"Step__c": returnValues.defaultLevel
				//   }
		
				// component.set("v.pageReference",pageReference);
				// console.log(component.get("v.pageReference"));
				
				// var defaultUrl = "#";
        		// followupService.navigate(pageReference);
            		// .then($A.getCallback(function(url) {
                	// component.set("v.url", url ? url : defaultUrl);
            		// }), $A.getCallback(function(error) {
					// component.set("v.url", defaultUrl);
					// console.log(component.get('v.url'));
					
				// }));
			}else if (state ==='ERROR'){
					var errors = response.getError();
					console.log(errors);
			}
		});
        $A.enqueueAction(action);
		
	}
})