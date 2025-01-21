global class BatchBulkLoadAutoSMS implements Queueable, Database.Stateful,Database.AllowsCallouts{ /**Change to Queueable */
    global Integer recordProcess = 0, retention;
    
    /**Change to Queueable 
    global List<case> start(Database.BatchableContext bc){
        System.debug('job start Auto EMail 2');
		
        List<case> listAutoSMSCase = [ SELECT Id,Primary_Phone_Existing_Patient__c,Primary_Phone_New_Patient__c,Nationality__c,Account_Nationality__c,Registration_URL__c,
             Last_Sent_Date__c,SMS_Sent__c 
             FROM CASE 
             WHERE Primary_Phone_New_Patient__c  != null
             //AND Is_Manual_SMS_Regist_Case__c = TRUE
             AND Status != 'Closed' LIMIT 100
            ];
                                
            System.debug('listAutoSMSCase size : ' + listAutoSMSCase.size());
       		return listAutoSMSCase;
        
    }
    */
   
    //global void execute(Database.BatchableContext bc, List<case> scope){
    global void execute(QueueableContext context){

        System.debug('job start Auto EMail 2');
		
        List<case> listAutoSMSCase = [ SELECT Id,Primary_Phone_Existing_Patient__c,Primary_Phone_New_Patient__c,Nationality__c,Account_Nationality__c,Registration_URL__c,
             Last_Sent_Date__c,SMS_Sent__c 
             FROM CASE 
             WHERE Primary_Phone_New_Patient__c  != null
             //AND Is_Manual_SMS_Regist_Case__c = TRUE
             AND Status != 'Closed' LIMIT 100
            ];
                                
            System.debug('listAutoSMSCase size : ' + listAutoSMSCase.size());

        System.debug('begin execute SMS Case');
        
        

    }

    global void finish(Database.BatchableContext bc){
        System.debug('BatchCase Auto Email Success');
    }

}