global class BatchContactCenterOverDue implements Queueable, Database.Stateful,Database.AllowsCallouts{ /**Change to Queueable */
    global Integer recordProcess = 0, retention;
    
    /**Change to Queueable 
    global List<case> start(Database.BatchableContext bc){
        System.debug('job start Contact Center OverDue Case');
		Set<Id> tmpParentId = new Set<Id>();
        List<Case> listCCOverDueCase = new List<Case>();
                
            listCCOverDueCase = [Select Id, Channel__c,OwnerId,CaseNumber,SLA_Overdue_Flag__c,CC_Case_Over_Due__c,owner.name,Owner_Role__c,RecordType.Name,Created_By_Role__c  From Case                               
            	Where Status != 'Closed'                   
            	And Channel__c = 'Contact Center'
                And SLA_Overdue_Flag__c = true
                And CC_Case_Over_Due__c = false 
                And (owner.name like '%Contact%' or Created_By_Role__c  like 'BIH CC%')
                AND RecordType.name like 'Contact%'
                AND (Owner.Name != 'Registration Team' or Owner_Role__c!= 'BIH Registration Manager' or Owner_Role__c != 'BIH Registration Officer')
                And Sent_CC_Notification__c = false                   
                 order by createddate desc limit 100];
            
            System.debug('listCCOverDueCase size : ' + listCCOverDueCase.size());
            
        
        return listCCOverDueCase;
    }
    */

    /**Change to Queueable */
    //global void execute(Database.BatchableContext bc, List<case> expired){
    global void execute(QueueableContext context){

        System.debug('job start Contact Center OverDue Case');
		Set<Id> tmpParentId = new Set<Id>();
        List<Case> listCCOverDueCase = new List<Case>();
                
            listCCOverDueCase = [Select Id, Channel__c,OwnerId,CaseNumber,SLA_Overdue_Flag__c,CC_Case_Over_Due__c,owner.name,Owner_Role__c,RecordType.Name,Created_By_Role__c  From Case                               
            	Where Status != 'Closed'                   
            	And Channel__c = 'Contact Center'
                And SLA_Overdue_Flag__c = true
                And CC_Case_Over_Due__c = false 
                And (owner.name like '%Contact%' or Created_By_Role__c  like 'BIH CC%')
                AND RecordType.name like 'Contact%'
                AND (Owner.Name != 'Registration Team' or Owner_Role__c!= 'BIH Registration Manager' or Owner_Role__c != 'BIH Registration Officer')
                And Sent_CC_Notification__c = false                   
                 order by createddate desc limit 100];
            
            System.debug('listCCOverDueCase size : ' + listCCOverDueCase.size());
            

        System.debug('overdue case');
        RequestContactCenterOverDue api = new RequestContactCenterOverDue();
        System.debug('cc overdue email Address jobId :'+ System.enqueueJob(api));

    }

    global void finish(Database.BatchableContext bc){
        System.debug('BatchContactCenterOverDue Success');
    }

}