({
	init : function(component, event, helper) {
		var pageRef = JSON.parse(JSON.stringify(component.get("v.pageReference").state));
		var recordId = pageRef.c__recordId;
		console.log('pageRef',pageRef);
		var recordTypeId = pageRef.c__recordTypeId;
		component.set('v.recordTypeId',recordTypeId);
		console.log('recordTypeId',recordTypeId);
		console.log('RECORDID',recordId);
		component.set('v.recordId',recordId);
		helper.setFocusedTabLabel(component, event, helper);
		// helper.getPickListValues(component, event, helper);
		// helper.setFocusedTabIcon(component, event, helper)
		helper.getStep(component, event, helper);
		helper.getTopLevelFollowUp(component, event, helper);
		// helper.getStepStatus(component, event, helper);
		// helper.getDatetime(component, event, helper);
	},
	Cancel : function(component, event, helper) {
		helper.closeFocusedTab(component, event, helper);
	},
	onChange : function(component, event, helper) {
		var step = component.get('v.Step');
		if (step != null && step != '' && step != undefined){
			var picklistMap = component.get('v.picklistMap');
			
			var status = picklistMap[step];
			console.log('status',status);
			component.set('v.picklistStepStatus',status);
			component.set('v.disable',false);
		}else {
			component.set('v.disable',true);
		}
	},
	saveRecord : function(component, event, helper) {
		helper.validateField(component, event, helper);
	}
})