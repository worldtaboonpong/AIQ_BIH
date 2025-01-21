({
	init: function (cmp, event, helper) {

		
		
		cmp.set('v.columns', [
			{ label: 'Hospital Number', fieldName: 'hn', type: 'text' },
			{ label: 'Account name', fieldName: 'fullName', type: 'text' },
			{ label: 'Date of Birth', fieldName: 'dateOfBirth', type: 'date' },
			{ label: 'Gender', fieldName: 'gender', type: 'string'},
			{ label: 'firstname-hidden', fieldName: 'firstName', type: 'string' },
			{ label: 'lastname-hidden', fieldName: 'lastName', type: 'string' },
			{ label: 'title-hidden', fieldName: 'title', type: 'string' },
			{ label: 'email-hidden', fieldName: 'email', type: 'string' },
			{ label: 'mobilePhone-hidden', fieldName: 'mobilePhone', type: 'string' },
			{ label: 'homePhone-hidden', fieldName: 'homePhone', type: 'string' },
			{ label: 'sex-hidden', fieldName: 'sex', type: 'integer' },
			
			{ label: '', type: 'button', 
						typeAttributes: { 
							label: 'Confirm', 
							name: 'Confirm', 
							title: 'Confirm' 
						}
			},
		]);
		
		var fullName = cmp.get("v.fullName");
		// console.log(fullName);
		var dateOfBirth = cmp.get("v.dateOfBirth");
		// console.log(dateOfBirth);
		
		if (fullName != null && fullName != undefined){
			var tmpFullName = fullName.split(" ");
			// console.log(tmpFullName);
			if (tmpFullName[0] == '-'){
				cmp.set("v.lastName", tmpFullName[1]);
			}else {
				cmp.set("v.firstName", tmpFullName[0]);
				cmp.set("v.lastName", tmpFullName[1]);
			}
		}
		
		var hnNumber = cmp.get("v.hnNumber");
		var dateOfBirth = cmp.get("v.dateOfBirth");
		var firstName = cmp.get("v.firstName");
		var lastName = cmp.get("v.lastName");
		var gender = cmp.get("v.gender");
		// if (hnNumber != undefined)
		
		if ((hnNumber != undefined && hnNumber != '') ||
			(dateOfBirth != undefined && dateOfBirth != '') ||
			(firstName != undefined && firstName != '') ||
			(lastName != undefined && lastName != '') ||
			(gender != undefined && gender != '')) {
			helper.getAccountByHN(cmp, event, helper);

		}else{
			console.log('no data for searching');
			cmp.set("v.hasInfoForSearch", true);
		}
		// var fetchData = {
		// 	opportunityName: "company.companyName",
		// 	accountName: "name.findName",
		// 	closeDate: "date.future",
		// 	amount: "finance.amount",
		// 	contact: "internet.email",
		// 	phone: "phone.phoneNumber",
		// 	website: "internet.url",
		// 	status: { type: "helpers.randomize", values: ['Pending', 'Approved', 'Complete', 'Closed'] },
		// 	actionLabel: { type: "helpers.randomize", values: ['Approve', 'Complete', 'Close', 'Closed'] },
		// 	confidenceDeltaIcon: { type: "helpers.randomize", values: ['utility:up', 'utility:down'] }
		// };


		// helper.fetchData(cmp, fetchData, 10);

		

	},
	handleRowAction: function (cmp, event, helper) {
		var action = event.getParam('action');
		var row = event.getParam('row');
		switch (action.name) {
			case 'Confirm':
				helper.showRowDetails(cmp, helper,row);
				break;
		}
	}
	,
	onSearch: function (component, event, helper) {
		var hnNumber = component.get("v.hnNumber");
		var dateOfBirth = component.get("v.dateOfBirth");
		var firstName = component.get("v.firstName");
		var lastName = component.get("v.lastName");
		var gender = component.get("v.gender");
		// if (hnNumber != undefined)
		// console.log(hnNumber);
		// console.log(dateOfBirth);
		// console.log(firstName);
		// console.log(lastName);
		// console.log(gender);
		
		if ((hnNumber != undefined && hnNumber != '')||
			(dateOfBirth != undefined && dateOfBirth != '')||
			(firstName != undefined && firstName != '') ||
			(lastName != undefined && lastName != '') ||
			(gender != undefined && gender != '' )) 
		{
			console.log('click - true');
			component.set("v.hasInfoForSearch", false);
			helper.getAccountByHN(component, event, helper);

		} else {
			console.log('click - false');
			
			component.set("v.hasInfoForSearch", true);
		}
	},
	onClear: function (component, event, helper) {
		component.set("v.hnNumber",'');
		component.set("v.dateOfBirth",'');
		component.set("v.firstName",'');
		component.set("v.lastName",'');
		component.set("v.gender",'');
	}
	
})