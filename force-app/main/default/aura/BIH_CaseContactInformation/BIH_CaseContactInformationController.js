({
	doInit : function(cmp, event, helper) {
		setTimeout(() => {
            //alert();
			helper.getCaseInfo(cmp, event, helper);
		}, 1);

		helper.startSpinner(cmp);
		var action = cmp.get("c.getBtnConfig");
		
		
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				if(response.getReturnValue()==='New' || response.getReturnValue()==='new' || response.getReturnValue()==='NEW'){
					cmp.set("v.isNew", true);
				}else{
					cmp.set("v.isNew", false);
				}
				
				
			}
			helper.stopSpinner(cmp);

		});
		$A.enqueueAction(action);

		helper.startSpinner(cmp);
		var action2 = cmp.get("c.getPDVSEndpoint");
		
		
		action2.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				

				cmp.set("v.pdvsEndpoint", response.getReturnValue());
				
				
			}
			helper.stopSpinner(cmp);

		});
		$A.enqueueAction(action2);

		helper.startSpinner(cmp);
		var action3 = cmp.get("c.getUserName");
		
		
		action3.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				

				cmp.set("v.userName", response.getReturnValue());

				cmp.set("v.userName2", response.getReturnValue().split('@')[0]);
				
				//console.log('POM: '+response.getReturnValue().split('@')[0]);
				
			}
			helper.stopSpinner(cmp);

		});
		$A.enqueueAction(action3);


		helper.startSpinner(cmp);
		var action4 = cmp.get("c.getSessionId");
		
		
		action4.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				

				cmp.set("v.sessionId", response.getReturnValue());
				
				
			}
			helper.stopSpinner(cmp);

		});
		$A.enqueueAction(action4);

		helper.startSpinner(cmp);
		var action5 = cmp.get("c.getClientId");
		action5.setParams({
			"caseId": cmp.get("v.recordId"),
		});
		
		action5.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {

				
				
				if(response.getReturnValue() === null){
					cmp.set("v.clientId","");
				}else{
					cmp.set("v.clientId", response.getReturnValue());
				}
				
				
			}
			helper.stopSpinner(cmp);

		});
		$A.enqueueAction(action5);

		

	},
	onSearchPDVS: function(component, event, helper){
		var dt = new Date().getTime();
    	var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        	var r = (dt + Math.random()*16)%16 | 0;
        	dt = Math.floor(dt/16);
        	return (c=='x' ? r :(r&0x3|0x8)).toString(16);
    	});
		// component.set("v.hnNumber", caseObj.Hospital_Number_HN__c);
		// component.set("v.dateOfBirth", caseObj.Date_of_Birth__c);
		// component.set("v.fullName", caseObj.Full_Name__c);
		// component.set("v.gender", caseObj.Gender__c);
     

		var hnNumber = component.get("v.caseObj.Hospital_Number_HN__c");

		if (typeof(hnNumber) == "undefined"){
			hnNumber = "";
		}

		var dateOfBirth = component.get("v.caseObj.Date_of_Birth__c");

		if (typeof(dateOfBirth) == "undefined"){
			dateOfBirth = "";
		}

		
		var fullName = component.get("v.caseObj.Full_Name__c");

		

		var firstName;
		var lastName;
		if (typeof(fullName) == "undefined"){
			firstName = "";
			lastName = "";
		}else{
			firstName = fullName.split(' ')[0];
			lastName = fullName.split(' ')[1];
		}

		if(typeof(firstName)=="undefined"){
			firstName = "";
		}
		if(typeof(lastName)=="undefined"){
			lastName = "";
		}

		var gender = component.get("v.caseObj.Gender__c");
		if(typeof(gender)=="undefined"){
			gender = "";
		}

		if (typeof(hnNumber) == "undefined"){
			hnNumber = "";
		}

		if(gender === "Male"){
			gender = 'male';
		}else if(gender === "Female"){
			gender = 'female';
		}else{
			gender = '';
		}

		var dateOfBirthString = '';

		var date = new Date(dateOfBirth);
		if (!isNaN(date.getTime())) {
			var day = date.getDate().toString();
			var month = (date.getMonth() + 1).toString();
			// Months use 0 index.

			dateOfBirthString = (day[1] ? day : '0' + day[0]) + '/' +
			(month[1] ? month : '0' + month[0]) + '/' + 
			date.getFullYear();
		}

		// var action = component.get("c.publishRequest");
		// action.setParams({
		// 	"caseId": JSON.stringify({
		// 		"search_patient": { 
		// 	"hn" 			: hnNumber,
		// 	"first_name" 	: firstName,
		// 	"last_name" 	: lastName,
		// 	"sex" 			: gender,
		// 	"date_of_birth" : dateOfBirthString,
		// 	"case_id" : component.get("v.recordId"),
		// 	"case_no" : component.get("v.caseObj.CaseNumber"),
		// 	"client_id" : component.get("v.clientId")
		// 	},
		// 		"request_session"	: component.get("v.sessionId"),
		// 		"username"			: component.get("v.userName")
		// 	}),
		// });
		// action.setCallback(this, function (response) {
		// 	var state = response.getState();
		// 	if (state === "SUCCESS") {
				
				
				
		// 	}

		// });
		// $A.enqueueAction(action);
		// 
		//alert("v.sessionId >> "+component.get("v.sessionId"));
		//alert("v.userName >> "+component.get("v.userName"));

		helper.startSpinner(component);
		$.ajax({url: component.get("v.pdvsEndpoint"), method: "post",headers: {
			'Content-Type'		:'application/json',
			'X-Service-Name'	:'auth-search_varify',
			'X-Request-UUID'	: uuid,
			'X-ProxyUser-Ip'	:'203.0.113.19',
			'API_KEY'			:'3a7c7be3125d4ea0a0ae665ed92cdc99'
		},dataType:"json",data:JSON.stringify({
						"search_patient": { 
					"hn" 			: hnNumber,
					"first_name" 	: firstName,
					"last_name" 	: lastName,
					"sex" 			: gender,
					"date_of_birth" : dateOfBirthString,
					"case_id" : component.get("v.recordId"),
					"case_no" : component.get("v.caseObj.CaseNumber"),
					"client_id" : component.get("v.clientId")
					},
						"request_session"	: component.get("v.sessionId"),
						"username"			: component.get("v.userName")
					})
		,
			success: function(result){
            	helper.stopSpinner(component);


				component.set("v.tmp",JSON.stringify(result));

				helper.getCaseInfo222(component);

				if(result.status){


					component.set("v.tmp",result.data.redirect_url);

					//helper.getCaseInfo222(component);

            		window.open(result.data.redirect_url,'_blank');
				}else{
					helper.displayToast(component, "Error", result.status_code + ' ' + result.status_message);
				} 
                
                //$A.get('e.force:refreshView').fire();
                var cmpEvent = $A.get('e.c:MinorEvent');//component.getEvent("minorEventRegister");
                cmpEvent.setParams({"message" : "Minor Check" });
                cmpEvent.fire();
          	},
			error: function( jqXhr, textStatus, errorThrown ){

				component.set("v.tmp","ERROR");

				//helper.getCaseInfo222(component);
				
				//helper.displayToast(component, "Error", 'Cannot connect to PDVS!');
				var cmpEvent = $A.get('e.c:MinorEvent');//component.getEvent("minorEventRegister");
                cmpEvent.setParams({"message" : "Minor Check" });
                cmpEvent.fire();
				//alert('Cannot connect to PDVS!');
				helper.stopSpinner(component);                
			}
                
		});
	},
	onTestBtn: function (component, event, helper) {
		helper.refreshFocusedTab(component, event, helper);
	},
	changeState: function changeState(component) {
		component.set('v.isexpanded', !component.get('v.isexpanded'));
	},
	hideModal: function (component, event, helper) {
		helper.hideModal(component, event, helper);
	},
	showModal: function (component, event, helper) {
		var caseObj = component.get("v.caseObj");
		//console.log('Case obj:',caseObj);
		if (caseObj == null){
			helper.showModal(component, event, helper);
		}else{
		component.set("v.hnNumber", caseObj.Hospital_Number_HN__c);
		component.set("v.dateOfBirth", caseObj.Date_of_Birth__c);
		component.set("v.fullName", caseObj.Full_Name__c);
		component.set("v.gender", caseObj.Gender__c);
		helper.showModal(component, event, helper);
		}
	},

	accountEvt: function (component, event, helper) {
		// console.log('accountEvt');
		helper.hideModal(component, event, helper);
		// var LastIndex = component.get("v.rowIndexLastPick");
		var accObj = event.getParam("account");
		// console.log('accountObj',JSON.parse(JSON.stringify(accObj)));


		var caseObj = component.get("v.caseObj");
		caseObj.Hospital_Number_HN__c = accObj.Hospital_Number_HN__c;
		caseObj.Full_Name__c = accObj.Name;
		caseObj.Date_of_Birth__c = accObj.PersonBirthdate;
		caseObj.Patient__c = accObj.Id;
		caseObj.Patient_Email__c = accObj.PersonEmail;
		caseObj.Verified_Patient__c = true;
		caseObj.Gender__c = accObj.Gender__c;
		caseObj.Phone__c = accObj.Phone;
		caseObj.Nationality__c = accObj.Nationality__c;
		caseObj.Country_of_Residence__c = accObj.Country_of_Residence__c;
		// caseObj.Email__c = accObj.PersonEmail;
		// console.log('caseObj:', caseObj);
		
		component.set("v.caseObj", caseObj);
		var action = component.get("c.saveCase");
		action.setParams({
			"caseObj": component.get("v.caseObj"),
		});
		helper.startSpinner(component);
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resValue = response.getReturnValue();
			
			if (state === "SUCCESS") {
				
				component.set("v.caseObj", resValue);
				// console.log(resValue);
				
				// $A.get('e.force:refreshView').fire();
				// // 
				// setTimeout(() => {
				// 	helper.stopSpinner(component);
				// 	helper.refreshFocusedTab(component, event, helper);
				// }, 500);
				// setTimeout(() => {
				helper.stopSpinner(component);
				// 	// console.log('1500');
					
					helper.refreshFocusedTab(component, event, helper);
				// }, 1500);
			}else{
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						// console.log("Error message: " +
						//     errors[0].message);
						helper.displayToast(component, "Error", errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
				component.set("v.caseObj", resValue);

				helper.stopSpinner(component);
			}
		});
		$A.enqueueAction(action); 
		// component.set('v.patientNameValue', accObj);
		helper.getNotefromAccount(component);
	},
})