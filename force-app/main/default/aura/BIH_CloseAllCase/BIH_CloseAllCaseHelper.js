({
	getChildCase : function(component) {
        var recordId = component.get("v.selectedCase");
		var action = component.get('c.getAllChildCase');
		action.setParams({
			"caseId": recordId,
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
					
                returnValues.forEach(function(record){
                    record['URL'] = '/lightning/r/Case/' + record['Id'] + '/view';
                    
                   if (record['Owner']) record.OwnerId = record.Owner.Name;
                });

                component.set('v.closeCaseList', returnValues);
			} else {
				var error = response.getError();
				console.log(error[0].message);
			}
		});
		$A.enqueueAction(action);
    },

 getCloseCaseReason : function(component) {
		var selectedRecordTypeId = component.get("v.selectedRecordTypeId");
		var plist = component.get('c.getPickListValuesCloseCaseReason');
		try {
			var SessionId = component.get("v.SessionId");
			console.log("SessionId: ",SessionId);
		}catch (ex){
			console.log(ex);
			
		}
		// console.log('recordId'+recordId);
		plist.setParams({
			"objectType": "Case",
			"recordTypeId": selectedRecordTypeId,
			"fieldName": "Close_Case_Reason__c",
		});
		plist.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				component.set('v.close_case_reasonPickList', returnValues);
				var FollowUpStep = component.get('v.FollowUpStep');
				setTimeout(function() {
					console.log('CC?:',component.get('v.isCC'));
					
					if (component.get('v.isCC')){
						console.log('isCC');
						console.log('FollowUpStep',FollowUpStep);
						
						var caseObj = component.get('v.case');
						if (FollowUpStep.Step__c == 'Call 3' && (FollowUpStep.Step_Status__c == 'Success' || FollowUpStep.Step_Status__c == 'Unsuccess')){
							caseObj.Close_Case_Reason__c = 'Send Back to Clinic';
						}else{
							caseObj.Close_Case_Reason__c = 'Completed by myself';
						}
						component.set('v.case',caseObj);
					}
				}, 10);	
			} else {
				var error = response.getError();
				console.log(error[0].message);
			}
		});
		$A.enqueueAction(plist);
		
	},
	getFollowUpStep: function (component, event, helper) {
		var action = component.get('c.getFollowUpStep');
		var recordId = component.get("v.selectedCase");
		
		action.setParams({
			caseId : recordId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				component.set('v.FollowUpStep', returnValues);
				
			} else if (state ==='ERROR'){
				var error = response.getError();
				console.log(error[0].message);
			}
		});
		$A.enqueueAction(action);
	},
    displayToast: function (component, type, message) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            type: type,
            message: message
        });
        toastEvent.fire();
	},
	startSpinner: function (component){
        component.set("v.loading",true);
    },
    stopSpinner: function (component){
        component.set("v.loading",false);
	},
	parseObj: function (objFields) {
        return JSON.parse(JSON.stringify(objFields));
	},
	getCC: function(component, event, helper){
		var action = component.get('c.getisCC');
        var recordId = component.get("v.selectedCase");
		action.setParams({
			"recordId": recordId,
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				component.set('v.isCC', returnValues);	
				// console.log('isCC: ', returnValues);
				
			} else {
				var error = response.getError();
				console.log(error[0].message);
			}
		});
		$A.enqueueAction(action);
	}
	
})