global class BatchBulkLoadAutoSMS implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
    global Integer recordProcess = 0, retention;
    
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
    
   
    global void execute(Database.BatchableContext bc, List<case> scope){

        System.debug('begin execute SMS Case');
        
        // callout
        //         
        for (case caseObj : scope){
            
		}
        

    }

    global void finish(Database.BatchableContext bc){
        System.debug('BatchCase Auto Email Success');
    }

}