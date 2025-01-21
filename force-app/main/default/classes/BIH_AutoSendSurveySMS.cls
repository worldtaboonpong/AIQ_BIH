public class BIH_AutoSendSurveySMS {
    
    @InvocableMethod(label='Auto Send Survey SMS'  description='for auto send survey' category='surveyInvitation')
    public static List<string> sendSms(List<string> surveyInvitationid){
        try {
            for(string tmpString : surveyInvitationid){
                //List<string> tmpcaseid = new List<string>();
                //tmpcaseid.add(tmpString);
                calloutSendSms(tmpString);
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        
        return surveyInvitationid;
    }
  
    
    public class SMSMessageRequest{
		@AuraEnabled
		public String Phone {get;set;}
		@AuraEnabled
		public String message {get;set;}
		@AuraEnabled
		public String tag {get;set;}
		@AuraEnabled
		public String senderId {get;set;}
	}

    @future(callout=true)
    public static void calloutSendSms(string surveyInvitationid) {
        //string messagesEng = 'Kindly complete your registration online with Bumrungrad International Hospital:'+'\n'+' https://bumrungrad.my.salesforce-sites.com/liveAgentSetupFlow/preregistration?id='+caseid +'\n'+'\n'+'Thank you and we look forward to serving you.'+'\n'+'Registration Department.'+'\n'+'\n'+'Please kindly discard this request, if you have already submitted the link.'+'\n'+'\n'+'Before your arrival, please read the attached registration documents for your consideration and convenience in providing services and medical care. Please click https://sforce.co/3bxQvGR';
        //string messagesThai = 'กรุณากรอกแบบฟอร์มลงทะเบียนออนไลน์ของท่านกับโรงพยาบาลบำรุงราษฎร์ ผ่านช่องทางคลิก:'+'\n'+' https://bumrungrad.my.salesforce-sites.com/liveAgentSetupFlow/preregistration?id='+caseid +'&lang=th'+'\n'+'\n'+'ขอขอบคุณที่ไว้วางใจโรงพยาบาลบำรุงราษฎร์'+'\n'+'แผนกลงทะเบียน'+'\n'+'\n'+'ขออภัยหากท่านได้กรอกข้อมูลประวัติดังกล่าวกับทางโรงพยาบาลแล้ว'+'\n'+'\n'+'โปรดอ่านเอกสารประกอบการลงทะเบียนที่แนบมานี้ก่อนเข้ารับบริการ เพื่อประกอบการตัดสินใจของท่านและเพื่อความสะดวกรวดเร็วในการให้บริการและบริบาลแก่ท่าน กรุณาคลิก https://sforce.co/3no5tlg';
        string messages = '';
        string contactNumber = '';
        string patientnationality = '';
        List<SurveyInvitation> surveyInvitationObj = [SELECT Id,InvitationLink ,Participant.id,Participant.Name,Phone__c FROM SurveyInvitation  WHERE id =:surveyInvitationid];
        string patientid = surveyInvitationObj[0].Participant.id;
        string patientname = surveyInvitationObj[0].Participant.Name;
        string patientphone = surveyInvitationObj[0].Phone__c;
        string surveyLink = surveyInvitationObj[0].InvitationLink;
        string messagesEng1 = 'Dear Valued Customer'+'\n'+'Mr./Ms.'+' '+patientname+'\n'+'\n'+surveyLink;
        //string messagesThai1 = 'เรียนท่านผู้ใช้บริการ'+'\n'+'คุณ'+' '+patientThainame+'\n'+'\n'+'ขอแจ้งให้ท่านทราบว่า ขณะนี้ทางโรงพยาบาลบำรุงราษฎร์ กำลังดำเนินการติดต่อบริษัทประกันของท่าน เพื่อขอหนังสือยืนยันความคุ้มครองสำหรับ'+'\n'+'\n'+'หัตถการ/การรักษา :'+'\n'+prod+'\n'+'\n'+'หากท่านต้องการสอบถามข้อมูลเพิ่มเติม กรุณาติดต่อ แผนกตรวจสอบสิทธิ์ความคุ้มครองก่อนการรักษา +66 (0) 2011 2289 ';
        //string messagesThai2 = 'เรียนท่านผู้ใช้บริการ'+'\n'+'คุณ'+' '+patientname+'\n'+'\n'+'ขอแจ้งให้ท่านทราบว่า ขณะนี้ทางโรงพยาบาลบำรุงราษฎร์ กำลังดำเนินการติดต่อบริษัทประกันของท่าน เพื่อขอหนังสือยืนยันความคุ้มครองสำหรับ'+'\n'+'\n'+'หัตถการ/การรักษา :'+'\n'+prod+'\n'+'\n'+'หากท่านต้องการสอบถามข้อมูลเพิ่มเติม กรุณาติดต่อ แผนกตรวจสอบสิทธิ์ความคุ้มครองก่อนการรักษา +66 (0) 2011 2289 ';
       	//string messagesEng2 = 'Dear Valued Customer'+' \n'+'\n'+'Please be informed that Bumrungrad International Hospital is following up with the insurance company for coverage of' +'\n'+'\n'+'procedure/treatment :'+'\n'+prod+'\n'+'\n'+'For further information, please contact us'+'\n'+ 'Pre-authorization department at +66 (0) 2011 2289 ';
        //string messagesThai3 = 'เรียนท่านผู้ใช้บริการ'+' \n'+'\n'+'ขอแจ้งให้ท่านทราบว่า ขณะนี้ทางโรงพยาบาลบำรุงราษฎร์ กำลังดำเนินการติดต่อบริษัทประกันของท่าน เพื่อขอหนังสือยืนยันความคุ้มครองสำหรับ'+'\n'+'\n'+'หัตถการ/การรักษา :'+'\n'+prod+'\n'+'\n'+'หากท่านต้องการสอบถามข้อมูลเพิ่มเติม กรุณาติดต่อ แผนกตรวจสอบสิทธิ์ความคุ้มครองก่อนการรักษา +66 (0) 2011 2289 ';
        List<Contact> ContactObj = [SELECT Id,Phone FROM Contact  WHERE id =:patientid];
    
        
        if(surveyInvitationObj.size() > 0){
            
            contactNumber = surveyInvitationObj[0].Phone__c != ''? surveyInvitationObj[0].Phone__c : surveyInvitationObj[0].Phone__c;
                messages = messagesEng1;
            
           
        }
        
		SMSMessageRequest body = new SMSMessageRequest();
		System.debug('Contact Object:' + ContactObj[0]);
		Http http = new Http();
        HttpRequest req = new HttpRequest();
        SMS_Log__c logs = new SMS_Log__c();
		logs.Contact__c = ContactObj[0].Id;
		//body.mobilePhone = contactNumber;
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