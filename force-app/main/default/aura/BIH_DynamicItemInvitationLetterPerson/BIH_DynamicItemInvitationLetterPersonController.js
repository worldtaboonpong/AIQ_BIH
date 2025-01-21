({
	AddNewRow: function (component, event, helper) {
		// fire the AddNewRowEvt Lightning Event 

		component.getEvent("AddRowEvt").fire();
	},

	removeRow: function (component, event, helper) {
		// fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
		console.log('rowindex :', component.get("v.rowIndex"));

		component.getEvent("DeleteRowEvt").setParams({ "indexVar": component.get("v.rowIndex") }).fire();
	},
	onChange: function (component, event, helper) {
		var selected = component.find("SpecialtySelect").get("v.value");
		
		component.set("v.PersonInstance.Specialty__c", selected);
		
		
		//do something else
	}
})