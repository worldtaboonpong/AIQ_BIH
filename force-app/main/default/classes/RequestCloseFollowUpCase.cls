public class RequestCloseFollowUpCase implements Queueable{
	public void execute(QueueableContext context)
    {
        List<case> listAutoCloseCaseCase = [select id,OwnerId,Follow_Up_Start_Time__c ,
        	IsFirstFollowupMailSent__c,IsSecondFollowupMailSent__c,Status
            from case 
            //where Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-10)
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-10)
            where Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-9)
            //and (Owner.name = 'Registration Team' or   
            //        Owner.UserRole.name =  'BIH Registration Manager' )
            and (Status = 'Pending')
            and IsFirstFollowupMailSent__c   = true                           
            and IsSecondFollowupMailSent__c  = true
            and Pass_to_Doctor_Date__c = null                                
            					  		];
        
        if(listAutoCloseCaseCase.size() > 0)
        {
            
            for(case tcase : listAutoCloseCaseCase)
            {
                tcase.Status = 'Closed';
                tcase.Close_Case_Reason__c = 'No response from patient';
                tcase.isClosedAll__c= True;
                //tcase.OwnerId= '00G2u000000cvKAEAY';
                System.debug('CaseClosedNoPatientResponse : ' + tcase.Id);
            }
            update listAutoCloseCaseCase;
            
        }
    }

}