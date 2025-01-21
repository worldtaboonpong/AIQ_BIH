@IsTest
public class TC_WarningAlertsControllerTest {
	@TestSetup
    static void setup() {
        TC_TestDataFactory.insertConfigData();
    }
    
    @IsTest
    static void unitTest01() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        accList.get(0).PersonBirthdate = Date.today() - 100;
        update accList;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TC_TrakCareServiceMock(
            TC_TrakCareServiceMock.warningAlerts
        ));
        
        TC_WarningAlertsController.getPatientDetails(accList.get(0).Id);
        Test.stopTest();
    }
    
    @IsTest
    static void unitTest02() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        accList.get(0).PersonBirthdate = Date.today() - 100;
        update accList;
        
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TC_TrakCareServiceMock(
            TC_TrakCareServiceMock.warningAlerts
        ));
        
        TC_WarningAlertsController.getPatientDetails(caseList.get(0).Id);
        Test.stopTest();
    }
}