({
	getSMSCase: function(component, event, helper){
		var action = component.get('c.getSMSCase');
		var recordId = component.get('v.recordId');
		console.log(recordId);
		action.setParams({ "recordId": recordId});
		action.setCallback(this, function(data) {
			var caseObj = data.getReturnValue();
			// caseObj.SMS_Template = 'Template Test';
			component.set("v.caseObj", caseObj);
			component.set("v.contactNumber",caseObj.Contact_Number__c);
			// component.set("v.caseObj.SMS_Sent__c", true);
			console.log('CaseObj: ',caseObj);
			helper.parseDateTH(component);
        	helper.parseDateEN(component);
      });
      $A.enqueueAction(action);
	},
	getSVTM: function(component, event, helper){
		var action = component.get('c.getSVTM');
		// var recordId = component.get('v.recordId');
		// console.log(recordId);
		// action.setParams({ "recordId": recordId});
		action.setCallback(this, function(data) {
			component.set("v.MapSVTM", data.getReturnValue());
			// component.set("v.caseObj.SMS_Sent__c", true);
			var mapSVTM = component.get('v.MapSVTM');
			console.log('MapSVTM: ',mapSVTM);
			var caseObj = component.get('v.caseObj');
			var cat =caseObj.Case_Category_Level1__c + caseObj.Case_Category_Level2__c+caseObj.Case_Category_Level3__c;
			//cat = 'AppointmentMake Appointment, Allocate Doctor New patient - Multiple Appointments';
            cat = 'AppointmentMake Appointment, Allocate DoctorNew patient - Multiple Appointments';
			console.log('cat',cat);
			if(mapSVTM.hasOwnProperty(cat)){
				console.log('Have/Has Cat');
				component.set('v.templateId',mapSVTM[cat].SMS_Template__c);
				console.log('v.templateId',mapSVTM[cat].SMS_Template__c);
				// component.set('v.templateId','a0FN000000E4sQWMAZ');
				console.log(component.get('v.templateId'));
				helper.getSMSTemplate(component, event, helper);
				// setTimeout(() => {
				helper.getSMSTemplateKey(component, event, helper);
				// }, 1000);
			}
      });
      $A.enqueueAction(action);
	},
	parseObj: function (objFields) {
        return JSON.parse(JSON.stringify(objFields));
    },
	getSMSTemplate: function (component, event, helper) {
		var action = component.get('c.getSMSTemplate');
		var templateId = component.get('v.templateId');
		console.log('set param');
		// action.setParams({ "temId": templateId});
		action.setCallback(this, function(data) {
			console.log('callback');
			var MapSMSTemplate = data.getReturnValue();
			console.log('MapSMSTemplate',MapSMSTemplate);
			// console.log('SMSTemplate.SMS_TH__c',SMSTemplate.SMS_TH__c);
			// console.log('SMSTemplate.SMS_EN__c',SMSTemplate.SMS_EN__c);
			// console.log('SMSTemplate.Field_Mapping_TH__c',SMSTemplate.Field_Mapping_TH__c);
			// console.log('SMSTemplate.Field_Mapping_EN__c',SMSTemplate.Field_Mapping_EN__c);
			
			// console.log(fields);
			// if (SMSTemplate.SMS_TH__c != null || SMSTemplate.SMS_TH__c != ''){
			// 	console.log('template 1');
			// 	var smsTH = SMSTemplate.SMS_TH__c;
			// 	var fieldsTH = SMSTemplate.Field_Mapping_TH__c;
			// 	fieldsTH = fieldsTH.split(",");
			// 	console.log('fieldsTH',fieldsTH);
			// 	for (var i = 0;i<fieldsTH.length;i++) {
			// 		var params = component.get("v.caseObj."+fieldsTH[i]);
			// 		if (params == undefined || params == null || params == ''){
			// 			smsTH = smsTH.replace("{"+i+"}",'{'+fieldsTH[i]+'}');
			// 		}else{
			// 			smsTH = smsTH.replace("{"+i+"}",params);
			// 		}
			// 		// console.log('fields: ',"v.caseObj."+params);
			// 	}
			// 	SMSTemplate.SMS_TH__c = smsTH;
			// }
			// if (SMSTemplate.SMS_EN__c != null || SMSTemplate.SMS_EN__c != ''){
			// 	console.log('template 2');
			// 	var smsEN = SMSTemplate.SMS_EN__c;
			// 	var fieldsEN = SMSTemplate.Field_Mapping_EN__c;
			// 	fieldsEN = fieldsEN.split(",");
			// 	console.log('fieldsEN',fieldsEN);
			// 	for (var i = 0;i<fieldsEN.length;i++) {
			// 		var params = component.get("v.caseObj."+fieldsEN[i]);
			// 		if (params == undefined || params == null || params == ''){
			// 			smsEN = smsEN.replace("{"+i+"}",'{'+fieldsEN[i]+'}');
			// 		}else{
			// 			smsEN = smsEN.replace("{"+i+"}",params);
			// 		}
			// 		// console.log('fields: ',"v.caseObj."+params);
			// 	}
			// 	SMSTemplate.SMS_EN__c = smsEN;
			// }
			console.log('Replace Template Success');
			component.set('v.MapSMSTemplate',MapSMSTemplate);
			// console.log(SMSTemplate);
		});
		$A.enqueueAction(action);
	},
	getSMSTemplateKey: function (component, event, helper) {
		var action = component.get('c.getSMSTemplateKey');
		var templateId = component.get('v.templateId');
		var parseDateTH = component.get('v.parseDateTH');
		var parseDateEN = component.get('v.parseDateEN');
		console.log('parseDateTH',parseDateTH);
		console.log('parseDateEN',parseDateEN);
		
		console.log('set param');
		// action.setParams({ "temId": templateId});
		action.setCallback(this, function(data) {
			console.log('callback');
			var SMSTemplate = data.getReturnValue();
			console.log('SMSTemplate',SMSTemplate);
			console.log(SMSTemplate);
			component.set('v.SMSTemplate',SMSTemplate);
			var templateId = component.get('v.templateId');
			var MapSMSTemplate = component.get('v.MapSMSTemplate');
			console.log('templateId: ',templateId);
			
			// var SMSTemplate = component.get('v.SMSTemplate');
			setTimeout(() => {
			
            for (var i = 0 ;i<SMSTemplate.length;i++){
                if (MapSMSTemplate[SMSTemplate[i]].Id == templateId){
					component.set('v.Templates',MapSMSTemplate[SMSTemplate[i]].SMS_Template_Subject__c);
					console.log('Templates: ',component.get('v.Templates'));
					var smsTH = MapSMSTemplate[SMSTemplate[i]].SMS_TH__c;
					var fieldsTH = MapSMSTemplate[SMSTemplate[i]].Field_Mapping_TH__c;
					console.log('smsTH',smsTH);
					if (fieldsTH != null && fieldsTH != ''){
					fieldsTH = fieldsTH.split(",");
					console.log('fieldsTH',fieldsTH);
					for (var j = 0; j<fieldsTH.length;j++){
						console.log('CaseObj: ',component.get('v.caseObj'));
						
						var params = component.get("v.caseObj."+fieldsTH[j]);
						console.log('params',params);
						
						if (params == undefined || params == null || params == ''){
							smsTH = smsTH.replace("{"+j+"}",'['+fieldsTH[j]+']');
						}else{
							if (fieldsTH[i] == 'App_Date_Format__c'){
								smsTH = smsTH.replace("{"+j+"}",parseDateTH);
							}else {
								smsTH = smsTH.replace("{"+j+"}",params);
							}
						}
					}
					MapSMSTemplate[SMSTemplate[i]].SMS_TH__c = smsTH;
				}
					var smsEN = MapSMSTemplate[SMSTemplate[i]].SMS_EN__c;
					var fieldsEN = MapSMSTemplate[SMSTemplate[i]].Field_Mapping_EN__c;
					if (fieldsEN != null && fieldsEN != ''){
					fieldsEN = fieldsEN.split(",");
					for (var j = 0; j<fieldsEN.length;j++){
						var params = component.get("v.caseObj."+fieldsEN[j]);
						
						if (params == undefined || params == null || params == ''){
							smsEN = smsEN.replace("{"+j+"}",'['+fieldsEN[j]+']');
						}else{
							if (fieldsEN[i] == 'App_Date_Format__c'){
								smsEN = smsEN.replace("{"+j+"}",parseDateEN);
							}else {
								smsEN = smsEN.replace("{"+j+"}",params);
							}
						}
					}
					MapSMSTemplate[SMSTemplate[i]].SMS_EN__c = smsEN;
				}
					component.set('v.message',smsTH);
					component.set('v.MapSMSTemplate',MapSMSTemplate);
                }
            }
			helper.stopSpinner(component, event, helper);
		}, 1000);

		});
		$A.enqueueAction(action);

	},
	displayToast: function (component, type, message) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            type: type,
            message: message
        });
        toastEvent.fire();
	},
	startSpinner: function (component){
        component.set("v.loading",true);
    },
    stopSpinner: function (component){
        component.set("v.loading",false);
	},
	parseDateTH : function (component){
		var dt = component.get('v.caseObj.App_Date_Format__c');
		console.log('dt',dt);
		if (dt != null && dt != '' && dt != undefined){
			var splitdt = dt.split('-');
			// console.log('splitdt',splitdt);
			var strMonthCut = Array("", "ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค.");
			// console.log('strMonthCut',strMonthCut);
			var months = parseInt(splitdt[1]);
			console.log('monthsTH: ',months);
			
			var monthTH = strMonthCut[months];
			// console.log('monthTH',monthTH);
			var returnDateTH = splitdt[0] +' '+monthTH+' '+(parseInt(splitdt[2])+543);
			// console.log('returnDateTH: ',returnDateTH);
			component.set('v.parseDateTH',returnDateTH);
		}
	},
	parseDateEN : function (component){
		var dt = component.get('v.caseObj.App_Date_Format__c');
		// console.log('dt',dt);
		if (dt != null && dt != '' && dt != undefined){
			var splitdt = dt.split('-');
			// console.log('splitdt',splitdt);
			var strMonthCut = Array("", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC");
			// console.log('strMonthCut',strMonthCut);
			var months = parseInt(splitdt[1]);
			console.log('monthsEN: ',months);
			var monthEN = strMonthCut[months];
			// console.log('monthTH',monthEN);
			var returnDateEN = splitdt[0] +' '+monthEN+' '+splitdt[2];
			// console.log('returnDateEN: ',returnDateEN);
			component.set('v.parseDateEN',returnDateEN);
		}
	}
	// parseObj: function (objFields) {
    //     return JSON.parse(JSON.stringify(objFields));
	// },
})