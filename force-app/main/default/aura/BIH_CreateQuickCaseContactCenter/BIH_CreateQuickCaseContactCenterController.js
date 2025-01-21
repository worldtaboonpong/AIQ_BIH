({
    init : function(component, event, helper) {
     
        console.log("===== QUICK CREATE CASE =====");
        var recordId =  component.get("v.recordId");
        console.log('recordId',recordId);

        var actionPromise = new Promise(function (resolve, reject) {
            var action = component.get("c.getUserProfile");
            action.setCallback(this, function(response) {
                var output = response.getReturnValue();
                var state = response.getState();
                if(state == "SUCCESS"){
                    console.log('User info',output);
                    // if(output.User_Team__c.includes("Contact Center")){
                    if(output.User_Team__c == undefined){
                        output.User_Team__c = '';
                    }
                    if((output.User_Team__c.includes("Contact Center") || output.Profile.Name == 'System Administrator')){
                        resolve(output);
                    }else{
                        helper.displayToast(component, "Error", 'This function can be used by only Contact Center');
                        $A.get("e.force:closeQuickAction").fire();
                    }
                } else if (state == "ERROR" || !output.isSuccess) {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log(errors);

                            // console.log("Error message: " +
                            //     errors[0].message);
                            helper.displayToast(component, "Error", errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }

            });
            $A.enqueueAction(action);
        });
        actionPromise.then(
            function (output) {
                if(output.User_Team__c.includes("Contact Center") || output.Profile.Name == 'System Administrator' ){
                    var action = component.get('c.createQuickCase');
                    action.setParams({
                        "recordId": recordId,
                    });
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        var customLabel = $A.get("$Label.c.Create_Quick_Case_Successfully");
                        if (state === "SUCCESS") {
                            console.log('state : ',state);
                            console.log('response.getReturnValue() ',response.getReturnValue());
                            helper.openTabWithSubtab(component, event, helper,response.getReturnValue().Id);
                            // $A.get("e.force:closeQuickAction").fire();
                            helper.displayToast(component,'success', customLabel);
                            console.log("===== QUICK CREATE CASE =====");
                            $A.get("e.force:closeQuickAction").fire();
                            $A.get('e.force:refreshView').fire();
                        } else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log(errors);
                                    helper.displayToast(component, "Error", errors[0].message);
                                }
                            } else {
                                console.log("Unknown error");
                            }
                            $A.get("e.force:closeQuickAction").fire();
                        }
                        

                    });
                    $A.enqueueAction(action);
                }else{
                    helper.displayToast(component, "Error", 'This function can be used by only Contact Center');
                }
            }
        );
    }
})