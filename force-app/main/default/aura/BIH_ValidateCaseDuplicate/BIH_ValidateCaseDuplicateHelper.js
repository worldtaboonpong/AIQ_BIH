({
	getData : function(component) {
		// console.log('--getdata--');
		
        var recordId = component.get("v.selectedCase");
		var action = component.get('c.validateCaseDuplicate');
		action.setParams({
			"caseId": recordId,
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				// console.dir(JSON.parse(JSON.stringify(returnValues[0])));
				// console.dir(JSON.parse(JSON.stringify(returnValues[1])));

				// returnValues[0].TestKey = 'test';
				// console.dir(JSON.parse(JSON.stringify(returnValues[0])));

				
				component.set('v.caseList', returnValues);
				component.set('v.caseListDefault', returnValues);
                returnValues.forEach(function(record){
                    record['URL'] = '/lightning/r/Case/' + record['Id'] + '/view';
                    
                    if (record['Owner']) record.OwnerId = record.Owner.Name;
					// if (record['AccountId']) record.AccountId = record.Account.Name;
					if (record.Owner.Id.slice(0,3) != '00G') record.ownerType = 'user' ,record.isOwnerTypeUser = true;
					 if(record.Accountid !=null){
                        record['AccountName'] = record.Account.Name;
                    }
					// console.log(record['AccountName']);
					
					// var test = record['Id'].slice(0,3);
					// console.log(test);
					// console.log(record);
                });
                
                if(returnValues.length > 1){
                    component.set("v.isDuplicate", true);
                }
				
			} else {
				var error = response.getError();
				// console.log(error[0].message);
			}
		});
		$A.enqueueAction(action);

	},
	ohandleSelect: function (component, event,value,name) {
        // This will contain the index (position) of the selected lightning:menuItem
		// console.log('helper');
		
        //component.set('v.caseOwnerValue', null);
		// Find all menu items
		var indexUser = name;
		var caseList = component.get("v.caseList");
		var typeUser = caseList[indexUser].ownerType;
		// console.log("TypeUser: ",typeUser);
		if (value == typeUser || (typeUser == null && value == 'queue')){
			if (value == 'user') {
           	 	// component.set('v.isOwnerTypeUser', true);
				// component.set("v.ownerType", value);
				// caseList[indexUser] = null;
				caseList[indexUser].ownerType = value;
				caseList[indexUser].isOwnerTypeUser = true;	
        	} else {
            	// component.set('v.isOwnerTypeUser', false);
				// component.set("v.ownerType", value);
				// caseList[indexUser] = null;
				caseList[indexUser].ownerType = value;
				caseList[indexUser].isOwnerTypeUser = false;
			}
		} else {
			if (value == 'user') {
				// component.set('v.isOwnerTypeUser', true);
				// component.set("v.ownerType", value);
				caseList[indexUser].Owner = null;
				caseList[indexUser].ownerType = value;
				caseList[indexUser].isOwnerTypeUser = true;	
			} else {
				// component.set('v.isOwnerTypeUser', false);
				// component.set("v.ownerType", value);
				caseList[indexUser].Owner = null;
				caseList[indexUser].ownerType = value;
				caseList[indexUser].isOwnerTypeUser = false;
			}
		}
		component.set('v.caseList', caseList);
	},
	validateField: function(component, event, helper){
		// console.log('-----VALIDATE-----');
		var isValid = true;

		var message ='Please complete all required fields';
		var caseList = component.get('v.caseList');
		// component.set('errors[0]',false);
		for (var i = 0;i<caseList.length;i++){
			if (caseList[i].Owner == null){
				isValid = false;
				component.set('v.showError',true);
			}
		}
		// console.log('isValid: ',isValid);
		if (!isValid){
            helper.displayToast(component, 'Error', message);
        }
        // console.log('-- END Validation --');
        return isValid;
	},
	startSpinner: function (component) {
        // console.log('-- start --');
        
        component.set('v.loading', true);
    },
    stopSpinner: function (component) {
        // console.log('-- stop --');
        component.set('v.loading', false);
	},
	displayToast: function (component, type, message) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            type: type,
            message: message
        });
        toastEvent.fire();
	},
	parseObj: function (objFields) {
        return JSON.parse(JSON.stringify(objFields));
    }
})