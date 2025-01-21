({
    closeFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
			var focusedTabId = response.tabId;
			console.log('response',response);
			console.log('workspaceAPI',workspaceAPI);
			console.log('focusedTabId',focusedTabId);
			// var focusedTabId2 = response.subtabs[0].tabId;
			var length = response.subtabs;
			console.log('length',length);
			
			// console.log('focusedTabId2',focusedTabId2);
			
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})