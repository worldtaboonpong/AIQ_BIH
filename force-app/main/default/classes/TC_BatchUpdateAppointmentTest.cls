@IsTest
public class TC_BatchUpdateAppointmentTest {
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
        TC_BatchUpdateAppointment tbrslCtrl = new TC_BatchUpdateAppointment();
        String sch = '0 0 23 * * ?'; 
        system.schedule('TC_BatchUpdateAppointmentTest', sch, tbrslCtrl); 
        Test.stopTest();
    }
}