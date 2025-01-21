({
	doInit : function(component, event, helper) {
        helper.startSpinner(component);
        helper.getLeadSourcePicklistValue(component);
		var recordId = component.get("v.selectedCase");
        
        var action = component.get("c.getCaseInfo");
		action.setParams({
			"caseId": recordId,
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var caseList = response.getReturnValue();
                component.set('v.case', caseList[0]);
               	var lead = component.get('v.lead');

                // console.log(JSON.parse(JSON.stringify(lead)));
                    for(var i = 0; i < caseList.length; i++){
                        
                        lead.Hospital_Number_HN__c = caseList[i].Hospital_Number_HN__c;
                        lead.Case__c = caseList[i].Id;  
                        lead.LeadSource = caseList[i].Lead_Source__c;
                        lead.Client__c  = caseList[i].AccountId;
                        lead.Sender_Email__c = caseList[i].SuppliedEmail;

                        lead.Phone = caseList[i].Phone__c ;
                        lead.Email = caseList[i].Patient_Email__c ;
                        lead.Procedure_1__c = caseList[i].Procedure_1__c ;
                        lead.Procedure_2__c = caseList[i].Procedure_2__c ;
                        lead.Procedure_3__c = caseList[i].Procedure_3__c ;
                        lead.Channel__c = caseList[i].Channel__c ;


                        if(caseList[i].Patient__c != null ){
                            var lastname = (caseList[i].Patient__r.LastName!=null)?caseList[i].Patient__r.LastName:caseList[i].Patient__r.Name;
                            var firstname = (caseList[i].Patient__r.FirstName!=null)?caseList[i].Patient__r.FirstName:caseList[i].Patient__r.Name;

                            lead.LastName = (lastname!='')?lastname:'-';
                            lead.FirstName = (firstname!='')?firstname:'';
                            
                            component.set('v.emptyLeadInfo', false);
                            
                        }else if(caseList[i].Full_Name__c != null){
                            var fullname = caseList[i].Full_Name__c;
                            var splitFullName = fullname.split(" ");

                            var firstname = splitFullName[0];
                            var lastname = splitFullName[1];

                            lead.LastName = (lastname!=''&& lastname!= undefined)?lastname:'-';
                            lead.FirstName = (firstname!='')?firstname:'';

                            component.set('v.emptyLeadInfo', false);

                        }else{
                            component.set('v.emptyLeadInfo', true);
                        }
                    }	

                setTimeout(() => {
                     component.set('v.lead', lead);
                }, 50);
                    
                helper.stopSpinner(component);

			} else {
                var error = response.getError();
                //helper.displayToast(component, 'Error', error);
				console.log(error[0].message);
			}
            
            
           
		});
        

        
		$A.enqueueAction(action);
    },
    
    convertCase : function(component, event, helper) {
        helper.startSpinner(component);
        var params = event.getParam('arguments');
        var callback;
        if (params) {
            callback = params.callback;
        }

        var lead = component.get("v.lead");

        var action = component.get("c.convertCaseToLead");
        action.setParams(
            {"l": lead}
        );
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state=='ERROR'){
                helper.stopSpinner(component);
            }

            if (callback) callback(response.getReturnValue());
            
        });

        $A.enqueueAction(action);
        
    }
    
})