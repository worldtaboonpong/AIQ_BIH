({
    onInit: function (component, event, helper) {
        var recordId ;
        var recordTypeId;
        //console.log('State ',JSON.parse(JSON.stringify(component.get("v.pageReference").state)));
        //console.log('State ',JSON.parse(JSON.stringify(component.get("v.pageReference").state.recordTypeId == undefined)));
        if(component.get("v.pageReference").state.recordTypeId != undefined){
            recordTypeId = component.get("v.pageReference").state.recordTypeId;
        }else{
            // //console.log('recordId : ',JSON.parse(JSON.stringify(component.get("v.recordId"))));
            recordId = component.get("v.recordId");
        }
        
        //console.log("recordTypeId : ", recordTypeId);
        //console.log("recordId : ", recordId);
        var action = component.get("c.getUserCurrent");
        action.setParams({
          caseId: recordId,
          recordTypeId: recordTypeId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('------ START Proxy Page ------');
                component.set("v.userObj", response.getReturnValue().userObj);

                //console.log("User Info : ", response.getReturnValue());
                var cmpName;
                var evt = $A.get("e.force:navigateToComponent");
                var userObj = response.getReturnValue().userObj;
                var recordTypeName = response.getReturnValue().recordTypeName;
                var recordTypeId = response.getReturnValue().recordTypeId;
                //console.log("userObj : ", userObj);
                //console.log("recordTypeName : ", recordTypeName);
                //console.log("recordTypeId : ", recordTypeId);
                //console.log("userObj : ", userObj.User_Team__c);
                if ( recordTypeName.includes("Contact Center")) {
                    cmpName = "c:BIH_EditCaseForContactCenter";
                }else if ( recordTypeName.includes("Registration Case")){
                    cmpName = "c:BIH_EditCaseForPreRegistration"; 
                }else if (recordTypeName.includes("Medical Enquiry")){
                    cmpName = "c:BIH_EditCaseForMedicalEnquiry"; 
                }
                 else {
                    cmpName = "c:BIH_EditChildCaseForm";
                }
                // if (component.get("v.pageReference").state.recordTypeId == '012N000000136juIAA'){
                //     cmpName = "c:BIH_EditCaseForContactCenter";
                // } else {
                //     cmpName = "c:BIH_EditChildCaseForm";
                // }
                //console.log('SFDC test ' +component.get("v.recordId"));

                if(component.get("v.recordId") === undefined){
                    evt.setParams({
                        componentDef: cmpName,
                        componentAttributes: {
                            recordTypeId: recordTypeId,
                        },
                        isredirect: true,
                    });
                } else {
                    evt.setParams({
                        componentDef: cmpName,
                        componentAttributes: {
                            recordId: component.get("v.recordId"),
                            recordTypeId: recordTypeId,
                        },
                        isredirect: true,
                    });
                }

                
                evt.fire();
                //console.log('------ END Proxy Page ------');

            }
            // helper.stopSpinner(component);
        });
        $A.enqueueAction(action);

    }
})