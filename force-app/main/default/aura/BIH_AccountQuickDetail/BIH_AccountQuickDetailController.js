({
	doInit: function (component, event, helper) {
		// Get empApi component.
		// component.set('v.subscription', null);
		// const empApi = component.find('empApi');
		// const errorHandler = function (message) {};
		// empApi.onError($A.getCallback(errorHandler));
		// helper.subscribe(component, event, helper);
		// Get empApi component.
 
		helper.startSpinner(component);
		var recordId = component.get("v.recordId");
		component.set('v.accountId', recordId);
		
		// console.log('Id : ' + recordId);
		helper.getListCase(component, event, helper);
		helper.getAccount(component, event, helper);
		helper.showContactCenterNote(component, event, helper);
		helper.getUserCurrent(component, event, helper);

	},
	
	onTabUpdated: function (component, event, helper) {

		var recordId = component.get("v.recordId");
		component.set('v.accountId', recordId);
		helper.getListCase(component, event, helper);
		helper.getAccount(component, event, helper);
		
		// var updatedTabId = event.getParam("tabId");
		// console.log("Tab Updated : ", updatedTabId);

	},
	// onTabRefreshed: function (component, event, helper) {

	// 	var recordId = component.get("v.recordId");
	// 	component.set('v.accountId', recordId);
	// 	helper.getListCase(component, event, helper);
	// 	helper.getAccount(component, event, helper);

	// 	// var updatedTabId = event.getParam("tabId");
	// 	// console.log("Tab Refreshed : ", updatedTabId);

	// },
	// onTabCreated: function (component, event, helper) {

	// 	var recordId = component.get("v.recordId");
	// 	component.set('v.accountId', recordId);
	// 	helper.getListCase(component, event, helper);
	// 	helper.getAccount(component, event, helper);

	// 	var updatedTabId = event.getParam("tabId");
	// 	console.log("Tab Created : ", updatedTabId);

	// },
	showModal : function (component, event, helper) {
		helper.showModal(component, event, helper);
	},
	hideModal : function (component, event, helper) {
		helper.hideModal(component, event, helper);
	}


})