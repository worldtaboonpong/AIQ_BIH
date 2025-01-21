@isTest
public class BIH_ContactCenterInformationCtrlTest {
	@testSetup static void methodName() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(2, 'test','test@mail.com', true);
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        List<User> userList = BIH_TestUtils.createUsers(1, 'FName', 'LName', 'user_test@mail.com', true);
        caseList[0].AccountId = accList[0].id;
        caseList[0].Patient__c = accList[1].id;
        caseList[0].Building__c = 'test1';
        caseList[0].Escalate_To__c = 'Airport';
        caseList[0].Department__c = 'test1';
        caseList[0].App_Time__c = Datetime.now().time();
        update caseList;
    }
    
    @isTest
    public static void test_method_1(){
        Case casetmp = [SELECT id,Status,RecordTypeId,Building__c,Department__c,Escalate_To__c FROM Case LIMIT 1];
        Test.startTest();
        BIH_ContactCenterInformationCtrl.getContactCenterInfo(casetmp.id);
        Test.stopTest();
    }
}