@isTest
public class BIH_GeneralWebInformationCtrlTest {
	 @testSetup static void methodName() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        accList.get(0).Hospital_Number_HN__c = '000000001';
        update accList.get(0);
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        List<User> userList = BIH_TestUtils.createUsers(1, 'FName', 'LName', 'user_test@mail.com', true);

        caseList[0].AccountId = accList[0].id;
        caseList[0].Web_Subject__c = Label.Make_an_Appointment; 
        caseList[0].Appointment_Time__c = Time.newInstance(18, 30, 2, 20);
        caseList[0].New_Appointment_Time__c = Time.newInstance(18, 30, 2, 20);
        caseList[0].Cancellation_Appointment__c = true;
        caseList[0].App_Time__c = Time.newInstance(18, 30, 2, 20);
        caseList[0].End_Time__c = Time.newInstance(18, 30, 2, 20);

        BIH_TestUtils.createServiceTypeMatrixs();
        update caseList;
        
        
    }
    
    @isTest
    public static void positiveTest1(){
        Case cas =[SELECT id FROM Case LIMIT 1];
        Test.startTest();
        BIH_GeneralWebInformationCtrl.getCaseInformation(cas.id);
        Test.stopTest();
    }
}