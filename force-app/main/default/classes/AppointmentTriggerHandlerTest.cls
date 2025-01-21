@isTest
public with sharing class AppointmentTriggerHandlerTest {
    @TestSetup
	static void makeData(){
		TC_TestDataFactory.insertConfigData();
	}

	@isTest
	static void testUpdateAppointment(){
		Test.setMock(HttpCalloutMock.class, new TC_TrakCareServiceMock(
            TC_TrakCareServiceMock.updateAppointmentResponse
        ));
		List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
		Appointment__c app = new Appointment__c(Account__c = accList.get(0).Id, Appointment_Id__c = '111', Appointment_Date__c = Date.today());
        insert app;
		Test.startTest();
		app.Notes__c = 'Test';
		update app;
		Test.stopTest();
	}


	@isTest
    static void setBypassTest() {
        Test.startTest();
        AppointmentTriggerHandler handler = AppointmentTriggerHandler.getInstance();
        handler.setBypass();
        System.assertEquals(false, handler.isActive);
        System.assertEquals(false, handler.isTriggerActivated());
        Test.stopTest();
    }

	@isTest
    static void clearBypassTest() {
        Test.startTest();
        AppointmentTriggerHandler handler = AppointmentTriggerHandler.getInstance();
        handler.clearBypass();
        System.assertEquals(true, handler.isActive);
        System.assertEquals(true, handler.isTriggerActivated());
        Test.stopTest();
    }
}