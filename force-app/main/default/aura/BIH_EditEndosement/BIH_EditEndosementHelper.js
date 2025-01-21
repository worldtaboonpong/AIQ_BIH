({
    onInIt: function (component, event, helper) {
        // ////console.log('--- EDIT CASE ---');
   
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            workspaceAPI.getTabInfo({
                tabId: response.parentTabId
            }).then(function (res) {
                var recordCaseId = res.recordId;
                component.set('v.recordId',res.recordId);
                var param = Math.floor((Math.random() * 10000) + 1);
				helper.getWrapper(component, event, helper, recordCaseId, param);
            });
        }).catch(function (error) {
            ////console.log(error);
        });
    },

    getWrapper: function (component, event, helper, recordCaseId, param) {
        var actionPromise = new Promise(function (resolve, reject) {
            var action = component.get('c.getcaseforendosement');
            action.setParams({
                "caseId" :recordCaseId,
                "param": param
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();
                    component.set('v.Endosement',res.caseEndosememt.ME_Endorsement__c);
                    component.set('v.caseObj',res.caseEndosememt);
                    component.set('v.recordId',res.caseIdendosememt);
                    component.set('v.recordTypeId',res.recordtypeEndosement);

                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            // ////console.log("Error message: " +
                            //     errors[0].message);
                            helper.displayToast(component, "Error", errors[0].message);
                        }
                    } else {
                        ////console.log("Unknown error");
                    }
                    // reject(Error('Invalid value: Task Object'))
                }
            });
            ////console.log('~~~~~~~~GetPIcklisValue wrapper called~~~~~~~~~~~~~~~');
            $A.enqueueAction(action);

        });
        
    },
    displayToast: function (component, type, message) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            type: type,
            message: message
        });
        toastEvent.fire();
    },
    
    onsaveEndosement: function (component, event, helper) {
        
        component.set('v.caseObj.ME_Endorsement__c',component.get('v.Endosement'));
          var action = component.get("c.UpdateCaseRecordEndosement");
			action.setParams({
				"caseObj": component.get('v.caseObj')
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				//console.log('state on save :' ,state);
				
				if (state === "SUCCESS") {
					var getReturnValue = response.getReturnValue();
                    if(getReturnValue){
                        helper.displayToast(component, "Success", "This case is saved");
                    }
                    else{
                        helper.displayToast(component, "Warning", "Save Failed");
                    }
                    $A.get('e.force:refreshView').fire();
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							var errorMsg = errors[0].message;
							var tmpIndex_1 = errorMsg.indexOf(",");
							var tmpIndex_2 = errorMsg.indexOf(":", tmpIndex_1);
							errorMsg = errorMsg.substring(tmpIndex_1 + 1, tmpIndex_2);
							helper.displayToast(component, "Error", errorMsg);
						}
					} else {
						//console.log("Unknown error");
					}
				}
				
				//helper.stopSpinner(component);
			});
			$A.enqueueAction(action);
    },
    
     closeFocusedTab: function (component, event, helper) {
         $A.get('e.force:refreshView').fire();
       /* var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            var focusedTabId = response.tabId;
            $A.get('e.force:refreshView').fire();
            workspaceAPI.closeTab({ tabId: focusedTabId });
        })
            .catch(function (error) {
                ////console.log(error);
            });*/
    },
  
})