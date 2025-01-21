public class RequestCustomAutoMailRegis implements Queueable{
   
    public void execute(QueueableContext context)
    {
        List<case> listAutoMailCase = [ select id,OwnerId, Reply_From_Registration_Patient__c,Sent_Registration_Email_DateTime__c ,
        Email_New_Patient__c,Subject,Status,Sent_Email_Regist_2nd_Time__c
            from case 
            where Sent_Registration_Email_DateTime__c  <    : datetime.now().AddDays(-1)
            //where Escalate_Date__c  <    : datetime.now().addMinutes(-2)
            and (Owner.name = 'Registration Team' or   
                    Owner.UserRole.name =  'BIH Registration Manager' )
            and (Status != 'Closed')
            and Reply_From_Registration_Patient__c   = false                           
            and Sent_Email_Regist_2nd_Time__c  = false
             ];
        List<String> userid = new List<String>();

        //String inbody = 'Hello';
        //String inTitle = 'Test Title';

        //String targetId ;
        //System.debug('######## RunTrigger after inbody:' + inbody);
        if(listAutoMailCase.size() > 0)
        {
            
            for(case tcase : listAutoMailCase)
            {
                tcase.Sent_Email_Regist_2nd_Time__c = true;
                //sendtouser( userid, targetid, inTitle, inbody);
                //Messaging.SingleEmailMessage message  = new Messaging.SingleEmailMessage();
            //message.toAddresses = new String[] { 'darkness.just@gmail.com'};
                //message.setTemplateId('00X2u000000gnarEAA');
//message.optOutPolicy = 'FILTER';
//message.subject = 'Opt Out Test Message';
//message.plainTextBody = 'This is the message body.';
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
            }
            update listAutoMailCase;
            
        }
    }

}