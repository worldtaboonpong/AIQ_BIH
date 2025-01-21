@IsTest
public class PreregistrationclsTest {
	@IsTest
    static void unitTest01() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        
        Appointment__c app = new Appointment__c(Account__c = accList.get(0).Id, Appointment_Id__c = '111', Appointment_Date__c = Date.today());
        insert app;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(caseList.get(0));
        Preregistrationcls pdCtrl = new Preregistrationcls(sc);
        pdCtrl.getGender();
        pdCtrl.getTitles2();
        pdCtrl.getLanguages();
        pdCtrl.getCountries();
        pdCtrl.getNationality();
        Preregistrationcls.fileUpload('Test', 'Test', caseList.get(0).Id);
		Preregistrationcls.updateCase(JSON.serialize(caseList.get(0)));
        Test.stopTest();
    }
}