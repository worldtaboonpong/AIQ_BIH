@isTest
public class BIH_EditCategoriesTest {
    @isTest
    public static void unitTest01(){
        
        Service_Type_Matrix__c tmp_serive_type = new Service_Type_Matrix__c();
        tmp_serive_type.Category_Level1_English__c = 'test_cate1';
        tmp_serive_type.Category_Level2_English__c = 'test_cate2';
        tmp_serive_type.Category_Level3_English__c ='test_cate4';
        tmp_serive_type.Channel__c ='Contact Center';
        tmp_serive_type.SLA__c =240;
        insert tmp_serive_type;
        
        Service_Type_Matrix__c tmp_serive_type1 = new Service_Type_Matrix__c();
        tmp_serive_type1.Category_Level1_English__c = 'Appointment';
        tmp_serive_type1.Category_Level2_English__c = 'test_cate2Individual';
        tmp_serive_type1.Category_Level3_English__c ='test_cate4Individual';
        tmp_serive_type1.Channel__c ='Referral';
        tmp_serive_type1.SLA__c =100;
        tmp_serive_type1.Quick_Case__c = 'Appointment';
        insert tmp_serive_type1;
        
        Service_Type_Matrix__c tmp_serive_type2 = new Service_Type_Matrix__c();
        tmp_serive_type2.Category_Level1_English__c = 'General';
        tmp_serive_type2.Category_Level2_English__c = 'test_cate2Individual';
        tmp_serive_type2.Category_Level3_English__c ='test_cate4Individual';
        tmp_serive_type2.Channel__c ='Referral';
        tmp_serive_type2.SLA__c =100;
        tmp_serive_type2.Quick_Case__c = 'General';
        insert tmp_serive_type2;
        
        Service_Type_Matrix__c tmp_serive_type3 = new Service_Type_Matrix__c();
        tmp_serive_type3.Category_Level1_English__c = 'Telemedicine';
        tmp_serive_type3.Category_Level2_English__c = 'test_cate2Individual';
        tmp_serive_type3.Category_Level3_English__c ='test_cate4Individual';
        tmp_serive_type3.Channel__c ='Referral';
        tmp_serive_type3.SLA__c =100;
        tmp_serive_type3.Quick_Case__c = 'Telemedicine';
        insert tmp_serive_type3;
       
        
        BIH_Building__c bud = new BIH_Building__c();    
        bud.Building_EN__c = 'test1';
        bud.BIH_Department__c = 'test1';
        bud.Building_TH__c = 'test1';
        bud.Department_EN__c = 'test1';
        bud.Department_TH__c = 'test1';
        bud.Floor__c = 'test1';
        insert bud; 
        
        Doctor__c doctor = new Doctor__c();
        doctor.Name = 'test_doctor';
        insert doctor;
		
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1 , 'Test001','BIHTest@bumrungradtest.com', true);
        List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        
        Case c = new Case(); 
        c.AccountId = accList.get(0).Id;
        c.Subject = 'Test naja HN: 098765432';
        c.Case_Category_Level1__c = 'Appointment';
        c.origin = 'Web';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Registration Case').getRecordTypeId();
        c.ParentId = casesList.get(1).id;
        c.Status = 'Pending';
        c.Pending_Reason__c = 'testing';
        c.Building__c = 'test1';
        c.Department__c = 'test1';
        c.doctor__c = doctor.id;
        insert c;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        
        Case caseObj = [
        	SELECT Id, Status, Building__c, Department__c, Case_Category_Level1__c, Case_Category_Level2__c,
            Case_Category_Level3__c
            FROM Case WHERE id = :c.Id  
        ];
        
        Test.startTest();
        BIH_EditCategories.getBtnConfig();
        BIH_EditCategories.GetAvailableRecordTypeCase();
        BIH_EditCategories.getPickListValuesIntoListByVFPrimary(new List<String>{'Status'});
        BIH_EditCategories.getPickListValueWrapper(c.Id);
        BIH_EditCategories.getCaseAndPatientInformation(c.Id);
        BIH_EditCategories.UpdateCaseRecord(caseObj);
        BIH_EditCategories.getUserTeam();
        Test.stopTest();
    }

}