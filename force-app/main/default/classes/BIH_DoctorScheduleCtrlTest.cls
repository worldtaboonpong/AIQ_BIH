@isTest
public with sharing class BIH_DoctorScheduleCtrlTest {
    @testSetup static void methodName() {
        // List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        // List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        // List<User> userList = BIH_TestUtils.createUsers(1, 'FName', 'LName', 'user_test@mail.com', true);
        Doctor__c doctor = new Doctor__c();
        doctor.Name = 'test_doctor';
        doctor.MD_Code__c = '1234';
        doctor.Doctor_First_Name__c = 'test';
        doctor.Doctor_Last_Name__c = 'doctor';
        doctor.Specialty__c = 'spec1';
        doctor.Specialty2__c = 'spec2';
        doctor.Doctor_Private_Note__c = 'testnote';
        doctor.Active__c = true;
        insert doctor;
        // caseList[0].AccountId = accList[0].id;
        // caseList[0].Doctor__c = doctor.id;
        // BIH_TestUtils.createServiceTypeMatrixs();
        // caseList[0].OwnerId = userList[0].id;
        // update caseList;
        
        
    }
    @isTest
    public static void test_method_1(){
        // Account acc = [SELECT id, Hospital_Number_HN__c From Account LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new BIH_DoctorScheduleServiceMockImpl());
        // BIH_DoctorScheduleService.TimeSlot tmpMock = new BIH_DoctorScheduleService.TimeSlot();
        // tmpMock.code = '1234';
        // tmpMock.startTime = '2017-12-23T06:00:00.000Z';
        // tmpMock.endTime = '2017-12-23T06:10:00.000Z';
        // tmpMock.locationCode = '001';
        // tmpMock.location = 'Test';
        // tmpMock.isAvailable= false;

        // BIH_DoctorScheduleService.TimeSlot tmpMock2 = new BIH_DoctorScheduleService.TimeSlot();
        // tmpMock2.code = '1235';
        // tmpMock2.startTime = '2017-12-23T06:20:00.000Z';
        // tmpMock2.endTime = '2017-12-23T06:30:00.000Z';
        // tmpMock2.locationCode = '002';
        // tmpMock2.location = 'Test';
        // tmpMock2.isAvailable= true;

        // ist<BIH_DoctorScheduleService.TimeSlot> tmpList = new List<BIH_DoctorScheduleService.TimeSlot>();
        // tmpList.add(tmpMock);
        // tmpList.add(tmpMock2);
        Test.startTest();
        // acc.Hospital_Number_HN__c = '000000001';
        // update acc;
        BIH_DoctorScheduleCtrl ctrl = new BIH_DoctorScheduleCtrl();
        BIH_DoctorScheduleCtrl.WrapperList tmpwrapper = BIH_DoctorScheduleCtrl.getListDoctorBySearching('spec1', 'spec2', '2017-12-23',1,3);
        // Account acctmp = BIH_VerifyPatientCtrl.verifyAccountByHN(tmpMock);
        Test.stopTest();
    }
}