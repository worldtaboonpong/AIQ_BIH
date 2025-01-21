({
	doInit : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Case Number', fieldName: 'URL', type: 'url', 
            	typeAttributes: {label: { fieldName: 'CaseNumber' }, target: '_self'}},
            { label: 'Subject', fieldName: 'Subject', type: 'text'},
            { label: 'Status', fieldName: 'Status', type: 'text'},
            { label: 'Channel', fieldName: 'Channel__c', type: 'text'},
            { label: 'Owner', fieldName: 'OwnerId', type: 'text'}
        ]);
        helper.getCC(component, event, helper);
        helper.getChildCase(component);
        helper.getFollowUpStep(component, event, helper);
        helper.getCloseCaseReason(component);
        console.log("v.selectedRecordTypeId",component.get("v.selectedRecordTypeId"));
    },
    onCloseChild: function (component, event, helper) {
        // console.log('action close');
        var params = event.getParam('arguments');
        var recordId = '';
        if (params) {
            recordId = params.caseId;
        }
        
        var action = component.get("c.closeAllChildCase");
        var caseReason = component.get("v.case.Close_Case_Reason__c");
        var caseChannel = component.get("v.case.Channel__c");
        // console.log(caseReason);
        var childCase = component.get('v.closeCaseList');
        
        var message ='Please select reason for close case';
        
            if (component.get("v.case.Close_Case_Reason__c") == ''){
                helper.displayToast(component, 'Error', message);
            }else{
                helper.startSpinner(component);
                // if (childCase != null){
                // childCase.forEach(element => {
                //     if (element.status != 'Closed' && element.Channel__c == caseChannel){}
                //         element.status = 'Closed';
                //         element.Close_Case_Reason__c = caseReason;
                //         element.isClosedAll__c = true;
                        
                //     });
                //     console.log('childCase:',childCase);
                // }
                // console.log('action'+action);
                action.setParams(
                    {"caseId": recordId,"closeReason":caseReason,"childCase":childCase}
                );
                // setTimeout(function(){
                action.setCallback(this, function(response) {
                    var c = response.getReturnValue();
                    console.log('return from all close:',c);
                    
                    var state = response.getState();
                    console.log('state Close All:',state);
                    if(state === "SUCCESS"){
                        helper.displayToast(component,'Success','All cases were closed');
			            // setTimeout(function() {
			            // window.location.reload();
                        // }, 2000);
                        // var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        // dismissActionPanel.fire();
                        setTimeout(function() {
			                window.location.reload();
		                }, 2000);
                    } else if (state == "ERROR"){
                        var errors = response.getError();
                        console.log('errors:',errors);
                        
                            if (errors) {
                                // var errors = response.getError();      
                                helper.displayToast(component, 'Error', errors[0].message);
                                console.log('There was a problem : '+errors[0].message);
                                // console.log('error');
        
                                // if (errors[0] && errors[0].message) {
                                //     console.log('error default');
        
                                //     // console.log("Error message: " +
                                //     // 	errors[0].message);
                                //     console.log(helper.parseObj(errors));
        
                                //     console.log("Error message: " +
                                //         errors[0].message);
                                //         var errorMsg = errors[0].message;
                                    
                                //     try{
                                //     var tmpIndex_1 = errorMsg.indexOf(",");
                                //     var tmpIndex_2 = errorMsg.indexOf(":", tmpIndex_1);
                                //     errorMsg = errorMsg.substring(tmpIndex_1 + 1, tmpIndex_2);
                                //     helper.displayToast(component, "Error", errorMsg);
                                //     }catch(error){
                                //         helper.displayToast(component, "Error", errorMsg);

                                //     }
                                //     helper.displayToast(component, "Error", errorMsg);
                                
                            } else {
                                console.log("Unknown error");
                            }
                    }
                helper.stopSpinner(component);
                });
            // }, 1000);
            }
        
        $A.enqueueAction(action);
        
    }
    
})