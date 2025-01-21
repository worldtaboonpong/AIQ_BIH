public class BIH_AutoSendPreAuthSMS {
    
    
    @InvocableMethod(label='preauth send sms'  description='for auto send sms' category='case')
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

    @future(callout=true)
    public static void calloutSendSms(string caseid) {
        //string messagesEng = 'Kindly complete your registration online with Bumrungrad International Hospital:'+'\n'+' https://bumrungrad.my.salesforce-sites.com/liveAgentSetupFlow/preregistration?id='+caseid +'\n'+'\n'+'Thank you and we look forward to serving you.'+'\n'+'Registration Department.'+'\n'+'\n'+'Please kindly discard this request, if you have already submitted the link.'+'\n'+'\n'+'Before your arrival, please read the attached registration documents for your consideration and convenience in providing services and medical care. Please click https://sforce.co/3bxQvGR';
        //string messagesThai = 'กรุณากรอกแบบฟอร์มลงทะเบียนออนไลน์ของท่านกับโรงพยาบาลบำรุงราษฎร์ ผ่านช่องทางคลิก:'+'\n'+' https://bumrungrad.my.salesforce-sites.com/liveAgentSetupFlow/preregistration?id='+caseid +'&lang=th'+'\n'+'\n'+'ขอขอบคุณที่ไว้วางใจโรงพยาบาลบำรุงราษฎร์'+'\n'+'แผนกลงทะเบียน'+'\n'+'\n'+'ขออภัยหากท่านได้กรอกข้อมูลประวัติดังกล่าวกับทางโรงพยาบาลแล้ว'+'\n'+'\n'+'โปรดอ่านเอกสารประกอบการลงทะเบียนที่แนบมานี้ก่อนเข้ารับบริการ เพื่อประกอบการตัดสินใจของท่านและเพื่อความสะดวกรวดเร็วในการให้บริการและบริบาลแก่ท่าน กรุณาคลิก https://sforce.co/3no5tlg';
        string messages = '';
        string contactNumber = '';
        string patientnationality = '';
        List<case> caseObj = [SELECT Id,Patient_Local_Name__c,Full_Name__c,Phone__c,Procedure_1__c,
                              Last_Sent_Date__c,SMS_Sent__c FROM CASE WHERE id =:caseid];
        string patientname = caseObj[0].Full_Name__c;
        string patientThainame = caseObj[0].Patient_Local_Name__c;
        string prod = caseObj[0].Procedure_1__c;
        string messagesEng1 = 'Dear Valued Customer'+'\n'+'Mr./Ms.'+' '+patientname+'\n'+'\n'+'Please be informed that Bumrungrad International Hospital is following up with the insurance company for coverage of'+'\n'+'\n'+ 'procedure/treatment :'+'\n'+prod+'\n'+'\n'+'For further information, please contact us'+'\n'+ 'Pre-authorization department at +66 (0) 2011 2289 ';
        string messagesThai1 = 'เรียนท่านผู้ใช้บริการ'+'\n'+'คุณ'+' '+patientThainame+'\n'+'\n'+'ขอแจ้งให้ท่านทราบว่า ขณะนี้ทางโรงพยาบาลบำรุงราษฎร์ กำลังดำเนินการติดต่อบริษัทประกันของท่าน เพื่อขอหนังสือยืนยันความคุ้มครองสำหรับ'+'\n'+'\n'+'หัตถการ/การรักษา :'+'\n'+prod+'\n'+'\n'+'หากท่านต้องการสอบถามข้อมูลเพิ่มเติม กรุณาติดต่อ แผนกตรวจสอบสิทธิ์ความคุ้มครองก่อนการรักษา +66 (0) 2011 2289 ';
        string messagesThai2 = 'เรียนท่านผู้ใช้บริการ'+'\n'+'คุณ'+' '+patientname+'\n'+'\n'+'ขอแจ้งให้ท่านทราบว่า ขณะนี้ทางโรงพยาบาลบำรุงราษฎร์ กำลังดำเนินการติดต่อบริษัทประกันของท่าน เพื่อขอหนังสือยืนยันความคุ้มครองสำหรับ'+'\n'+'\n'+'หัตถการ/การรักษา :'+'\n'+prod+'\n'+'\n'+'หากท่านต้องการสอบถามข้อมูลเพิ่มเติม กรุณาติดต่อ แผนกตรวจสอบสิทธิ์ความคุ้มครองก่อนการรักษา +66 (0) 2011 2289 ';
       	string messagesEng2 = 'Dear Valued Customer'+' \n'+'\n'+'Please be informed that Bumrungrad International Hospital is following up with the insurance company for coverage of' +'\n'+'\n'+'procedure/treatment :'+'\n'+prod+'\n'+'\n'+'For further information, please contact us'+'\n'+ 'Pre-authorization department at +66 (0) 2011 2289 ';
        string messagesThai3 = 'เรียนท่านผู้ใช้บริการ'+' \n'+'\n'+'ขอแจ้งให้ท่านทราบว่า ขณะนี้ทางโรงพยาบาลบำรุงราษฎร์ กำลังดำเนินการติดต่อบริษัทประกันของท่าน เพื่อขอหนังสือยืนยันความคุ้มครองสำหรับ'+'\n'+'\n'+'หัตถการ/การรักษา :'+'\n'+prod+'\n'+'\n'+'หากท่านต้องการสอบถามข้อมูลเพิ่มเติม กรุณาติดต่อ แผนกตรวจสอบสิทธิ์ความคุ้มครองก่อนการรักษา +66 (0) 2011 2289 ';
        //string messagesEng2 = 'Dear Sir/Madam'+' '+patientThainame+' \n'+'\n'+messagesEng;
        //string messagesThai2 = 'เรียน คุณ'+' '+patientFirstnameManual+' '+patientLastnameManual+'\n'+'\n'+messagesThai;

        if(caseObj.size() > 0){
            
            contactNumber = caseObj[0].Phone__c != ''? caseObj[0].Phone__c : caseObj[0].Phone__c;
  			//patientnationality = caseObj[0].Nationality_New_Patient__c;
            if(caseObj[0].Patient_Local_Name__c != ' ' && caseObj[0].Patient_Local_Name__c != null){
                messages = messagesEng1+' \n'+'\n'+messagesThai1;
            }else if(caseObj[0].Full_Name__c != ' '&& caseObj[0].Full_Name__c != null){
                messages = messagesEng1+' \n'+'\n'+messagesThai2;
            }
            else{
                messages = messagesEng2+' \n'+'\n'+messagesThai3;
            }
        }
        
		SMSMessageRequest body = new SMSMessageRequest();
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
        

        req.setHeader('Ocp-Apim-Subscription-Key',BIH_Constants.SUBSCRIPTION_KEY);
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


	}

}