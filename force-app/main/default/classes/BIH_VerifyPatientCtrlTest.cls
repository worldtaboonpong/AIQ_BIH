@isTest
public with sharing class BIH_VerifyPatientCtrlTest {
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
    @isTest
    public static void test_method_1(){
        Test.setMock(HttpCalloutMock.class, new BIH_PatientInformationServiceMockImpl());
        Account acc = [SELECT id, Hospital_Number_HN__c From Account LIMIT 1];
        List<BIH_PatientInformationService.alertMessages> alertlist = new List<BIH_PatientInformationService.alertMessages>();
        BIH_PatientInformationService.alertMessages al = new BIH_PatientInformationService.alertMessages();
        al.type = 1;
        al.hn = '0084138947';
        al.code ='VIP2';
        al.description ='VIP - Gold - Orion';
        al.message = 'test';
        al.createdAt = '2013-09-27T00:00:00';
      	alertlist.add(al);
        
        BIH_PatientInformationService.patientInfoData tmpMock = new BIH_PatientInformationService.patientInfoData(); 
        tmpMock.hn = '000000001';
        tmpMock.dateOfBirth = '2017-12-23T06:00:00.000Z';
        tmpMock.title = 'Mrs';
        tmpMock.firstName = 'TestFN';
        tmpMock.lastName = 'TestLN';
        tmpMock.sex = 1;
        tmpMock.email = 'test@mail.com';
        tmpMock.mobilePhone = '0800000000';
        tmpMock.homePhone = '0800000000';
        tmpMock.nationality = 'Thai';
        tmpMock.passportNumber= '0000000001';
        tmpMock.country= 'Thailand ';
        tmpMock.countryOfResident= 'Thailand';
        tmpMock.idCardNumber= '0000000001';
        tmpMock.preferredLanguage= 'Thai';
        tmpMock.email2= 'test@mail.com';
        tmpMock.officePhone= '0800000000';
        tmpMock.note= 'Test Note';
        tmpMock.alertMessages =alertlist;

        system.debug('tmpMock'+tmpMock);
        acc.Hospital_Number_HN__c = '000000001';
        update acc;
        BIH_VerifyPatientCtrl.ResponVerifyWrapper tmpwrapper = BIH_VerifyPatientCtrl.getAccountByHN('0000000001', '', '', '', '', '');
        Test.startTest();
        Account acctmp = BIH_VerifyPatientCtrl.verifyAccountByHN(tmpMock);
        Test.stopTest();
    }
    @isTest
    public static void test_method_2(){
        Test.setMock(HttpCalloutMock.class, new BIH_PatientInformationServiceMockImpl());
        List<BIH_PatientInformationService.alertMessages> alertlist = new List<BIH_PatientInformationService.alertMessages>();
        BIH_PatientInformationService.alertMessages al = new BIH_PatientInformationService.alertMessages();
        al.type = 1;
        al.hn = '0084138947';
        al.code ='VIP2';
        al.description ='VIP - Gold - Orion';
        al.message = 'test';
        al.createdAt = '2013-09-27T00:00:00';
      	alertlist.add(al);
        
        BIH_PatientInformationService.patientInfoData tmpMock = new BIH_PatientInformationService.patientInfoData(); 
        tmpMock.hn = '000000001';
        tmpMock.dateOfBirth = '2017-12-23T06:00:00.000Z';
        tmpMock.title = 'Mrs';
        tmpMock.firstName = 'TestFN';
        tmpMock.lastName = 'TestLN';
        tmpMock.sex = 1;
        tmpMock.email = 'test@mail.com';
        tmpMock.mobilePhone = '0800000000';
        tmpMock.homePhone = '0800000000';
        tmpMock.nationality = 'Thai';
        tmpMock.passportNumber= '0000000001';
        tmpMock.country= 'Thailand ';
        tmpMock.countryOfResident= 'Thailand';
        tmpMock.idCardNumber= '0000000001';
        tmpMock.preferredLanguage= 'Thai';
        tmpMock.email2= 'test@mail.com';
        tmpMock.officePhone= '0800000000';
        tmpMock.note= 'Test Note';
        tmpMock.alertMessages =alertlist;
         system.debug('tmpMock'+tmpMock);
        Test.startTest();
        string strTmp = tmpMock.getGender(tmpMock.sex);
        Account accgetbyName  = BIH_VerifyPatientCtrl.getAccountByName('test');
        Test.setMock(HttpCalloutMock.class, new BIH_PatientInformationServiceMockImpl());
        BIH_VerifyPatientCtrl.ResponVerifyWrapper tmpwrapper = BIH_VerifyPatientCtrl.getAccountByHN('', 'TestName', '', '', '', '');
        Account acctmp = BIH_VerifyPatientCtrl.verifyAccountByHN(tmpMock);
        Test.stopTest();
    }
}