public class RequestCloseRegistCase implements Queueable{
	public void execute(QueueableContext context)
    {
        List<case> listAutoCloseCaseCase = [select id,OwnerId, Reply_From_Registration_Patient__c,Sent_Registration_Email_DateTime__c ,
        								Sent_Email_Regist_2nd_Time__c,Status
            						from case 
            						where Sent_Registration_Email_DateTime__c  <    : datetime.now().AddDays(-3)
            						//where Escalate_Date__c  <    : datetime.now().addMinutes(-2)
           			 				and (Owner.name = 'Registration Team' or   
                    					Owner.UserRole.name =  'BIH Registration Manager' )
            						and (Status != 'Closed')
            						and Reply_From_Registration_Patient__c   = false                           
            						and Sent_Email_Regist_2nd_Time__c  = true
            					  		];
        
        if(listAutoCloseCaseCase.size() > 0)
        {
            
            for(case tcase : listAutoCloseCaseCase)
            {
                tcase.Status = 'Closed';
                tcase.Close_Case_Reason__c = 'No response from patient';
                tcase.isClosedAll__c= True;
                tcase.OwnerId= '00G2u000000cvKAEAY';
                System.debug('CaseClosedNoPatientResponse : ' + tcase.Id);
            }
            update listAutoCloseCaseCase;
            
        }
    }

}