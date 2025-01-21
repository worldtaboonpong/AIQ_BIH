global class BatchCloseFollowUpCase implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
	global Integer recordProcess = 0, retention;
    
    global List<case> start(Database.BatchableContext bc){
        System.debug('job start Close Case');
		
        List<case> listAutoCloseCaseCase = [ select id,OwnerId,Follow_Up_Start_Time__c ,
        IsFirstFollowupMailSent__c,IsSecondFollowupMailSent__c,Status
            from case 
            where Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-6)
            //Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-9)
            //where Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-5)
            //and (Owner.name = 'Registration Team' or   
            //        Owner.UserRole.name =  'BIH Registration Manager' )
            and (Status = 'Pending')
            and IsFirstFollowupMailSent__c   = true                           
            and IsSecondFollowupMailSent__c  = true
            and ((Pass_to_Doctor_Date__c = null) OR (Pass_to_Doctor_Date__c != null and Reply_from_Doctor_Date__c != null))  
            and (NOT (Owner.UserRole.Name LIKE 'Clinic%' OR Owner.Name LIKE 'Clinic%'))                                
            ];
                                
            System.debug('listAutoCloseCaseCase size : ' + listAutoCloseCaseCase.size());
       		return listAutoCloseCaseCase;
    }
    
    global void execute(Database.BatchableContext bc, List<case> expired){

        System.debug('begin execute Close Case');
        
        RequestCloseFollowUpCase api = new RequestCloseFollowUpCase();
        System.debug('Add Customer Address jobId :'+ System.enqueueJob(api));

        
        

    }

    global void finish(Database.BatchableContext bc){
        System.debug('BatchCase Auto Close Follow up Case Success');
    }

}