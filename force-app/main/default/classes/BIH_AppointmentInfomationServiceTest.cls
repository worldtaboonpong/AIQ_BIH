@isTest
public class BIH_AppointmentInfomationServiceTest {
     @testSetup static void methodName() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
    }
    @isTest
    public static void test_method_1(){
        Account acc = [SELECT id FROM Account LIMIT 1];
        Test.startTest();
        Account tmpacc = BIH_AppointmentInformationCtrl.getAccount(acc.id);
        Test.setMock(HttpCalloutMock.class, new BIH_AppointmentInfoServiceMockImpl());
        List<BIH_AppointmentInformationService.AppointmentInfoRequest> tmplist = BIH_AppointmentInformationCtrl.getAppointmentInformation('000000001');
    	Test.stopTest();
    }
    @isTest
    public static void test_method_2(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BIH_AppointmentInfoServiceMockImpl());
        List<BIH_AppointmentInformationService.AppointmentInfoRequest> tmplist = BIH_AppointmentInformationCtrl.getAppointmentInformation('000000002');
    	Test.stopTest();
    }
    @isTest
    public static void test_method_3(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BIH_AppointmentInfoServiceMockImpl());
        List<BIH_AppointmentInformationService.AppointmentInfoRequest> tmplist = BIH_AppointmentInformationCtrl.getAppointmentInformation('000000003');
    	Test.stopTest();
    }

}