global class BatchAutoSendMEEmailFirstTime implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
            global Integer recordProcess = 0, retention;
    
    global List<case> start(Database.BatchableContext bc){
        System.debug('job start Auto EMail Followup1');
        
        List<case> listAutoMailCase = [ select id,OwnerId,ME_Follow_Up_Start_Time__c ,
            Subject,Status
            from case 
            where ME_Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-2)
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-2)
            //where 
            //ME_Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-1)
            //and (Owner.name = 'Registration Team' or   
            //        Owner.UserRole.name =  'BIH Registration Manager' )
            and  Status = 'Closed'
            and ( Close_Case_Reason__c = 'NMI' or Close_Case_Reason__c = 'DR/NMI')
            and ME_Follow_Up_Start_Time__c   != null                           
            and Send_1st_ME_Email__c  = false
            and New_ME_Email__c = false                           
            ];
                                
            System.debug('listAutoSendMEEmailFirstTime size : ' + listAutoMailCase.size());
            return listAutoMailCase;
        // return Database.getQueryLocator(
        //     'select id,OwnerId, Escalate_Date__c,Escalate_More_Than_24_Hour__c   from case'
        // );
    }
    
    global void execute(Database.BatchableContext bc, List<case> expired){

        System.debug('begin execute 2 send First Follow up mail');
        
        RequestAutoSendMEEmailFirstTime api = new RequestAutoSendMEEmailFirstTime();
        System.debug('Add Customer Address jobId :'+ System.enqueueJob(api));

        
        

    }

    global void finish(Database.BatchableContext bc){
        System.debug('BatchCase Auto Email Success');
    }

}