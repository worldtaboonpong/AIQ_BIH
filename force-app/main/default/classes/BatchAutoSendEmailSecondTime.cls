global class BatchAutoSendEmailSecondTime implements Queueable, Database.AllowsCallouts{ /**Change to Queueable */
	global Integer recordProcess = 0, retention;
    
    /**Change to Queueable 
    global List<case> start(Database.BatchableContext bc){
        System.debug('job start Auto 2 nd EMail Followup');
		
        List<case> listAutoMailCase = [ select id,OwnerId,Follow_Up_Start_Time__c ,
        	Subject,Status
            from case 
            where Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-5)
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-5)
            //where 
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-5)
            and  Status = 'Pending'
            and ( Pending_Reason__c = 'Waiting for Patient' or Pending_Reason__c = 'Waiting for reply from RO')
            and Follow_Up_Start_Time__c   != null                           
            and IsFirstFollowupMailSent__c  = true
            and Send_Email_Followup_2nd_Time__c = false
            ];
                                
            System.debug('listFirstFollowUpMailCase size : ' + listAutoMailCase.size());
       		return listAutoMailCase;
        // return Database.getQueryLocator(
        //     'select id,OwnerId, Escalate_Date__c,Escalate_More_Than_24_Hour__c   from case'
        // );
    }
    */

    /**Change to Queueable */
    //global void execute(Database.BatchableContext bc, List<case> expired){
    global void execute(QueueableContext context){

        System.debug('job start Auto 2 nd EMail Followup');
		
        List<case> listAutoMailCase = [ select id,OwnerId,Follow_Up_Start_Time__c ,
        	Subject,Status
            from case 
            where Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-5)
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-5)
            //where 
            //Follow_Up_Start_Time__c  <    : datetime.now().addMinutes(-5)
            and  Status = 'Pending'
            and ( Pending_Reason__c = 'Waiting for Patient' or Pending_Reason__c = 'Waiting for reply from RO')
            and Follow_Up_Start_Time__c   != null                           
            and IsFirstFollowupMailSent__c  = true
            and Send_Email_Followup_2nd_Time__c = false
            ];
                                
        System.debug('listFirstFollowUpMailCase size : ' + listAutoMailCase.size());

        // return Database.getQueryLocator(
        //     'select id,OwnerId, Escalate_Date__c,Escalate_More_Than_24_Hour__c   from case'
        // );

        System.debug('begin execute 2 send First Follow up 2 nd mail');
        
        RequestAutoSendEmailSecondTime api = new RequestAutoSendEmailSecondTime();
        System.debug('Add Customer Address jobId :'+ System.enqueueJob(api));

    }

    global void finish(Database.BatchableContext bc){
        System.debug('BatchCase Auto 2nd Email Success');
    }

}