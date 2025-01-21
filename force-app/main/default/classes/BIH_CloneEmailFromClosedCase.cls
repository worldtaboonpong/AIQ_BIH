global class BIH_CloneEmailFromClosedCase { 
    public Set<Id> caseId {get;set;}
    
    public static Map<String,Mapping_Email_To_Team_Set__c> mapEmailToTeam {get{
        if(mapEmailToTeam==null){
            System.debug(' 1******BIH_CloneEmailFromClosedCase');
            mapEmailToTeam = new Map<String,Mapping_Email_To_Team_Set__c>();
            for(Mapping_Email_To_Team_Set__c mapTeam : [Select ID, Name ,Email__c,Channel__c  from Mapping_Email_To_Team_Set__c]){
                mapEmailToTeam.put(mapTeam.Channel__c,mapTeam);
            }
        }
        return mapEmailToTeam;
    }set;}
    
    global void cloneCase(Set<id> cid) {
        this.caseId = cid;
        List<Case> scope = new List<Case>([   Select id , Close_Case_Ref__c ,Channel__c,Subject
                                           from case where Close_Case_Ref__c in:caseId and status != 'Closed']); 
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
                                    c.Case_Detail__c = emails.TextBody;//HtmlBody;
                                    c.Subject = truncateSubject(emails.Subject);
                                    c.Subject__c = emails.Subject;
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
                                            c.Case_Detail__c = emails.TextBody;//HtmlBody;
                                            c.Subject = truncateSubject(emails.Subject);
                                            c.Subject__c = emails.Subject;
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
                
                if(cloneCaseIdSet.size() > 0)
                {
                    
                    Map<Id,EmailMessage> mapCloneCaseWithEmail = new Map<Id,EmailMessage>();
                    Map<Id,EmailMessage> mapRefCaseWithEmail = new Map<Id,EmailMessage>();
                    Map<Id,EmailMessage> oldFileWithNewFile = new Map<Id,EmailMessage>();
                    
                    List<EmailMessage> mEmailMessageList = [Select Id,ParentId FROM EmailMessage where Id in: cloneCaseIdSet];
                    
                    if(mEmailMessageList.size() > 0)
                    {
                        for(EmailMessage eml : mEmailMessageList)
                        {
                            mapCloneCaseWithEmail.put(eml.ParentId,eml);//clone case and new email
                        }
                    }
                    
                    if(mapCloneCaseWithEmail.size() > 0)
                    {
                        for(EmailMessage eml : mapCloneCaseWithEmail.values())
                        {
                            if(caseIdWithRefCase.get(eml.ParentId)!=null)
                            {//use new case id to find ref id
                                Id refCaseId = caseIdWithRefCase.get(eml.ParentId);//found ref case id
                                
                                if(parentCasewithEmail.get(refCaseId)!=null)
                                {
                                    Id oldFileId = parentCasewithEmail.get(refCaseId).id;//email parent
                                    if(oldFileId!=null)
                                    {
                                        oldFileWithNewFile.put(oldFileId,eml);//OldEmail and NewEmail
                                    }
                                }
                            }
                        }
                    }
                    
                    //copy file
                    List<ContentDocumentLink> fileList = new List<ContentDocumentLink>();
                    
                    Set<Id> mDocLinksId = new Set<Id>();
                    Set<Id> mDocumentId = new Set<Id>();
					
                    List<ContentDocumentLink> mDocumentLinkList = [Select Id, ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId IN: oldFileWithNewFile.Keyset()];
                    if(mDocumentLinkList.size() > 0)
                    {
                        for(ContentDocumentLink mContentDocs : mDocumentLinkList)
                        {
                            mDocLinksId.add(mContentDocs.ContentDocumentId);
                        }
                    }
                    //List<ContentDocument> mDocumentList = [Select Id, FileType, Title, FileExtension from ContentDocument where Id IN: mDocLinksId];
                    
                    List<ContentVersion> mContentVersionList = [Select Id, VersionData,ContentDocumentId from ContentVersion where ContentDocumentId IN: mDocLinksId ];
                    
                    for (ContentDocumentLink docLinks : mDocumentLinkList)
                    { 
                        for (ContentVersion docVersion : mContentVersionList) 
                        {
                            if(docVersion.ContentDocumentId == docLinks.ContentDocumentId)
                            {
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
                    if(fileList.size() > 0)
                    {
                        insert fileList;
                    }
                }
                
            }
            if(scope.size() > 0)
            {
                update scope;
            }
            
        }
        
    }
    
    //Method to truncate Email Subject
    public static String truncateSubject(String subjectString) 
    {
        
        String newSubject = '';
        if (subjectString.length() > 255) 
        {
            String strNew = subjectString.substringBetween('ref:', ':ref');
            if (strNew != null && strNew.length() > 0)
            {
                newSubject = subjectString.left(210) + ' [ ref:'+strNew+':ref ]';
            } 
            else 
            {
                newSubject = subjectString.left(255);
            }
        } 
        else 
        {
            newSubject = subjectString;
        }
        return newSubject;
    }
}