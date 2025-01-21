({
	doInit : function(component, event, helper) {
        console.log( '----ONINIT----');
        
        var actions = [
            { label: 'Person', name: 'show_person' },
            { label: 'Queue', name: 'show_queue' }
        ]
        component.set('v.mycolumns', [
            {label: 'Case Number', fieldName: 'URL', type: 'url', 
            	typeAttributes: {label: { fieldName: 'CaseNumber' }, target: '_self'}},
            { label: 'Subject', fieldName: 'Subject', type: 'text'},
            { label: 'Sender', fieldName: 'AccountId', type: 'text'},
            { label: 'Web Email', fieldName: 'SuppliedEmail', type: 'text'},
            { label: 'Owner', fieldName: 'OwnerId', type: 'text' ,editable:'true'},
            { type: 'action', typeAttributes: { rowActions: actions } },
            { label: 'CreatedDate', fieldName: 'CreatedDate', 
                type: 'date',
                typeAttributes: {
                    day: 'numeric',
                    month: 'short',
                    year: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    hour12: true
                  }, 
                  sortable: false
            }
        ]);
        helper.getData(component);
        // var test = component.get('v.caseList');
        // var errors = component.get('v.errors');
        // for (let index = 0; index < test.length; index++) {
        //     if (errors[i] == null){
        //         errors[i] = false;
        //     }
        // }
        // component.set('v.errors',errors);
        // console.log();
        
    },
    hideModal: function (component, event, helper) {
        component.set("v.ShowModalList", false);
        helper.getData(component);

    },
    
    showModal: function (component, event, helper) {
        // var caseListDefault = component.get("v.caseListDefault");
        // var caseList = component.get("v.caseList");
        // console.log('====');
        
        // console.log(caseListDefault);
        // console.log('====');
        // console.log(caseList);
        // // if (caseList != caseListDefault){
        // component.set("v.caseList", caseListDefault);
        // console.log("caseList: ", caseList);
        // }
        component.set("v.ShowModalList", true);
    },
    handleSelect: function (component, event, helper) {
        // This will contain the index (position) of the selected lightning:menuItem
        // console.dir(event);
        // var a = event.getSource();
        // var id = a.getLocalId();
        var selectedMenuItemValue = event.getParam("value");
        var selectedMenuItemName = event.getSource().get("v.name");
        // console.log('ID: ',id);
        // console.log('Name: ',selectedMenuItemName);
        // console.log('selectedMenuItemValue :', selectedMenuItemValue);

		helper.ohandleSelect(component, event, selectedMenuItemValue, selectedMenuItemName);
	},
    onSave : function (component, event, helper) {
        var caseList = component.get('v.caseList');
		var action = component.get("c.UpdateCaseRecord");
        var errors = component.get('v.errors');
        // console.log("List: ",caseList);
        for (var i = 0;i<caseList.length;i++){
            if (caseList[i].Owner != null){
                caseList[i].OwnerId = caseList[i].Owner.Id;
                // component.set('v.showError',false);
                // errors[i] = false;
            }
            else {
                caseList[i].OwnerId = null;
                // component.set('v.showError',true);
                // errors[i] = true;
            }
            console.log('Errors: ',errors[i]);
            
            
            // console.log('--');
            // console.log("CaseOwner: ",caseList[i].Owner);
            // console.log("AccountId: ",caseList[i].AccountId);
        }
        
        
        var validate = helper.validateField(component, event, helper);
        // console.log("Validation: ", validate);
        
        if (validate) {
            helper.startSpinner(component);
            action.setParams({
                "caseList":caseList,
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                // console.log("state: ", state);
                
                if (state === "SUCCESS"){
                    // var getReturnValue = response.getReturnValue();
                    // console.log("getReturnValue: ",getReturnValue);

                    helper.displayToast(component,"Success","This case is saved");
                    component.set("v.ShowModalList", false);

                } else if (state === "ERROR"){
                    var errors = response.getError();
                    // console.log("Errors: ",errors);
                    
                    if (errors){
                        // console.log('error');

                        if (errors[0] && errors[0].message) {
							// console.log("Error message: " +
							// 	errors[0].message);
							console.log(helper.parseObj(errors));
							console.log("Error message: " +
								errors[0].message);
							var errorMsg = errors[0].message;
                            var tmpIndex_1 = errorMsg.indexOf(",");
                            // console.log(tmpIndex_1);                            
                            var tmpIndex_2 = errorMsg.indexOf("]", tmpIndex_1);
                            // console.log(tmpIndex_2);                            
							errorMsg = errorMsg.substring(tmpIndex_1 + 1, tmpIndex_2+1);
                            helper.displayToast(component, "Error", errorMsg);
						}
                    } else {
						console.log("Unknown error");
                    }
                }
                helper.stopSpinner(component);
            });
            $A.enqueueAction(action);
        }else {

        }

    }

    
    
})