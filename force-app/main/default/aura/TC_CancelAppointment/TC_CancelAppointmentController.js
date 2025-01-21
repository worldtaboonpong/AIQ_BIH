({
	doOk: function(component, event, helper) {
        helper.jsOk(component, event, helper);
    },
    
    doCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})