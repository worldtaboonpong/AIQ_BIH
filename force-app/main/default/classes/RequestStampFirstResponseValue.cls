public class RequestStampFirstResponseValue implements Queueable{
    	public void execute(QueueableContext context)
    {
        System.debug('Call RequestStampFirstResponseValue 1 ' );
        Set<Id> tmpCaseId = new Set<Id>();
        AggregateResult[]  emailMaxDateList = null;
        List<EmailMessage> emailFirstResponseList = new List<EmailMessage>();
        List<Case> caseList = [select id,owner.name,Owner_Role__c   
            from case 
            where createddate = THIS_YEAR
            AND (owner.name like '%Refer%' or Owner.name like '%Individual%' or Owner_Role__c  like '%Refer%' or Owner_Role__c   like '%Indivi%'or RecordType.Name like '%Primary Case%')
            AND Has_First_Response__c = False
            Order by createddate desc Limit 3000];
        System.debug('RequestStampFirstResponseValue caseList size : ' + caseList.size());
        if(caseList.size() > 0){
            for(Case tmpcase : caseList){
                tmpCaseId.add(tmpcase.Id);
            }
            emailMaxDateList = [Select Parent.Id parentid ,min(CreatedDate) maxdate
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
                group by Parent.Id Limit 3000]; 


				emailFirstResponseList = [Select Id,Parent.Id  ,First_Response_Of_Email_Team__c,Last_Modified_By_Role__c,Created_By_Role__c ,CreatedDate
            	From EmailMessage                               
            	Where Parent.Id IN: tmpCaseId
            	And First_Response_Of_Email_Team__c  = null
                //And (Status = '2' or Status = '3')                          
                //And Status = '3'
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
        
        	
        	Map<String, DateTime> mapParentId = new Map<String, DateTime>();
        	Set<Id> CaseIdUpdateHas = new Set<Id>();
            if(emailMaxDateList.size() > 0 && emailFirstResponseList.size()>0)
        	{
            	for (AggregateResult ar : emailMaxDateList)  
                {
                    System.debug('Email ID : ' + ar.get('parentid'));
                 	//temail.First_Response_Of_Email_Team__c = temail.CreatedDate;
                    System.debug('emailFirstResponseList size : ' + emailFirstResponseList.size());
                    mapParentId.put(String.valueOf(ar.get('parentid')), DateTime.valueOf(ar.get('maxdate')));
            	}
                for(EmailMessage temail :emailFirstResponseList)
                {
					if(temail.CreatedDate == mapParentId.get(temail.Parent.Id))
					{
						temail.First_Response_Of_Email_Team__c = mapParentId.get(temail.Parent.Id);
						CaseIdUpdateHas.add(temail.Parent.Id);
					}
					
                }
                update emailFirstResponseList;
            }
        
        		List<Case> caseupdatelist = [select id,Has_First_Response__c   
            		from case 
            		where id IN: CaseIdUpdateHas
                    AND Has_First_Response__c = False                       
            		];
        	
         		System.debug('caseupdatelist : ' + caseupdatelist.size());
        		if(caseupdatelist.size() > 0){
                    for (case caseup : caseupdatelist)  
                	{
                        System.debug(' ******* caseup.id  : ' + caseup.id);
                    	caseup.Has_First_Response__c = true;
                    	
                    	//mapParentId.put(String.valueOf(ar.get('parentid')), DateTime.valueOf(ar.get('maxdate')));
            		}
                }
        		update caseupdatelist;
        
        }
}