public class RequestBulkLoadAutoSMS implements Queueable ,Database.AllowsCallouts{
	    
    public void execute(QueueableContext context)
    {
        List<case> listAutoMailCase = [ SELECT Id,Primary_Phone_Existing_Patient__c,Primary_Phone_New_Patient__c,Nationality__c,Account_Nationality__c,Registration_URL__c,
             Last_Sent_Date__c,SMS_Sent__c,Is_Manual_SMS_Regist_Case__c 
             FROM CASE 
             WHERE Primary_Phone_New_Patient__c  != null
             //AND Is_Manual_SMS_Regist_Case__c = TRUE
             AND Status != 'Closed'];
        
        for(case tcase : listAutoMailCase)
        {
            BIH_CaseSendAutoSMS.calloutSendSms(tcase.id);
        }
        
        
        
        
        //List<String> userid = new List<String>();

        //String inbody = 'Hello';
        //String inTitle = 'Test Title';

        //String targetId ;
        //System.debug('######## RunTrigger after inbody:' + inbody);
        /*if(listAutoMailCase.size() > 0)
        {
            
            for(case tcase : listAutoMailCase)
            {
                //tcase.Sent_Email_Regist_2nd_Time__c = true;
                //sendtouser( userid, targetid, inTitle, inbody);
                //Messaging.SingleEmailMessage message  = new Messaging.SingleEmailMessage();
            	//message.toAddresses = new String[] { 'darkness.just@gmail.com'};
                //message.setTemplateId('00X2u000000gnarEAA');
				//message.optOutPolicy = 'FILTER';
				//message.subject = 'Opt Out Test Message';
				//message.plainTextBody = 'This is the message body.';
            	//Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
            }
            //update listAutoMailCase;
            
        }*/
    }

}