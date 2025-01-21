@isTest
public with sharing class BIH_EditChildCaseFormCtrl_Test {
    @testSetup static void methodName() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(2, 'test','test@mail.com', true);
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        List<User> userList = BIH_TestUtils.createUsers(1, 'FName', 'LName', 'user_test@mail.com', true);
        
        Doctor__c doctor = new Doctor__c();
        doctor.Name = 'test_doctor';
        insert doctor;
        caseList[0].AccountId = accList[0].id;
        caseList[0].Patient__c = accList[1].id;
        caseList[0].Doctor__c = doctor.id;
        caseList[0].Building__c = 'test1';
        caseList[0].Escalate_To__c = 'Airport';
        caseList[0].Department__c = 'test1';
        
        BIH_TestUtils.createServiceTypeMatrixs();
        List<Service_Type_Matrix__c> stmList = new List<Service_Type_Matrix__c>();
        Service_Type_Matrix__c stm = [SELECT id FROM Service_Type_Matrix__c LIMIT 1 ];
        stm.Channel__c ='Referral'; 
        stmList.add(stm);
    
        Service_Type_Matrix__c tmp_serive_type = new Service_Type_Matrix__c();
        tmp_serive_type.Category_Level1_English__c = 'test_cate1';
        tmp_serive_type.Category_Level2_English__c = 'test_cate2';
        tmp_serive_type.Category_Level3_English__c ='test_cate4';
        tmp_serive_type.Channel__c ='Referral';
        tmp_serive_type.SLA__c =240;
        stmList.add(tmp_serive_type);
    
        upsert stmList;
    
        System.debug('Service_Type_Matrix__c : '+[SELECT id FROM Service_Type_Matrix__c] );
    
        BIH_Building__c bud = new BIH_Building__c();    
        bud.Building_EN__c = 'test1';
        bud.BIH_Department__c = 'test1';
        bud.Building_TH__c = 'test1';
        bud.Department_EN__c = 'test1';
        bud.Department_TH__c = 'test1';
        bud.Floor__c = 'test1';
        insert bud;     
        // caseList[0].OwnerId = userList[0].id;

        update caseList;
    
        Case_Campaign_Master__c ccm = new Case_Campaign_Master__c();
        ccm.Campaign_Code__c = '001';
        ccm.Max__c = 10;
        ccm.Campaign_Detail__c = '001';
        ccm.Campaign_Source__c  = 'fb';
        ccm.Campaign_Type__c = 'Public';
        insert ccm;
    
        Case_Campaign_Master__c ccm2 = new Case_Campaign_Master__c();
        ccm2.Campaign_Code__c = '002';
        ccm2.Max__c = 10;
        ccm2.Campaign_Detail__c = '002';
        ccm2.Campaign_Source__c  = 'line';
        ccm2.Campaign_Type__c = 'Offered';
        insert ccm2;
    
        accList[0].Hospital_Number_HN__c = '000000000001';
        update accList[0];
    
        Case_Campaign_Patient__c ccp = new Case_Campaign_Patient__c();
        ccp.Patient__c  = accList[0].Id;
        ccp.Campaign_Master__c  = ccm2.id;
        insert ccp;
    }
    @isTest
    public static void test_method_1(){
        List<Account> acc = [SELECT id FROM Account LIMIT 2];
        Case casetmp = [SELECT id,Status,RecordTypeId,Building__c,Department__c,Escalate_To__c FROM Case LIMIT 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BIH_GetPickListValuesByHttpReqMockImpl());
        // BIH_EditCaseForContactCenterCtrl ctrl = new BIH_EditCaseForContactCenterCtrl();  
        BIH_EditChildCaseFormCtrl.pickListValueWrapper tmp_picklist_value=  BIH_EditChildCaseFormCtrl.getPickListValueWrapper(casetmp.RecordTypeId,casetmp.id); 
        Map<String, List<BIH_PicklistOption>> tmp_dependency_field =  BIH_EditChildCaseFormCtrl.getDependencyFieldValues('Status','Close_Case_Reason__c');  
        BIH_EditChildCaseFormCtrl.getParentIdOnFocusTab(acc[0].id); 
        BIH_EditChildCaseFormCtrl.CaseAndPatientInformationWrapper tmp_case_patient_info = BIH_EditChildCaseFormCtrl.getCaseAndPatientInformation(casetmp.id);  
        BIH_EditChildCaseFormCtrl.UpdateCaseRecord(casetmp, acc[0],acc[1]); 
        BIH_EditChildCaseFormCtrl.CaseAndPatientInformationWrapper tmp_case_patient_info2 = BIH_EditChildCaseFormCtrl.getCaseAndPatientInformation(null);
    
        
        
        // BIH_EditChildCaseFormCtrl ctrl = new BIH_EditChildCaseFormCtrl();
        //BIH_EditChildCaseFormCtrl.pickListValueWrapper tmp_picklist_value=  BIH_EditChildCaseFormCtrl.getPickListValueWrapper(casetmp.RecordTypeId,casetmp.id);
        //Map<String, List<BIH_PicklistOption>> tmp_dependency_field =  BIH_EditChildCaseFormCtrl.getDependencyFieldValues('Status','Close_Case_Reason__c');
        //BIH_EditChildCaseFormCtrl.getParentIdOnFocusTab(acc[0].id);
        //BIH_EditChildCaseFormCtrl.CaseAndPatientInformationWrapper tmp_case_patient_info = BIH_EditChildCaseFormCtrl.getCaseAndPatientInformation(casetmp.id);
        //BIH_EditChildCaseFormCtrl.UpdateCaseRecord(casetmp, acc[0],acc[1]);
        //BIH_EditChildCaseFormCtrl.CaseAndPatientInformationWrapper tmp_case_patient_info_test = new BIH_EditChildCaseFormCtrl.CaseAndPatientInformationWrapper();
        //tmp_case_patient_info_test = BIH_EditChildCaseFormCtrl.getCaseAndPatientInformation(casetmp.Id);
        //BIH_EditChildCaseFormCtrl.CaseAndPatientInformationWrapper tmp_case_patient_info2 = BIH_EditChildCaseFormCtrl.getCaseAndPatientInformation(null);
        Test.stopTest();
    }
    
    @isTest
    public static void test_method_2(){
        List<Account> acc = [SELECT id FROM Account LIMIT 2];
        Case casetmp = [SELECT id,Status,RecordTypeId,Building__c,Department__c,Escalate_To__c FROM Case LIMIT 1];
        List<User> enduserList = BIH_TestUtils.createEndUsers(1, 'FName001', 'LName0001', 'user_test001@mail.com',BIH_TestUtils.AIRPORT_PROFILE_ID, true);
        Test.setMock(HttpCalloutMock.class, new BIH_GetPickListValuesByHttpReqMockImpl());
        System.runAs(enduserList.get(0)) {
            Test.startTest();
            // BIH_EditChildCaseFormCtrl ctrl = new BIH_EditChildCaseFormCtrl();
            //BIH_EditChildCaseFormCtrl.pickListValueWrapper tmp_picklist_value=  BIH_EditChildCaseFormCtrl.getPickListValueWrapper(casetmp.RecordTypeId,casetmp.id);
            Map<String, List<BIH_PicklistOption>> tmp_dependency_field =  BIH_EditChildCaseFormCtrl.getDependencyFieldValues('Status','Close_Case_Reason__c');
     
        BIH_EditChildCaseFormCtrl.pickListValueWrapper testpickListValueWrapper = BIH_EditChildCaseFormCtrl.getPickListValueWrapper(casetmp.RecordTypeId,casetmp.Id);       
            //BIH_EditChildCaseFormCtrl.CaseAndPatientInformationWrapper tmp_case_patient_info2 = BIH_EditChildCaseFormCtrl.getCaseAndPatientInformation(null);
            Test.stopTest();
        }
        
        
    }
    @isTest
    public static void test_method_3(){
        List<Case_Campaign_Master__c> ccmList = [SELECT id FROM Case_Campaign_Master__c WHERE Campaign_Type__c = 'Offered' LIMIT 1];
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BIH_GetPickListValuesByHttpReqMockImpl());
        BIH_EditChildCaseFormCtrl.CampaignWrapper cw = BIH_EditChildCaseFormCtrl.getCampaignList('000000000001');
        BIH_EditChildCaseFormCtrl.CampaignDetailWrapper cdw = BIH_EditChildCaseFormCtrl.getCampaignDetail(ccmList[0].id);
        Test.stopTest();
    }
    @istest
    public static void test_method_99(){
        Case cs = [select Id from Case limit 1];

        Test.startTest();
        BIH_EditChildCaseFormCtrl.getClientId(cs.Id);
        BIH_EditChildCaseFormCtrl.getSessionId();
        BIH_EditChildCaseFormCtrl.getUserName();
        BIH_EditChildCaseFormCtrl.getPDVSEndpoint();
        BIH_EditChildCaseFormCtrl.getBtnConfig();
        BIH_EditChildCaseFormCtrl.getCaseAndPatientInformationUpdated(cs.Id);
        
        
        
        BIH_EditCaseForContactCenterCtrl.getClientId(cs.Id);
        BIH_EditCaseForContactCenterCtrl.getSessionId();
        BIH_EditCaseForContactCenterCtrl.getUserName();
        BIH_EditCaseForContactCenterCtrl.getPDVSEndpoint();
        BIH_EditCaseForContactCenterCtrl.getBtnConfig();
        BIH_EditCaseForContactCenterCtrl.getCaseAndPatientInformationUpdated(cs.Id);
        
        
        
        BIH_CaseContactInformationCtrl.getClientId(cs.Id);
        BIH_CaseContactInformationCtrl.getSessionId();
        BIH_CaseContactInformationCtrl.getUserName();
        BIH_CaseContactInformationCtrl.getPDVSEndpoint();
        BIH_CaseContactInformationCtrl.getBtnConfig();
        BIH_CaseContactInformationCtrl.publishRequest('');

        Contact ct = [Select Id from Contact limit 1];
        Account accc = [select Id from Account limit 1];
        Account accc2 = [select Id from Account limit 2].get(1);
        BIH_EditCaseForContactCenterCtrl.getSenderAccountByContact(ct.Id);
        BIH_EditCaseForContactCenterCtrl.getContactParentIdOnFocusTab(ct.Id);
        BIH_EditCaseForContactCenterCtrl.getParentIdOnFocusTab(accc.Id);
        cs.Status = 'Pending';
        cs.Pending_Reason__c = 'Follow up';
        update cs;
        try {
            BIH_EditCaseForContactCenterCtrl.UpdateCaseRecord(cs,accc,accc2);
        } catch (Exception e) {
            
        }
        BIH_EditCaseForContactCenterCtrl.getPickListValuesIntoListByVFPrimary(new List<String>{'Pending_Reason__c'});

        BIH_CaseContactInformationCtrl.getCaseContactInformation(cs.Id);
        BIH_CaseContactInformationCtrl.getNotefromAccount(accc.Id);
        BIH_CaseContactInformationCtrl.saveCase(cs);
        
        
        
        
        Map<String,Contact_Center_Escalation_Rule__mdt> aaa = BIH_EditCaseForContactCenterCtrl.mapContactCenterEscalationRule;
        Map<Id,Case_Status_with_Record_Type__mdt> bbb = BIH_EditCaseForContactCenterCtrl.mapCaseStatusWithRecordType;
           
        Test.stopTest();
    }
    @isTest
    public static void test_method_4(){
        List<Account> acc = [SELECT id FROM Account LIMIT 2];
        Case casetmp = [SELECT id,RecordTypeId FROM Case LIMIT 1];
        Map<Id,Case_Status_with_Record_Type__mdt> testMap = BIH_EditChildCaseFormCtrl.mapCaseStatusWithRecordType;
        List<String> caseName = new List<String>();
        caseName.add('Full_Name__c');
        Test.setMock(HttpCalloutMock.class, new BIH_GetPickListValuesByHttpReqMockImpl());
        Test.startTest();
        BIH_EditChildCaseFormCtrl.getPickListValuesIntoListByVFPrimary(caseName);
        //BIH_EditChildCaseFormCtrl.UpdateCaseRecord(casetmp,acc[0], acc[1]);
        BIH_EditChildCaseFormCtrl.getParentIdOnFocusTab(acc[0].Id);
        BIH_EditChildCaseFormCtrl.getCaseAndPatientInformation(casetmp.Id);
        BIH_EditChildCaseFormCtrl.getCurrentUserLanguage();
        BIH_EditChildCaseFormCtrl.getCurrentUserRole();
        // BIH_EditChildCaseFormCtrl.pickListValueWrapper testpickListValueWrapper2 = BIH_EditChildCaseFormCtrl.getPickListValueWrapper('',casetmp.Id);
        Test.stopTest();
    }
        @isTest
    public static void test_method_5(){
        Test.startTest();
        
        Case_Campaign_Master__c CampMas = new Case_Campaign_Master__c();
        CampMas.Name = 'TestCamp';
        CampMas.Campaign_Code__c = '0001';
        insert CampMas;
        
        Case testcase = new Case();
        //testcase.Name = 'Test001';
        //testcase.CASENUMBER = '0001';
        testcase.CASE_CATEGORY_LEVEL1__C = 'General Information';
        testcase.CHANNEL__C = 'Referral';
        testcase.ESCALATE_DATE__C = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        testcase.ESCALATE_TO__C = 'Referral';
        testcase.ORIGIN = 'Email';
        testcase.PRIORITY = 'High';
        testcase.SUBJECT = 'test01';
        testcase.SUPPLIEDEMAIL ='aa@aa.com';
        testcase.RecordTypeId =  Schema.sObjectType.Case.getRecordTypeInfosByName().get('Primary Case').getRecordTypeId();
        testcase.CAMPAIGN_INTEREST_TYPE__C = 'Interest';
        testcase.CAMPAIGN_MASTER__C = CampMas.Id;
        insert testcase;
        
        Test.stopTest();
    } 
     
    @isTest
    public static void negativeTest(){
        Airport_Flight__c airportFlight = new Airport_Flight__c();
        airportFlight.Flight_Number__c = '3K511';
        airportFlight.Arrival_Time__c  = '845';
        insert airportFlight;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BIH_GetPickListValuesByHttpReqMockImpl());
        Case casetmp = [SELECT id,RecordTypeId FROM Case LIMIT 1];
        
        BIH_EditChildCaseFormCtrl.getPickListValueWrapper('','');
        BIH_EditChildCaseFormCtrl.getPickListValueWrapper(BIH_Constants.AIRPORT_TRANSFER_CASE_RECORDTYPE,casetmp.Id);
        
        Test.stopTest();

    }
    
    
    
    @isTest
    public static void negativeTest2(){
        Test.startTest();
        BIH_EditChildCaseFormCtrl.getPROwnernameDetail();
        BIH_EditChildCaseFormCtrl.getPRFollowerDetail();
        BIH_EditChildCaseFormCtrl.getInprogressReasonDetail();
        BIH_EditChildCaseFormCtrl.getIndiRefferDetail();
        BIH_EditChildCaseFormCtrl.getReviewByDetail();
        BIH_EditChildCaseFormCtrl.getSpecialtyDetail();
        BIH_EditChildCaseFormCtrl.getLikelyProDetail();
        BIH_EditChildCaseFormCtrl.getWhenConsultDetail();
        BIH_EditChildCaseFormCtrl.getGenderNewPatientDetail();
        BIH_EditChildCaseFormCtrl.getTitleNewPatientDetail();
        BIH_EditChildCaseFormCtrl.getTitleExtPatientDetail();
        BIH_EditChildCaseFormCtrl.getGenderExtPatientDetail();
        BIH_EditChildCaseFormCtrl.getNationalityDetail();
        BIH_EditChildCaseFormCtrl.getPreferLangDetail();
        Test.stopTest();
    }
    
    @istest
    public static void negativeTest3(){
        Case cas = [select Id from Case limit 1];

        Test.startTest();
        BIH_EditChildCaseFormCtrl.getAccountDetailList(cas.Id);
        Test.stopTest();
    }
}