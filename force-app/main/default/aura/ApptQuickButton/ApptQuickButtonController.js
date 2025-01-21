({
    doInit : function(component, event, helper) {
        
        
        // var recordId = component.get("v.recordId");
        var recordId = component.get("v.recordId");
        console.log("recordId: ", recordId);
        
        
        var action = component.get("c.getCaseInfo");
        action.setParams({ "appId": recordId});
        
        action.setCallback(this, function(data) {
            var returnValues = data.getReturnValue();
            component.set("v.CaseInfo", returnValues);
            var CaseInfo = component.get("v.CaseInfo");
            console.log('isClosed?',CaseInfo[0].IsClosed);
            component.set("v.caseRecordTypeId",CaseInfo[0].RecordTypeId);
            if (CaseInfo[0].Owner.Type == "User"){
                // CaseInfo[0].isOwnerTypeUser = true;
                component.set('v.isOwnerTypeUser',true);
                component.set('v.ownerType','user');
                component.set("v.caseOwnerValue",CaseInfo[0].Owner)
                
            }else {
                // CaseInfo[0].isOwnerTypeUser = false;
                component.set('v.ownerType','queue');
                component.set('v.isOwnerTypeUser',false);
                
                component.set("v.caseOwnerValue",CaseInfo[0].Owner)
            }
            component.set("v.CaseInfo", CaseInfo);
            console.log("CASEINFO:",CaseInfo[0]);
            
            
            //   console.log(data.getReturnValue());
            helper.reActivateUser(component);
            helper.getisContactCenter(component, event, helper);
            helper.getisPreRegis(component, event, helper);
            helper.getCurrentUser(component, event, helper);
            helper.getChildcase(component, event, helper);
            helper.getRecordType(component, event, helper);
            helper.getOwnerType(component, event, helper);
            helper.getClosedCase(component, event, helper);
            helper.getCloseRecordType(component, event, helper);
            helper.getPickList(component, event, helper);
            //
        });
        $A.enqueueAction(action);
		
		
		// component.set("v.CaseOwnerName", c[0].Full_Name__c);
		// component.set("v.CaseNumber", c[0].CaseNumber);
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
	// showModalCreateClinic: function (component, event, helper) {
	// 	component.set("v.ModalCreateClinic", true);
	// },
	// hideModalCreateClinic: function (component, event, helper) {
	// 	component.set("v.ModalCreateClinic", false);
	// },
    hideModalCloseCase: function (component, event, helper) {
		component.set("v.ModalCloseCase", false);
	},
	showModalCloseCase: function (component, event, helper) {
		component.set("v.ModalCloseCase", true);
	},
	hideModalSMSMessage: function (component, event, helper) {
		component.set("v.ModalSMSMessage", false);
	},
	showModalSMSMessage: function (component, event, helper) {
		component.set("v.ModalSMSMessage", true);
	},    
    hideModalConvertLead: function (component, event, helper) {
		component.set("v.ModalConvertCase", false);
	},
	showModalConvertLead: function (component, event, helper) {
		component.set("v.ModalConvertCase", true);
	},
	hideModalAcceptCase: function (component, event, helper) {
		component.set("v.ModalAcceptCase", false);
	},
	showModalAcceptCase: function (component, event, helper) {
		var c = component.get("v.CaseInfo");
		var curr = component.get("v.CurrentUser");
		console.log(curr);
		console.log(c);
		component.set("v.CurrentUserName",curr.Name);
		component.set("v.CaseNumber",c[0].CaseNumber);
		component.set("v.CaseOwnerName", c[0].Owner.Name);
		// component.set("v.CurrentUser",  );
		component.set("v.ModalAcceptCase", true);
	},
	showModalReActivate: function (component, event, helper) {
		component.set("v.ModalReActivate",true);
	},
	hideModalReActivate: function (component, event, helper) {
		component.set("v.ModalReActivate",false);
	},
    closeAllCase : function(component, event, helper) {
		// console.log('in close all case method.');
		
        var recordId = component.get("v.recordId");
		var callCloseCase = component.find('BIH_CloseAllCase');
		
		if (callCloseCase !== null && callCloseCase !== undefined) {
			var closeStatus = callCloseCase.onCloseChild(recordId);
			// console.log('closeStatus: ',closeStatus);
			// setTimeout(function() {
			// {
			// 		// console.log('closeStatus: ',closeStatus);
					
			// 		// console.log('update close case done');
			// 		// component.set("v.ModalCloseCase", false);
				// });
			// }, 1000);
			
            // $A.get('e.force:refreshView').fire();  
			$A.enqueueAction(closeStatus);
		}
		// setTimeout(function() {
		// 	window.location.reload();
		// }, 2000);

	},
	sendSMS : function(component, event, helper) {
        var recordId = component.get("v.recordId");
		var callSendSMS = component.find('BIH_SendSMSMessage');
		console.log('sendSMS :',callSendSMS);

		if (callSendSMS !== null && callSendSMS !== undefined) {
			var sendStatus = callSendSMS.sendSMSMessage(recordId);
			// $A.getCallback(function(res) {
			// setTimeout(function() {
				sendStatus.setCallback(this,function(response){
					console.log(response.getState());
					console.log(response.getReturnValue());
					$A.get('e.force:refreshView').fire();  
				});
				// 		// console.log('closeStatus: ',closeStatus);
						
				// 		// console.log('update close case done');
						// component.set("v.ModalSMSMessage", false);
				// 	});
				// }, 1000);
				// $A.get('e.force:refreshView').fire();  
			// });
			
			$A.enqueueAction(sendStatus);
		}

	},
    convertCaseToLead : function(component, event, helper) {
        // console.log('in convert case to lead method.');
        
        var convertLead = component.find('BIH_ConvertCaseToLead');
		if (convertLead !== null && convertLead !== undefined) {
			var action = convertLead.convertCase(function(result) {
                // console.log("callback for aura:method was executed");
                // console.log("result: " + result.Id);
                helper.openLeadTab(component, event, helper,result.Id);
            });
            
            
        }
        
	},
    // onSaveAndGenerate: function (component, event, helper) {
	// 	var tmpCmp = component.find('GenerateInvitionLetterCmp');
	// 	if (tmpCmp !== null && tmpCmp !== undefined) {
	// 		tmpCmp.SaveAndGenerate();
    //     }
    //     // helper.hideModal(component, event, helper);
    // },
    // onSaveAndGenerateEvt: function (component, event, helper) {
    //     helper.hideModal(component, event, helper);
	// },
	handleSelect: function (component, event, helper) {
		// This will contain the index (position) of the selected lightning:menuItem
		var selectedMenuItemValue = event.getParam("value");
		// console.log('selectedMenuItemValue :', selectedMenuItemValue);

		helper.ohandleSelect(component, event, selectedMenuItemValue);
	},
	navigateToGeneratePDF: function (component, event, helper) {
        
        console.log('start pdf');
		// var evt = $A.get("e.force:navigateToComponent");
		// evt.setParams({
		// 	componentDef: "c:BIH_GenerateInvitionLetter",
		// 	componentAttributes: {
		// 		selectedCase: component.get("v.recordId"),
		// 	}
		// });
		// evt.fire();
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
        console.log('pageReference==',pageReference);
	
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
                
                console.log('++++++++++++++++++++++ else');
				// this is standard navigation, use the navigate method to open the component
				navService.navigate(pageReference, false);
			}
		})
		.catch(function (error) {
			console.log(error);
		});
        
        
	},
	saveCaseOwner: function (component, event, helper) {
		// console.log("----START UPDATE----");
		var CheckBox1 = component.get("v.CheckValue1");
		var CheckBox2 = component.get("v.CheckValue2");
		var c = component.get("v.CaseInfo");
		var curr = component.get("v.CurrentUser");
		// console.log(curr);
		// console.log(c);
		// console.log("-----------------");
		
		
		if (CheckBox1 && !CheckBox2){
			c[0].OwnerId = curr.Id;
			// c[0].Owner_Change_Reason__c = null;
			console.log("caseInfo: ",c[0]);
			var action = component.get("c.UpdateCase");
			helper.startSpinner(component);
			action.setParams({
			"caseOwner": c[0]
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			console.log("Update status: ",state);
			if (state === "SUCCESS"){
				// helper.displayToast(component,type,message);
				helper.displayToast(component,"Success","Owner case is changed");
				component.set("v.ModalAcceptCase", false);
				setTimeout(function() {
					window.location.reload();
				}, 2000);
			}
			else if (state == "ERROR"){
				var errors = response.getError();
					if (errors) {
						console.log('error');

						if (errors[0] && errors[0].message) {
							console.log('error default');

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
		// enqueue the server side action  
		$A.enqueueAction(action);
	}else if (CheckBox2 && !CheckBox1) {
		var picklist = component.find("case_owner_reason").get("v.value");
		console.log("picklist:",picklist);
		var caseOwnerValue = component.get("v.caseOwnerValue");
		if (caseOwnerValue != null){
		c[0].OwnerId = caseOwnerValue.Id;
		c[0].Owner_Change_Reason__c = picklist;
		console.log("c[0]:",c[0]);
		
		var action = component.get("c.UpdateCase");
			helper.startSpinner(component);
			action.setParams({
			"caseOwner": c[0]
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			console.log("Update status: ",state);
			if (state === "SUCCESS"){
				// helper.displayToast(component,type,message);
				helper.displayToast(component,"Success","Owner case is changed");
				component.set("v.ModalAcceptCase", false);
				setTimeout(function() {
					window.location.reload();
				}, 2000);
			}
			else if (state === "ERROR"){
				var errors = response.getError();
					if (errors) {
						console.log('error');

						if (errors[0] && errors[0].message) {
							console.log('error default');

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
		// enqueue the server side action  
		$A.enqueueAction(action);
	}else {
		helper.displayToast(component, "Error", "Please Enter Owner");

	}
	}
	else if (CheckBox1 && CheckBox2){
		helper.displayToast(component,"Error","Please Select 1 Owner for this Case");

	}
	else {
		helper.displayToast(component,"Error","Please Choose Owner");
	}
	},
	saveReActivate: function (component, event, helper) {
		var dateTimeNow = new Date().toISOString();
		var currentuser = component.get("v.CurrentUser")
		var c = component.get("v.CaseInfo");
		// var curr = component.get("v.CurrentUser");
		// console.log(curr);
		var recordTypeMaps = component.get("v.recordTypeMap");
		var ownerMap = component.get("v.ownerMap");
		var ChildCaseMap = component.get("v.ChildCaseMap");
		console.log("ChildCaseMap:",ChildCaseMap);
		console.log("ownerMap:",ownerMap);
		console.log("recordTypeMaps:",recordTypeMaps);
		var channelName = c[0].Channel__c;
		console.log("channelName:",channelName);
		
		if (ChildCaseMap.hasOwnProperty(channelName)){
			console.log("----START UPDATE----");
			var recordTeam = ChildCaseMap[channelName].Record_Type_Name__c;
			console.log("Select Record Map:",recordTypeMaps[recordTeam]);
			c[0].RecordTypeId = recordTypeMaps[recordTeam].Id;
			
			var queueName = ChildCaseMap[channelName].Queue_Name__c;
			console.log("Select Owner Map:",ChildCaseMap[channelName]);

			//alert('FOR K.MAY CURRENT USER RE-ACTIVATE: '+currentuser.Name);
			
			c[0].OwnerId = currentuser.Id;
			// c[0].OwnerId = ChildCaseMap[c.Channel__c].OwnerId;
			// c[0].RecordTypeId = ChildCaseMap[c.Channel__c].RecordTypeId;
			c[0].IsClosed = false;
			c[0].Status = "In Progress";
			c[0].Reactivated__c = true;
			c[0].Close_Case_Reason__c = null;
			c[0].Reactivated_By__c = currentuser.Name;
			c[0].Reactivated_Date__c = dateTimeNow;
			console.log(c);
			console.log("-----------------");
			// console.log('isClosed?',c[0].IsClosed);
		// console.log("caseInfo: ",c[0]);
		var action = component.get("c.UpdateCase");
		helper.startSpinner(component);
		action.setParams({
			"caseOwner": c[0]
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			console.log("Update status: ",state);
			if (state === "SUCCESS"){
				var getReturnValue = response.getReturnValue();
				// console.log('==== isNew ====');
				var isNew = component.get("v.recordId");
				console.log("isNew:",isNew);
				
				// console.log(isNew);
				console.log("getReturnValue:",getReturnValue);
				// helper.displayToast(component,type,message);
				helper.displayToast(component,"Success","This case is re-activated");
				component.set("v.ModalReActivate", false);
				component.set("v.IsClosed", false);
				// helper.refreshFocusedTab(component, event, helper);
				// if (isNew === undefined || isNew == undefined || isNew == null || isNew == '') {
					// helper.openTabWithSubtab(component, event, helper, getReturnValue.Id);
				// }

				setTimeout(function() {
					window.location.reload();
				}, 2000);
			}
			else if (state === "ERROR"){
				var errors = response.getError();
					if (errors) {
						console.log('error');

						if (errors[0] && errors[0].message) {
							console.log('error default');

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
		// enqueue the server side action  
		$A.enqueueAction(action);
	}else {
		console.log("-----DONT HAVE CHANNEL-----");
		var recType = c[0].RecordType.Name;
		console.log("recordType:",recType);
		console.log("CASE:",c[0]);
		var ClosedrecordTypeMap = component.get("v.ClosedrecordTypeMap");
		console.log("ClosedrecordTypeMap:",ClosedrecordTypeMap);
		
		var closedCaseMap = component.get("v.closedCaseMap");
		if (closedCaseMap.hasOwnProperty(recType)){
			console.log("---VALIDATE SUCCESS---");
			var channel = closedCaseMap[recType].Channel__c;
			console.log("channel:",channel);
			var activerec = closedCaseMap[recType].Active_Record_Type__c;
			console.log("activerec:",activerec);

			//alert('FOR K.MAY CURRENT USER RE-ACTIVATE2: '+currentuser.Name);
			
			c[0].OwnerId = currentuser.Id;

			c[0].Channel__c = channel;
			c[0].IsClosed = false;
			c[0].Status = "In Progress";
			c[0].Reactivated__c = true;
			c[0].Reactivated_By__c = currentuser.Name;
			c[0].Close_Case_Reason__c = null;
			c[0].Reactivated_Date__c = dateTimeNow;
			console.log("-----TEST-----");
			
			console.log(ClosedrecordTypeMap[activerec].Id);
			
			c[0].RecordTypeId = ClosedrecordTypeMap[activerec].Id;
			console.log("---SET CASE SUCCESS---");
			
			var action = component.get("c.UpdateCase");
			helper.startSpinner(component);
			action.setParams({
				"caseOwner": c[0]
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				console.log("Update status: ",state);
				if (state === "SUCCESS"){
					var getReturnValue = response.getReturnValue();
					// console.log('==== isNew ====');
					var isNew = component.get("v.recordId");
					console.log("isNew:",isNew);
				
					// console.log(isNew);
					console.log("getReturnValue:",getReturnValue);
					// helper.displayToast(component,type,message);
					helper.displayToast(component,"Success","This case is re-activated");
				component.set("v.ModalReActivate", false);
				component.set("v.IsClosed", false);
				// helper.refreshFocusedTab(component, event, helper);
				// if (isNew === undefined || isNew == undefined || isNew == null || isNew == '') {
					// helper.openTabWithSubtab(component, event, helper, getReturnValue.Id);
				// }

				setTimeout(function() {
					window.location.reload();
				}, 2000);
			}
			else if (state === "ERROR"){
				var errors = response.getError();
					if (errors) {
						console.log('error');

						if (errors[0] && errors[0].message) {
							console.log('error default');

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
		// enqueue the server side action  
		$A.enqueueAction(action);
		}
		else {
			helper.displayToast(component, "Error", "This Case doesn't has Channel");
		}
	}
},

onCheck1: function(component, event, helper) {

	component.set("v.CheckValue1",true);
	component.set("v.CheckValue2",false);
	

},
onCheck2: function(component, event, helper) {
	component.set("v.CheckValue1",false);
	component.set("v.CheckValue2",true);

},

})