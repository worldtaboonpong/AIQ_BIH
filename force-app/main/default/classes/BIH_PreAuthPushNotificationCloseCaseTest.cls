@IsTest
public class BIH_PreAuthPushNotificationCloseCaseTest {
        @testSetup static void methodName() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        List<User> userList = BIH_TestUtils.createUsers(1, 'FName', 'LName', 'user_test@mail.com', true);
        Doctor__c doctor = new Doctor__c();
        doctor.Name = 'test_doctor';
        insert doctor;
        accList[0].Local_First_Name__c = 'มาดาม';
        accList[0].Local_Last_Name__c = 'เคท';
        update accList;
        
        caseList[0].AccountId = accList[0].id;
        caseList[0].Doctor__c = doctor.id;
        caseList[0].Full_Name__c = 'Madan Kate';
        caseList[0].Hospital_Number_HN__c = '1212312121';
        caseList[0].Appointment_Date__c = Date.today().addDays(7);
        BIH_TestUtils.createServiceTypeMatrixs();
        update caseList;
        
        
    }
    @IsTest
    public static void testBIH_PreAuthPushNotificationCloseCaseTest() {
        
        Case c = [SELECT id FROM Case LIMIT 1]; 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        Test.startTest();
        BIH_PreAuthPushNotificationCloseCase.calloutSendPushNotification(c.Id);
        List<string> caseIDSMS = new List<string>();
        caseIDSMS.add(c.Id);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        BIH_PreAuthPushNotificationCloseCase.sendPushNotification(caseIDSMS);
        
        
        //BIH_CaseSendAutoSMS.SMSMessageRequest();  
        
        Test.stopTest();
        
        
    }
    @IsTest
    public static void testBIH_PreAuthPushNotificationCloseCaseTest2() {
        Case c = [SELECT id FROM Case LIMIT 1]; 
        Test.startTest();
        List<string> caseIDSMS = new List<string>();
        caseIDSMS.add(c.Id);  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator3());   
        BIH_PreAuthPushNotificationCloseCase.sendPushNotification(caseIDSMS);
        
        
        Test.stopTest();
        
        
    }

}