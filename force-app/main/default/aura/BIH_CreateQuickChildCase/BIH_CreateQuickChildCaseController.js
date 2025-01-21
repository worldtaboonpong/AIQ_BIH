({
    init: function(component, event, helper) {
        console.log("Component Initialized");
        var recordId = component.get("v.recordId");
        console.log('recordId:', recordId);

        var action = component.get("c.getUserProfile");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var output = response.getReturnValue();
                console.log('User info:', output);
                if (output.User_Team__c == undefined) {
                    output.User_Team__c = '';
                }
                if (output.User_Team__c.includes("Individual") || output.User_Team__c.includes("Referral")|| output.User_Team__c.includes("Contact Center") || output.User_Team__c.includes("BH Phuket") || output.Profile.Name == 'System Administrator') {
                    console.log("User is authorized to create a case");
                } else {
                    helper.displayToast(component, "Error", 'You do not have permission to use quick child case function');
                    $A.get("e.force:closeQuickAction").fire();
                }
            } else {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.log(errors[0].message);
                    helper.displayToast(component, "Error", errors[0].message);
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    handleClick: function(component, event, helper) {
        console.log("Button Clicked");
        // Implement the logic to create a quick case
        var recordId = component.get("v.recordId");
        var action = component.get('c.createQuickCase');
        action.setParams({
            "recordId": recordId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var customLabel = $A.get("$Label.c.Create_Quick_Case_Successfully");
            if (state === "SUCCESS") {
                var caseId = response.getReturnValue().Id;
                console.log('Case created successfully with ID:', caseId);
                helper.openTabWithSubtab(component, event, helper, caseId);
                helper.displayToast(component, 'success', customLabel);
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
                //window.location.reload();
            } else {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.log(errors[0].message);
                    helper.displayToast(component, "Error", errors[0].message);
                } else {
                    console.log("Unknown error");
                }
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    }
})