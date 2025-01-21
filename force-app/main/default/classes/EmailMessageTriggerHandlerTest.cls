@isTest
public class EmailMessageTriggerHandlerTest {
    @isTest
    public static void positiveTest(){
        
        List<User> userList = BIH_TestUtils.createUsers(1, 'FName', 'LName', 'user_test@mail.com', true);
        userList.get(0).user_team__c = 'Referral Team';
        update userList.get(0);
        
        Group testGroup = new Group(Name='Referral Team', Type='Queue');
        insert testGroup;
        
        Mapping_Email_To_Team_Set__c mdtEmail = new Mapping_Email_To_Team_Set__c();
        mdtEmail.name = 'emailrefferral';
        mdtEmail.Email__c = 'test@bumrungrad.com;info.bihtest@gmail.com;test@bumrungrad.com;';
        mdtEmail.Channel__c = 'Referral';
        insert mdtEmail;
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }
        Test.startTest();
        
        
        System.runAs(userList.get(0)) {
            List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321','Appointment','Email', true);        
            
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
            
            ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;    
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = emailList3.get(0).id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            insert cdl;
            
        }
        
        
        Test.stopTest();
    }
    
    @isTest
    public static void positiveTest2(){
        
        Test.startTest();
        List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321','Appointment','Email', true);
        
        //closed case
        casesList.get(0).Status = 'Pending';
        casesList.get(0).Pending_Reason__c  = 'N/A';
        update casesList.get(0);
        
        
        List<EmailMessage> emailList = BIH_TestUtils.createEmailMessages(1 , 'Appointment Card',casesList.get(0).id, true);
        
        Test.stopTest();
    }
    @isTest
    public static void positiveTest3(){
        
        Test.startTest();
        List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321','Appointment','Email', true);
        List<Case> casesList2 = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321','Appointment','Email', true);
        
        for (case c : casesList) {
            c.Status = 'Pending';
            c.Pending_Reason__c  = 'N/A';
            for (case cases : casesList2) {
                cases.Close_Case_Ref__c = c.Id; 
                cases.Status = 'Pending';
                cases.Pending_Reason__c  = 'N/A';
            }
        }
        //closed case
        
        update casesList;
        update casesList2;
        
        List<EmailMessage> emailList = BIH_TestUtils.createEmailMessages(1 , 'Appointment Card',casesList.get(0).id, true);
        
        Test.stopTest();
    }
    
    @isTest
    public static void Test4(){
        
        Mapping_Email_To_Team_Set__c mdtEmail = new Mapping_Email_To_Team_Set__c();
        mdtEmail.name = 'emailrefferral';
        mdtEmail.Email__c = 'test@bumrungrad.com;';
        mdtEmail.Channel__c = 'Referral';
        insert mdtEmail;
        
        
        Test.startTest();
        
        
        
        
        Mapping_Email_To_Team_Set__c me = new Mapping_Email_To_Team_Set__c(Name='Individual Team Case',Channel__c = 'Individual' ,Email__c ='test@bumrungrad.com,bih.test001@gmail.com');
        insert me;
        List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321','Appointment','Email', true);        
        Id PRIMARY_CASE_RECORDTYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Primary Case').getRecordTypeId();
        //closed case
        casesList.get(0).Status = 'Closed';
        casesList.get(0).Close_Case_Reason__c = 'Normal Case';
        casesList.get(0).Channel__c = 'Referral';
        casesList.get(0).OwnerId = UserInfo.getUserId();
        casesList.get(0).RecordTypeId = PRIMARY_CASE_RECORDTYPE;
        update casesList.get(0);
        Test.stopTest();
        
    }
    
    @isTest
    public static void negativeTest(){
        
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
        
        
        System.runAs(userList.get(0)) {
            List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321','Appointment','Email', true);        
            
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
            
            ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;    
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = emailList3.get(0).id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            insert cdl;
            
        }
        String subString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
        BIH_CloneEmailFromClosedCase.truncateSubject(subString);
        Test.stopTest();
    }

    
}