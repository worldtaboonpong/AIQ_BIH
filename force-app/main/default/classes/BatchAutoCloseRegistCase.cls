global class BatchAutoCloseRegistCase implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
	global Integer recordProcess = 0, retention;
    
    global List<case> start(Database.BatchableContext bc){
        System.debug('job start Close Case');
		
        List<case> listAutoCloseCaseCase = [ select id,OwnerId, Reply_From_Registration_Patient__c,Sent_Registration_Email_DateTime__c ,
        Sent_Email_Regist_2nd_Time__c,Status
            from case 
            where Sent_Registration_Email_DateTime__c  <    : datetime.now().AddDays(-4)
            //where Escalate_Date__c  <    : datetime.now().addMinutes(-2)
            and (Owner.name = 'Registration Team' or   
                    Owner.UserRole.name =  'BIH Registration Manager' )
            and (Status != 'Closed')
            and Reply_From_Registration_Patient__c   = false                           
            and Sent_Email_Regist_2nd_Time__c  = true	
            ];
                                
            System.debug('listAutoCloseCaseCase size : ' + listAutoCloseCaseCase.size());
       		return listAutoCloseCaseCase;
    }
    
    global void execute(Database.BatchableContext bc, List<case> expired){

        System.debug('begin execute Close Case');
        
        RequestCloseRegistCase api = new RequestCloseRegistCase();
        System.debug('Add Customer Address jobId :'+ System.enqueueJob(api));

        
        

    }

    global void finish(Database.BatchableContext bc){
        System.debug('BatchCase Auto Close Case Success');
    }

}