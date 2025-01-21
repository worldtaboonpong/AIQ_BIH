public class RequestContactCenterOverDue implements Queueable{
    	public void execute(QueueableContext context)
    {
        Set<Id> tmpParentId = new Set<Id>();
        Map<Id,EmailMessage> emailmessageMap = new Map<Id,EmailMessage>();
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
            
            System.debug('Request => listCCOverDueCase size : ' + listCCOverDueCase.size());
            System.debug('');
            


        	String targetId ;
            if(listCCOverDueCase.size() > 0)
        	{
            	for(case tcase : listCCOverDueCase)
            	{
                    
                 	tcase.CC_Case_Over_Due__c = true;
                    System.debug('Case Id with CC overdue case : ' + tcase.Id);
                    

            	}
                update listCCOverDueCase;
            }
        
    } 

}