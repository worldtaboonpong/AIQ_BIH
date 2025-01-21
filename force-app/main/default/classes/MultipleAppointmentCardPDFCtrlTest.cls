@IsTest
public class MultipleAppointmentCardPDFCtrlTest {
	@TestSetup
    static void setup() {
        TC_TestDataFactory.insertConfigData();
    }
    
    @IsTest
    static void unitTest01() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        accList.get(0).PersonBirthdate = Date.today() - 100;
        update accList;
        
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        
        Appointment__c app = new Appointment__c(Account__c = accList.get(0).Id, Appointment_Id__c = '111', Appointment_Date__c = Date.today());
        insert app;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TC_TrakCareServiceMock(
            TC_TrakCareServiceMock.onlineAppointmentsResponse
        ));
        
        ApexPages.CurrentPage().getParameters().put('accId', accList.get(0).Id);
        ApexPages.CurrentPage().getParameters().put('selectedRowsIds', '1,2');
        MultipleAppointmentCardPDFCtrl ctrl = new MultipleAppointmentCardPDFCtrl();
        
        Test.stopTest();
    }
    
    @IsTest
    static void unitTest02() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        accList.get(0).PersonBirthdate = Date.today() - 100;
        accList.get(0).Preferred_Language__c = 'Thai';
        update accList;
        
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        
        Appointment__c app = new Appointment__c(Account__c = accList.get(0).Id, Appointment_Id__c = '111', Appointment_Date__c = Date.today());
        insert app;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TC_TrakCareServiceMock(
            TC_TrakCareServiceMock.onlineAppointmentsResponse
        ));
        
        ApexPages.CurrentPage().getParameters().put('accId', accList.get(0).Id);
        ApexPages.CurrentPage().getParameters().put('selectedRowsIds', '1,2');
        MultipleAppointmentCardPDFCtrl ctrl = new MultipleAppointmentCardPDFCtrl();
        
        Test.stopTest();
    }
}