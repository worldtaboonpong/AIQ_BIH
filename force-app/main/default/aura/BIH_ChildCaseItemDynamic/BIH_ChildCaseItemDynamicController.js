({

	// function call on component Load
	doInit: function (component, event, helper) {
		// helper.getLeadSourcePicklistValue(component, event);
		var caseInstance = component.get("v.CaseInstance") || {};
        caseInstance.Id = component.get("v.recordId");
        component.set("v.CaseInstance", caseInstance);
        //var caseId2 = component.get("v.recordId");
		//console.log('Case IDtoon222:', caseId2);
		
        component.set("v.CaseInstance.HNTmp", "");
        component.set("v.CaseInstance.FirstNameTmp", "");
        component.set("v.CaseInstance.LastNameTmp", "");
        component.set("v.CaseInstance.Channel__c", "");
        component.set("v.CaseInstance.Verified_Patient__c", "");
        
		var caseId = component.get("v.refid");
        console.log('***************caseId:', caseId);
        
        // call action
        // 
        // 
        var caseId = component.get("v.refid");
            
            console.log('Case IDtoon222:', caseId); // Check if caseId is being set correctly
            
            
            var action = component.get("c.getPatientDetails");
            action.setParams({ caseId: caseId });

            action.setCallback(this, function(response) {
                var state = response.getState();

                if (state === "SUCCESS") {

                    var patientDetails = response.getReturnValue();
                    console.log('Patient Details:', patientDetails); // Log patient details
                    
                   
                    component.set("v.CaseInstance", patientDetails);
                    component.set("v.isShow", patientDetails.Verified_Patient__c==="true" ? true : false);
                    console.log('**v.isShow**', patientDetails.Verified_Patient__c==="true" ? true : false);
                    console.log('test77');
                } else {
                    console.error("Failed to retrieve patient details: " + response.getError());
                }
            });
            $A.enqueueAction(action);
            
        
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
     handleSamePatientChange : function(component, event, helper){
        helper.handleSamePatientChange(component, event, helper);
    }

})