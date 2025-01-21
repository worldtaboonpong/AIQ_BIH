@isTest
public class BIH_CaseUtilityTest {
  @isTest
    public static void positiveTest(){
        Test.startTest();
        
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1 , 'Test001','BIHTest@bumrungradtest.com', true);
        List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        Id REGISTRATION_CASE_RECORDTYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Registration Case').getRecordTypeId();
        Case c = new Case(); 
            c.Subject = 'Test naja HN: 098765432';
            c.Case_Category_Level1__c = 'Appointment';
            //c.your_question__c = 'Your Question';
            c.origin = 'Web';
        c.RecordTypeId = REGISTRATION_CASE_RECORDTYPE;
        c.ParentId = casesList.get(1).id;
        insert c;
        
        Lead l = new Lead();
        l.lastname = 'test001';
        
 
        BIH_CaseUtility.convertCaseToLead(l);
        // BIH_CaseUtility.getPickListValuesCloseCaseReason('Case',c.recordTypeId,'Close_Case_Reason__c');
        BIH_CaseUtility.mapClosedCase();
        BIH_CaseUtility.recordTypeMap();
        BIH_CaseUtility.ownerMap();
        BIH_CaseUtility.mapDataChildcase();
        BIH_CaseUtility.ClosedrecordTypeMap();
        BIH_CaseUtility.UpdateCaseRecord(casesList);
        BIH_CaseUtility.getCurrent();
        BIH_CaseUtility.UpdateCase(casesList.get(1));
        //BIH_CaseUtility.UpdateReActivate(casesList.get(1));
        BIH_CaseUtility.closeAllChildCase(casesList.get(1).Id,'Normal Close',casesList);
        //BIH_CaseUtility.getPickListValuesCloseCaseReason();
        BIH_CaseUtility.getPickListValuesLeadSource();
        List<string> picklistField = new List<string>{'Priority'};
        BIH_CaseUtility.getPickListValuesCaseMapping(picklistField);
        BIH_CaseUtility.getPickListValuesCase('Priority');
        BIH_CaseUtility.getcloseAllChildCase(casesList.get(0).Id,'Referral');
        BIH_CaseUtility.getcloseAllCase(casesList.get(0).Id);
        BIH_CaseUtility.getisCC(casesList.get(0).Id);
        BIH_CaseUtility.getSMSCase(casesList.get(0).Id);
        // BIH_CaseUtility.sendSMSMessage('TEST',casesList.get(0),'0823857141');
        BIH_CaseUtility.getSVTM();
        BIH_CaseUtility.getSMSTemplate();
        BIH_CaseUtility.getSMSTemplateKey();
        BIH_CaseUtility.getCaseQuickButtonAssignment('Contact Center Team');
        
        // BIH_CaseUtility a = new BIH_CaseUtility();
        // a.caseRecordTypeName;
        // a.mapCaseStatusWithRecordType;
        // Case a = new Case();
        // a.Case_Category_Level1__c.addError('FIELD_CUSTOM_VALIDATION_EXCEPTION');
        // BIH_CaseContactInformationCtrl.saveCase(a);

        
        BIH_CaseUtility.getBtnConfig();
        BIH_CaseUtility.getisPreRegis(c.id);
     	BIH_CaseUtility.getUserSessionId();
        BIH_CaseUtility.getisPC(c.id);
        BIH_CaseUtility.closeCaseByMyselfAction(c.id);
        BIH_CaseUtility.closeCaseSuppotAction(c.id);    

        
        //BIH_CaseUtility.getPickListValuesCloseCaseReason('Case',c.recordTypeId,'Close_Case_Reason__c');
        //Id REGISTRATION_CASE_RECORDTYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Registration Case').getRecordTypeId();
   
        
             
        

        
        Test.stopTest();
    }
   
    @isTest
    public static void testws(){
        Id REGISTRATION_CASE_RECORDTYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Registration Case').getRecordTypeId();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        
		BIH_CaseUtility.getPickListValuesCaseStatus(REGISTRATION_CASE_RECORDTYPE);
        BIH_CaseUtility.getBtnConfig();
        system.debug('a'+REGISTRATION_CASE_RECORDTYPE);
        Test.stopTest();
    }
    
    @isTest
    public static void testws1(){
        Id REGISTRATION_CASE_RECORDTYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Registration Case').getRecordTypeId();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        
		BIH_CaseUtility.getPickListValuesCloseCaseReason('Case',REGISTRATION_CASE_RECORDTYPE,'Close_Case_Reason__c');
        
        
        Test.stopTest();
    }
    
    
    @isTest
    public static void positiveTest2(){
        Test.startTest();
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1 , 'Test001','BIHTest@bumrungradtest.com', true);
        List<Case> casesList = BIH_TestUtils.createCases(1 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        
    
        BIH_CaseUtility.validateCaseDuplicate(casesList.get(0).id);
        BIH_CaseUtility.getAllChildCase(casesList.get(0).id);
        BIH_CaseUtility.getCaseInfo(casesList.get(0).id);
        
        
        BIH_CaseContactInformationCtrl.getCaseContactInformation(casesList.get(0).id);
        BIH_CaseContactInformationCtrl.getNotefromAccount(accList.get(0).id);
        BIH_CaseContactInformationCtrl.saveCase(casesList.get(0));
        
        
        BIH_ChildCaseDynamicCtrl.mapDataChildcase();
        BIH_ChildCaseDynamicCtrl.ownerMap();
        BIH_ChildCaseDynamicCtrl.recordTypeMap();

        //BIH_CaseContactInformationCtrl.saveCase(casesList2.get(0));
        BIH_GeneralWebInformationCtrl.getCaseInformation(casesList.get(0).id);

        Case tmpCase = casesList.get(0);
        tmpCase.Hospital_Number_HN__c = '0909090909090909090';
    BIH_CaseContactInformationCtrl.saveCase(tmpCase);
        System.debug(BIH_CloneEmailFromClosedCase.mapEmailToTeam);
        Test.stopTest();
    }
    @isTest
    public static void negativeTest(){
        Test.startTest();
        Case case2 = new Case();
        List<Case> casesList = BIH_TestUtils.createCases(1 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        BIH_CaseContactInformationCtrl.saveCase(casesList[0]);
        // BIH_CaseUtility.UpdateCaseOwner(casesList.get(0));
        // BIH_CaseUtility.UpdateReActivate(casesList.get(0));
        // BIH_CaseUtility.closeAllChildCase(case2.Id,'EIEIEI');
        Test.stopTest();
    }
    @isTest
    public static void positiveTest3(){
        Test.startTest();
        PageReference pageRef = Page.BIH_PickListDesc;
        List<Case> casesList = BIH_TestUtils.createCases(1 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        pageRef.getParameters().put('id',casesList.get(0).id);
        pageRef.getParameters().put('recordTypeId',casesList.get(0).recordTypeId);
        pageRef.getParameters().put('recordTypeName','Airport_Transfer_Case');
        pageRef.getParameters().put('sobjectType','Case');
        Test.setCurrentPage(pageRef);
        BIH_PickListDescCtrl.describe(casesList.get(0).id,'Reactivated__c');
        // ApexPages.StandardController sc = new ApexPages.StandardController(casesList.get(0));
        BIH_PickListDescCtrl obj = new BIH_PickListDescCtrl();
        // obj.redirPage();
        // obj.isBlank;
        Test.stopTest();

    }

    @isTest
    public static void positiveTest5(){
        Test.startTest();
        List<Case> casesList = BIH_TestUtils.createCases(6 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1 , 'Test001','BIHTest@bumrungradtest.com', true);
        String caseId = casesList.get(0).Id;
        String accId = accList.get(0).Id;
        Datetime dt = Datetime.now();
        BIH_FollowUpStepCtrl.getPickListValuesMap();
        BIH_FollowUpStepCtrl.getPickListValuesIntoList('Follow_Up_Step__c','Step__c');
        BIH_FollowUpStepCtrl.getDependencyFieldValues('Step__c','Step_Status__c');
        BIH_FollowUpStepCtrl.getDatetime();
        user followUser =BIH_FollowUpStepCtrl.getCurrentUser();
        BIH_TestUtils.createFollowUpStep(casesList.get(0).Id,followUser.Id,'Call 1');
        BIH_TestUtils.createFollowUpStep(casesList.get(1).Id,followUser.Id,'Call 2');
        BIH_TestUtils.createFollowUpStep(casesList.get(2).Id,followUser.Id,'Call 3');
        BIH_TestUtils.createFollowUpStep(casesList.get(3).Id,followUser.Id,'Email');
        BIH_TestUtils.createFollowUpStep(casesList.get(4).Id,followUser.Id,'SMS');
        BIH_FollowUpStepCtrl.getTopLevelFollowUp(casesList.get(0).Id);
        BIH_FollowUpStepCtrl.getTopLevelFollowUp(casesList.get(1).Id);
        BIH_FollowUpStepCtrl.getTopLevelFollowUp(casesList.get(2).Id);
        BIH_FollowUpStepCtrl.getTopLevelFollowUp(casesList.get(3).Id);
        BIH_FollowUpStepCtrl.getTopLevelFollowUp(casesList.get(4).Id);
        BIH_FollowUpStepCtrl.getTopLevelFollowUp(casesList.get(5).Id);
        BIH_FollowUpStepCtrl.SaveFollowUp('SMS','Success','0891234567',dt,casesList.get(0).Id,followUser.Id,'TEST');
        BIH_CaseUtility.getFollowUpStep(casesList[0].id);
        Test.stopTest();
    }

    @isTest
    public static void positiveTest6(){
        Test.startTest();
        List<Case> casesList = BIH_TestUtils.createCases(3 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        List<Case> casesList2 = BIH_TestUtils.createCases(1 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        List<EmailMessage> emailList = BIH_TestUtils.createEmailMessages(1 , 'Appointment Card',casesList2.get(0).id, true);
        for (EmailMessage email : emailList){
            email.CcAddress = 'test@test.com';
        }
        update emailList;
        Set<Id> testSet = new Set<Id>();
        testSet.add(casesList2.get(0).Id);
        for (Case c : casesList){
            c.Close_Case_Ref__c = casesList2.get(0).Id;
            c.Status = 'New';
        }
        update casesList;
        Mapping_Email_To_Team_Set__c teamSet = new Mapping_Email_To_Team_Set__c();
        teamSet.Name = 'Contact Center Team';
        teamSet.Email__c = 'info.contactuat@gmail.com;info.contacttest@gmail.com;info.contactuat2@gmail.com;info.contacttest2@gmail.com;';
        teamSet.Channel__c = 'Contact Center';
        insert teamSet;
        // ContentDocument cd = new ContentDocument();
        // cd.FileType = 'PNG';
        // cd.Title = 'logo-bi';
        // cd.FileExtension = 'png';
        // insert cd;
        // ContentDocumentLink cdl = new ContentDocumentLink();
        // cdl.LinkedEntityId = casesList2.get(0).Id;
        // cdl.ContentDocumentId = cd.Id;
        // insert cdl;
        
        // Map<String,Mapping_Email_To_Team_Set__c> mapEmailToTeam = new Map<String,Mapping_Email_To_Team_Set__c>();
        update casesList;
        //BIH_CloneEmailFromClosedCase cloneemail = new BIH_CloneEmailFromClosedCase(testSet);
        // cloneemail.mapEmailToTeam;
        //Database.executeBatch(cloneemail);
        // RestRequest req = new RestRequest();
        // RestResponse res = new RestResponse();
        // req.requestURI = '/services/apexrest/BIH_WebToCaseService';  //Request URL
        // req.httpMethod = 'POST';//HTTP Request Type
        // req.requestBody = Blob.valueof(JsonMsg);
        // RestContext.request = req;
        // RestContext.response= res;
        
        // List<Case> casesList = BIH_TestUtils.createCases(1 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        // BIH_SendSMSService.getAppointmentInformation('Message TEST',casesList.get(0),'0823857141');
        Test.stopTest();
    }
    @isTest
    public static void positiveTest7() {
        List<Case> casesList = BIH_TestUtils.createCases(1 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        Test.setMock(HttpCalloutMock.class, new BIH_SendSMSServiceMockUpImpl());
        casesList[0].App_Time__c = Time.newInstance(18, 30, 2, 20);
        casesList[0].App_Date__c = Date.today();
        update casesList;
        Test.startTest();
        // BIH_SendSMSService.getAppointmentInformation('Message TEST',casesList.get(0),'0823857141');
        
        BIH_CaseUtility.getSMSCase(casesList[0].id);

        BIH_CaseUtility.sendSMSMessage('Message TEST',casesList.get(0),'0823857141');

       
        Test.stopTest();
    }
     @isTest
    public static void positiveTest8() {
        Online_Service_Log__c tstLog = BIH_TestUtils.createOnlineServiceLog();
        Test.startTest();
        OnlineServiceLog.generateContentVersionRequest(tstLog,'test');
        OnlineServiceLog.generateContentVersionResponse(tstLog,'true');
        // OnlineServiceLog.generateFile(tstLog.Id,'TEST');
        Test.stopTest();
    }
    @isTest
    public static void positiveTest9() {
        Test.startTest();
        PageReference pageRef = Page.BIH_PickListDesc;
        List<Case> casesList = BIH_TestUtils.createCases(1 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        pageRef.getParameters().put('id',casesList.get(0).id);
        pageRef.getParameters().put('recordTypeId',casesList.get(0).recordTypeId);
        pageRef.getParameters().put('recordTypeName','Airport_Transfer_Case');
        // pageRef.getParameters().put('sobjectType','Case');
        Test.setCurrentPage(pageRef);
        // BIH_PickListDescCtrl.describe(casesList.get(0).id,'Reactivated__c');
        // ApexPages.StandardController sc = new ApexPages.StandardController(casesList.get(0));
        // BIH_PickListDescCtrl obj = new BIH_PickListDescCtrl();
        // obj.redirPage();
        // obj.isBlank;
        BIH_PickListDescCtrl.describe('Case', 'Airport_Transfer_Case', 'Id');

        Test.stopTest();
    }
     @isTest
    public static void positiveTest10() {
        Test.startTest();
        BIH_CaseUtility.Request tmpReq = new BIH_CaseUtility.Request();
        // BIH_CaseUtility ctrl = new BIH_CaseUtility();
        tmpReq.convertToObject('{ "md_code" : "100001"}');
        Map<Id,RecordType> tmpMap = BIH_CaseUtility.caseRecordTypeName;
        Map<Id,Case_Status_with_Record_Type__mdt> tmpMap2  =BIH_CaseUtility.mapCaseStatusWithRecordType;
        Test.stopTest();
    }

    @isTest
    public static void positiveTestLiveChatTranscript(){
        Test.startTest();
        List<Case> casesList = BIH_TestUtils.createCases(1 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        //LiveChatTranscript script = new LiveChatTranscript();
        //LiveChatVisitor visitor = new LiveChatVisitor();
        // visitor.SessionKey = 'TEST';
        //insert visitor;
        // Group groups = new Group();
        // groups.Name = 'Individual Team Case';
        // groups.DeveloperName = 'Individual_Team_Case';
        // groups.Type = 'Queue';
        // upsert groups;
        //script.status = 'Completed';
        //script.LiveChatVisitorId = visitor.Id;
        //insert script;
       // script.status = 'Missed';
        //script.CaseId = casesList.get(0).Id;
        //update script;
        Test.stopTest();
    }
   
}