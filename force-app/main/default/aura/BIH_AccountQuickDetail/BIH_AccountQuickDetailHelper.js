({
	getListCase: function (component, event, helper) {
		// console.log("== getListCase ==");
		
		var action = component.get('c.getCaseByAccountId');
		var accId = component.get('v.accountId');
		var newcaseList = component.get('v.newcaseList');
		newcaseList = [];
		action.setParams({
			"accountId": accId,
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				// console.log('returnValues : ', returnValues);
				// console.log('returnValues : ', returnValues.length);
				if (returnValues.length > 0){
					for (var i = 0;i < returnValues.length;i++){
						if (returnValues[i].Status == 'New'){
							newcaseList.push(returnValues[i]);
						}
					}
					// console.log('returnValues[returnValues.length-1].Createddate : ', returnValues[returnValues.length - 1].CreatedDate);
					component.set('v.lastCaseDate', (returnValues[returnValues.length - 1].CreatedDate));
				}else{ 
					// component.set('v.lastCaseDate', '-');
					component.set('v.lastCaseDate', null);

				}
				console.log('v.newcaseList: ', newcaseList);
				
				component.set('v.caseList', returnValues);
				component.set('v.newcaseList', newcaseList);
				
			} else {
				var error = response.getError();
				console.log(error[0].message);
			}
			helper.stopSpinner(component);
		});
		$A.enqueueAction(action);
	},
	parseObj: function (objFields) {
		return JSON.parse(JSON.stringify(objFields));
	},
	startSpinner: function (component) {
		component.set('v.loading', true);
	},
	stopSpinner: function (component) {
		component.set('v.loading', false);
	},
	showContactCenterNote: function (component, event, helper){
		
		var action = component.get("c.showContactCenterNote");
		action.setCallback(this, function(data) {
			component.set("v.showContactCenterNote", data.getReturnValue());
			console.log("showContactCenterNote: ",component.get("v.showContactCenterNote"));
		});
		$A.enqueueAction(action);
	},
	getUserCurrent: function (component, event, helper){
		
		var action = component.get("c.getUserCurrent");
		action.setCallback(this, function(data) {
			component.set("v.userObj", data.getReturnValue());
			console.log("userObj: ",component.get("v.userObj"));
		});
		$A.enqueueAction(action);
	},

	getAccount: function (component, event, helper) {
		var action = component.get('c.getAccount');
		var accId = component.get('v.accountId');
		// console.log(accId);

		action.setParams({
			"accountId": accId,
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				// console.log('returnValues : ', returnValues);
				component.set('v.accountObj', returnValues);
				if(returnValues.Contact_Center_Flag__c == true){
					helper.showModal(component, event, helper);
					
				}

			} else {
				var error = response.getError();
				console.log(error[0].message);
			}
			helper.stopSpinner(component);
		});
		$A.enqueueAction(action);
	},
	hideModal: function (component, event, helper) {
		component.set("v.ShowModule", false);
		component.set('v.isFirstTime', false);
		
	},
	showModal: function (component, event, helper) {
        component.set("v.ShowModule", true);
    },
			// subscribe: function (component, event, helper) {
			// 	// Get the empApi component.
			// 	const empApi = component.find('empApi');
			// 	// Get the channel from the attribute.
			// 	const channel = component.get('v.channel');
			// 	// Subscription option to get only new events.
			// 	const replayId = -1;
			// 	// Callback function to be passed in the subscribe call.
			// 	// After an event is received, this callback prints the event
			// 	// payload to the console. A helper method displays the message
			// 	// in the console app.
			// 	const callback = function (message) {
			// 		console.log('Event Received : ' + JSON.stringify(message));
			// 		helper.refreshView(component, event, helper);
			// 		// var recordId = component.get("v.recordId");
			// 	};
			// 	// Subscribe to the channel and save the returned subscription object.
			// 	empApi.subscribe(channel, replayId, $A.getCallback(callback)).then($A.getCallback(function (newSubscription) {
			// 		console.log('Subscribed to channel ' + channel);
			// 		component.set('v.subscription', newSubscription);
			// 	}));
			// },
			// // Client-side function that invokes the unsubscribe method on the
			// // empApi component.
			// unsubscribe: function (component, event, helper) {
			// 	// Get the empApi component.
			// 	const empApi = component.find('empApi');
			// 	// Get the channel from the component attribute.
			// 	const channel = component.get('v.subscription').channel;
			// 	// Callback function to be passed in the unsubscribe call.
			// 	const callback = function (message) {
			// 		console.log('Unsubscribed from channel ' + message.channel);
			// 	};
			// 	// Unsubscribe from the channel using the subscription object.        
			// 	empApi.unsubscribe(component.get('v.subscription'), $A.getCallback(callback));
			// },
			// refreshView: function (component, event, helper) {
			// 	var recordId = component.get("v.recordId");
			// 	component.set('v.accountId', recordId);
			// 	console.log('Id : ' + recordId);
			// 	helper.getListCase(component, event, helper);
			// 	helper.getAccount(component, event, helper);
			// }
})