global class BatchStampFirstResponseValue implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
   //global Integer recordProcess = 0, retention;
    
    global List<EmailMessage> start(Database.BatchableContext bc){
        System.debug('job start Patient Reply Email');
        Set<Id> tmpCaseId = new Set<Id>();
        AggregateResult[]  emailMaxDateList = null;
        Integer remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
        Integer upperBound = Math.min(remainingRows, 1000);
        List<EmailMessage> emailFirstResponseList = new List<EmailMessage>();
        
        List<Case> caseList = [select id,owner.name,Owner_Role__c   
            from case 
            where createddate = THIS_YEAR
            AND Has_First_Response__c = False                   
            AND (owner.name like '%Refer%' or Owner.name like '%Individual%' or Owner_Role__c  like '%Refer%' or Owner_Role__c   like '%Indivi%'or RecordType.Name like '%Primary Case%')
            Order by createddate desc Limit 3000];
        System.debug('************************************' );
        System.debug('caseList size : ' + caseList.size());
        
        if(caseList.size() > 0){
            for(Case tmpcase : caseList){
                tmpCaseId.add(tmpcase.Id);
            }
            emailMaxDateList = [Select Parent.Id parentid ,min(CreatedDate) maxdate
            	From EmailMessage                               
            	Where Parent.Id IN: tmpCaseId
            	And First_Response_Of_Email_Team__c  = null
                And Email_IN_OUT__c = 'Outgoing'
                //And (Status = '2' or Status = '3')
                And Parent.Has_First_Response__c =false                 
                And (Created_By_Role__c  = 'BIH Individual Team Head' 
                     or Created_By_Role__c  ='BIH Individual Officer' 
                     or Created_By_Role__c  = 'BIH Individual Manager'
                     or Created_By_Role__c  = 'BIH Individual Officer TH'
                     or Created_By_Role__c  = 'BIH Individual Officer PH'
                     or Created_By_Role__c  = 'BIH Referral Team Head' 
                     or Created_By_Role__c  = 'BIH Referral Officer' 
                     or Created_By_Role__c  = 'BIH Referral Manager')                      
                group by Parent.Id Limit 3000]; 
            System.debug('emailMaxDateList size : ' + emailMaxDateList.size());
            
            emailFirstResponseList = [Select Id,Parent.Id  ,First_Response_Of_Email_Team__c,Last_Modified_By_Role__c,Created_By_Role__c 
            	From EmailMessage                               
            	Where Parent.Id IN: tmpCaseId
            	And First_Response_Of_Email_Team__c  = null
                //And (Status = '2' or Status = '3')       
                And Email_IN_OUT__c = 'Outgoing'                      
                And Parent.Has_First_Response__c =false                       
                And (Created_By_Role__c  = 'BIH Individual Team Head' 
                     or Created_By_Role__c  ='BIH Individual Officer' 
                     or Created_By_Role__c  = 'BIH Individual Manager'
                     or Created_By_Role__c  = 'BIH Individual Officer TH'
                     or Created_By_Role__c  = 'BIH Individual Officer PH'
                     or Created_By_Role__c  = 'BIH Referral Team Head' 
                     or Created_By_Role__c  = 'BIH Referral Officer' 
                     or Created_By_Role__c  = 'BIH Referral Manager')   
                                          Limit 3000];             
            System.debug('emailFirstResponseList size : ' + emailMaxDateList.size());
            System.debug('');
           
        }
        
 
        return emailFirstResponseList;
    }
    
    global void execute(Database.BatchableContext bc, List<EmailMessage> expired){

        System.debug('reply email');
        RequestStampFirstResponseValue api = new RequestStampFirstResponseValue();
        System.debug('patient reply email Address jobId :'+ System.enqueueJob(api));

    }
     
     
     
     

    global void finish(Database.BatchableContext bc){
        System.debug('Stamp Value Success');
    }
        
}