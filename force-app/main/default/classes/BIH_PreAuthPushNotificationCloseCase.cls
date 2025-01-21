public class BIH_PreAuthPushNotificationCloseCase {
    
        
    
    @InvocableMethod(label='preauth send push notification final'  description='for auto send push notification' category='case')
    public static List<string> sendPushNotification(List<string> caseid){
        try {
            for(string tmpString : caseid){
                //List<string> tmpcaseid = new List<string>();
                //tmpcaseid.add(tmpString);
                calloutSendPushNotification(tmpString);
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        
        return caseid;
    }   
    
    public class PushNotificationMessageRequest{
		@AuraEnabled
		public String hn {get;set;}
		@AuraEnabled
		public String title {get;set;}
		@AuraEnabled
		public String body {get;set;}
		@AuraEnabled
		public String deeplinkUrl {get;set;}
        @AuraEnabled
		public String actionUrl {get;set;}
        @AuraEnabled
		public String mediaUrl {get;set;}
        @AuraEnabled
		public String notificationType {get;set;}
	}

    @future(callout=true)
    public static void calloutSendPushNotification(string caseid) {
        //string messagesEng = 'Kindly complete your registration online with Bumrungrad International Hospital:'+'\n'+' https://bumrungrad.my.salesforce-sites.com/liveAgentSetupFlow/preregistration?id='+caseid +'\n'+'\n'+'Thank you and we look forward to serving you.'+'\n'+'Registration Department.'+'\n'+'\n'+'Please kindly discard this request, if you have already submitted the link.'+'\n'+'\n'+'Before your arrival, please read the attached registration documents for your consideration and convenience in providing services and medical care. Please click https://sforce.co/3bxQvGR';
        //string messagesThai = 'กรุณากรอกแบบฟอร์มลงทะเบียนออนไลน์ของท่านกับโรงพยาบาลบำรุงราษฎร์ ผ่านช่องทางคลิก:'+'\n'+' https://bumrungrad.my.salesforce-sites.com/liveAgentSetupFlow/preregistration?id='+caseid +'&lang=th'+'\n'+'\n'+'ขอขอบคุณที่ไว้วางใจโรงพยาบาลบำรุงราษฎร์'+'\n'+'แผนกลงทะเบียน'+'\n'+'\n'+'ขออภัยหากท่านได้กรอกข้อมูลประวัติดังกล่าวกับทางโรงพยาบาลแล้ว'+'\n'+'\n'+'โปรดอ่านเอกสารประกอบการลงทะเบียนที่แนบมานี้ก่อนเข้ารับบริการ เพื่อประกอบการตัดสินใจของท่านและเพื่อความสะดวกรวดเร็วในการให้บริการและบริบาลแก่ท่าน กรุณาคลิก https://sforce.co/3no5tlg';
        
        string messages = '';
        string contactNumber = '';
        string patientnationality = '';
        List<case> caseObj = [SELECT Id,Patient_Local_Name__c,Full_Name__c,Phone__c,Procedure_1__c,
                              Last_Sent_Date__c,SMS_Sent__c,Hospital_Number_HN__c,Appointment_Date__c,Sent_First_Email_to_Insurance_Customer__c,Send_Email_to_Insurance_Customer__c FROM CASE WHERE id =:caseid];
        string patientname = caseObj[0].Full_Name__c;
        string patientThainame = caseObj[0].Patient_Local_Name__c;
        string prod = caseObj[0].Procedure_1__c;
        string hn =  caseObj[0].Hospital_Number_HN__c;
        DateTime dt =  Date.valueOf(caseObj[0].Appointment_Date__c);
        String strDatetime  = dt.format('dd-MM-yyyy');
        string title = 'Dear'+' '+patientname;
        string titleThai = 'เรียน คุณ '+' '+patientThainame;
        string notitype = 'notice';
 
        //string messagesEng1 = 'Please be informed that Bumrungrad International Hospital is following up with the insurance company for coverage of'+'\n'+'\n'+ 'procedure/treatment :'+'\n'+prod+'\n'+'\n'+'For further information, please contact us'+'\n'+ 'Pre-authorization department at +66 (0) 2011 2289 ';
        //string messagesThai1 = 'ขอแจ้งให้ท่านทราบว่า ขณะนี้ทางโรงพยาบาลบำรุงราษฎร์ กำลังดำเนินการติดต่อบริษัทประกันของท่าน เพื่อขอหนังสือยืนยันความคุ้มครองสำหรับ'+'\n'+'\n'+'หัตถการ/การรักษา :'+'\n'+prod+'\n'+'\n'+'หากท่านต้องการสอบถามข้อมูลเพิ่มเติม กรุณาติดต่อ แผนกตรวจสอบสิทธิ์ความคุ้มครองก่อนการรักษา +66 (0) 2011 2289 ';
        //string messagesThai2 = 'ขอแจ้งให้ท่านทราบว่า ขณะนี้ทางโรงพยาบาลบำรุงราษฎร์ กำลังดำเนินการติดต่อบริษัทประกันของท่าน เพื่อขอหนังสือยืนยันความคุ้มครองสำหรับ'+'\n'+'\n'+'หัตถการ/การรักษา :'+'\n'+prod+'\n'+'\n'+'หากท่านต้องการสอบถามข้อมูลเพิ่มเติม กรุณาติดต่อ แผนกตรวจสอบสิทธิ์ความคุ้มครองก่อนการรักษา +66 (0) 2011 2289 ';
       	//string messagesEng2 =  'Please be informed that Bumrungrad International Hospital is following up with the insurance company for coverage of' +'\n'+'\n'+'procedure/treatment :'+'\n'+prod+'\n'+'\n'+'For further information, please contact us'+'\n'+ 'Pre-authorization department at +66 (0) 2011 2289 ';
        //string messagesThai3 = 'ขอแจ้งให้ท่านทราบว่า ขณะนี้ทางโรงพยาบาลบำรุงราษฎร์ กำลังดำเนินการติดต่อบริษัทประกันของท่าน เพื่อขอหนังสือยืนยันความคุ้มครองสำหรับ'+'\n'+'\n'+'หัตถการ/การรักษา :'+'\n'+prod+'\n'+'\n'+'หากท่านต้องการสอบถามข้อมูลเพิ่มเติม กรุณาติดต่อ แผนกตรวจสอบสิทธิ์ความคุ้มครองก่อนการรักษา +66 (0) 2011 2289 ';
        string pushnotiEngOpen =  'We would like to inform you that we have submitted your pre-approval for treatment on '+' '+strDatetime+' '+'to your insurance company for coverage consideration. The insurance company may take 3 to 7 business days to respond. As soon as we receive their response, we shall inform you.'+'\n'+'\n'+'Best regards,'+'\n'+ ' Pre-authorization, Bumrungrad International Hospital ';       
        string pushnotiEng3days = 'We would like to update you that your insurance company is reviewing your case for pre-approval coverage. The hospital will continue to follow up your case and will update you as soon as possible on any development.'+'\n'+ ' Thank you for your patience.'+'\n'+ ' Best regards, Pre-authorization, Bumrungrad International Hospital ';
        string pushnotiEngFinal = 'Please be informed that the insurance company has responded about your pre-approval request. Please refer to your email for coverage information or contact us at 02-0112289 for more information. For appointment arrangement, please contact 02-066-8888.'+'\n'+'\n'+'Best regards,'+'\n'+'\n'+'Pre-authorization, Bumrungrad International Hospital ';
        string pushnotiThaiOpen = 'ทางแผนกตรวจสอบสิทธิ์ก่อนการทำหัตถการของโรงพยาบาลฯ ได้ทำการแจ้งเคสของท่านไปยังบริษัทประกันเพื่อทำการพิจารณาความคุ้มครองสำหรับนัดหมายวันที่ '+' '+strDatetime+' '+' แล้ว ซึ่งบริษัทประกันอาจใช้ระยะเวลา 3 ถึง 7 วัน ในการพิจารณาและตอบกลับ โดยทางโรงพยาบาลจะทำการติดตามผลการพิจารณา และแจ้งให้ท่านทราบเป็นลำดับถัดไป '+'\n'+ 'ขอแสดงความนับถือ'+'\n'+ ' แผนกตรวจสอบสิทธิ์ก่อนการทำหัตถการ'+'\n'+ ' โรงพยาบาลบำรุงราษฎร์อินเตอร์เนชั่นแนล'; 
        string pushnotiThai3days = 'โรงพยาบาลบำรุงราษฎร์ อินเตอร์เนชั่นเนล ขอแจ้งความคืบหน้าให้ท่านทราบว่า บริษัทประกันยังคงอยู่ในขั้นตอนพิจารณาความคุ้มครองของท่าน ทางโรงพยาบาล ยังคงทำการติดตามผล และแจ้งให้ท่านทราบเป็นลำดับถัดไป '+'\n'+ 'ขอแสดงความนับถือ '+'\n'+ 'แผนกตรวจสอบสิทธิ์ก่อนการทำหัตถการ'+'\n'+ ' โรงพยาบาลบำรุงราษฎร์ อินเตอร์เนชั่นแนล';
        string pushnotiThaiFinal = 'โรงพยาบาลบำรุงราษฎร์ อินเตอร์เนชั่นแนล ขอเรียนให้ท่านทราบว่าบริษัทประกันฯ ได้ตอบกลับเกี่ยวกับคำขออนุมัติของท่านเป็นที่เรียบร้อยแล้ว '+'\n'+ 'ท่านสามารถตรวจสอบข้อมูลจากอีเมลของท่าน หรือติดต่อแผนกตรวจสอบสิทธิ์ก่อนการทำหัตถการที่ 02-011-2289 สำหรับข้อมูลเพิ่มเติม '+'\n'+ 'สำหรับการนัดหมายกรุณาติดต่อ 1378 '+'\n'+'\n'+ 'ขอแสดงความนับถือ'+'\n'+'\n'+'แผนกตรวจสอบสิทธิ์ก่อนการทำหัตถการ, โรงพยาบาลบำรุงราฎร์ อินเตอร์เนชั่นแนล';
        
        
        
        if(caseObj.size() > 0){
            contactNumber = caseObj[0].Hospital_Number_HN__c != ''? caseObj[0].Hospital_Number_HN__c : caseObj[0].Hospital_Number_HN__c;
            if(caseObj[0].Patient_Local_Name__c != ' ' && caseObj[0].Patient_Local_Name__c != null){
                messages = pushnotiThaiFinal;
                title = titleThai;
            }else if(caseObj[0].Full_Name__c != ' '&& caseObj[0].Full_Name__c != null){
                messages = pushnotiEngFinal;
            }
            else{
                messages = pushnotiEngFinal+' \n'+'\n'+pushnotiThaiFinal;
            }
        }
        
		PushNotificationMessageRequest body = new PushNotificationMessageRequest();
		System.debug('Case Object:' + caseObj[0]);
		Http http = new Http();
        HttpRequest req = new HttpRequest();
        SMS_Log__c logs = new SMS_Log__c();

		logs.Case__c = caseObj[0].Id;
        body.notificationType = notitype;
		body.hn = hn;
        body.title = title;
        body.body = messages;
        body.actionUrl = null;
        body.mediaUrl = null;
        body.deeplinkUrl = 'https://www.bumrungrad.com/en/notification/all';
        

        req.setMethod('POST');
		logs.SMS_Message__c = messages;
		req.setBody(JSON.serialize(body));
        System.debug('setBody : '+JSON.serialize(body));

        String endpoint ='https://bihtest.azure-api.net/customer/test/notifications/send-via-hn';
        String subscriptionKey = '2aa66c5ead5645e484c2769e9a24e5ef';
        

        req.setHeader('Ocp-Apim-Subscription-Key',BIH_Constants.SUBSCRIPTION_PUSH_NOTI_KEY);
		System.debug('SUBSCRIPTION_KEY : '+BIH_Constants.SUBSCRIPTION_PUSH_NOTI_KEY);
		req.setHeader('Content-Type', 'application/json');
		req.setTimeout(Integer.ValueOf(BIH_Constants.SET_TIMEOUT_SERVICE));
        System.debug('setTimeout : '+Integer.ValueOf(BIH_Constants.SET_TIMEOUT_SERVICE));
		
        System.debug('endpoint : '+BIH_Constants.END_POINT_PUSH_NOTI);
		req.setEndpoint(BIH_Constants.END_POINT_PUSH_NOTI);//app config end point
		System.debug(BIH_Constants.END_POINT_PUSH_NOTI);
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
            ////
            Task TaskLog = new Task();
            TaskLog.WhatId = caseObj[0].Id; 
            TaskLog.subject = 'Push Notification Close';
            TaskLog.Description = messages; 
            insert TaskLog; 
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