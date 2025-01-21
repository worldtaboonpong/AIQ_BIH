@IsTest
public class TC_AppointmentListCtrlTest {
	@TestSetup
    static void setup() {
        TC_TestDataFactory.insertConfigData();
    }
    
    @IsTest
    static void unitTest01() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        
        Appointment__c app = new Appointment__c(Account__c = accList.get(0).Id, Appointment_Id__c = '111', Appointment_Date__c = Date.today());
        insert app;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TC_TrakCareServiceMock(
            TC_TrakCareServiceMock.onlineAppointmentsResponse
        ));
        TC_AppointmentListCtrl.fetchAppointments(accList.get(0).Id);
        Test.stopTest();
    }
    
    @IsTest
    static void unitTest02() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        
        Appointment__c app = new Appointment__c(Account__c = accList.get(0).Id, Appointment_Id__c = '111', Appointment_Date__c = Date.today());
        insert app;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TC_TrakCareServiceMock(
            TC_TrakCareServiceMock.onlineAppointmentView
        ));
        TC_AppointmentListCtrl.viewAppointment(accList.get(0).Id, '6900||118047||1');
        Test.stopTest();
    }
}