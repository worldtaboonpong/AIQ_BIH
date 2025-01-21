public class RequestAutoSendEmailFirstTime implements Queueable{
    public void execute(QueueableContext context)
    {
        List<case> listAutoMailCase = [ select id,OwnerId,Follow_Up_Start_Time__c ,
        	Subject,Status
            from case 
            where Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-2)
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-2)
            //where 
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-2)
            and Status = 'Pending'
            and (Pending_Reason__c = 'Waiting for Patient' or Pending_Reason__c = 'Waiting for reply from RO')
            and Follow_Up_Start_Time__c   != null                           
            and Send_1st_Email__c  = false
            					  ];
        List<String> userid = new List<String>();

        if(listAutoMailCase.size() > 0)
        {
            
            for(case tcase : listAutoMailCase)
            {
                tcase.Send_1st_Email__c = true;
                System.debug('Request Case ID : ' + tcase.Id);
            }
            update listAutoMailCase;
            
        }
    }

}