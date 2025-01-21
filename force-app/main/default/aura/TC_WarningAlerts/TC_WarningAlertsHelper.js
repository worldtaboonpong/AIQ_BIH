({
	jsPatientDetails: function (component, event, helper) {
        var action = component.get("c.getPatientDetails");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS") {
                var finalRes = result.getReturnValue();
                component.set("v.patientAlerts", finalRes.IconPaths);
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
})