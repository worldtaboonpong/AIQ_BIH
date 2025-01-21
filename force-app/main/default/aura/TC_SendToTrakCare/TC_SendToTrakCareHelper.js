({
    jsInit: function (component, event, helper) {
        let recordId = component.get('v.recordId');
        
        let action = component.get("c.sendToTrakCare");
        action.setParam('recordId', recordId);
        action.setCallback(this, function(response) {
            let returnValue = response.getReturnValue();
            if (returnValue.includes('Error')) {
                helper.showToast("Send To Trak Care", returnValue, "error");
            } else {
                helper.showToast("Send To Trak Care", returnValue, "success");
            }
            
            $A.get('e.force:refreshView').fire();
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
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