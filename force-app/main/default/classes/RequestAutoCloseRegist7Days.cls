public class RequestAutoCloseRegist7Days implements Queueable{
    public void execute(QueueableContext context)
    {
        
        List<case> listAutoCloseCaseCase = [select id,OwnerId, Reply_From_Registration_Patient__c,Sent_Registration_Email_DateTime__c ,
                                            Sent_Email_Regist_2nd_Time__c,Status
                                            from case 
                                            where Sent_Registration_Email_DateTime__c  <    : datetime.now().AddDays(-7)
                                            //where createddate    <    : datetime.now().addMinutes(-2)
                                            and (Owner.name = 'Registration Team' or   
                                                 Owner.UserRole.name =  'BIH Registration Manager' )
                                            and (Status != 'Closed')
                                            and Reply_From_Registration_Patient__c   = false   
                                            and Pass_to_Doctor_Date__c != null and Reply_from_Doctor_Date__c != null
                                           ];
       
        List<case> listAutoCloseCaseCase2 = [select id,OwnerId, Reply_From_Registration_Patient__c,Sent_Registration_Email_DateTime__c ,
                                             Sent_Email_Regist_2nd_Time__c,Status
                                             from case 
                                             where Sent_Registration_Email_DateTime__c  <    : datetime.now().AddDays(-7)
                                             //where createddate    <    : datetime.now().addMinutes(-2)
                                             and (Owner.name = 'Registration Team' or   
                                                  Owner.UserRole.name =  'BIH Registration Manager' )
                                             and (Status != 'Closed')
                                             and Reply_From_Registration_Patient__c   = false   
                                             and Pass_to_Doctor_Date__c = null 
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
        if(listAutoCloseCaseCase2.size() > 0)
        {
            
            for(case tcase : listAutoCloseCaseCase2)
            {
                tcase.Status = 'Closed';
                tcase.Close_Case_Reason__c = 'No response from patient';
                tcase.isClosedAll__c= True;
                tcase.OwnerId= '00G2u000000cvKAEAY';
                System.debug('CaseClosedNoPatientResponse : ' + tcase.Id);
            }
            update listAutoCloseCaseCase2;
            
        }
                                             
                                             
    }

}