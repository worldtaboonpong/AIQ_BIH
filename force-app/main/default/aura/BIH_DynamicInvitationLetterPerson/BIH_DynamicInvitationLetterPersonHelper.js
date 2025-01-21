({
	createObjectData: function (component, event) {
		// get the contactList from component and add(push) New Object to List

		var recordId = component.get("v.recordId");
		var RowItemList = component.get("v.personList");
		var PersonType = component.get("v.PersonType");
		RowItemList.push({
			'sobjectType': 'Invitation_Letter_Person__c',
			'Person_Name__c': '',
			'Passport_Number__c': '',
			'Appointment_Date__c': '',
			'Specialty__c': '',
			'Person_Type__c': PersonType,
			// 'Invitation_Letter__c': invitLetterObj.Id,
		});
		console.log('RowItemList :', RowItemList);

		// set the updated list to attribute (contactList) again   
		component.set("v.personList", RowItemList);
	}, 
	// helper function for check if first Name is not null/blank on save  
	// validateRequired: function (component, event) {
	// 	console.log('validate');
	// 	var RowItemListTemp = [];
	// 	var countTemp = 0;
	// 	var isValid = true;
	// 	var allCaseRows = component.get("v.caseList");
	// 	// console.log('-----');
	// 	// console.dir(allCaseRows);

	// 	for (var indexVar = 0; indexVar < allCaseRows.length; indexVar++) {
	// 		if (!(allCaseRows[indexVar].Full_Name__c == '' && allCaseRows[indexVar].HospitalNumber__c == '')) {
	// 			// allCaseRows.splice(indexVar, 1);
	// 			// console.log('::: '+indexVar+' :::');

	// 			RowItemListTemp[countTemp] = allCaseRows[indexVar];
	// 			countTemp++;
	// 		}
	// 	}
	// 	// console.log('--++--');
	// 	// console.dir(RowItemListTemp);
	// 	console.log('RowItemListTemp : ', allCaseRows);

	// 	component.set("v.caseList", RowItemListTemp);
	// 	// console.log('isValid : ', isValid);

	// 	return isValid;
	// },
	// hideModal: function (component, event, helper) {
	// 	component.set("v.ShowModule", false);
	// },
	// showModal: function (component, event, helper) {
	// 	component.set("v.ShowModule", true);
	// },
})