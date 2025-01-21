({

	// function call on component Load
	doInit: function (component, event, helper) {
		// helper.getLeadSourcePicklistValue(component, event);

	},

	AddNewRow: function (component, event, helper) {
		// fire the AddNewRowEvt Lightning Event 
		
		component.getEvent("AddRowEvt").fire();
	},

	removeRow: function (component, event, helper) {
		// fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
		// console.log('rowindex :',component.get("v.rowIndex"));
		
		component.getEvent("DeleteRowEvt").setParams({ "indexVar": component.get("v.rowIndex") }).fire();
	},
	verifyRow: function (component, event, helper) {
		// fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
		// console.log('rowindex :', component.get("v.rowIndex"));

		component.getEvent("verifyRowEvt").setParams({ "indexVar": component.get("v.rowIndex") }).fire();
	},

})