({
	getCaseInfo: function (component, event, helper){
		var recordId = component.get("v.recordId");
		var action = component.get("c.getCaseContactInformation");
		action.setParams({
			"caseId": recordId,
		});
		action.setCallback(this, function (response) {
			//console.log(response);

			var state = response.getState();
			//console.log(state);

			if (state === "SUCCESS") {
                var cmpEvent = $A.get('e.c:MinorEvent');//component.getEvent("minorEventRegister");
                cmpEvent.setParams({"message" : "Minor Check" });
                cmpEvent.fire();
                
				//console.log('--- CaseContact ---');
				var responseValue = response.getReturnValue();
				//console.log(responseValue);

				component.set("v.caseObj", responseValue.caseObj);
				component.set("v.userObj", responseValue.userObj);
				// console.log(component.get("v.caseObj"));
				component.set("v.caseId", response.getReturnValue().caseObj.Id);
				// console.log('--- end init CaseContact ---');

				var channel1 = responseValue.caseObj.Platform_Event_Channel__c;
				//alert(channel1);

				// if(channel1 == '1'){
				// 	channel1 = '';
				// }

				//channel1 = '';

				var cmp = component;

				//if(cmp.get('v.caseObj.Verified_Patient__c') === false){
					const empApi = cmp.find('empApi');

					// Uncomment below line to enable debug logging (optional)
					// empApi.setDebugFlag(true);
			
					// Register error listener and pass in the error handler function
					empApi.onError($A.getCallback(error => {
						// Error can be any type of error (subscribe, unsubscribe...)
						console.error('EMP API error: ', JSON.stringify(error));
						//alert('EMP API error: ', JSON.stringify(error));
					}));


					cmp.set("v.channel",channel1);
			
					
					// Get the channel from the input box
					const channel = '/event/Publish_Verify_Button'+channel1+'__e';
					// Replay option to get new events
					const replayId = -1;

					//alert(channel);
			
					// Subscribe to an event
					empApi.subscribe(channel, replayId, $A.getCallback(eventReceived => {
						// Process event (this is called each time we receive an event)
						//console.log('Received event ', JSON.stringify(eventReceived));

						//alert('PLATFORM EVENT RECEIVED!!! with CaseId: '+eventReceived.data.payload.Case_Id__c);
			
						// console.log(eventReceived.data.payload.Case_Id__c);
			
						// console.log(cmp.get('v.recordId'));
						if(eventReceived.data.payload.Case_Id__c === cmp.get('v.recordId')){
			
							
							helper.getCaseInfo(cmp, event, helper);
							cmp.set('v.caseObj.Verified_Patient__c',true);
						}
					}))
					.then(subscription => {
						// Subscription response received.
						// We haven't received an event yet.
						//console.log('Subscription request sent to: ', subscription.channel);
						// Save subscription to unsubscribe later
						cmp.set('v.subscription', subscription);
					});
				//}

				
			}
			else {
				console.log('--ERROR--');

			}
		});
		$A.enqueueAction(action); 
	},
	getCaseInfo222: function (component){
		var action3 = component.get("c.publishRequest");
		action3.setParams({
			"caseId": component.get("v.tmp"),
		});
		action3.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				
				
				
			}

		});
		$A.enqueueAction(action3);
	},
	helperMethod : function() {
	},
	hideModal: function (component, event, helper) {
		component.set("v.ShowModule", false);
	},
	showModal: function (component, event, helper) {
		component.set("v.ShowModule", true);
		// var showModule = component.get('v.ShowModule');
		// console.log(showModule);
		
	},
	startSpinner: function (component) {
		component.set('v.loading', true);
	},
	stopSpinner: function (component) {
		component.set('v.loading', false);
	},
	displayToast: function (component, type, message) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            type: type,
            message: message
        });
        toastEvent.fire();
    },
	refreshFocusedTab: function (component, event, helper) {
		// setTimeout(() => {
			var workspaceAPI = component.find("workspace");
			workspaceAPI.getFocusedTabInfo().then(function (response) {
				var focusedTabId = response.tabId;
				//console.log('focusedTabId :', focusedTabId);

				workspaceAPI.refreshTab({
					tabId: focusedTabId,
					includeAllSubtabs: true
				});
			}).catch(function (error) {
				console.log(error);
			});
		// }, 3000);
		
	},
	getNotefromAccount: function (component){
		//console.log("----START GETNOTE----");
		
		var action = component.get("c.getNotefromAccount");
		var caseObj = component.get("v.caseObj");
		var accId = caseObj.Patient__c;
		action.setParams({
			"accId": accId,
		});
		action.setCallback(this, function (response) {
			var returnValues = response.getReturnValue();
			//console.log("returnValues1 :", returnValues);
			
			if (returnValues.Note__c != null){
				component.set("v.accObj",returnValues);
				component.set("v.isError",true);
			}else {
				component.set("v.isError",false);
			}
			
		
		});
		$A.enqueueAction(action);
	
	}
})