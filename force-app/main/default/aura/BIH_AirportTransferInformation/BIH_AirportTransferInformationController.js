({
    init : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getWrapperInfo");
        helper.startSpinner(component);
        action.setParams({
            "caseId": recordId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('--- CaseContact ---');
                var responseValue = response.getReturnValue();
                component.set("v.caseObj", responseValue.caseObj);
                var checkintime =  responseValue.caseObj.Check_In_Time__c;
                var checkouttime =  responseValue.caseObj.Check_Out_Time__c;
                
                component.set('v.checkInTime', responseValue.checkInTime);
                component.set('v.checkOutTime', responseValue.checkOutTime);
                


            }
            helper.stopSpinner(component);
        });
        $A.enqueueAction(action); 
    },
    hideModal: function (component, event, helper) {
        helper.hideModal(component, event, helper);
    },
    showModal: function (component, event, helper) {
        helper.showModal(component, event, helper);
    },
})