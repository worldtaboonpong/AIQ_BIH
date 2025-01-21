global class BatchAutoSendMEEmailSecondTime implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{ /**Change to Queueable */
                global Integer recordProcess = 0, retention;    
    
    /**Change to Queueable */
    global List<case> start(Database.BatchableContext bc){
        System.debug('job start Auto EMail Followup1');
        
        List<case> listAutoMailCase = [ select id,OwnerId,ME_Follow_Up_Start_Time__c ,
            Subject,Status
            from case 
            where ME_Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-5)
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-2)
            //where 
            //ME_Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-5)
            //and (Owner.name = 'Registration Team' or   
            //        Owner.UserRole.name =  'BIH Registration Manager' )
            and CreatedDate >2023-10-10T19:22:36.584+07:00            
            and  Status = 'Closed'
            and ( Close_Case_Reason__c = 'NMI' or Close_Case_Reason__c = 'DR/NMI')
            and ME_Follow_Up_Start_Time__c   != null
            and IsMEFirstFollowupMailSent__c = true
            and Send_ME_Email_Followup_2nd_Time__c = false
            and New_ME_Email__c = false                           
            ];
                                
            System.debug('listAutoSendMEEmailFirstTime size : ' + listAutoMailCase.size());
            return listAutoMailCase;
        // return Database.getQueryLocator(
        //     'select id,OwnerId, Escalate_Date__c,Escalate_More_Than_24_Hour__c   from case'
        // );
    }
    
    /**Change to Queueable 
    //global void execute(Database.BatchableContext bc, List<case> expired){
    global void execute(QueueableContext context){

        System.debug('job start Auto EMail Followup1');
        
        List<case> listAutoMailCase = [ select id,OwnerId,ME_Follow_Up_Start_Time__c ,
            Subject,Status
            from case 
            //where ME_Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-5)
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-2)
            where 
            ME_Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-5)
            //and (Owner.name = 'Registration Team' or   
            //        Owner.UserRole.name =  'BIH Registration Manager' )
            and  Status = 'Closed'
            and ( Close_Case_Reason__c = 'NMI' or Close_Case_Reason__c = 'DR/NMI')
            and ME_Follow_Up_Start_Time__c   != null
            and IsMEFirstFollowupMailSent__c = true
            and Send_ME_Email_Followup_2nd_Time__c = false
            and New_ME_Email__c = false                           
            ];
                                
            System.debug('listAutoSendMEEmailFirstTime size : ' + listAutoMailCase.size());
        // return Database.getQueryLocator(
        //     'select id,OwnerId, Escalate_Date__c,Escalate_More_Than_24_Hour__c   from case'
        // );

        System.debug('begin execute 2 send First Follow up mail');
        
        RequestAutoSendMEEmailSecondTime api = new RequestAutoSendMEEmailSecondTime();
        System.debug('Add Customer Address jobId :'+ System.enqueueJob(api));

        
        

    }*/
    global void execute(Database.BatchableContext bc, List<case> expired){

        System.debug('begin execute RequestAutoSendMEEmailSecondTime');
        
        RequestAutoSendMEEmailSecondTime api = new RequestAutoSendMEEmailSecondTime();
        System.debug('RequestAutoSendMEEmailFirstTime jobId :'+ System.enqueueJob(api));

        
        

    }

    global void finish(Database.BatchableContext bc){
        System.debug('BatchCase Auto Email Success');
    }


}