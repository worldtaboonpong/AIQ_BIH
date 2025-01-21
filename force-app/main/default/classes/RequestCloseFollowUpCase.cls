public class RequestCloseFollowUpCase implements Queueable{
	public void execute(QueueableContext context)
    {
        List<case> listAutoCloseCaseCase = [select id,OwnerId,Follow_Up_Start_Time__c ,
        	IsFirstFollowupMailSent__c,IsSecondFollowupMailSent__c,Status
            from case 
            where Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-6)
            and (Status = 'Pending')
            and IsFirstFollowupMailSent__c   = true                           
            and IsSecondFollowupMailSent__c  = true
            and ((Pass_to_Doctor_Date__c = null) OR (Pass_to_Doctor_Date__c != null and Reply_from_Doctor_Date__c != null))
            and (NOT (Owner.UserRole.Name LIKE 'Clinic%' OR Owner.Name LIKE 'Clinic%')) 
            					  		];
        
        if(listAutoCloseCaseCase.size() > 0)
        {
            
            for(case tcase : listAutoCloseCaseCase)
            {
                tcase.Status = 'Closed';
                tcase.Close_Case_Reason__c = 'No response from patient';
                tcase.isClosedAll__c= True;
                System.debug('CaseClosedNoPatientResponse : ' + tcase.Id);
            }
            update listAutoCloseCaseCase;
            
        }
    }

}