({

	init: function (cmp, event, helper) {
		cmp.set('v.Endosement',"");
        //var dt = new Date().getTime();
        //var randomNumber = valueof((Math.random() * 100));
		helper.onInIt(cmp, event, helper);
        	
	},

	onCancel: function (component, event, helper) {
		helper.closeFocusedTab(component, event, helper);
        //var randomNumber = valueof((Math.random() * 100));
        //helper.onInIt(cmp, event, helper);
        var param = Math.floor((Math.random() * 10000) + 1);
        helper.getWrapper(component, event, helper, component.get('v.recordId'), param);
	},

	onSave: function (component, event, helper) {
        //var randomNumber = valueof((Math.random() * 100));
        helper.onsaveEndosement(component, event, helper);
	},
	
})