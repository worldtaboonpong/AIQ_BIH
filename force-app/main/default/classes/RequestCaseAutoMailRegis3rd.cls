public class RequestCaseAutoMailRegis3rd implements Queueable{
    	    
    public void execute(QueueableContext context)
    {
        List<case> listAutoMailCase = [ select id,OwnerId, Reply_From_Registration_Patient__c,Sent_Registration_Email_DateTime__c ,
        							Email_New_Patient__c,Subject,Status,Sent_Email_Regist_2nd_Time__c,Sent_Email_Regist_3rd_Time__c,Diff_Appointment_Date_and_Now__c
            						from case 
            						//where Sent_Registration_Email_DateTime__c  <    : datetime.now().AddDays(-1)
            						where Sent_Registration_Email_DateTime__c  <    : datetime.now().addMinutes(-5)
            						and (Owner.name = 'Registration Team' or   
                    					Owner.UserRole.name =  'BIH Registration Manager' )
            						and (Status != 'Closed')
            						and Reply_From_Registration_Patient__c   = false                           
            						and Sent_Email_Regist_2nd_Time__c  = true
            						and Sent_Email_Regist_3rd_Time__c = false
                                    and (Appointment_Date__c = null or Diff_Appointment_Date_and_Now__c < 7)
                                    and Sent_Email_Regist_7_Days__c= false   
            					  ];
        List<String> userid = new List<String>();

        
        if(listAutoMailCase.size() > 0)
        {
            
            for(case tcase : listAutoMailCase)
            {
                tcase.Sent_Email_Regist_3rd_Time__c = true;
                
            }
            update listAutoMailCase;
            
        }
    }


}