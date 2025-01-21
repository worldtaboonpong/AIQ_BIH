({
    getLeadSourcePicklistValue : function(component) {
        var plist = component.get('c.getPickListValuesChannel');
        plist.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValues = response.getReturnValue();
                component.set('v.channel', returnValues);            
            } else {
                var error = response.getError();
                console.log(error[0].message);
            }
        });
        $A.enqueueAction(plist);
    },
    handleSamePatientChange: function(component, event, helper) {
        var isChecked = component.get("v.samePatient");
        var isshow = component.get("v.isShow");
        if (isChecked&&isshow) {
            
            var vCaseInstance = component.get("v.CaseInstance");
            component.set("v.CaseInstance.HNTmp", vCaseInstance.Hospital_Number_HN__c);
            component.set("v.CaseInstance.FirstNameTmp", vCaseInstance.FirstName);
            component.set("v.CaseInstance.LastNameTmp", vCaseInstance.LastName);
            component.set("v.CaseInstance.Channel__c", vCaseInstance.Channel__c);
            component.set("v.CaseInstance.Verified_Patient__c", vCaseInstance.Verified_Patient__c);
            
            //var caseId = component.get("v.CaseInstance.Id");
            //var caseId = component.get("v.recordId");
            
        } else {
            component.set("v.CaseInstance.HNTmp", '');
            component.set("v.CaseInstance.FirstNameTmp", '');
            component.set("v.CaseInstance.LastNameTmp", '');
            component.set("v.CaseInstance.Channel__c", '');
            component.set("v.CaseInstance.Verified_Patient__c", '');
        }
    }
})