global class BIH_CloneEmailFromClosedCase implements Database.Batchable<sObject>{
    public Set<Id> caseId {get;set;}

    public static Map<String,Mapping_Email_To_Team_Set__c> mapEmailToTeam {get{
        if(mapEmailToTeam==null){
            mapEmailToTeam = new Map<String,Mapping_Email_To_Team_Set__c>();
            for(Mapping_Email_To_Team_Set__c mapTeam : [Select ID, Name ,Email__c,Channel__c  from Mapping_Email_To_Team_Set__c]){
                mapEmailToTeam.put(mapTeam.Channel__c,mapTeam);
            }
        }
        return mapEmailToTeam;
    }set;}

    global BIH_CloneEmailFromClosedCase(Set<id> cid) {
        this.caseId = cid;
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //get clone closed case all under origin case
        return Database.getQueryLocator([Select id , Close_Case_Ref__c ,Channel__c
                                        from case where Close_Case_Ref__c in:caseId and status != 'Closed']); 
    }
    
    global void execute(Database.BatchableContext BC, List<Case> scope) {
        
        List<Id> closedCaseIdSet = new List<Id>();
        Map<Id,Id> caseIdWithRefCase = new Map<Id,Id>();
        if(scope.size() > 0){

            for(Case c : scope){
                closedCaseIdSet.add(c.Close_Case_Ref__c);
                caseIdWithRefCase.put(c.id,c.Close_Case_Ref__c);
            }
    
            Map<Id,EmailMessage> parentCasewithEmail = new Map<Id,EmailMessage> ();
            
            Map<Id,EmailMessage> mapEmail = new Map<Id,EmailMessage>(
                    [SELECT id,ParentId, ActivityId, CreatedById, TextBody, HtmlBody, Headers, Subject, FromName, 
                     FromAddress, ToAddress, CcAddress, BccAddress, Incoming,
                     HasAttachment, Status, MessageDate, IsDeleted, ReplyToEmailMessageId, IsExternallyVisible, 
                     MessageIdentifier, ThreadIdentifier, IsClientManaged, RelatedToId, IsTracked, IsOpened, 
                     FirstOpenedDate, LastOpenedDate, IsBounced, EmailTemplateId FROM EmailMessage 
                     where RelatedToId in: closedCaseIdSet order by createddate]);
    
            for(EmailMessage eml : mapEmail.values()){
               parentCasewithEmail.put(eml.RelatedToId,eml);//get latest email
            }


    
            system.debug('parentCasewithEmail'+parentCasewithEmail);
            List<EmailMessage> moveMail = new List<EmailMessage>();
            if(parentCasewithEmail.size() > 0){
                for(Case c : scope){
                    if(parentCasewithEmail.get(c.Close_Case_Ref__c)!=null){
                        
                        EmailMessage emails = parentCasewithEmail.get(c.Close_Case_Ref__c);
    
                        if(emails!=null){
                            EmailMessage cloneEmail = emails.clone();
                            string channelOfCase = c.Channel__c;
                            
                            //check channel before move email to clone case
                            if(channelOfCase !=null&&  mapEmailToTeam.get(channelOfCase)!=null){
                                string emailToList = mapEmailToTeam.get(channelOfCase).Email__c;
                                system.debug(Json.serializePretty(emailToList));

                                List<String> lstEmail = emailToList.split(';');//get email team list
                                
                                string toAddressEmail = cloneEmail.ToAddress;
                                
                                List<String> lstToAdressEmail = toAddressEmail.split(';');//split toAddress
                                //string firstToEmail = lstToAdressEmail.get(0); => change to check all email.

                                string ccAddressEmail = cloneEmail.CcAddress;
                                List<String> lstCCAdressEmail = new List<String>();
                                string firstCCEmail;
                                if(ccAddressEmail!=null){
                                   lstCCAdressEmail = ccAddressEmail.split(';');//split toAddress
                                    //firstCCEmail = lstCCAdressEmail.get(0); => change to check all email.
                                }
                                
                                //check ToAddress is found ?
                                Boolean foundToAddress = false;
                                for(String toEmail : lstToAdressEmail){
                                    string trimToAddress = toEmail.trim();
                                    system.debug(Json.serializePretty(lstEmail));
                                    //if(lstEmail.contains(trimToAddress)){
                                        cloneEmail.ParentId = c.id;
                                        cloneEmail.RelatedToId = c.id;
                                        moveMail.add(cloneEmail);
                                        c.Case_Detail__c = emails.HtmlBody;
                                        c.Subject = emails.Subject;
                                        c.suppliedemail = emails.FromAddress;
                                        foundToAddress = true;
                                        break;
                                    //}

                                }
                               
                                //If ToAddress not found,Check CCAddress.
                                if(!foundToAddress && lstCCAdressEmail.size() > 0){
                                    for(String ccEmail : lstCCAdressEmail){
                                        string trimCCAddress = ccEmail.trim();
                                        if(lstEmail.contains(trimCCAddress)){
                                            cloneEmail.ParentId = c.id;
                                            cloneEmail.RelatedToId = c.id;
                                            moveMail.add(cloneEmail);
                                            c.Case_Detail__c = emails.HtmlBody;
                                            c.Subject = emails.Subject;
                                            c.suppliedemail = emails.FromAddress;
                                            break;
                                        }
                                    }

                                }
                            }

                        }
 
                    }

                }
            }
            
            try{
    
            if(moveMail.size() > 0){
                Set<Id> cloneCaseIdSet = new Set<Id>(); 
                Database.SaveResult[] srList = Database.insert(moveMail, false);
                // Iterate through each returned result
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {

                        cloneCaseIdSet.add(sr.getId());

                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted account. Case ID: ' + sr.getId());
                        
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Case fields that affected this error: ' + err.getFields());
                        }
                    }
                }

                if(cloneCaseIdSet.size() > 0){
                    
                    Map<Id,EmailMessage> mapCloneCaseWithEmail = new Map<Id,EmailMessage>();
                    Map<Id,EmailMessage> mapRefCaseWithEmail = new Map<Id,EmailMessage>();

                    for(EmailMessage eml : [Select Id,ParentId FROM EmailMessage where Id in: cloneCaseIdSet]){
                        mapCloneCaseWithEmail.put(eml.ParentId,eml);//clone case and new email
                    }

                    Map<Id,EmailMessage> oldFileWithNewFile = new Map<Id,EmailMessage>();

                    for(EmailMessage eml : mapCloneCaseWithEmail.values()){
                        if(caseIdWithRefCase.get(eml.ParentId)!=null){//use new case id to find ref id
                            Id refCaseId = caseIdWithRefCase.get(eml.ParentId);//found ref case id

                            if(parentCasewithEmail.get(refCaseId)!=null){
                                Id oldFileId = parentCasewithEmail.get(refCaseId).id;//email parent
                                if(oldFileId!=null){
                                    oldFileWithNewFile.put(oldFileId,eml);//OldEmail and NewEmail
                                }
                            }
                        }
                    }
                    
                    //copy file
                    List<ContentDocumentLink> fileList = new List<ContentDocumentLink>();
                    for (ContentDocumentLink docLinks : [Select Id, ContentDocumentId,LinkedEntityId  from ContentDocumentLink where LinkedEntityId =: oldFileWithNewFile.Keyset()]) { 
                        for (ContentDocument docs : [Select Id, FileType, Title, FileExtension from ContentDocument where Id= :docLinks.ContentDocumentId ]) {
                            for (ContentVersion docVersion : [Select Id, VersionData,ContentDocumentId from ContentVersion where ContentDocumentId =:docLinks.ContentDocumentId ]) {
                
                                //relate to mail
                                ContentDocumentLink cDe = new ContentDocumentLink();
                                cDe.ContentDocumentId = docVersion.ContentDocumentId;
                                cDe.LinkedEntityId = oldFileWithNewFile.get(docLinks.LinkedEntityId).id; // you can use objectId,GroupId etc
                                cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                                cDe.Visibility = 'AllUsers';
                                fileList.add(cDe);

                                //relate to case
                                ContentDocumentLink cDe2 = new ContentDocumentLink();
                                cDe2.ContentDocumentId = docVersion.ContentDocumentId;
                                cDe2.LinkedEntityId = oldFileWithNewFile.get(docLinks.LinkedEntityId).ParentId; // you can use objectId,GroupId etc
                                cDe2.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                                cDe2.Visibility = 'AllUsers';
                                fileList.add(cDe2);
                            }
                        }
                    }
                    insert fileList;
                }

            }
            
            update scope;
                
            } catch (Exception e) {
                system.debug(e);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}