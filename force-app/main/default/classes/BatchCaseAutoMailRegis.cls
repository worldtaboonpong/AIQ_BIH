global class BatchCaseAutoMailRegis implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
    global Integer recordProcess = 0, retention;
    
    global List<case> start(Database.BatchableContext bc){
        System.debug('job start Auto EMail 2');
		
        List<case> listAutoMailCase = [ select id,OwnerId, Reply_From_Registration_Patient__c,Sent_Registration_Email_DateTime__c ,
        	Email_New_Patient__c,Subject,Status,Sent_Email_Regist_2nd_Time__c
            from case 
            where Sent_Registration_Email_DateTime__c  <    : datetime.now().addMinutes(-2)
            //where Escalate_Date__c  <    : datetime.now().addMinutes(-2)
            and (Owner.name = 'Registration Team' or   
                    Owner.UserRole.name =  'BIH Registration Manager' )
            and (Status != 'Closed')
            and Reply_From_Registration_Patient__c   = false                           
            and Sent_Email_Regist_2nd_Time__c  = false
            ];
                                
            System.debug('listAutoMailCase size : ' + listAutoMailCase.size());
       		return listAutoMailCase;
        // return Database.getQueryLocator(
        //     'select id,OwnerId, Escalate_Date__c,Escalate_More_Than_24_Hour__c   from case'
        // );
    }
    
    global void execute(Database.BatchableContext bc, List<case> expired){

        System.debug('begin execute 2 send regis email');
        
        RequestCustomAutoMailRegis api = new RequestCustomAutoMailRegis();
        System.debug('Add Customer Address jobId :'+ System.enqueueJob(api));

        
        

    }

    global void finish(Database.BatchableContext bc){
        System.debug('BatchCase Auto Email Success');
    }

}