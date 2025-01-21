@isTest
public class BIH_ApptUtilityTest {
    @isTest
    public static void positiveTest(){
        Test.startTest();
        
        
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1 , 'Test001','BIHTest@bumrungradtest.com', true);
        List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        Id REGISTRATION_CASE_RECORDTYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Registration Case').getRecordTypeId();
        Case c = new Case(); 
        c.Subject = 'Test naja HN: 098765432';
        c.Case_Category_Level1__c = 'Appointment';
        c.origin = 'Web';
        c.RecordTypeId = REGISTRATION_CASE_RECORDTYPE;
        c.ParentId = casesList.get(1).id;
        c.App_Date__c = System.today(); 
        c.Channel__c = 'Individual';
        c.Lead_Source__c = 'Email';
        insert c;
        
        Lead l = new Lead();
        l.lastname = 'test001';

        Id Person_Account_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account act = new Account();
        act.Hospital_Number_HN__c = '1212312121';
        act.FirstName = 'Megetba';
        act.LastName = 'AAA';
        act.Nationality__c = 'American';
        act.PersonBirthdate = Date.newInstance(1990, 04, 02);
        act.RecordTypeId = Person_Account_RECORDTYPE;
        insert act;
        
        Appointment__c appointment = new Appointment__c();
        appointment.Case__c = c.Id;
        appointment.Appointment_Time__c = '17:00';
        appointment.Location__c = 'Test Location';
        appointment.Patient_Letter_Notes__c = 'Test Notes';
        appointment.Account__c = act.Id ;
        appointment.Hospital_Number_HN__c = act.Hospital_Number_HN__c;
        appointment.Appointment_Status__c = 'Booked';
        appointment.Appointment_Date__c =   System.today(); 
        appointment.Non_fixed_Time__c = '13:00';
        insert appointment;
        
        
        BIH_ApptUtility.getSMSCase(appointment.id);
        BIH_ApptUtility.getSVTM();
        BIH_ApptUtility.getSMSTemplate();
        BIH_ApptUtility.getSMSTemplateKey();
        BIH_ApptUtility.getCaseInfo(appointment.Id);
        //BIH_ApptUtility.sendSMSMessage('TEST',casesList.get(0),'0823857141');
        
        
        Test.stopTest();
    }
    

    @isTest
    public static void negativeTest(){
        Test.startTest();
        Case case2 = new Case();
        List<Case> casesList = BIH_TestUtils.createCases(1 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        BIH_CaseContactInformationCtrl.saveCase(casesList[0]);
        // BIH_CaseUtility.UpdateCaseOwner(casesList.get(0));
        // BIH_CaseUtility.UpdateReActivate(casesList.get(0));
        // BIH_CaseUtility.closeAllChildCase(case2.Id,'EIEIEI');
        Test.stopTest();
    }
    @isTest
    public static void positiveTest71() {
        List<Case> casesList = BIH_TestUtils.createCases(1 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        Test.setMock(HttpCalloutMock.class, new BIH_SendSMSServiceMockUpImpl());
        casesList[0].App_Time__c = Time.newInstance(18, 30, 2, 20);
        casesList[0].App_Date__c = Date.today();
        update casesList;
        Id Person_Account_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account act = new Account();
        act.Hospital_Number_HN__c = '1212312121';
        act.FirstName = 'Megetba';
        act.LastName = 'AAA';
        act.Nationality__c = 'American';
        act.PersonBirthdate = Date.newInstance(1990, 04, 02);
        act.RecordTypeId = Person_Account_RECORDTYPE;
        insert act;
        
        Appointment__c appointment = new Appointment__c();
        appointment.Case__c = casesList[0].Id;
        appointment.Appointment_Time__c = '17:00';
        appointment.Location__c = 'Test Location';
        appointment.Patient_Letter_Notes__c = 'Test Notes';
        appointment.Account__c = act.Id ;
        appointment.Hospital_Number_HN__c = act.Hospital_Number_HN__c;
        appointment.Appointment_Status__c = 'Booked';
        appointment.Appointment_Date__c =   System.today(); 
        appointment.Non_fixed_Time__c = '13:00';
        insert appointment;
        System.debug('appointment71'+appointment.id);
        Test.startTest();
        
        BIH_ApptUtility.getSMSCase(appointment.id);
        
        BIH_ApptUtility.sendSMSMessage('Message TEST',appointment,'0823857141');
        
        
        Test.stopTest();
    }
    
        
    

   

}