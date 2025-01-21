({
	doInit : function(component, event, helper) {
        helper.startSpinner(component, event, helper);
		helper.getSMSCase(component, event, helper);
        helper.getSVTM(component, event, helper);
        helper.stopSpinner(component);
    },
    onChangeLanguage: function (component, event, helper) {
        var lang = component.find('sms_language').get('v.value');
        var values = component.find('sms_template').get('v.value');
        
        console.log('lang',lang);
        console.log('values',values);
        var MapSMSTemplate = component.get('v.MapSMSTemplate');
        if (lang == 'EN'){
            component.set('v.message',MapSMSTemplate[values].SMS_EN__c);
        }else {
            component.set('v.message',MapSMSTemplate[values].SMS_TH__c);
        }
        // alert(values);
        
    },
    onChangeTemplate: function (component, event, helper) {
        var values = component.find('sms_template').get('v.value');
        var lang = component.find('sms_language').get('v.value');
        var parseDateTH = component.get('v.parseDateTH');
        var parseDateEN = component.get('v.parseDateEN');

        console.log('values:',values);
        // alert(values);
        if (values != 'none'){
            console.log('case1');
            
            var MapSMSTemplate = component.get('v.MapSMSTemplate');
            // var templateId = component.get('v.templateId');
            // var SMSTemplate = component.get('v.SMSTemplate');
            // for (var i = 0 ;i<SMSTemplate.length;i++){
            //     if (MapSMSTemplate[SMSTemplate[i]].Id == templateId){
            //         component.set('v.Template',MapSMSTemplate[SMSTemplate[i]].SMS_Template_Subject__c);
            //     }
            // }
            // console.log('HasOwnProperty ? :',MapSMSTemplate.hasOwnProperty());
            
		    console.log('SMSTemplate',MapSMSTemplate);
			if (MapSMSTemplate[values].SMS_TH__c != null || MapSMSTemplate[values].SMS_TH__c != ''){
				console.log('template 1');
				var smsTH = MapSMSTemplate[values].SMS_TH__c;
                var fieldsTH = MapSMSTemplate[values].Field_Mapping_TH__c;
                if (fieldsTH != null && fieldsTH != ''){
				    fieldsTH = fieldsTH.split(",");
				    console.log('fieldsTH',fieldsTH);
				    for (var i = 0;i<fieldsTH.length;i++) {
					    var params = component.get("v.apptObj."+fieldsTH[i]);
                    
					    if (params == undefined || params == null || params == ''){
						    smsTH = smsTH.replace("{"+i+"}",'['+fieldsTH[i]+']');
					    }else{
                            if (fieldsTH[i] == 'App_Date_Format__c'){
                                smsTH = smsTH.replace("{"+i+"}",parseDateTH);
                            }else {
                                smsTH = smsTH.replace("{"+i+"}",params);
                            }
					    }
					// console.log('fields: ',"v.caseObj."+params);
                    }
                    MapSMSTemplate[values].SMS_TH__c = smsTH;
                }
                // else {
                //     MapSMSTemplate[values].SMS_TH__c = smsTH;
                // }
			}
			if (MapSMSTemplate[values].SMS_EN__c != null || MapSMSTemplate[values].SMS_EN__c != ''){
				console.log('template 2');
				var smsEN = MapSMSTemplate[values].SMS_EN__c;
                var fieldsEN = MapSMSTemplate[values].Field_Mapping_EN__c;
                if (fieldsEN != null && fieldsEN != ''){
				fieldsEN = fieldsEN.split(",");
				console.log('fieldsEN',fieldsEN);
				for (var i = 0;i<fieldsEN.length;i++) {
					var params = component.get("v.apptObj."+fieldsEN[i]);
					if (params == undefined || params == null || params == ''){
						smsEN = smsEN.replace("{"+i+"}",'['+fieldsEN[i]+']');
					}else{
                        if (fieldsEN[i] == 'App_Date_Format__c'){
                            smsEN = smsEN.replace("{"+i+"}",parseDateEN);
                        }else {
                            smsEN = smsEN.replace("{"+i+"}",params);
                        }
					}
					// console.log('fields: ',"v.caseObj."+params);
				}
                MapSMSTemplate[values].SMS_EN__c = smsEN;
            }
            }
            console.log('MapSMSTemplate[values].SMS_EN__c',MapSMSTemplate[values].SMS_EN__c);
            console.log('MapSMSTemplate[values].SMS_TH__c',MapSMSTemplate[values].SMS_TH__c);
            if (lang == 'TH'){
            component.set('v.message',MapSMSTemplate[values].SMS_TH__c);
            }else {
                component.set('v.message',MapSMSTemplate[values].SMS_EN__c);
            }
            component.set('v.MapSMSTemplate',MapSMSTemplate);
            console.log('Replace Template Success');
        }else {
            console.log('case2');
            component.set('v.message','');
        }
        
    },
	onSendMessage: function (component, event, helper) {
        //console.log('===> start ');
        
        //var params = event.getParam('arguments');
        var recordId = component.get('v.apptObj.Id');
        var contactNumber = component.get('v.contactNumber');
        //console.log('===> start =',recordId);
        //if (params) {
        //    recordId = params.caseId;
        //}
        
        var action = component.get("c.sendSMSMessage");
        var apptObj = component.get("v.apptObj");
        
        var message ='Please insert contact number and message';
        var smsmessage = component.get('v.message');
            if (component.get("v.message") == ''){
                helper.displayToast(component, 'Error', message);
			}else if (component.get("v.apptObj.account__r.phone") == ''){
                helper.displayToast(component, 'Error', message);
			}
			else{
                helper.startSpinner(component);
                
                action.setParams(
                    {"apptObj": apptObj,"message": smsmessage,"contactNumber":contactNumber}
                );
                action.setCallback(this, function(response) {
                    var c = response.getReturnValue();
                    console.log('return from sms:',c);
                    c = c.split("|");
                    var state = c[0];
                    console.log('state sms message:',state);
                    if (c[2].startsWith('{')){
                        if (state ==='SUCCESS'){
                            helper.displayToast(component,'Success','Message was sent.');
                            setTimeout(function() {
			                    window.location.reload();
		                    }, 2000);
                        }else if (state==='ERROR'){
                            var errors = JSON.parse(c[2]);
                            // errors = helper.parseObj(errors);
                            console.log('error:',errors.message);
                            helper.displayToast(component, "Error", errors.message);
                        }
                    }else{
                        if(state === "SUCCESS"){
                            helper.displayToast(component,'Success','Message was sent.');
                            setTimeout(function() {
			                    window.location.reload();
		                    }, 2000);
                        } else if (state === "ERROR"){
                            var errors = c[2];
                            console.log('errors:',errors);
                            helper.displayToast(component, 'Error', errors);
                        }
                    }
                    
                helper.stopSpinner(component);
                });
            }
        //Start - Fixed Issue Case No.9773
        component.set("v.isDisable", true);
        //End - Fixed Issue Case No.9773
        $A.enqueueAction(action);
        
    },

})