public class BIH_CaseSendAutoSMS {

    
    @InvocableMethod(label='send sms'  description='for auto send sms' category='case')
    public static List<string> sendSms(List<string> caseid){
        try {
            for(string tmpString : caseid){
                //List<string> tmpcaseid = new List<string>();
                //tmpcaseid.add(tmpString);
                calloutSendSms(tmpString);
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        
        return caseid;
    }   
    
    public class SMSMessageRequest{
		@AuraEnabled
		public String mobilePhone {get;set;}
		@AuraEnabled
		public String message {get;set;}
		@AuraEnabled
		public String tag {get;set;}
		@AuraEnabled
		public String senderId {get;set;}
	}
    
    /*
    @future
    public static void calloutSendSms(List<string> caseid) {
        string messages = 'test test';
        string contactNumber = '';
        List<case> caseObj = [SELECT Id,Primary_Phone_Existing_Patient__c,Primary_Phone_New_Patient__c,Nationality__c,Account_Nationality__c,Registration_URL__c,
                              Last_Sent_Date__c,SMS_Sent__c FROM CASE WHERE id =:caseid[0]];
        
        if(caseObj.size()>0){
            
            contactNumber = caseObj[0].Primary_Phone_New_Patient__c != ''? caseObj[0].Primary_Phone_New_Patient__c : caseObj[0].Primary_Phone_Existing_Patient__c;
            
        }
        
        caseObj[0].Last_Sent_Date__c = DateTime.now();
		caseObj[0].SMS_Sent__c = true;
		SMSMessageRequest body = new SMSMessageRequest();
		// String smsmessage = 'Test SMS Message';
		// String mobilePhone = '';
		System.debug('Case Object:' + caseObj[0]);
		Http http = new Http();
        HttpRequest req = new HttpRequest();
		SMS_Log__c logs = new SMS_Log__c();
		logs.Case__c = caseObj[0].Id;
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

        UPDATE caseObj[0];

	}*/
    
    @future(callout=true)
    public static void calloutSendSms(string caseid) {
        string messagesEng = 'Kindly complete your registration online with Bumrungrad International Hospital:'+'\n'+'https://bumrungrad--uat.sandbox.my.salesforce-sites.com/liveAgentSetupFlow/preregistration?id='+caseid +'\n'+'\n'+'Thank you and we look forward to serving you.'+'\n'+'Registration Department.'+'\n'+'\n'+'Please kindly discard this request, if you have already submitted the link.'+'\n'+'\n'+'Before your arrival, please read the attached registration documents for your consideration and convenience in providing services and medical care. Please click https://sforce.co/3bxQvGR';
        string messagesThai = 'กรุณากรอกแบบฟอร์มลงทะเบียนออนไลน์ของท่านกับโรงพยาบาลบำรุงราษฎร์ ผ่านช่องทางคลิก:'+'\n'+' https://bumrungrad--uat.sandbox.my.salesforce-sites.com/liveAgentSetupFlow/preregistration?id='+caseid +'&lang=th'+'\n'+'\n'+'ขอขอบคุณที่ไว้วางใจโรงพยาบาลบำรุงราษฎร์'+'\n'+'แผนกลงทะเบียน'+'\n'+'\n'+'ขออภัยหากท่านได้กรอกข้อมูลประวัติดังกล่าวกับทางโรงพยาบาลแล้ว'+'\n'+'\n'+'โปรดอ่านเอกสารประกอบการลงทะเบียนที่แนบมานี้ก่อนเข้ารับบริการ เพื่อประกอบการตัดสินใจของท่านและเพื่อความสะดวกรวดเร็วในการให้บริการและบริบาลแก่ท่าน กรุณาคลิก https://sforce.co/3no5tlg';
        string messages = '';
        string contactNumber = '';
        string patientnationality = '';
        List<case> caseObj = [SELECT Id,Full_Name__c,First_Name_New_Patient__c,Last_Name_New_Patient__c,First_Name_Patient__c,Last_Name_Patient__c,Primary_Phone_Existing_Patient__c,Primary_Phone_New_Patient__c,Nationality__c,Account_Nationality__c,Registration_URL__c,Nationality_New_Patient__c,
                              Last_Sent_Date__c,SMS_Sent__c FROM CASE WHERE id =:caseid];
        string patientname = caseObj[0].Full_Name__c;
        string patientFirstnameManual = caseObj[0].First_Name_Patient__c;
        string patientLastnameManual = caseObj[0].Last_Name_Patient__c;
        string messagesEng1 = 'Dear Sir/Madam'+' '+patientname+'\n'+'\n'+'Kindly complete your registration online with Bumrungrad International Hospital:'+'\n'+' https://bumrungrad--uat.sandbox.my.salesforce-sites.com/liveAgentSetupFlow/preregistration?id='+caseid +'\n'+'\n'+'Thank you and we look forward to serving you.'+'\n'+'Registration Department.'+'\n'+'\n'+'Please kindly discard this request, if you have already submitted the link.'+'\n'+'\n'+'Before your arrival, please read the attached registration documents for your consideration and convenience in providing services and medical care. Please click https://sforce.co/3bxQvGR';
        string messagesThai1 = 'เรียน คุณ'+' '+patientname+'\n'+'\n'+'กรุณากรอกแบบฟอร์มลงทะเบียนออนไลน์ของท่านกับโรงพยาบาลบำรุงราษฎร์ ผ่านช่องทางคลิก:'+'\n'+' https://bumrungrad--uat.sandbox.my.salesforce-sites.com/liveAgentSetupFlow/preregistration?id='+caseid +'&lang=th'+'\n'+'\n'+'ขอขอบคุณที่ไว้วางใจโรงพยาบาลบำรุงราษฎร์'+'\n'+'แผนกลงทะเบียน'+'\n'+'\n'+'ขออภัยหากท่านได้กรอกข้อมูลประวัติดังกล่าวกับทางโรงพยาบาลแล้ว'+'\n'+'\n'+'โปรดอ่านเอกสารประกอบการลงทะเบียนที่แนบมานี้ก่อนเข้ารับบริการ เพื่อประกอบการตัดสินใจของท่านและเพื่อความสะดวกรวดเร็วในการให้บริการและบริบาลแก่ท่าน กรุณาคลิก https://sforce.co/3no5tlg';
        string messagesEng2 = 'Dear Sir/Madam'+' '+patientFirstnameManual+' '+patientLastnameManual+'\n'+'\n'+messagesEng;
        string messagesThai2 = 'เรียน คุณ'+' '+patientFirstnameManual+' '+patientLastnameManual+'\n'+'\n'+messagesThai;
        system.debug('caseObj[0].First_Name_Patient__c'+caseObj[0].First_Name_Patient__c);
        if(caseObj.size() > 0){
            
            contactNumber = caseObj[0].Primary_Phone_New_Patient__c != ''? caseObj[0].Primary_Phone_New_Patient__c : caseObj[0].Primary_Phone_Existing_Patient__c;
  			patientnationality = caseObj[0].Nationality_New_Patient__c;
            if(patientnationality == 'Thai' && caseObj[0].Full_Name__c != ' ' && caseObj[0].Full_Name__c != null){
                messages = messagesThai1;
            }else if(patientnationality == 'Thai' && caseObj[0].First_Name_Patient__c != ' '&& caseObj[0].First_Name_Patient__c != null){
                messages = messagesThai2;
            }else if(patientnationality != 'Thai' && caseObj[0].Full_Name__c != ' '&& caseObj[0].Full_Name__c != null){
                messages = messagesEng1;
            }else if(patientnationality != 'Thai' && caseObj[0].First_Name_Patient__c != ' ' && caseObj[0].First_Name_Patient__c != null){
                messages = messagesEng2;
            }
            else{
                messages = messagesEng;
            }
        }
        
        //caseObj[0].Last_Sent_Date__c = DateTime.now();
		//caseObj[0].SMS_Sent__c = true;
		SMSMessageRequest body = new SMSMessageRequest();
		// String smsmessage = 'Test SMS Message';
		// String mobilePhone = '';
		System.debug('Case Object:' + caseObj[0]);
		Http http = new Http();
        HttpRequest req = new HttpRequest();
		SMS_Log__c logs = new SMS_Log__c();
		logs.Case__c = caseObj[0].Id;
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
		
		//insert logs;
		// if (req.getBody() != null && req.getBody() != ''){
		// 	OnlineServiceLog.generateContentVersionRequest(logs,req.getBody());
		// }else {
		// 	OnlineServiceLog.generateContentVersionRequest(logs,endpoint);
		// }
		// if (res.getBody() != null && res.getBody() != '' && res.getBody().equalsIgnoreCase('true')) {
		// 	OnlineServiceLog.generateContentVersionResponse(logs,res.getBody());
		// }

        //Update caseObj[0];

	}
}