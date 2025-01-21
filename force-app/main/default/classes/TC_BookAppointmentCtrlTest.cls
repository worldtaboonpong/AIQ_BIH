@IsTest
public class TC_BookAppointmentCtrlTest {
    @TestSetup
    static void setup() {
        TC_TestDataFactory.insertConfigData();
    }
    
    @IsTest
    static void unitTest01() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        
        Test.startTest();
        TC_BookAppointmentCtrl.getBookingDetails('BH', 'BICF15N15D', 'S118', 'S105', '67389', '', '', '');
        TC_BookAppointmentCtrl.findDoctorAndSchedules('BH', 'BICF15N15D', 'S118', 'S105', '67389', '', '', '');
        
        Schedule_List__c sl = [SELECT Id FROM Schedule_List__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new TC_TrakCareServiceMock(
            TC_TrakCareServiceMock.schedulesResponse
        ));
        TC_BookAppointmentCtrl.getDoctorTimeSlots(sl.Id, string.valueOf(date.today()), null, null);
        Map<String, Object> mapObj = TC_BookAppointmentCtrl.reviewAppointment(accList.get(0).Id, sl.Id+'#7079||54305#10:00', string.valueOf(date.today()));
        Test.stopTest();
        TC_BookAppointmentCtrl.bookAppointmentRecord((Appointment__c)mapObj.get('Appointment'));
    }
}