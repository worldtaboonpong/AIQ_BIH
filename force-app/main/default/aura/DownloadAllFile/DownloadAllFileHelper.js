({
    downloadFiles : function(component, event, helper) {
        var action = component.get("c.generateDownloadAllFiles");
        var test = component.get("v.recordId");
        //alert('test : '+test);
        action.setParams({
            caseId: component.get("v.recordId")
        });
        //alert('test1 : '+test);
        action.setCallback(this,function(response){
            //alert('test2 : '+test);
            var state = response.getState();
            if(state ==="SUCCESS"){
                //alert ("SUCCESS From server:"+ response.getReturnValue());

                if(response.getReturnValue() != 'No Documents Found'){

                    //alert('!= No Documents');
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({"url" : response.getReturnValue()})
                    urlEvent.fire();
                    
                }else{
                    //alert('== No Documents');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error1',
                        message: 'No Documents Found',
                        duration: '5000',
                        key:'info_alt',
                        type:'error',
                        mode:'pester'
                    });
                    toastEvent.fire();
                }
            }
            else if (state === "INCOMPLETE"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error2',
                    message: 'INCOMPLETE',
                    duration: '5000',
                    key:'info_alt',
                    type:'error',
                    mode:'pester'
                });
                toastEvent.fire();
            }
            else if (state === "ERROR"){
                /*var errors = response.getError();
                if(errors){
                    if(errors[0] && error[0].message){
                        console.log("Error message: "+
                        error[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }*/
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error3',
                    message: 'No Documents Found',
                    duration: '5000',
                    key:'info_alt',
                    type:'error',
                    mode:'pester'
                });
                toastEvent.fire();

            }
        });
        $A.enqueueAction(action);
    },
})