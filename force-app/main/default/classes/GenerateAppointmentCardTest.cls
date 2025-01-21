@isTest
public with sharing class GenerateAppointmentCardTest {

    // Define test setup method to create necessary test data
    @testSetup static void setupTestData() {
        // Create test records for accounts, cases, users, and a doctor
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test', 'test@mail.com', true);
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test', 'Request', 'Email', true);
        List<User> userList = BIH_TestUtils.createUsers(1, 'FName', 'LName', 'user_test@mail.com', true);

        // Create a test doctor record
        Doctor__c doctor = new Doctor__c();
        doctor.Name = 'test_doctor';
        insert doctor;

        // Associate the case with an account and a doctor
        caseList[0].AccountId = accList[0].Id;
        caseList[0].Doctor__c = doctor.Id;

        // Create service type matrix records
        BIH_TestUtils.createServiceTypeMatrixs();

        // Update the case records
        update caseList;
    }

    // Test method to cover GenerateAppointmentCard class
    @isTest
    public static void testGenerateAppointmentCard() {
        // Query a test case record
        Id Person_Account_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        //system.debug('++++++++++++Person_Account_RECORDTYPE',Person_Account_RECORDTYPE);
        Account act = new Account();
        act.Hospital_Number_HN__c = '1212312121';
        //act.Salutation = 'Miss';
        act.FirstName = 'Megetba';
        act.LastName = 'AAA';
        act.Nationality__c = 'Thai';
        act.Local_First_Name__c = 'มากี้';
        act.Local_Last_Name__c = 'บาลอง';
        act.PersonBirthdate = Date.newInstance(1990, 04, 02);
        act.RecordTypeId = Person_Account_RECORDTYPE;
        insert act;
        
        Case testCase = [SELECT Id FROM Case LIMIT 1];

        // Create an Appointment__c record and associate it with the case
        Appointment__c appointment = new Appointment__c();
        appointment.Case__c = testCase.Id;
        appointment.Appointment_Time__c = '2023-09-05T03:46:48.000+0000';
        appointment.Location__c = 'Test Location';
        appointment.Patient_Letter_Notes__c = 'Test Notes';
        appointment.Account__c = act.Id ;
        appointment.Hospital_Number_HN__c = act.Hospital_Number_HN__c;
        appointment.Appointment_Status__c = 'Booked';
        appointment.Appointment_Date__c =   System.today(); 
        
        // Set other fields as needed

        // Insert the Appointment__c record
        insert appointment;
        Test.startTest();
        GenerateAppointmentCard.InvitationLetterWrapper tmpwrapper = GenerateAppointmentCard.getInvitationLetterWrapper(appointment.id);
        
        Appointment__c obj_appoint = [Select id,Case__c from Appointment__c where id = :appointment.id ];
        String CaseId = obj_appoint.Case__c;
        
        System.debug('***** appointment.Case__c = '+appointment.Case__c);
        System.debug('$$$$$ CaseId = '+CaseId);
        
        
        /*List<Appointment__c> apptList = [SELECT Id,Account__r.Hospital_Number_HN__c,Account__r.Salutation, Account__r.Name,HN_Barcode__c, Account__r.PersonBirthdate, Account__r.Age__c,
                                         Appointment_Date__c,Appointment_Time__c,Non_fixed_Time__c, Doctor__c, Location__c,Patient_Letter_Notes__c,Account__r.Nationality__c ,
                                         Account__r.Local_First_Name__c, Account__r.Local_Last_Name__c, Account__r.Local_Middle_Name__c from Appointment__c where Case__c =: CaseId and Appointment_Status__c != 'Cancelled'and Appointment_Date__c >= TODAY ];
        System.debug('$$$$$ start 1 apptList = '+apptList);*/
        
        Case tmpcase = GenerateAppointmentCard.saveInvitationLetterWrapper(tmpwrapper);
        tmpcase = GenerateAppointmentCard.createInvitaionLetterToPDF(testCase.id);
        PageReference page = System.Page.AppointmentCard;
        page.getParameters().put('id', testCase.id);
        page.getParameters().put('isCopy', 'false');
        Test.setCurrentPage(page);
        AppointmentCardPDF ctrl = new AppointmentCardPDF();
        
        
        GenerateAppointmentCard.AppointmentWrapper testwrpper = new GenerateAppointmentCard.AppointmentWrapper();
        testwrpper.Id = 'test1';
		testwrpper.hospitalNumber = 'test2';    
        testwrpper.salutation = 'test3';   
        testwrpper.name = 'test4';   
        testwrpper.apptDate = 'test5';   
        testwrpper.apptTime = 'test6';   
        testwrpper.apptResource = 'test7';   
        testwrpper.dob = 'test8';   
        //testwrpper.age = 'test9';   
        testwrpper.apptDoctor = 'test10';   
        testwrpper.apptLocation = 'test11';   
        
        Test.stopTest();

    }
    
    @isTest
    public static void testGenerateAppointmentCardNotThai() {
        // Query a test case record
        Id Person_Account_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        //system.debug('++++++++++++Person_Account_RECORDTYPE',Person_Account_RECORDTYPE);
        Account act = new Account();
        act.Hospital_Number_HN__c = '1212312121';
        //act.Salutation = 'Miss';
        act.FirstName = 'Megetba';
        act.LastName = 'AAA';
        act.Nationality__c = 'American';
        //act.Local_First_Name__c = 'มากี้';
        //act.Local_Last_Name__c = 'บาลอง';
        act.PersonBirthdate = Date.newInstance(1990, 04, 02);
        act.RecordTypeId = Person_Account_RECORDTYPE;
        insert act;
        
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        
        // Create an Appointment__c record and associate it with the case
        Appointment__c appointment = new Appointment__c();
        appointment.Case__c = testCase.Id;
        appointment.Appointment_Time__c = '2023-09-05T03:46:48.000+0000';
        appointment.Location__c = 'Test Location';
        appointment.Patient_Letter_Notes__c = 'Test Notes';
        appointment.Account__c = act.Id ;
        appointment.Hospital_Number_HN__c = act.Hospital_Number_HN__c;
        appointment.Appointment_Status__c = 'Booked';
        appointment.Appointment_Date__c =   System.today(); 
        appointment.Non_fixed_Time__c = '13:00';
        
        // Set other fields as needed
        
        // Insert the Appointment__c record
        insert appointment;
        Test.startTest();
        GenerateAppointmentCard.InvitationLetterWrapper tmpwrapper = GenerateAppointmentCard.getInvitationLetterWrapper(appointment.id);
        
        Appointment__c obj_appoint = [Select id,Case__c from Appointment__c where id = :appointment.id ];
        String CaseId = obj_appoint.Case__c;
        
        System.debug('***** appointment.Case__c = '+appointment.Case__c);
        System.debug('$$$$$ CaseId = '+CaseId);
        
        
        /*List<Appointment__c> apptList = [SELECT Id,Account__r.Hospital_Number_HN__c,Account__r.Salutation, Account__r.Name,HN_Barcode__c, Account__r.PersonBirthdate, Account__r.Age__c,
Appointment_Date__c,Appointment_Time__c,Non_fixed_Time__c, Doctor__c, Location__c,Patient_Letter_Notes__c,Account__r.Nationality__c ,
Account__r.Local_First_Name__c, Account__r.Local_Last_Name__c, Account__r.Local_Middle_Name__c from Appointment__c where Case__c =: CaseId and Appointment_Status__c != 'Cancelled'and Appointment_Date__c >= TODAY ];
System.debug('$$$$$ start 1 apptList = '+apptList);*/
        
        Case tmpcase = GenerateAppointmentCard.saveInvitationLetterWrapper(tmpwrapper);
        tmpcase = GenerateAppointmentCard.createInvitaionLetterToPDF(testCase.id);
        PageReference page = System.Page.AppointmentCard;
        page.getParameters().put('id', testCase.id);
        page.getParameters().put('isCopy', 'false');
        Test.setCurrentPage(page);
        AppointmentCardPDF ctrl = new AppointmentCardPDF();
        
        
        GenerateAppointmentCard.AppointmentWrapper testwrpper = new GenerateAppointmentCard.AppointmentWrapper();
        testwrpper.Id = 'test1';
        testwrpper.hospitalNumber = 'test2';    
        testwrpper.salutation = 'test3';   
        testwrpper.name = 'test4';   
        testwrpper.apptDate = 'test5';   
        testwrpper.apptTime = 'test6';   
        testwrpper.apptResource = 'test7';   
        testwrpper.dob = 'test8';   
        //testwrpper.age = 'test9';   
        testwrpper.apptDoctor = 'test10';   
        testwrpper.apptLocation = 'test11';   
        
        Test.stopTest();
        
    }
 

}