({
	getAccountByHN: function (component,event,helper) {
		helper.startSpinner(component);
		var hnNumber = component.get("v.hnNumber");
		var dateOfBirth = component.get("v.dateOfBirth");
		var firstName = component.get("v.firstName");
		var lastName = component.get("v.lastName");
		var gender = component.get("v.gender");
		var action = component.get("c.getAccountByHN");
		action.setParams({
			"hnNumber": hnNumber,
			"Firstname": firstName,
			"Lastname": lastName,
			"Email": '',
			"DateOfBirth": dateOfBirth,
			"Gender": gender,
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			
			if (state === "SUCCESS") {
				// console.log('--- verify ---');
				// console.log(JSON.stringify(response.getReturnValue()));
				if (response.getReturnValue().ErrorMessage != undefined){
					component.set("v.isErrorMessage", true);
				}else{
					component.set("v.data", response.getReturnValue().patientList);
					// console.log('data : ', JSON.parse(JSON.stringify(component.get("v.data"))));
					component.set("v.isErrorMessage", false);
				}
				// console.log('--- End verify ---');
			}
			helper.stopSpinner(component);
		});
		$A.enqueueAction(action);
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
	showRowDetails: function (component, helper,row ) {
		console.log(JSON.parse(JSON.stringify(row)));
		
		helper.startSpinner(component);
		var action = component.get("c.verifyAccountByHN");
		var infoObj = {
			'hn': row.hn,
			'fullName': row.fullName,
			'dateOfBirth': row.dateOfBirth,
			'gender': row.gender,
			'firstName': row.firstName,
			'lastName': row.lastName,
			'title': row.title,
			'email': row.email,
			'mobilePhone': row.mobilePhone,
			'homePhone': row.homePhone,
			'sex': row.sex,
			
		}
		action.setParams({
			"infoObj": infoObj,
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				// console.log('test');
				
				// console.log(JSON.stringify(response.getReturnValue()));
				component.getEvent("accountEvt").setParams({ "account": response.getReturnValue() }).fire();
				// var mockData = [{ "Id": "", "Name": "Dakota Aldridge", "PersonBirthdate": "1973-03-11", "Hospital_Number_HN__c": "102402644", "Gender__c": "Male" },
				// 	{ "Id": "", "Name": "Dakota Najera", "Hospital_Number_HN__c": "100526347", "PersonBirthdate": "1989-01-18", "Gender__c": "Male"},
				// 	{ "Id": "", "Name": "Dakota  Hla Hla", "Hospital_Number_HN__c": "100513251", "PersonBirthdate": "1991-07-26", "Gender__c": "Female" }];
				// component.set("v.data", response.getReturnValue());
				// minColumnWidth
				// response.getReturnValue().forEach(function (item, index) {
				// 	console.dir(item.doctorName);

				// });


				// helper.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
			}
			helper.stopSpinner(component);

		});
		$A.enqueueAction(action);
		// console.log('row :', row);
		
	
		// console.log('accObj :', accObj);
		
		// // eslint-disable-next-line no-alert
		// component.getEvent("verifyRowEvt").setParams({ "indexVar": "1" }).fire();
		// alert("Showing opportunity");
	},

	
})