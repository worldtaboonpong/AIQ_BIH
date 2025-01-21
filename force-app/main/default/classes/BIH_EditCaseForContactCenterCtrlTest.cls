@isTest
public with sharing class BIH_EditCaseForContactCenterCtrlTest {
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
        stm.Channel__c ='Contact Center';
        stmList.add(stm);

        Service_Type_Matrix__c tmp_serive_type = new Service_Type_Matrix__c();
        tmp_serive_type.Category_Level1_English__c = 'test_cate1';
        tmp_serive_type.Category_Level2_English__c = 'test_cate2';
        tmp_serive_type.Category_Level3_English__c ='test_cate4';
        tmp_serive_type.Channel__c ='Contact Center';
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
    // @isTest
    // public static void test_method_1(){
    //     List<Account> acc = [SELECT id FROM Account LIMIT 2];
    //    	Case casetmp = [SELECT id,Status,RecordTypeId,Building__c,Department__c,Escalate_To__c FROM Case LIMIT 1];
    //     Test.startTest();
    //     Test.setMock(HttpCalloutMock.class, new BIH_GetPickListValuesByHttpReqMockImpl());
    //     // BIH_EditCaseForContactCenterCtrl ctrl = new BIH_EditCaseForContactCenterCtrl();
    //     BIH_EditCaseForContactCenterCtrl.pickListValueWrapper tmp_picklist_value=  BIH_EditCaseForContactCenterCtrl.getPickListValueWrapper(casetmp.RecordTypeId,casetmp.id);
    //     Map<String, List<BIH_PicklistOption>> tmp_dependency_field =  BIH_EditCaseForContactCenterCtrl.getDependencyFieldValues('Status','Close_Case_Reason__c');
    //     BIH_EditCaseForContactCenterCtrl.getParentIdOnFocusTab(acc[0].id);
    //     BIH_EditCaseForContactCenterCtrl.CaseAndPatientInformationWrapper tmp_case_patient_info = BIH_EditCaseForContactCenterCtrl.getCaseAndPatientInformation(casetmp.id);
    //     BIH_EditCaseForContactCenterCtrl.UpdateCaseRecord(casetmp, acc[0],acc[1]);
    //     BIH_EditCaseForContactCenterCtrl.CaseAndPatientInformationWrapper tmp_case_patient_info2 = BIH_EditCaseForContactCenterCtrl.getCaseAndPatientInformation(null);

    //     casetmp.Escalate_To__c = 'Pharmacy';
    //     BIH_EditCaseForContactCenterCtrl.UpdateCaseRecord(casetmp, acc[0],acc[1]);
    //     casetmp.Escalate_To__c = 'Individual';
    //     BIH_EditCaseForContactCenterCtrl.UpdateCaseRecord(casetmp, acc[0],acc[1]);
    //     casetmp.Escalate_To__c = 'Referral';
    //     BIH_EditCaseForContactCenterCtrl.UpdateCaseRecord(casetmp, acc[0],acc[1]);
    //     casetmp.Escalate_To__c = 'Assigned Station';
    //     BIH_EditCaseForContactCenterCtrl.UpdateCaseRecord(casetmp, acc[0],acc[1]);
    //     casetmp.Escalate_To__c = 'Dental';
    //     BIH_EditCaseForContactCenterCtrl.UpdateCaseRecord(casetmp, acc[0],acc[1]);
    //     casetmp.Escalate_To__c = 'English';
	// 	BIH_EditCaseForContactCenterCtrl.UpdateCaseRecord(casetmp, acc[0],acc[1]);
    //     casetmp.Escalate_To__c = 'Finance';
    //     BIH_EditCaseForContactCenterCtrl.UpdateCaseRecord(casetmp, acc[0],acc[1]);
    //     casetmp.Escalate_To__c = 'Marketing';
    //     BIH_EditCaseForContactCenterCtrl.UpdateCaseRecord(casetmp, acc[0],acc[1]);
    //     casetmp.Escalate_To__c = 'Medical Record';
    //     BIH_EditCaseForContactCenterCtrl.UpdateCaseRecord(casetmp, acc[0],acc[1]);
    //     casetmp.Escalate_To__c = 'Nurse Consult';
    //     BIH_EditCaseForContactCenterCtrl.UpdateCaseRecord(casetmp, acc[0],acc[1]);
    //     Test.stopTest();
        
        
    // }
    
    @isTest
    public static void test_method_2(){
        List<Account> acc = [SELECT id FROM Account LIMIT 2];
        Case casetmp = [SELECT id,Status,RecordTypeId,Building__c,Department__c,Escalate_To__c FROM Case LIMIT 1];
        List<User> enduserList = BIH_TestUtils.createEndUsers(1, 'FName001', 'LName0001', 'user_test001@mail.com',BIH_TestUtils.AIRPORT_PROFILE_ID, true);
        System.runAs(enduserList.get(0)) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new BIH_GetPickListValuesByHttpReqMockImpl());
            // BIH_EditCaseForContactCenterCtrl ctrl = new BIH_EditCaseForContactCenterCtrl();
            BIH_EditCaseForContactCenterCtrl.pickListValueWrapper tmp_picklist_value=  BIH_EditCaseForContactCenterCtrl.getPickListValueWrapper(casetmp.RecordTypeId,casetmp.id);
            Map<String, List<BIH_PicklistOption>> tmp_dependency_field =  BIH_EditCaseForContactCenterCtrl.getDependencyFieldValues('Status','Close_Case_Reason__c');
            
            BIH_EditCaseForContactCenterCtrl.CaseAndPatientInformationWrapper tmp_case_patient_info2 = BIH_EditCaseForContactCenterCtrl.getCaseAndPatientInformation(null);
            Test.stopTest();
        }
        
        
    }

     @isTest
    public static void test_method_3(){
        List<Case_Campaign_Master__c> ccmList = [SELECT id FROM Case_Campaign_Master__c WHERE Campaign_Type__c = 'Offered' LIMIT 1];
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BIH_GetPickListValuesByHttpReqMockImpl());
        BIH_EditCaseForContactCenterCtrl.CampaignWrapper cw = BIH_EditCaseForContactCenterCtrl.getCampaignList('000000000001');
        BIH_EditCaseForContactCenterCtrl.CampaignDetailWrapper cdw = BIH_EditCaseForContactCenterCtrl.getCampaignDetail(ccmList[0].id);
        Test.stopTest();
    }
    
       @isTest
    	public static void negativeCCTest(){
        List<String> caseName = new List<String>();
        caseName.add('Full_Name__c'); 
        Case cs = [select Id from Case limit 1];
            
        List<Account> acc = [SELECT id FROM Account LIMIT 2];
        Case casetmp = [SELECT id,Status,RecordTypeId,Building__c,Department__c,Escalate_To__c FROM Case LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new BIH_GetPickListValuesByHttpReqMockImpl());    
        Test.startTest();
            BIH_EditCaseForContactCenterCtrl.getPickListValuesIntoListByVFPrimary(caseName);    
            BIH_EditCaseForContactCenterCtrl.getVaccineDetail();
            BIH_EditCaseForContactCenterCtrl.getHealthAreaDetail();
            BIH_EditCaseForContactCenterCtrl.getTopicDetail();
            Map<String,Contact_Center_Escalation_Rule__mdt> aaa = BIH_EditCaseForContactCenterCtrl.mapContactCenterEscalationRule;    
            Map<Id,Case_Status_with_Record_Type__mdt> bbb = BIH_EditCaseForContactCenterCtrl.mapCaseStatusWithRecordType;
            BIH_EditCaseForContactCenterCtrl.getBtnConfig();
            BIH_EditCaseForContactCenterCtrl.getPDVSEndpoint();
            BIH_EditCaseForContactCenterCtrl.getClientId(cs.Id);
            BIH_EditCaseForContactCenterCtrl.getSessionId();
            BIH_EditCaseForContactCenterCtrl.getUserName();
            Contact ct = [Select Id from Contact limit 1];
            Account accc = [select Id from Account limit 1];
            Account accc2 = [select Id from Account limit 2].get(1);
            cs.Status = 'Pending';
            cs.Pending_Reason__c = 'Follow up';
            update cs;
            try {
                BIH_EditCaseForContactCenterCtrl.UpdateCaseRecord(cs,accc,accc2);
            } catch (Exception e) {
                
            }
            BIH_EditCaseForContactCenterCtrl.getParentIdOnFocusTab(acc[0].Id);
            Contact ct1  = [Select Id from Contact limit 1];    
            BIH_EditCaseForContactCenterCtrl.getContactParentIdOnFocusTab(ct1.Id);
            BIH_EditCaseForContactCenterCtrl.getCaseAndPatientInformationUpdated(cs.Id);
            BIH_EditCaseForContactCenterCtrl.getSenderAccountByContact(ct.Id);
        Test.stopTest();
    }


}