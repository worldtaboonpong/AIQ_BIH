@IsTest
public class TC_CancelAppointmentCtrlTest {
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
            TC_TrakCareServiceMock.cancelBookingResponse
        ));
        
        Appointment__c appDetail = new Appointment__c();
        appDetail.Reason_for_Cancellation__c = 'C017';
        appDetail.Free_Text_Reason_for_Cancellation__c = '12345';
        appDetail.Discontinue_Orders__c = true;
        TC_CancelAppointmentCtrl.cancelAppointments(app.Id, appDetail);
        Test.stopTest();
    }
}