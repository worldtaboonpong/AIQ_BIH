global class BatchReplyEmailRegis implements Queueable, Database.Stateful,Database.AllowsCallouts{ /**Change to Queueable */
    global Integer recordProcess = 0, retention;
    
    /**Change to Queueable 
    global List<case> start(Database.BatchableContext bc){
        System.debug('job start Patient Reply Email');
		Set<Id> tmpParentId = new Set<Id>();
        Map<Id,EmailMessage> emailmessageMap = new Map<Id,EmailMessage>();
        List<Case> listReplyMailinCase = new List<Case>();
            
        List<EmailMessage> emailList = [select Parent.Id 
         	From EmailMessage 
            //Where FromAddress = 'noreply@bumrungrad.com'
            //And ToAddress = 'pre-registration@bumrungrad.com'                            
            Where FromAddress = 'noreply@bumrungrad.com' 
            And ToAddress = 'registration@leighripley.com'];     
        
        System.debug('emailList size : ' + emailList.size());
        
        if(emailList.size() > 0){
            for (EmailMessage tmpemail : emailList){
            	tmpParentId.add(tmpemail.Parent.Id);
                emailmessageMap.put(tmpemail.Parent.Id , tmpemail);
        	}
            
            listReplyMailinCase = [Select Id, Reply_From_Registration_Patient__c,OwnerId,CaseNumber,Patient_Reply_to_Registration_DateTime__c 
            	From Case                               
            	Where Id IN: tmpParentId
                And Status != 'Closed'                   
            	And Reply_From_Registration_Patient__c = false
                And Patient_Reply_to_Registration_DateTime__c = null];
            
            System.debug('listReplyMailinCase size : ' + listReplyMailinCase.size());
            
        }
        return listReplyMailinCase;
    }
    */
    
    /**Change to Queueable */
    //global void execute(Database.BatchableContext bc, List<case> expired){
    global void execute(QueueableContext context){

        System.debug('job start Patient Reply Email');
		Set<Id> tmpParentId = new Set<Id>();
        Map<Id,EmailMessage> emailmessageMap = new Map<Id,EmailMessage>();
        List<Case> listReplyMailinCase = new List<Case>();
            
        List<EmailMessage> emailList = [select Parent.Id 
         	From EmailMessage 
            //Where FromAddress = 'noreply@bumrungrad.com'
            //And ToAddress = 'pre-registration@bumrungrad.com'                            
            Where FromAddress = 'noreply@bumrungrad.com' 
            And ToAddress = 'registration@leighripley.com'];     
        
        System.debug('emailList size : ' + emailList.size());
        
        if(emailList.size() > 0){
            for (EmailMessage tmpemail : emailList){
            	tmpParentId.add(tmpemail.Parent.Id);
                emailmessageMap.put(tmpemail.Parent.Id , tmpemail);
        	}
            
            listReplyMailinCase = [Select Id, Reply_From_Registration_Patient__c,OwnerId,CaseNumber,Patient_Reply_to_Registration_DateTime__c 
            	From Case                               
            	Where Id IN: tmpParentId
                And Status != 'Closed'                   
            	And Reply_From_Registration_Patient__c = false
                And Patient_Reply_to_Registration_DateTime__c = null];
            
            System.debug('listReplyMailinCase size : ' + listReplyMailinCase.size());
            
        }

        System.debug('reply email');
        RequestReplyEmailRegis api = new RequestReplyEmailRegis();
        System.debug('patient reply email Address jobId :'+ System.enqueueJob(api));

    }

    global void finish(Database.BatchableContext bc){
        System.debug('BatchReplyEmailRegis Success');
    }


}