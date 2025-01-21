global class BatchAutoSendMECL implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
                    global Integer recordProcess = 0, retention;
    
    global List<case> start(Database.BatchableContext bc){
        System.debug('job start Auto EMail Followup CL');
        
        List<case> listAutoMailCase = [ select id,OwnerId,ME_Follow_Up_Start_Time__c ,
            Subject,Status
            from case 
            where ME_Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-5)
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-2)
            //where 
            //ME_Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-2)
            //and (Owner.name = 'Registration Team' or   
            //        Owner.UserRole.name =  'BIH Registration Manager' )
            and Status = 'Closed'
            and Close_Case_Reason__c = 'CL Out' 
            and ME_Follow_Up_Start_Time__c   != null
            and Send_ME_CL_Follow_Up__c = false
            and New_ME_Email__c = false                            
            ];
                                
            System.debug('listAutoSendMEEmailFirstTime size : ' + listAutoMailCase.size());
            return listAutoMailCase;
        // return Database.getQueryLocator(
        //     'select id,OwnerId, Escalate_Date__c,Escalate_More_Than_24_Hour__c   from case'
        // );
    }
    
    global void execute(Database.BatchableContext bc, List<case> expired){

        System.debug('begin execute CL Follow up mail');
        
        RequestAutoSendMECL api = new RequestAutoSendMECL();
        System.debug('Add CL jobId :'+ System.enqueueJob(api));

        
        

    }

    global void finish(Database.BatchableContext bc){
        System.debug('BatchCase Auto Email CL Success');
    }

}