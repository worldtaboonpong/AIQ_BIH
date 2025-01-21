global with sharing class BIH_SendSMSService {
		
	global class SMSMessageRequest{
		@AuraEnabled
		public String mobilePhone {get;set;}
		@AuraEnabled
		public String message {get;set;}
		@AuraEnabled
		public String tag {get;set;}
		@AuraEnabled
		public String senderId {get;set;}
	}
	global static String getAppointmentInformation(String messages,Case caseObj,String contactNumber) {
        caseObj.Last_Sent_Date__c = DateTime.now();
		caseObj.SMS_Sent__c = true;
		SMSMessageRequest body = new SMSMessageRequest();
		// String smsmessage = 'Test SMS Message';
		// String mobilePhone = '';
		System.debug('Case Object:' + caseObj);
		Http http = new Http();
        HttpRequest req = new HttpRequest();
		SMS_Log__c logs = new SMS_Log__c();
		logs.Case__c = caseObj.Id;
		body.mobilePhone = contactNumber;
		logs.Contact_Number__c = contactNumber;
		body.senderId = '0';
		body.tag = 'U';
        req.setMethod('POST');
		body.message = messages;
		logs.SMS_Message__c = messages;
		req.setBody(JSON.serialize(body));
        System.debug('setBody : '+JSON.serialize(body));
        
        // Set Request Header
        req.setHeader('Ocp-Apim-Subscription-Key',BIH_Constants.SUBSCRIPTION_KEY);
        // req.setHeader('Ocp-Apim-Subscription-Key','BIH_Constants.SUBSCRIPTION_KEY');
		// req.setHeader('Content-Type', 'application/json');
		System.debug('SUBSCRIPTION_KEY : '+BIH_Constants.SUBSCRIPTION_KEY);
		
		req.setHeader('Content-Type', 'application/json');
		req.setTimeout(Integer.ValueOf(BIH_Constants.SET_TIMEOUT_SERVICE));
        System.debug('setTimeout : '+Integer.ValueOf(BIH_Constants.SET_TIMEOUT_SERVICE));
		String endpoint =BIH_Constants.END_POINT_SMS_MESSAGE;
        System.debug('endpoint : '+BIH_Constants.END_POINT_SMS_MESSAGE);
		req.setEndpoint(endpoint);//app config end point
		System.debug(endpoint);
		logs.SMS_Request__c = req.getBody();
        HttpResponse res = http.send(req);
		logs.SMS_Response__c = res.getBody();
		System.debug(res.getBody());
		String strResponse = '';
		if(res.getStatusCode() == 200 || res.getStatusCode() == 206){
			String sCode = string.valueof(res.getStatusCode());
			strResponse += 'SUCCESS|';
			strResponse += sCode + '|';
			strResponse += res.getBody();
		}else{
			String sCode = string.valueof(res.getStatusCode());
			strResponse += 'ERROR|';
			strResponse += sCode + '|';
			strResponse += res.getBody();
            System.debug('******************* error test 1');
            System.debug('sCode : '+sCode);
            System.debug('StatusCode : '+res.getStatusCode());
            System.debug('strResponse : '+strResponse);
		}
		// System.debug(air[0].visitTypeString);
		
		insert logs;
		// if (req.getBody() != null && req.getBody() != ''){
		// 	OnlineServiceLog.generateContentVersionRequest(logs,req.getBody());
		// }else {
		// 	OnlineServiceLog.generateContentVersionRequest(logs,endpoint);
		// }
		// if (res.getBody() != null && res.getBody() != '' && res.getBody().equalsIgnoreCase('true')) {
		// 	OnlineServiceLog.generateContentVersionResponse(logs,res.getBody());
		// }

        UPDATE caseObj;

		return strResponse;
	}
    global static String getAppointmentObjInformation(String messages,Appointment__c apptObj,String contactNumber) {
        apptObj.Last_Sent_Date__c = DateTime.now();
		apptObj.SMS_Sent__c = true;
		SMSMessageRequest body = new SMSMessageRequest();
		// String smsmessage = 'Test SMS Message';
		// String mobilePhone = '';
		System.debug('Appt Object:' + apptObj);
		Http http = new Http();
        HttpRequest req = new HttpRequest();
		SMS_Log__c logs = new SMS_Log__c();
		logs.Appointment__c = apptObj.Id;
		body.mobilePhone = contactNumber;
		logs.Contact_Number__c = contactNumber;
		body.senderId = '0';
		body.tag = 'U';
        req.setMethod('POST');
		body.message = messages;
		logs.SMS_Message__c = messages;
		req.setBody(JSON.serialize(body));
        System.debug('setBody : '+JSON.serialize(body));
        
        // Set Request Header
        req.setHeader('Ocp-Apim-Subscription-Key',BIH_Constants.SUBSCRIPTION_KEY);
        // req.setHeader('Ocp-Apim-Subscription-Key','BIH_Constants.SUBSCRIPTION_KEY');
		// req.setHeader('Content-Type', 'application/json');
		System.debug('SUBSCRIPTION_KEY : '+BIH_Constants.SUBSCRIPTION_KEY);
		
		req.setHeader('Content-Type', 'application/json');
		req.setTimeout(Integer.ValueOf(BIH_Constants.SET_TIMEOUT_SERVICE));
        System.debug('setTimeout : '+Integer.ValueOf(BIH_Constants.SET_TIMEOUT_SERVICE));
		String endpoint =BIH_Constants.END_POINT_SMS_MESSAGE;
        System.debug('endpoint : '+BIH_Constants.END_POINT_SMS_MESSAGE);
		req.setEndpoint(endpoint);//app config end point
		System.debug(endpoint);
		logs.SMS_Request__c = req.getBody();
        HttpResponse res = http.send(req);
		logs.SMS_Response__c = res.getBody();
		System.debug(res.getBody());
		String strResponse = '';
		if(res.getStatusCode() == 200 || res.getStatusCode() == 206){
			String sCode = string.valueof(res.getStatusCode());
			strResponse += 'SUCCESS|';
			strResponse += sCode + '|';
			strResponse += res.getBody();
		}else{
			String sCode = string.valueof(res.getStatusCode());
			strResponse += 'ERROR|';
			strResponse += sCode + '|';
			strResponse += res.getBody();
            System.debug('******************* error test 1');
            System.debug('sCode : '+sCode);
            System.debug('StatusCode : '+res.getStatusCode());
            System.debug('strResponse : '+strResponse);
		}
		// System.debug(air[0].visitTypeString);
		
		insert logs;
		// if (req.getBody() != null && req.getBody() != ''){
		// 	OnlineServiceLog.generateContentVersionRequest(logs,req.getBody());
		// }else {
		// 	OnlineServiceLog.generateContentVersionRequest(logs,endpoint);
		// }
		// if (res.getBody() != null && res.getBody() != '' && res.getBody().equalsIgnoreCase('true')) {
		// 	OnlineServiceLog.generateContentVersionResponse(logs,res.getBody());
		// }

        UPDATE apptObj;

		return strResponse;
	}
}