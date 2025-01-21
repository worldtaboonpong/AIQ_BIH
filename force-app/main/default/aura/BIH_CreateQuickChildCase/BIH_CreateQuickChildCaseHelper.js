({
    displayToast: function(component, type, message) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            type: type,
            message: message
        });
        toastEvent.fire();
    },

    openTabWithSubtab: function(component, event, helper, caseId) {
        console.log('caseId:', caseId);
        var focusedTabId;
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            focusedTabId = response.tabId;
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: focusedTabId,
                url: '/lightning/r/Case/' + caseId + '/view',
                focus: false
            });
        }).catch(function(error) {
            console.log(error);
        });
    }
})