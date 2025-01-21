global class BatchAutoCloseRegist7Days implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{ /**Change to Queueable */
global Integer recordProcess = 0, retention;
    
    /**Change to Queueable  */
    global List<case> start(Database.BatchableContext bc){
        System.debug('job start Close Case');

        List<case> listAutoCloseCaseCase = [ select id,OwnerId, Reply_From_Registration_Patient__c,Sent_Registration_Email_DateTime__c ,
        Sent_Email_Regist_2nd_Time__c,Status
            from case 
            where Sent_Registration_Email_DateTime__c  <    : datetime.now().AddDays(-7)
            //where createddate    <    : datetime.now().addMinutes(-2)
            and (Owner.name = 'Registration Team' or   
                    Owner.UserRole.name =  'BIH Registration Manager' )
            and (Status != 'Closed')
            and Reply_From_Registration_Patient__c   = false   
            and ((Pass_to_Doctor_Date__c = null) OR (Pass_to_Doctor_Date__c != null and Reply_from_Doctor_Date__c != null))  
            ];
                                
            System.debug('listAutoCloseCaseCase size : ' + listAutoCloseCaseCase.size());
        return listAutoCloseCaseCase;
    }
    

 
    global void execute(Database.BatchableContext bc, List<case> expired){

        System.debug('begin execute Close Case');
        
        RequestAutoCloseRegist7Days api = new RequestAutoCloseRegist7Days();

    }
    

    global void finish(Database.BatchableContext bc){
        System.debug('BatchCase Auto Close Case Success');
    }
    
    @AuraEnabled
    public static void testclassCall() {
        integer a = 0;
        integer b = 0;
        integer c = 0;
        b = a+b+1;
        c = b+a;
        
        //System.debug('c = ',c);
        
        
        
    }
    

}