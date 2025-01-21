global class BatchCaseNotify implements Queueable, Database.Stateful,Database.AllowsCallouts { /**Change to Queueable */
    global Integer recordProcess = 0, retention;
    
    /**Change to Queueable 
    global List<case> start(Database.BatchableContext bc){
       
        System.debug('job start ');

        List<case> listNotiCase = [ select id,OwnerId, Escalate_Date__c,Escalate_More_Than_24_Hour__c ,
        Escalate_Date_Over_Than_24_Hours__c,Sent_Notify_by_Medical_Enquiry__c
            from case 
            where Escalate_Date__c  <    : datetime.now().AddDays(-1)
            //where Escalate_Date__c  <    : datetime.now().addMinutes(-2)
            and (Owner.name != 'Medical Enquiry Team' or   
                    Owner.UserRole.name !=  'BIH Medical Enquiry' )
            and  ( Is_MCO__c = true    or    Is_Escalate_To_MCO__c = true )
            and (Escalate_More_Than_24_Hour__c = true)
            and (Status != 'Closed')
            and Sent_Notify_by_Medical_Enquiry__c = false
            ];
                                
           // System.debug('listNotiCase size : ' + listNotiCase.size());
       return listNotiCase;
        // return Database.getQueryLocator(
        //     'select id,OwnerId, Escalate_Date__c,Escalate_More_Than_24_Hour__c   from case'
        // );
    }
    */
    
    /**Change to Queueable */
    //global void execute(Database.BatchableContext bc, List<case> expired){
    global void execute(QueueableContext context){

        System.debug('job start ');

        List<case> listNotiCase = [ select id,OwnerId, Escalate_Date__c,Escalate_More_Than_24_Hour__c ,
        Escalate_Date_Over_Than_24_Hours__c,Sent_Notify_by_Medical_Enquiry__c
            from case 
            where Escalate_Date__c  <    : datetime.now().AddDays(-1)
            //where Escalate_Date__c  <    : datetime.now().addMinutes(-2)
            and (Owner.name != 'Medical Enquiry Team' or   
                    Owner.UserRole.name !=  'BIH Medical Enquiry' )
            and  ( Is_MCO__c = true    or    Is_Escalate_To_MCO__c = true )
            and (Escalate_More_Than_24_Hour__c = true)
            and (Status != 'Closed')
            and Sent_Notify_by_Medical_Enquiry__c = false
            ];

        System.debug('begin execute ');
        
        RequestCustomNotifcation api = new RequestCustomNotifcation();
        System.debug('Add Customer Address jobId :'+ System.enqueueJob(api));


    }

    global void finish(Database.BatchableContext bc){
        System.debug('BatchCaseNotify Success');
    }
}