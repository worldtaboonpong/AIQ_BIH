({

	// function call on component Load
	doInit: function (component, event, helper) {
 
        var recordId = component.get("v.recordId");
        var action = component.get("c.find_CaseById");
		action.setParams({ "get_caseid": recordId});
        
        action.setCallback(this, function(data) {
			component.set("v.ParentCase", data.getReturnValue());
			console.log('PARENTCASE',data.getReturnValue().Case_Detail__c);
			
			helper.createObjectData(component, event);
			
        });
        $A.enqueueAction(action);
		helper.getLeadSourcePicklistValue(component);
		helper.getChildcase(component);
		helper.getOwnerType(component);
		helper.getRecordType(component);
		// console.log('ownerMap: ',component.get('v.ownerMap'));
		// console.log('recordtypeMap: ',component.get('v.recordtypeMap'));
		
		// create a Default RowItem [Contact Instance] on first time Component Load
		// by call this helper function  
		
	},

	// function for save the Records 
	Save: function (component, event, helper) {
		// first call the helper function in if block which will return true or false.
		// this helper function check the "first Name" will not be blank on each row.
		var caseTmp = component.get("v.caseList");
		var childCaseMaps = component.get("v.childCaseMap");
		var recordTypeMaps = component.get("v.recordtypeMap");
		var ownerMaps = component.get("v.ownerMap");
		var parentCase = component.get("v.ParentCase");
		
		if (helper.validateRequired(component, event)) {
			
			// call the apex class method for save the Contact List
			// with pass the case List attribute to method param.  
			
			// console.log('ownerMaps',ownerMaps);
			// console.log('recordTypeMaps',recordTypeMaps);
			
			// console.log('childCaseMapeieie:', childCaseMaps);
			// console.log('recordTypeMaps: ',recordTypeMaps);
			// console.log('ownerMaps: ',ownerMaps);
			console.log(caseTmp);

			
			// caseTmp.forEach(element => {
				
			// });
			caseTmp.forEach(element => {
				console.log('element',element);
				// console.log(childCaseMaps.has(element.Channel__c));
				var channelName = element.Channel__c;
				console.log('channelName: ',channelName);
				if (channelName == parentCase.Channel__c){
					console.log('Check1');
					
					element.RecordTypeId = parentCase.RecordTypeId;
					element.OwnerId = parentCase.OwnerId;
				}
				else
				{
					// console.log('Check2');
					if (childCaseMaps.hasOwnProperty(channelName)){
					console.log('-----VALIDATE CHANNEL-----');
					var recordType = childCaseMaps[channelName].Record_Type_Name__c;
					// var ownerType = childCaseMaps[channelName].Owner_Type__c;
					var queueName = childCaseMaps[channelName].Queue_Name__c;
					// console.log('----START----');
					console.log('recordType: ',recordType);
					console.log('queueName: ',queueName);
					// console.log('ownerMaps',ownerMaps);
					// console.log('recordTypeMaps',recordTypeMaps);
					
					
					
					if (ownerMaps.hasOwnProperty(queueName)){
						console.log('Check3');

						element.OwnerId = ownerMaps[queueName].Id;
						console.log('----OWNER FINISH----');
					}else {
						console.log('Error Check3');
						
					}
					
					if (recordTypeMaps.hasOwnProperty(recordType)){
						console.log('Check4');

						element.RecordTypeId = recordTypeMaps[recordType].Id;
						console.log('----RECORD FINISH----');
					}else {
						console.log('Error Check4');

					}
					
				}
			}
			element.Full_Name__c = element.FirstNameTmp + ' ' + element.LastNameTmp;
			delete element['FirstNameTmp'];
			delete element['LastNameTmp'];

			console.log('Child Case: ',element);
			console.log('-----finish-----');
			// console.log('element finish');
				
		});
			// console.log(caseTmp);
			component.set("v.caseList", caseTmp);
			var action = component.get("c.saveCases");
			
			action.setParams({
				"ListCase": component.get("v.caseList")
			});
			// set call back 
			helper.startSpinner(component);
			action.setCallback(this, function (response) {
				var state = response.getState();
				console.log("test state:",state);
				
				if (state === "SUCCESS") {
					// if response if success then reset/blank the 'caseList' Attribute 
					// and call the common helper method for create a default Object Data to Case List 
					component.set("v.caseList", []);

					helper.createObjectData(component, event);
					//alert('Save Completed.');
					helper.displayToast(component, "Success", "Created related case successfully");
                    $A.get('e.force:refreshView').fire();
				}else if (state === "ERROR"){
				var errors = response.getError();
					if (errors) {
						console.log('error');

						if (errors[0] && errors[0].message) {
							console.log('error default');

							// console.log("Error message: " +
							// 	errors[0].message);
							console.log(helper.parseObj(errors));

							console.log("Error message: " +
								errors[0].message);
							var errorMsg = errors[0].message;
							var tmpIndex_1 = errorMsg.indexOf(",");
							var tmpIndex_2 = errorMsg.indexOf(":", tmpIndex_1);
							errorMsg = errorMsg.substring(tmpIndex_1 + 1, tmpIndex_2);
							helper.displayToast(component, "Error", errorMsg);
						}
					} else {
						console.log("Unknown error");
					}
				}
				helper.stopSpinner(component);
			});
			// enqueue the server side action  
			$A.enqueueAction(action);
			$A.get("e.force:refreshView").fire();
		}
	},

	// function for create new object Row in Case List 
	addNewRow: function (component, event, helper) {
		// console.log('AddNewRowEvt');
		
		// call the comman "createObjectData" helper method for add new Object Row to List  
		helper.createObjectData(component, event);
	},
	verifyRowEvt: function (component, event, helper) {
		// console.log('verifyRowEvt');
		var index = event.getParam("indexVar");
		var caseList = component.get("v.caseList");
		// console.log(index);
		// console.log(caseList);
		// console.log('caseList[index]: ',caseList[index]);
		// console.log('caseList[index].FirstNameTmp: ',caseList[index].FirstNameTmp);
		// console.log('caseList[index].LastNameTmp: ', caseList[index].LastNameTmp);
		component.set("v.hnNumber", caseList[index].Hospital_Number_HN__c);
		// component.set("v.dateOfBirth", caseList[0].Date_Of_Birth__c);
		if (caseList[index].FirstNameTmp != '' && caseList[index].LastNameTmp != ''){
			var tmpfullname = caseList[index].FirstNameTmp + ' ' + caseList[index].LastNameTmp;
			component.set("v.fullName", tmpfullname); 
		}else if (caseList[index].FirstNameTmp != '' && caseList[index].LastNameTmp == ''){
			var tmpfullname = caseList[index].FirstNameTmp;
			component.set("v.fullName", tmpfullname); 
		}else if (caseList[index].FirstNameTmp == '' && caseList[index].LastNameTmp != ''){
			var tmpfullname = '-' + ' '+ caseList[index].LastNameTmp;
			component.set("v.fullName", tmpfullname); 
		}else if (caseList[index].FirstNameTmp == '' && caseList[index].LastNameTmp == ''){
			var tmpfullname = '';
			component.set("v.fullName", tmpfullname);
		}
		// console.log("v.fullName", component.get("v.fullName"));
		
		component.set("v.rowIndexLastPick", index);
		// component.set("v.gender", caseList[0].Gender__c);
		
		
		helper.showModal(component, event, helper);
		// // call the comman "createObjectData" helper method for add new Object Row to List  
		// helper.createObjectData(component, event);
	},
	hideModal: function (component, event, helper) {
		helper.hideModal(component, event, helper);
	},
	// function for delete the row 
	removeDeletedRow: function (component, event, helper) {
		// get the selected row Index for delete, from Lightning Event Attribute  
		var index = event.getParam("indexVar");
		// console.log('index :' + index);
		
		// get the all List (caseList attribute) and remove the Object Element Using splice method    
		var AllRowsList = component.get("v.caseList");
		AllRowsList.splice(index, 1);
		// set the caseList after remove selected row element  
		component.set("v.caseList", AllRowsList);
	},
	accountEvt: function (component, event, helper) {
		// console.log('accountEvt');
		helper.hideModal(component, event, helper);
		var LastIndex = component.get("v.rowIndexLastPick");
		var accObj = event.getParam("account");
		// console.log(JSON.parse(JSON.stringify(accObj)));

		
		var caseList = component.get("v.caseList");
		caseList[LastIndex].Hospital_Number_HN__c = accObj.Hospital_Number_HN__c;
		var tmpFullName = accObj.Name.split(" ");
		// console.log(tmpFullName);
		// cmp.set("v.firstName", tmpFullName[0]);
		// cmp.set("v.lastName", tmpFullName[1]);
		
		caseList[LastIndex].FirstNameTmp = tmpFullName[0];
		caseList[LastIndex].LastNameTmp = tmpFullName[1];
		// caseList[LastIndex].Full_Name__c = accObj.Name;
		// caseList[LastIndex].Verified_Patient__c = true;
		caseList[LastIndex].Full_Name__c = accObj.Name;
		caseList[LastIndex].Date_of_Birth__c = accObj.PersonBirthdate;
		caseList[LastIndex].Patient__c = accObj.Id;
		caseList[LastIndex].Patient_Email__c = accObj.PersonEmail;
		caseList[LastIndex].Verified_Patient__c = true;
		caseList[LastIndex].Gender__c = accObj.Gender__c;
		caseList[LastIndex].Phone__c = accObj.Phone;
		caseList[LastIndex].Nationality__c = accObj.Nationality__c;
		caseList[LastIndex].Country_of_Residence__c = accObj.Country_of_Residence__c;

		component.set("v.caseList", caseList);
	},
	
		
	
})