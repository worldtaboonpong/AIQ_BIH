@isTest
public class ProxyRedirectEditPageCtrlTest {
	@testSetup static void methodName() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(2, 'test','test@mail.com', true);
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        // List<User> userList = BIH_TestUtils.createUsers(1, 'FName', 'LName', 'user_test@mail.com', true);
        
        Doctor__c doctor = new Doctor__c();
        doctor.Name = 'test_doctor';
        insert doctor;
        caseList[0].AccountId = accList[0].id;
        caseList[0].Patient__c = accList[1].id;
        caseList[0].Doctor__c = doctor.id;
        BIH_TestUtils.createServiceTypeMatrixs();
        // caseList[0].OwnerId = userList[0].id;
       
        update caseList;
    }
    @isTest
    public static void test_method_1(){
        ProxyRedirectEditPageCtrl.Wrapper wrap = new ProxyRedirectEditPageCtrl.Wrapper();
        Case cas = [SELECT id,RecordTypeId FROM Case LIMIT 1];
        Test.startTest();
        wrap = ProxyRedirectEditPageCtrl.getUserCurrent(cas.id,null);
        wrap = ProxyRedirectEditPageCtrl.getUserCurrent(cas.id,cas.RecordTypeId);
        wrap = ProxyRedirectEditPageCtrl.getUserCurrent(null,cas.RecordTypeId);
        wrap = ProxyRedirectEditPageCtrl.getUserCurrent(null,null);
        Test.stopTest();
    }
}