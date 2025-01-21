@isTest
public with sharing class BIH_GenerateInvitionLetterCtrlTest {
     @testSetup static void methodName() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        List<User> userList = BIH_TestUtils.createUsers(1, 'FName', 'LName', 'user_test@mail.com', true);
        Doctor__c doctor = new Doctor__c();
        doctor.Name = 'test_doctor';
        insert doctor;
        caseList[0].AccountId = accList[0].id;
        caseList[0].Doctor__c = doctor.id;
        BIH_TestUtils.createServiceTypeMatrixs();
        // caseList[0].OwnerId = userList[0].id;
        update caseList;
        
        
    }
    @isTest
    public static void test_method_1(){
        Case c = [SELECT id FROM Case LIMIT 1];
        Test.startTest();
        BIH_GenerateInvitionLetterCtrl.InvitationLetterWrapper tmpwrapper = BIH_GenerateInvitionLetterCtrl.getInvitationLetterWrapper(c.id);
        Case tmpcase = BIH_GenerateInvitionLetterCtrl.saveInvitationLetterWrapper(tmpwrapper);
        tmpcase = BIH_GenerateInvitionLetterCtrl.createInvitaionLetterToPDF(c.id);
        PageReference page = System.Page.GeneratePDFInvitation;
        page.getParameters().put('id', c.id);
        page.getParameters().put('isCopy', 'false');
        Test.setCurrentPage(page);
        GeneratePDFInvitation ctrl = new GeneratePDFInvitation();
        Test.stopTest();
    }
}