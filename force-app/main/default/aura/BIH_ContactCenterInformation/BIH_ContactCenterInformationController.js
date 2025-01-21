({
	init : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getContactCenterInfo");
        // helper.startSpinner(component);
        action.setParams({
            "contactcaseId": recordId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('--- CaseContact ---');
                var responseValue = response.getReturnValue();
				component.set("v.ContactcaseObj", responseValue);
				console.log("v.ContactcaseObj", responseValue);
				console.log("v.ContactcaseObj", responseValue.ContactcaseObj);
				
                // var checktime =  responseValue.Escalate_Date__c;
               
                // console.log('time ',checktime);
                
                // var time = new Date(checktime).toLocaleTimeString('nb-NO');

                // if (time == "Invalid Date"){
                //     time = "";
                // }
               
                // component.set("v.timeEscalate",time);
                // console.log('time3 ',time);
              
            }
            // helper.stopSpinner(component);
        });
        $A.enqueueAction(action); 
    },
    changeState1: function changeState(component) {
		component.set('v.isexpanded1', !component.get('v.isexpanded1'));
    },
    changeState2: function changeState(component) {
		component.set('v.isexpanded2', !component.get('v.isexpanded2'));
    },
    changeState3: function changeState(component) {
		component.set('v.isexpanded3', !component.get('v.isexpanded3'));
  },
  changeState4: function changeState(component) {
		component.set('v.isexpanded3', !component.get('v.isexpanded4'));
  },
  changeState5: function changeState(component) {
		component.set('v.isexpanded3', !component.get('v.isexpanded5'));
	},

})