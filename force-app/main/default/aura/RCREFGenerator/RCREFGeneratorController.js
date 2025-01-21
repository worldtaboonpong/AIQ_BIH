({
    handleClick: function(component, event, helper) {
        component.set("v.isLoading", true); // Show spinner

        // Get the recordId from the component
        let recordId = component.get("v.recordId");

        // Call Apex method
        let action = component.get("c.generateRcRef");
        action.setParams({ caseId: recordId });

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                // Set the RCREF__c value in the attribute
                component.set("v.rcRef", response.getReturnValue());
                component.set("v.isLoading", false);
                
                // Show success message
                helper.showToast("Success", "New RCREF__c value generated", "success");
            } else {
                // Handle errors and show error message
                helper.showToast("Error", "Failed to generate RCREF__c", "error");
                component.set("v.isLoading", false);
            }
        });
        
        $A.enqueueAction(action);
    }
})