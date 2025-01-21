public class RequestAutoSendEmailSecondTime implements Queueable{
        public void execute(QueueableContext context)
    {
        List<case> listAutoMailCase = [ select id,OwnerId,Follow_Up_Start_Time__c ,
        	Subject,Status
            from case 
            where Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-5)
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-5)
            //where 
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-5)
            and  Status = 'Pending'
            and ( Pending_Reason__c = 'Waiting for Patient' or Pending_Reason__c = 'Waiting for reply from RO')
            and Follow_Up_Start_Time__c   != null                           
            and IsFirstFollowupMailSent__c  = true
            and Send_Email_Followup_2nd_Time__c = false
            					  ];
        List<String> userid = new List<String>();

        if(listAutoMailCase.size() > 0)
        {
            
            for(case tcase : listAutoMailCase)
            {
                tcase.Send_Email_Followup_2nd_Time__c = true;
                System.debug('Request Case 2nd ID : ' + tcase.Id);
            }
            update listAutoMailCase;
            
        }
    }


}