({
	setFocusedTabLabel : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "New Follow Up Step"
            });
        })
        .catch(function(error) {
            console.log(error);
        });
	},
	setFocusedTabIcon : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
				icon: "action:call",
				size: "small",
                iconAlt: "New Follow Up Step"
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
	getStep : function(component, event, helper) {
		var action = component.get('c.getPickListValuesIntoList');
		action.setParams({
			objectType : 'Follow_Up_Step__c',
			selectedField : 'Step__c'
		});
		action.setCallback(this, function (response) {
			var returnValues = response.getReturnValue();
			component.set('v.picklistValues1',returnValues);
		});
		$A.enqueueAction(action);
	},
	getPickListValuesMap : function(component, event, helper) {
		var action = component.get('c.getPickListValuesMap');
		action.setCallback(this, function (response) {
			var returnValues = response.getReturnValue();
			component.set('v.picklistMap',returnValues);
			console.log('v.picklistMap',returnValues);
			var step = component.get('v.Step');
			var status = returnValues[step];
			console.log('status',status);
			component.set('v.picklistStepStatus',status);
		});
		$A.enqueueAction(action);
	},
	getPickListValues1 : function(component, event, helper) {
		var action = component.get('c.getPickListValues1');
		var selectedRecordTypeId = component.get('v.recordTypeId');
		action.setParams({
			"objectType": "Follow_Up_Step__c",
			"recordTypeId": selectedRecordTypeId,
			"fieldName": "Step_Status__c",
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			console.log('state',state);
			if (state === "SUCCESS"){
				var returnValues = response.getReturnValue();
				console.log('STEP STATUS',returnValues);
			}else if (state === "ERROR"){
				var errors = response.getError();
                console.log('errors:',errors);
			}
		});
		$A.enqueueAction(action);
	},
	getStepStatus : function(component, event, helper) {
		var action = component.get('c.getPickListValuesIntoList');
		action.setParams({
			objectType : 'Follow_Up_Step__c',
			selectedField : 'Step_Status__c'
		});
		action.setCallback(this, function (response) {
			var returnValues = response.getReturnValue();
			component.set('v.picklistValues2',returnValues);
		});
		$A.enqueueAction(action);
	},
	getDatetime : function(component, event, helper){
		var action = component.get('c.getDatetime');
		action.setCallback(this, function (response) {
			var returnValues = response.getReturnValue();
			console.log('now',returnValues);
			component.set('v.now',returnValues)			
		});
		$A.enqueueAction(action);
	},
	getCurrentUser : function(component, event, helper){
		var action = component.get('c.getCurrentUser');
		action.setCallback(this, function (response) {
			var returnValues = response.getReturnValue();
			console.log('owner',returnValues);
			component.set('v.owner',returnValues)			
		});
		$A.enqueueAction(action);
	},
	getTopLevelFollowUp : function(component, event, helper){
		var action = component.get('c.getTopLevelFollowUp');
		var recordId = component.get('v.recordId');
		action.setParams({
			"caseId": recordId
		});
		action.setCallback(this, function (response){
			var state = response.getState();
			console.log('STATE: ',state);
			if (state === 'SUCCESS'){
				var returnValues = response.getReturnValue();
				console.log('returnValuesWrapper',returnValues);
				if (returnValues.defaultLevel != null){
					console.log('returnValues.defaultLevel',returnValues.defaultLevel);
					setTimeout(() => {
						component.set('v.Step',returnValues.defaultLevel);
						component.set('v.disable',false);
					}, 100);
				}
			}else if (state ==='ERROR'){
					var errors = response.getError();
					console.log(errors);
			}
			helper.getPickListValuesMap(component, event, helper);

		});
        $A.enqueueAction(action);
	},
	refreshFocusedTab: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            var focusedTabId = response.parentTabId;
            workspaceAPI.refreshTab({
                tabId: focusedTabId,
                includeAllSubtabs: true
            });
        }).catch(function (error) {
            console.log(error);
        });
    },
	closeFocusedTab : function(component, event, helper, Id) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
			var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: Id});
        })
        .catch(function(error) {
            console.log(error);
        });
	},
	startSpinner: function (component) {
        // console.log('-- start --');

        component.set('v.loading', true);
    },
    stopSpinner: function (component) {
        // console.log('-- stop --');
        component.set('v.loading', false);
	},
	displayToast: function (component, type, message) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            type: type,
            message: message
        });
        toastEvent.fire();
	},
	parseObj: function (objFields) {
        return JSON.parse(JSON.stringify(objFields));
	},
	openTabWithSubtab: function (component, event, helper, id) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
			console.log('response',response);
			console.log('response.isSubtab',response.isSubtab);
                workspaceAPI.openTab({
                    url: '/lightning/r/Follow_Up_Step__c/' + id + '/view',
                    focus: true
                });
        })
            .catch(function (error) {
                console.log('error',error);
            });
	},
	validateField: function (component, event, helper) {
		var step = component.get('v.Step');
		var Step_Status__c = component.get('v.StepStatus');
		var Phone_SMS_Email__c = component.get("v.Phone_SMS_Email__c");
		var Contact_Date__c = component.find("Contact_Date__c").get("v.value");
		var Case__c = component.find("Case__c").get("v.value");
		var OwnerId = component.find("OwnerId").get("v.value");
		var Remark__c = component.find("Remark__c").get("v.value");
		var isValid = true;

		console.log('step',step);
		console.log('Step_Status__c',Step_Status__c);
		console.log('Phone_SMS_Email__c',Phone_SMS_Email__c);
		console.log('Contact_Date__c',Contact_Date__c);
		console.log('Case__c',Case__c);
		console.log('OwnerId',OwnerId);
		console.log('Remark__c',Remark__c);
		if (Step_Status__c == '' || Step_Status__c == undefined) {
            isValid = false;
            component.find('Step_Status__c').showHelpMessageIfInvalid();
            // message = 'Please complete Case Category Level1 field'
        }
        // console.log('caseObj.Origin : ' + caseObj.Origin);
        if (Phone_SMS_Email__c == '' || Phone_SMS_Email__c == undefined) {
            isValid = false;
            component.find('Phone_SMS_Email__c').showHelpMessageIfInvalid();
            // message = 'Please complete Case Origin field'
        }
        // // console.log('caseObj.Channel__c : ' + caseObj.Channel__c);
        // if (Contact_Date__c == '' || Contact_Date__c == undefined) {
        //     isValid = false;
        //     component.find('Contact_Date__c').showHelpMessageIfInvalid();
        //     // message = 'Please complete Channel field'
        // }

		if (!isValid){
			helper.displayToast(component, "Error", 'Please complete all required fields');
		}else {
			helper.startSpinner(component);
			var action = component.get('c.SaveFollowUp');
			action.setParams({
				'Step' : step,
				'Step_Status' : Step_Status__c,
				'Phone_SMS_Email' : Phone_SMS_Email__c,
				'Contact_Date' : Contact_Date__c,
				'CaseId' : Case__c,
				'OwnerId' : OwnerId,
				'Remark' : Remark__c
			});
			action.setCallback(this, function (response){
				var state = response.getState();
				console.log('STATE',state);
			
				if (state === "SUCCESS") {
					var returnValues = response.getReturnValue();
					console.log('returnValuesFollowUpOBJ',returnValues);
					helper.displayToast(component, "Success", "This case is saved");
					var workspaceAPI = component.find("workspace");
					var focusedTabId = '';
					workspaceAPI.getFocusedTabInfo().then(function(response) {
					focusedTabId = response.tabId;
					})
					helper.refreshFocusedTab(component, event, helper);
					helper.openTabWithSubtab(component, event, helper, returnValues.Id);
					helper.closeFocusedTab(component, event, helper, focusedTabId);

				}else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						console.log('error');

						if (errors[0] && errors[0].message) {
						// console.log("Error message: " +
						// 	errors[0].message);
						console.log(helper.parseObj(errors));

						console.log("Error message: " +
							errors[0].message);
						var errorMsg = errors[0].message;
						var tmpIndex_1 = errorMsg.indexOf(",");
						var tmpIndex_2 = errorMsg.indexOf(":", tmpIndex_1);
						errorMsg = errorMsg.substring(tmpIndex_1 + 1, tmpIndex_2);
						helper.displayToast(component, "Error", errorMsg);
					}
					} else {
						console.log("Unknown error");
					}
				}
			
			helper.stopSpinner(component);

		});
		$A.enqueueAction(action);
		}
	}
})