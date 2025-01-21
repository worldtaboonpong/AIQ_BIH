({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        console.log("mRecordId: ", recordId);
        
        var action = component.get("c.getPersonAccountRecord");
        action.setParams({ "mRecordId": recordId});
        
        action.setCallback(this, function (response) {
            var returnValues = response.getReturnValue();
            var mName = returnValues.Name;
            console.log('returnValues :',returnValues)
            console.log('name :',mName)
        });
        $A.enqueueAction(action);
	},
	hideModal: function (component, event, helper) {
		helper.hideModal(component, event, helper);
	},
	showModal: function (component, event, helper) {
		helper.showModal(component, event, helper);
	},
	onRefresh: function (component, event, helper) {
		helper.refreshFocusedTab(component, event, helper);
	},
    navigateToGeneratePDF: function (component, event, helper) 
    {
        console.log('start pdf');
        
        var workspaceAPI = component.find("workspace");
        console.log('workspaceAPI==',workspaceAPI);
        var navService = component.find("navService");
        console.log('navService==',navService);
        
        var pageReference = {
            type: "standard__component",
            attributes: {
                componentName: "c:AppointmentCard",
            },
            state: {
                c__selectedCase: component.get("v.recordId"),
            }
        };   
        workspaceAPI.isConsoleNavigation().then(function (isConsole) {
            if (isConsole) {
                console.log('******************* if');
                // console.log('isConsole :' + isConsole);
                
                //  // in a console app - generate a URL and then open a subtab of the currently focused parent tab
                navService.generateUrl(pageReference).then(function (cmpURL) {
                    // console.log('cmpURL :' + cmpURL);
                    workspaceAPI.getEnclosingTabId().then(function (tabId) {
                        return workspaceAPI.openSubtab({
                            parentTabId: tabId,
                            url: cmpURL,
                            focus: true
                        });
                    }).then(function (subTabId) {
                        // the subtab has been created, use the Id to set the label
                        workspaceAPI.setTabLabel({
                            tabId: subTabId,
                            label: "Edit Invitation Letter"
                        });
                        workspaceAPI.setTabIcon({
                            tabId: subTabId,
                            icon: "utility:note",
                            iconAlt: "new note"
                        });
                    });
                });
            } else {
                navService.navigate(pageReference, false);
            }
        })
        .catch(function (error) {
            console.log(error);
        });
    }
})