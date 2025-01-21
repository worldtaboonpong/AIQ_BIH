global class BatchStampFirstResponseMEteam implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
    global List<EmailMessage> start(Database.BatchableContext bc){
        System.debug('job start Medical Enquiry Team');
        Set<Id> tmpCaseId = new Set<Id>();
        AggregateResult[]  emailMaxDateList = null;
        Integer remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
        Integer upperBound = Math.min(remainingRows, 1000);
        List<EmailMessage> emailFirstResponseList = new List<EmailMessage>();
        
        List<Case> caseList = [select id,owner.name,Owner_Role__c   
            from case 
            where createddate = THIS_YEAR
            AND (owner.name like '%Medical Enquiry%'or Owner_Role__c  like '%Medical Enquiry%' or RecordType.Name = 'Medical Enquiry')
            AND Has_ME_First_Response__c = False
            Order by createddate desc Limit 50];
        System.debug('************************************' );
        System.debug('Medical Enquiry caseList size : ' + caseList.size());
        
        if(caseList.size() > 0){
            for(Case tmpcase : caseList){
                tmpCaseId.add(tmpcase.Id);
            }
            emailMaxDateList = [Select Parent.Id parentid ,min(CreatedDate) maxdate
            	From EmailMessage                               
            	Where Parent.Id IN: tmpCaseId
            	And ME_First_Response_DateTime__c  = null
                And Email_IN_OUT__c = 'Outgoing'                
                //And Status = '3'
                AND Parent.Has_ME_First_Response__c = False
                And Created_By_Role__c  = 'BIH Medical Enquiry'                     
                group by Parent.Id Limit 50]; 
            System.debug('Medical Enquiry emailMaxDateList size : ' + emailMaxDateList.size());
            
            emailFirstResponseList = [Select Id,Parent.Id  ,ME_First_Response_DateTime__c,Last_Modified_By_Role__c,Created_By_Role__c 
            	From EmailMessage                               
            	Where Parent.Id IN: tmpCaseId
            	And ME_First_Response_DateTime__c  = null
                And Email_IN_OUT__c = 'Outgoing'                      
                //And Status = '3'
                AND Parent.Has_ME_First_Response__c = False
                And Created_By_Role__c  = 'BIH Medical Enquiry'  
                Limit 50 FOR UPDATE];             
            System.debug('Medical Enquiry emailFirstResponseList size : ' + emailMaxDateList.size());
            System.debug('');
           
        }
        
 
        return emailFirstResponseList;
    }
        global void execute(Database.BatchableContext bc, List<EmailMessage> expired){

        System.debug('reply email');
        RequestStampFirstResponseMEteam api = new RequestStampFirstResponseMEteam();
        System.debug('ME email Address jobId :'+ System.enqueueJob(api));

    }
     
     
     
     

    global void finish(Database.BatchableContext bc){
        System.debug('Stamp ME Value Success');
    }
}