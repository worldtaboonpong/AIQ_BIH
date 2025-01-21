global class BatchCaseAutoMailRegis3rd implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
    global Integer recordProcess = 0, retention;
    
    global List<case> start(Database.BatchableContext bc){
        System.debug('job start Auto EMail 3');
		
        List<case> listAutoMailCase = [ select id,OwnerId, Reply_From_Registration_Patient__c,Sent_Registration_Email_DateTime__c ,
        	Email_New_Patient__c,Subject,Status,Sent_Email_Regist_2nd_Time__c,Sent_Email_Regist_3rd_Time__c,Diff_Appointment_Date_and_Now__c
            from case 
            //where Sent_Registration_Email_DateTime__c  <    : datetime.now().AddDays(-1)
            where Sent_Registration_Email_DateTime__c  <    : datetime.now().addMinutes(-5)
            and (Owner.name = 'Registration Team' or   
                    Owner.UserRole.name =  'BIH Registration Manager' )
            and (Status != 'Closed')
            and Reply_From_Registration_Patient__c   = false                           
            and Sent_Email_Regist_2nd_Time__c  = true
            and Sent_Email_Regist_3rd_Time__c = false
            and (Appointment_Date__c = null or Diff_Appointment_Date_and_Now__c < 7)
            and Sent_Email_Regist_7_Days__c= false
            ];
                                
            System.debug('listAutoMailCase size : ' + listAutoMailCase.size());
       		return listAutoMailCase;
        // return Database.getQueryLocator(
        //     'select id,OwnerId, Escalate_Date__c,Escalate_More_Than_24_Hour__c   from case'
        // );
    }
    
    global void execute(Database.BatchableContext bc, List<case> expired){

        System.debug('begin execute 3 send regis email');
        
        RequestCaseAutoMailRegis3rd api = new RequestCaseAutoMailRegis3rd();
        System.debug('Add Customer Address jobId :'+ System.enqueueJob(api));

        
        

    }

    global void finish(Database.BatchableContext bc){
        System.debug('BatchCase Auto 3 Email Success');
    }

}