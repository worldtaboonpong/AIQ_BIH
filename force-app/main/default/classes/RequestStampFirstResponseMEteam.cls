public class RequestStampFirstResponseMEteam implements Queueable{
    	public void execute(QueueableContext context)
    {
        System.debug('Call RequestStampFirstResponseValue 1 ' );
        Set<Id> tmpCaseId = new Set<Id>();
        AggregateResult[]  emailMaxDateList = null;
        List<EmailMessage> emailFirstResponseList = new List<EmailMessage>();
        List<Case> caseList = [select id,owner.name,Owner_Role__c,RecordType.name   
            from case 
            where createddate = THIS_YEAR
            AND (owner.name like '%Medical Enquiry%'or Owner_Role__c  like '%Medical Enquiry%' or RecordType.Name = 'Medical Enquiry')
            AND Has_ME_First_Response__c = False
            Order by createddate desc Limit 50];
        System.debug('RequestStampFirstResponseMedical Enquiry caseList size : ' + caseList.size());
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
				

			emailFirstResponseList = [Select Id,Parent.Id  ,ME_First_Response_DateTime__c,Last_Modified_By_Role__c,Created_By_Role__c 
            	From EmailMessage                               
            	Where Parent.Id IN: tmpCaseId
            	And ME_First_Response_DateTime__c  = null
                //And Status = '3'
                And Email_IN_OUT__c = 'Outgoing'
                AND Parent.Has_ME_First_Response__c = False                      
                And Created_By_Role__c  = 'BIH Medical Enquiry'  
                Limit 50 FOR UPDATE];             
            	System.debug('email Medical Enquiry FirstResponseList size : ' + emailMaxDateList.size());
            	System.debug('');
            	
        	}    
        
        	
        	Map<String, DateTime> mapParentId = new Map<String, DateTime>();
        	Set<Id> CaseIdUpdateHas = new Set<Id>();
            if(emailMaxDateList.size() > 0 && emailFirstResponseList.size()>0)
        	{
            	for (AggregateResult ar : emailMaxDateList)  
                {
                    System.debug('Case ID : ' + ar.get('parentid'));
                 	//temail.First_Response_Of_Email_Team__c = temail.CreatedDate;
                    System.debug('emailFirstResponseList size : ' + emailFirstResponseList.size());
                    mapParentId.put(String.valueOf(ar.get('parentid')), DateTime.valueOf(ar.get('maxdate')));
            	}
                for(EmailMessage temail :emailFirstResponseList)
                {
                    temail.ME_First_Response_DateTime__c = mapParentId.get(temail.Parent.Id);
                    CaseIdUpdateHas.add(temail.Parent.Id);
                    System.debug('Email Update ID : ' + temail.Id);
                }
                update emailFirstResponseList;
            }
        
        		List<Case> caseupdatelist = [select id,Has_ME_First_Response__c   
            		from case 
            		where id IN: CaseIdUpdateHas
                    AND Has_ME_First_Response__c = False                       
            		];
        	
         		System.debug('caseupdatelist : ' + caseupdatelist.size());
        		if(caseupdatelist.size() > 0){
                    for (case caseup : caseupdatelist)  
                	{
                        System.debug(' ******* caseup.id  : ' + caseup.id);
                    	caseup.Has_ME_First_Response__c = true;
            		}
                }
        		update caseupdatelist;
        
        }
}