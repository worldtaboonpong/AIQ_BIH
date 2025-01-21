@IsTest
public with sharing class BIH_AutoSendPreAuthSMSTest {
        @testSetup static void methodName() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        List<User> userList = BIH_TestUtils.createUsers(1, 'FName', 'LName', 'user_test@mail.com', true);
        Doctor__c doctor = new Doctor__c();
        doctor.Name = 'test_doctor';
        insert doctor;
        caseList[0].AccountId = accList[0].id;
        caseList[0].Doctor__c = doctor.id;
        BIH_TestUtils.createServiceTypeMatrixs();
        // caseList[0].OwnerId = userList[0].id;
        update caseList;
        }
    	
    
        @IsTest
      	public static void testBIH_AutoSendPreAuthSMSTest() {
        
        Case c = [SELECT id FROM Case LIMIT 1]; 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        Test.startTest();
        BIH_AutoSendPreAuthSMS.calloutSendSms(c.Id);
        List<string> caseIDSMS = new List<string>();
          caseIDSMS.add(c.Id);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        BIH_AutoSendPreAuthSMS.sendSms(caseIDSMS);
       
          
        //BIH_CaseSendAutoSMS.SMSMessageRequest();  
        
        Test.stopTest();
          

        }
    
        @IsTest
      	public static void testBIH_AutoSendPreAuthSMSTest2() {
        Case c = [SELECT id FROM Case LIMIT 1]; 
        Test.startTest();
        List<string> caseIDSMS = new List<string>();
          caseIDSMS.add(c.Id);  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator3());   
        BIH_AutoSendPreAuthSMS.sendSms(caseIDSMS);

        
        Test.stopTest();
          

        }
}