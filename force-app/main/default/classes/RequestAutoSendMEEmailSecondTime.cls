public class RequestAutoSendMEEmailSecondTime implements Queueable{
    public void execute(QueueableContext context)
    {
        List<case> listAutoMailCase = [ select id,OwnerId,ME_Follow_Up_Start_Time__c ,
            Subject,Status
            from case 
            where ME_Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-5)
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-2)
            //where 
            //ME_Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-5)
            and CreatedDate >2023-10-10T19:22:36.584+07:00                               
            and Status = 'Closed'
            and ( Close_Case_Reason__c = 'NMI' or Close_Case_Reason__c = 'DR/NMI')
            and ME_Follow_Up_Start_Time__c   != null
            and IsMEFirstFollowupMailSent__c = true
            and Send_ME_Email_Followup_2nd_Time__c = false
            and New_ME_Email__c = false                           
                                  ];
        List<String> userid = new List<String>();

        if(listAutoMailCase.size() > 0)
        {
            
            for(case tcase : listAutoMailCase)
            {
                tcase.Send_ME_Email_Followup_2nd_Time__c = true;
                System.debug('Request Case ID : ' + tcase.Id);
            }
            update listAutoMailCase;
            
        }
    }

}