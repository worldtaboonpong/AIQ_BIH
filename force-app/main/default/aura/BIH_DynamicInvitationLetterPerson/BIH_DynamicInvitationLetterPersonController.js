({

	// function call on component Load
	doInit: function (component, event, helper) {

		// var recordId = component.get("v.recordId");
		// var action = component.get("c.find_CaseById");
		// action.setParams({ "get_caseid": recordId });

		// action.setCallback(this, function (data) {
		// 	component.set("v.ParentCase", data.getReturnValue());
		helper.createObjectData(component, event);
		// });
		// $A.enqueueAction(action);

		// create a Default RowItem [Contact Instance] on first time Component Load
		// by call this helper function  

	},
	// function for create new object Row in Case List 
	addNewRow: function (component, event, helper) {
		console.log('AddNewRowEvt');
		var RowItemList = component.get("v.personList");
		if (RowItemList.length < 5) {

		// call the comman "createObjectData" helper method for add new Object Row to List  
			helper.createObjectData(component, event);
		}
	},
	// function for delete the row 
	removeDeletedRow: function (component, event, helper) {
		// get the selected row Index for delete, from Lightning Event Attribute  
		var index = event.getParam("indexVar");
		console.log('index :' + index);

		// get the all List (caseList attribute) and remove the Object Element Using splice method    
		var AllRowsList = component.get("v.personList");
		var deleteList = component.get("v.personListForDelete");
		var tmpItem = AllRowsList[index];
		deleteList.push(tmpItem);
		AllRowsList.splice(index, 1);
		// set the caseList after remove selected row element  
		component.set("v.personList", AllRowsList);
		component.set("v.personListForDelete", deleteList);
		console.log('---- delete ----');
		
		if (tmpItem.Id != null && tmpItem.Id != undefined ){
			var deleteListlog = component.get("v.personListForDelete");
			console.log(JSON.parse(JSON.stringify(deleteListlog)));
		}
		
		
	},
})