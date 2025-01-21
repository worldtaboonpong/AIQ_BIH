@isTest
public class BIH_CloneEmailFromClosedCaseTest 
{
    static testmethod void BIH_CloneEmailTest()
    {
        List<User> userList = BIH_TestUtils.createUsers(1, 'FName', 'LName', 'user_test@mail.com', true);
        userList.get(0).user_team__c = 'Individual Team';
        update userList.get(0);
        
        Group testGroup = new Group(Name='Individual Team', Type='Queue');
        insert testGroup;
        
        Mapping_Email_To_Team_Set__c mdtEmail = new Mapping_Email_To_Team_Set__c();
        mdtEmail.name = 'emailrefferral';
        mdtEmail.Email__c = 'test@bumrungrad.com;info.bihtest@gmail.com;test@bumrungrad.com;';
        mdtEmail.Channel__c = 'Referral';
        insert mdtEmail;
        
        Mapping_Email_To_Team_Set__c mdtEmail1 = new Mapping_Email_To_Team_Set__c();
        mdtEmail1.name = 'emailindividual';
        mdtEmail1.Email__c = 'info.bihtest@gmail.com';
        mdtEmail1.Channel__c = 'Individual';
        insert mdtEmail1;
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }
        Test.startTest();
        
        List<User> mUser = [SELECT Id FROM User WHERE FirstName =: 'FName'];
        System.runAs(userList.get(0)) {
            Set<Id> mCaseIds = new Set<Id>();
            List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321','Appointment','Email', true);        
            for(Case mCase : casesList)
            {
                mCaseIds.add(mCase.Id);
            }
            //closed case
            //casesList.get(0).OwnerId = testGroup.Id;
            casesList.get(0).Status = 'Closed';
            casesList.get(0).Close_Case_Reason__c = 'Normal Case';
            casesList.get(0).Channel__c = 'Referral';
            update casesList.get(0);
            
            
            
            List<EmailMessage> emailList2 = BIH_TestUtils.createEmailMessages(1 , 'Appointment Card',casesList.get(0).id, true);
            
            casesList.get(1).Close_Case_Ref__c = casesList.get(0).id;
            casesList.get(1).Status = 'New';
            casesList.get(1).OwnerId = testGroup.Id;
            casesList.get(1).Channel__c = 'Referral';
            update casesList.get(1);
            
            List<EmailMessage> emailList3 = BIH_TestUtils.createEmailMessages(1 , 'Appointment Card',casesList.get(0).id, true);
            List<EmailMessage> emailList4 = BIH_TestUtils.createEmailMessages(1 , 'Appointment Card',casesList.get(1).id, true);
            
            
            Map<String,Case> existingCloneCase = new Map<String,Case>();
            string closeIdwithChannel  = casesList.get(1).Close_Case_Ref__c+casesList.get(1).Channel__c;
            existingCloneCase.put(closeIdwithChannel,casesList.get(1));
            
            ContentVersion cv = new ContentVersion();
            cv.Title = 'Test Document';
            cv.PathOnClient = 'TestDocument.pdf';
            cv.VersionData = Blob.valueOf('Test Content');
            cv.IsMajorVersion = true;
            Insert cv;
            
            //Get Content Documents
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
            
            //Create ContentDocumentLink 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = emailList3.get(0).Id;
            cdl.ContentDocumentId = conDocId;
            cdl.shareType = 'V';
            Insert cdl;
            
            
            String subString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
            BIH_CloneEmailFromClosedCase.truncateSubject(subString);
            String subString1 = 'ref:Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.:ref';
            BIH_CloneEmailFromClosedCase.truncateSubject(subString1);
        }
        
        Test.stopTest();
    }
}