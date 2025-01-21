({
	jsOk : function(component, event, helper) {
        var appointmentVar = component.get("v.appointment");
        if (appointmentVar.Reason_for_Cancellation__c == null) {
            helper.showToast("Cancel Appointment", "Please select Reason for Cancellation", "error");
        } else {
            var action = component.get("c.cancelAppointments");
            action.setParams({
                "appId": component.get("v.recordId"),
                "appDetail": appointmentVar
            });
            action.setCallback(this, function (result) {
                var responseString = result.getReturnValue();
                if(!responseString.includes('Error')) {
                    helper.showToast("Cancel Appointment", responseString, "success");
                } else {
                    helper.showToast("Cancel Appointment", responseString, "error");
                }
                $A.get("e.force:closeQuickAction").fire();
            });
            $A.enqueueAction(action);
        }
    },
    
    showToast : function(title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
})