global class EmailMessageBackup Implements Database.Batchable <sObject> {
    
    global Database.queryLocator start(
        Database.BatchableContext bc
    ){
                /*
        String strSOQL = 'SELECT Id, CreatedDate, BccAddress, ';
        strSOQL += 'CreatedById, CcAddress, ';
        strSOQL += 'LastModifiedById, MessageDate,';
        strSOQL += 'FromAddress,Headers, ';
        strSOQL += 'HtmlBody,';
        strSOQL += 'FirstOpenedDate, First_Response_Of_Email_Team__c, ';
        strSOQL += 'LastModifiedDate,LastOpenedDate, ';
        strSOQL += 'ME_First_Response_DateTime__c,';
        strSOQL += 'ParentId,Status,';
        strSOQL += 'Subject,TextBody,ToAddress ';
        strSOQL += 'FROM EmailMessage';
        strSOQL += 'WHERE CreatedDate = this_month';
        return Database.getQueryLocator( 
        strSOQL 
        );
        */
        String strSOQL = 'SELECT Id, CreatedDate, BccAddress, ' +
            'CreatedById, CcAddress, ' +
            'LastModifiedById, MessageDate, ' +
            'FromAddress, Headers, ' +
            'HtmlBody, ' +
            'FirstOpenedDate, First_Response_Of_Email_Team__c, ' +
            'LastModifiedDate, LastOpenedDate, ' +
            'ME_First_Response_DateTime__c, ' +
            'ParentId, Status, ' +
            'Subject, TextBody, ToAddress ' +
            'FROM EmailMessage ' +
            'WHERE CreatedDate = THIS_MONTH';
        return Database.getQueryLocator(strSOQL);
        
    }
    
    global void execute(
        Database.BatchableContext bc, 
        List < EmailMessage > listEmailMessage
    ){
        
        List < Email_Message_Backup__b > listEmailBackups = 
            new List < Email_Message_Backup__b >();
        
        for (
            EmailMessage objEmail : listEmailMessage
        ) {
            
            Email_Message_Backup__b objBackup = new Email_Message_Backup__b();
            objBackup.BccAddress__c = objEmail.BccAddress;
            objBackup.CreatedById__c = objEmail.CreatedById;
            objBackup.CreatedDate__c = objEmail.CreatedDate;
            objBackup.ParentId__c = objEmail.ParentId;
            objBackup.LastModifiedById__c = objEmail.LastModifiedById;
            objBackup.LastModifiedDate__c = objEmail.LastModifiedDate;
            objBackup.FromAddress__c = objEmail.FromAddress;
            objBackup.Headers__c = objEmail.Headers;
            objBackup.HtmlBody__c = objEmail.HtmlBody;
            objBackup.Headers__c = objEmail.Headers;
            objBackup.ME_First_Response_DateTime__c = objEmail.ME_First_Response_DateTime__c;
            objBackup.LastOpenedDate__c = objEmail.LastOpenedDate;
            objBackup.Message_Date__c = objEmail.MessageDate;
            objBackup.Subject__c = objEmail.Subject;
            objBackup.TextBody__c = objEmail.TextBody;
            objBackup.ToAddress__c = objEmail.ToAddress;
            listEmailBackups.add( objBackup );
            
        }
        
        if ( !Test.isRunningTest() ) {
            
            Database.insertImmediate(
                listEmailBackups
            ); 
            
        }
        //delete listEmailMessage;
        
    }
        global void finish( 
        Database.BatchableContext bc 
    ) { 
    }
        
    
    
    

}