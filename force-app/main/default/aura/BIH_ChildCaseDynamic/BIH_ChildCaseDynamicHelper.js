({
	createObjectData: function (component, event) {
		// get the contactList from component and add(push) New Object to List

		var recordId = component.get("v.recordId");
		var RowItemList = component.get("v.caseList");
		var parentCase = component.get("v.ParentCase");
		console.log("parentCase: ",parentCase);
		RowItemList.push({
			'sobjectType': 'Case',
			'Hospital_Number_HN__c': '',
			'Full_Name__c': '',
			'ParentId': recordId,
			'AccountId': parentCase.AccountId,
			'SuppliedEmail': parentCase.SuppliedEmail,
			'Subject': parentCase.Subject,
			'Status': parentCase.Status,
			'Close_Case_Reason__c': parentCase.Close_Case_Reason__c,
			'Pending_Person__c': parentCase.Pending_Person__c,
			'Pending_Reason__c': parentCase.Pending_Reason__c,
			'Description': parentCase.Description,
			'Case_Category_Level1__c': parentCase.Case_Category_Level1__c,
			'Case_Category_Level2__c': parentCase.Case_Category_Level2__c,
			'Case_Category_Level3__c': parentCase.Case_Category_Level3__c,
			'Channel__c': parentCase.Channel__c,
			'Case_Detail__c': parentCase.Case_Detail__c,
			'Origin': parentCase.Origin,
			'Priority': parentCase.Priority,
			'RecordTypeId':parentCase.RecordTypeId,
			'Caller_Name__c': parentCase.Caller_Name__c,
			'Contact_Number__c': parentCase.Contact_Number__c,
			'Contact_Center_Channel__c': parentCase.Contact_Center_Channel__c,
			// 'Escalate_to__c':parentCase.Escalate_to__c,			
			// 'Escalate_Date__c':parentCase.Escalate_Date__c,			
			'Service_Detail__c':parentCase.Service_Detail__c,			
			// 'Case_Solution__c':parentCase.Case_Solution__c,			
			'Building__c':parentCase.Building__c,			
			'Doctor_Name__c':parentCase.Doctor_Name__c,			
			'Patient_s_Room_Department__c':parentCase.Patient_s_Room_Department__c,			
			'IV_Team_Name__c':parentCase.IV_Team_Name__c,			
			'Symptoms_Diseases__c':parentCase.Symptoms_Diseases__c,			
			'Contact_Center_Source__c':parentCase.Contact_Center_Source__c,			
			'Contact_Center_Attendee__c':parentCase.Contact_Center_Attendee__c,			
			'Department__c':parentCase.Department__c,			
			'Specialty_Doctor__c':parentCase.Specialty_Doctor__c,			
			'Doctor__c':parentCase.Doctor__c,			
			'Interpreter_Language__c':parentCase.Interpreter_Language__c,			
			'Type_of_SMS__c':parentCase.Type_of_SMS__c,			
			'Medical_Procedure__c':parentCase.Medical_Procedure__c,			
			'Contact_Center_Other_Source__c':parentCase.Contact_Center_Other_Source__c,			
			'Contact_Center_Follower__c':parentCase.Contact_Center_Follower__c,			
			'Postpone_Date__c':parentCase.Postpone_Date__c,			
			'Not_App_Reason__c':parentCase.Not_App_Reason__c,			
			'App_Date__c':parentCase.App_Date__c,			
			'App_Date_Liaison__c':parentCase.App_Date_Liaison__c,			
			'App_Time_Status__c':parentCase.App_Time_Status__c,			
			'App_Time__c':parentCase.App_Time__c,	
			'FirstNameTmp' : '',
			'LastNameTmp': '',
			'Add_field_Info_1__c': parentCase.Add_field_Info_1__c,
			'Add_field_Info_2__c': parentCase.Add_field_Info_2__c,
			'Add_field_Info_3__c': parentCase.Add_field_Info_3__c,
			'Add_field_Info_4__c': parentCase.Add_field_Info_4__c,
			'Add_field_Info_5__c': parentCase.Add_field_Info_5__c,
			'Add_field_Info_6__c': parentCase.Add_field_Info_6__c,
			'Add_field_Info_7__c': parentCase.Add_field_Info_7__c,
			'Add_field_Info_8__c': parentCase.Add_field_Info_8__c,
			'Add_field_Info_9__c': parentCase.Add_field_Info_9__c,
			'Add_field_Info_10__c': parentCase.Add_field_Info_10__c,
			'Add_field_Info_11__c': parentCase.Add_field_Info_11__c,
			'Add_field_Info_12__c': parentCase.Add_field_Info_12__c,
			'Add_field_Info_13__c': parentCase.Add_field_Info_13__c,
            'Dynamic_Group__c':parentCase.Dynamic_Group__c,
            'Messagebird_Q_Clinic__c':parentCase.Messagebird_Q_Clinic__c,
            'Case_From_MB__c':parentCase.Case_From_MB__c,
            'MessageBird_Link__c': parentCase.MessageBird_Link__c,
            'MessageBird_Agent__c':parentCase.MessageBird_Agent__c,
            'MessageBird_Ticket_ID__c':parentCase.MessageBird_Ticket_ID__c,
			// 'Verified_Patient__c':parentCase.Verified_Patient__c
		});
		// console.log('RowItemList :',RowItemList);
		
		// set the updated list to attribute (contactList) again   
		component.set("v.caseList", RowItemList);
		// console.log("RowItemList: ",component.get("v.caseList"));
		
	}, 
	// helper function for check if first Name is not null/blank on save  
	validateRequired: function (component, event) {
		// console.log('validate');
		var RowItemListTemp = [];
		var countTemp = 0;
		var isValid = true;
		var allCaseRows = component.get("v.caseList");
		// console.log('-----');
		// console.dir(allCaseRows);
		// console.log(allCaseRows);
		
		for (var indexVar = 0; indexVar < allCaseRows.length; indexVar++) {
			if (!(allCaseRows[indexVar].FristNameTmp == '' && allCaseRows[indexVar].LastNameTmp == '' && allCaseRows[indexVar].Hospital_Number_HN__c == '')) {
				// allCaseRows.splice(indexVar, 1);
				// console.log('::: '+indexVar+' :::');
				
				RowItemListTemp[countTemp] = allCaseRows[indexVar];
				countTemp++;
            }
		}
		// console.log('--++--');
		// console.dir(RowItemListTemp);
		// console.log('RowItemListTemp : ', allCaseRows);
		
		component.set("v.caseList", RowItemListTemp);
		// console.log('isValid : ', isValid);
		
		return isValid;
	},
	hideModal: function (component, event, helper) {
		component.set("v.ShowModule", false);
	},
	showModal: function (component, event, helper) {
		component.set("v.ShowModule", true);
	},
	displayToast: function (component, type, message) {
		var toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({
			type: type,
			message: message
		});
		toastEvent.fire();
	},
	startSpinner: function (component) {
		// console.log('-- start --');
		component.set('v.loading', true);
	},
	stopSpinner: function (component) {
		// console.log('-- stop --');
		component.set('v.loading', false);
	},
	getLeadSourcePicklistValue : function(component) {
		var plist = component.get('c.getPickListValuesChannel');
		plist.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				// console.log(returnValues);
				
				component.set('v.picklistTmp', returnValues);			
				// console.log('picklistTmp', component.get('v.picklistTmp'));
			} else {
				var error = response.getError();
				console.log(error[0].message);
			}
		});
		$A.enqueueAction(plist);
	},
	getChildcase : function (component){
		var action = component.get("c.mapDataChildcase");
		// action.setParams({});
		// set call back 
		action.setCallback(this, function (response) {
			// var state = response.getState();
			var returnValues = response.getReturnValue();
			component.set('v.childCaseMap', returnValues);
			console.log("childCaseMap: ",component.get('v.childCaseMap'));
		});
		// enqueue the server side action  
		$A.enqueueAction(action);
	
	},
	getOwnerType : function (component){
		var action = component.get("c.ownerMap");
		// var owner = component.get("v.ownerTypeName");
		// action.setParams({
		// 	"ownerName":owner,
		// });
		// set call back 
		action.setCallback(this, function (response) {
			// var state = response.getState();
			var returnValues = response.getReturnValue();
			component.set('v.ownerMap',returnValues);
			console.log("ownerMap: ",component.get('v.ownerMap'));

		});
		// enqueue the server side action  
		$A.enqueueAction(action);
		
		
	},
	getRecordType : function (component){
		var action = component.get("c.recordTypeMap");
		// var record = component.get("v.recordTypeName");

		// action.setParams({
		// 	"recordName":record
		// });
		// set call back 
		action.setCallback(this, function (response) {
			// var state = response.getState();
			var returnValues = response.getReturnValue();
			component.set('v.recordtypeMap',returnValues);
			console.log("recordtypeMap: ",component.get('v.recordtypeMap'));
		});
		// enqueue the server side action  
		$A.enqueueAction(action);
		
	},
	parseObj: function (objFields) {
        return JSON.parse(JSON.stringify(objFields));
    },
})