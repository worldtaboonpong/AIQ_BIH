public class RequestAutoSendMECL implements Queueable{
        public void execute(QueueableContext context)
    {
        List<case> listAutoMailCase = [ select id,OwnerId,ME_Follow_Up_Start_Time__c ,
            Subject,Status
            from case 
            //where ME_Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-5)
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-2)
            where 
            ME_Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-2)
            //and (Owner.name = 'Registration Team' or   
            //        Owner.UserRole.name =  'BIH Registration Manager' )
            and Status = 'Closed'
            and Close_Case_Reason__c = 'CL Out' 
            and ME_Follow_Up_Start_Time__c   != null
            and Send_ME_CL_Follow_Up__c = false
            and New_ME_Email__c = false                            
            order by createddate desc  ];
        List<String> userid = new List<String>();

        if(listAutoMailCase.size() > 0)
        {
            
            for(case tcase : listAutoMailCase)
            {
                tcase.Send_ME_CL_Follow_Up__c = true;
                System.debug('Request Case ID : ' + tcase.Id);
            }
            update listAutoMailCase;
            
        }
    }

}