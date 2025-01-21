({
    getCurrentUser: function (component, event, helper){
    var actionPromise = new Promise(function (resolve, reject) {
        var action = component.get("c.getCurrent");
        action.setCallback(this, function(data) {
            component.set("v.CurrentUser", data.getReturnValue());

            //alert('FOR K.MAY CURRENT USER: '+data.getReturnValue().Name);

            var currentUser = data.getReturnValue();
            var rolename = '';
            if (currentUser.UserRole != null){
                rolename = currentUser.UserRole.Name;
            }
            console.log('rolename:',rolename);
            
            var caseObj = component.get('v.CaseInfo');
            console.log('CASEOBJ IN CURR:',caseObj[0]);
            
            if (caseObj[0].OwnerId == currentUser.Id){
                component.set('v.IsOwner',true);
                console.log('IS OWNER');
            }else if (rolename != '' && rolename != undefined && rolename.includes("CC Officer")){
                component.set('v.IsSup',false);
                console.log('IS CC Officer');
            }
            // component.set('v.IsSup',false);
            // component.set('v.IsOwner',false);
            console.log("CurrentUser: ",component.get("v.CurrentUser"));
            resolve(data.getReturnValue());
        });
        $A.enqueueAction(action);
    });
    actionPromise.then(
        function (data) {
            var action2 = component.get("c.getCaseQuickButtonAssignment");
            action2.setParams({
                "user_team": data.User_Team__c
            });
            action2.setCallback(this, function(data2) {
                component.set("v.CaseQuickButtonAssignment", data2.getReturnValue());
                console.log("CaseQuickButtonAssignment: ", JSON.parse(JSON.stringify(component.get("v.CaseQuickButtonAssignment"))));
            });
            $A.enqueueAction(action2);
            // helper.getWrapper(component, event, helper);

        }
    );
    //   $A.enqueueAction(action);
    },
	hideModal: function (component, event, helper) {
		component.set("v.ShowModule", false);
	},
	showModal: function (component, event, helper) {
		// console.log('showmodal');
		component.set("v.ShowModule", true);
	},
    refreshFocusedTab: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
			workspaceAPI.getFocusedTabInfo().then(function (response) {
				var focusedTabId = response.tabId;
				// console.log('focusedTabId :', focusedTabId);

				workspaceAPI.refreshTab({
					tabId: focusedTabId,
					includeAllSubtabs: true
				});
			}).catch(function (error) {
				console.log(error);
			});
    },
    closeFocusedTab: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            var focusedTabId = response.tabId;
            // console.log('focusedTabId :', focusedTabId);
            
            workspaceAPI.closeTab({ tabId: focusedTabId });
        })
            .catch(function (error) {
                console.log(error);
            });
    },
    openTabWithSubtab: function (component, event, helper,id) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            if (!response.isSubtab){
                workspaceAPI.openTab({
                    url: '/lightning/r/Case/'+id+'/view',
                    focus: true
                });
            }else{
                workspaceAPI.openSubtab({
                    parentTabId: response.parentTabId,
                    url: '/lightning/r/Case/'+ id +'/view',
                    focus: true
                });
            }
        })
            .catch(function (error) {
                console.log(error);
            });
    },
    openLeadTab : function(component, event, helper,id) {
        var workspaceAPI = component.find("workspace");
         workspaceAPI.getFocusedTabInfo().then(function (response) {
            if (!response.isSubtab){
                workspaceAPI.openTab({
                    url: '/lightning/r/Lead/'+id+'/view',
                    focus: true
                }).then(function(tabInfo) {
            	// console.log("The url for this tab is: " + tabInfo.url);
                component.set("v.ModalConvertCase", false);
            });
            }else{
                workspaceAPI.openSubtab({
                    parentTabId: response.parentTabId,
                    url: '/lightning/r/Lead/'+ id +'/view',
                    focus: true
                }).then(function(tabInfo) {
            	// console.log("The url for this tab is: " + tabInfo.url);
                component.set("v.ModalConvertCase", false);
            });
            }
        })
        .catch(function (error) {
            console.log(error);
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
    startSpinner: function (component){
        component.set("v.loading",true);
    },
    stopSpinner: function (component){
        component.set("v.loading",false);
    },
    reActivateUser:function (component){
        var cases = component.get("v.CaseInfo");
        console.log(cases);
        
        if (cases[0].IsClosed == true){
            component.set("v.IsClosed", true);
        }
        else {
            component.set("v.IsClosed", false);
        }
    },
    getChildcase : function (component, event, helper){
		var action = component.get("c.mapDataChildcase");
		// action.setParams({});
		// set call back 
		action.setCallback(this, function (response) {
			// var state = response.getState();
            var returnValues = response.getReturnValue();
            console.log("returnValues:",returnValues);
            
			component.set('v.ChildCaseMap', returnValues);
			// console.log("childCaseMap: ",component.get('v.childCaseMap'));
		});
		// enqueue the server side action  
		$A.enqueueAction(action);
	
    },
    getOwnerType : function (component, event, helper){
		var action = component.get("c.ownerMap");
		// var owner = component.get("v.ownerTypeName");
		// action.setParams({
		// 	"ownerName":owner,
		// });
		// set call back 
		action.setCallback(this, function (response) {
			// var state = response.getState();
			var returnValues = response.getReturnValue();
            component.set('v.ownerMap',returnValues);
            console.log("returnValuesOwner:",returnValues);
            
			// console.log("ownerMap: ",component.get('v.ownerMap'));

		});
		// enqueue the server side action  
		$A.enqueueAction(action);
		
		
	},
	getRecordType : function (component, event, helper){
		var action = component.get("c.recordTypeMap");
		// var record = component.get("v.recordTypeName");

		// action.setParams({
		// 	"recordName":record
		// });
		// set call back 
		action.setCallback(this, function (response) {
			// var state = response.getState();
			var returnValues = response.getReturnValue();
            component.set('v.recordTypeMap',returnValues);
            console.log("returnValuesrecordType: ",returnValues);
            var CaseInfo = component.get("v.CaseInfo");
            console.log('CaseInfo',CaseInfo);
            console.log('caseinfo.recordtypeid',CaseInfo[0].RecordTypeId);
            
            // if (returnValues['Contact_Center_Case'].Id == CaseInfo[0].RecordTypeId){
            //     console.log('isis: ',returnValues['Contact_Center_Case'].Id);
            //     component.set('v.isCC',true);
            // }
			// console.log("recordtypeMap: ",component.get('v.recordtypeMap'));
		});
		// enqueue the server side action  
		$A.enqueueAction(action);
		
    },
    getCloseRecordType : function (component, event, helper){
		var action = component.get("c.ClosedrecordTypeMap");
		// var record = component.get("v.recordTypeName");

		// action.setParams({
		// 	"recordName":record
		// });
		// set call back 
		action.setCallback(this, function (response) {
			// var state = response.getState();
			var returnValues = response.getReturnValue();
            component.set('v.ClosedrecordTypeMap',returnValues);
            console.log("returnValuesClosedrecordType: ",returnValues);
            
			// console.log("recordtypeMap: ",component.get('v.recordtypeMap'));
		});
		// enqueue the server side action  
		$A.enqueueAction(action);
		
    },
    getClosedCase : function (component, event, helper){
		var action = component.get("c.mapClosedCase");
		// action.setParams({});
		// set call back 
		action.setCallback(this, function (response) {
			// var state = response.getState();
            var returnValues = response.getReturnValue();
            console.log("returnValues Closed Case:",returnValues);
            
			component.set('v.closedCaseMap', returnValues);
			// console.log("childCaseMap: ",component.get('v.childCaseMap'));
		});
		// enqueue the server side action  
		$A.enqueueAction(action);
	
    },
    ohandleSelect: function (component, event,value) {
        // This will contain the index (position) of the selected lightning:menuItem
        // console.log('helper');
        component.set('v.caseOwnerValue', null);
        // Find all menu items
        if (value == 'user') {
            component.set('v.isOwnerTypeUser', true);
            component.set("v.ownerType", value);
        } else {
            component.set('v.isOwnerTypeUser', false);
            component.set("v.ownerType", value);
        }
       
    },
    parseObj: function (objFields) {
        return JSON.parse(JSON.stringify(objFields));
    },
    getPickList: function (component, event, helper){
        var action = component.get('c.getPickListValuesCase');
        action.setParams({
            "field_name": "Owner_Change_Reason__c"
        });
		// set call back 
		action.setCallback(this, function (response) {
			// var state = response.getState();
            var returnValues = response.getReturnValue();
            console.log("v.Picklist",returnValues);
            component.set("v.Picklist",returnValues);
		});
		// enqueue the server side action  
		$A.enqueueAction(action);
    },
    getisContactCenter : function (component, event, helper) {
        var action = component.get('c.getisCC');
        var CaseInfo = component.get("v.CaseInfo");
        console.log('Caseinfo-:',CaseInfo[0]);
        
        action.setParams({
            "recordId": CaseInfo[0].Id
        });
		// set call back 
		action.setCallback(this, function (response) {
			// var state = response.getState();
            var returnValues = response.getReturnValue();
            console.log('isCC?: ',returnValues);
            component.set('v.IsCC',returnValues);
		});
		// enqueue the server side action  
		$A.enqueueAction(action);
    },
    getisPreRegis : function (component, event, helper) {
        var action = component.get('c.getisPreRegis');
        var CaseInfo = component.get("v.CaseInfo");
        console.log('Caseinfo-:',CaseInfo[0]);
        
        action.setParams({
            "recordId": CaseInfo[0].Id
        });
		// set call back 
		action.setCallback(this, function (response) {
			// var state = response.getState();
            var returnValues = response.getReturnValue();
            console.log('isPreRegis?: ',returnValues);
            component.set('v.IsPreRegis',returnValues);
		});
		// enqueue the server side action  
		$A.enqueueAction(action);
    },
    getisPreAuth : function (component, event, helper) {
        var action = component.get('c.getisPreAuth');
        var CaseInfo = component.get("v.CaseInfo");
        console.log('Caseinfo-:',CaseInfo[0]);
        
        action.setParams({
            "recordId": CaseInfo[0].Id
        });
		// set call back 
		action.setCallback(this, function (response) {
			// var state = response.getState();
            var returnValues = response.getReturnValue();
            console.log('isPreAuth?: ',returnValues);
            component.set('v.IsPreAuth',returnValues);
		});
		// enqueue the server side action  
		$A.enqueueAction(action);
    },
    getisPC : function (component, event, helper) {
        var action = component.get('c.getisPC');
        var CaseInfo = component.get("v.CaseInfo");
        console.log('Caseinfo-:getisPC',CaseInfo[0]);
        
        action.setParams({
            "recordId": CaseInfo[0].Id
        });
		// set call back 
		action.setCallback(this, function (response) {
			// var state = response.getState();
            var returnValues = response.getReturnValue();
            console.log('isPC?: ',returnValues);
            component.set('v.IsPC',returnValues);
		});
		// enqueue the server side action  
		$A.enqueueAction(action);
    }
        
        
        
        
        
})