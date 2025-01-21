@isTest
public without sharing class BIH_OnlineRegistrationFormServiceTest {

    @TestSetup
    static void makeData(){
        //create account
        Account acc = new Account(
            Salutation = 'Mr.',
            FirstName = 'Edward',
            MiddleName = 'Beby',
            LastName = 'Lasttest',
            Gender__c = 'Male',
            Date_of_Birth__c = Date.newinstance(1958, 3, 5),
            //Nationality__c = 'Barbadian',
            Country_of_Residence__c = 'Belgium'
        );
        insert acc;

        //create case
        Case c = new Case(
            Subject = 'Test Case',
            AccountId = acc.Id,
            SuppliedEmail = 'test@email.com',
            Hospital_Number_HN__c = '0012345678'
        );
        insert c;
        
        //create case
        Case c2 = new Case(
            Subject = 'Test Case2',
            AccountId = acc.Id,
            SuppliedEmail = 'test2@email.com'
        );
        insert c2;

        //create email task on case
        Task t = new Task(
            TaskSubtype = 'Email',
            WhatId = c.Id,
            Status = 'Completed',
            Subject = 'Email: Appointment Confirmation',
            Priority = 'Normal',
            Description = 'Email Body',
            ActivityDate = Date.newinstance(2020, 6, 19)
        );
        insert t;
    }

    @isTest
    public static void missingFileInfoPostTest(){
        // Setup a test request
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/onlineRegistrationForm';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf(getMockData('OnlineRegistrationForm_Missing_File_Info'));
        RestContext.request = req;

        // Call the method to test
        Test.startTest();
        BIH_OnlineRegistrationFormService.PostResponse reqPost = BIH_OnlineRegistrationFormService.http_post();
        Test.stopTest();
        
    }

    @isTest
    public static void missingRequiredFieldPostTest(){
        // Setup a test request
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/onlineRegistrationForm';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf(getMockData('OnlineRegistrationForm_Missing_Required'));
        RestContext.request = req;

        // Call the method to test
        Test.startTest();
        BIH_OnlineRegistrationFormService.PostResponse reqPost = BIH_OnlineRegistrationFormService.http_post();
        Test.stopTest();
    }

    @isTest
    public static void successPostTest(){
        // Setup a test request
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/onlineRegistrationForm';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf(getMockData('OnlineRegistrationForm_Success'));
        RestContext.request = req;

        // Call the method to test
        Test.startTest();
        BIH_OnlineRegistrationFormService.PostResponse reqPost = BIH_OnlineRegistrationFormService.http_post();
        Test.stopTest();
    }

    @isTest
    public static void successGetTest(){
        BIH_Constants__mdt cons = [Select Id, MasterLabel , DeveloperName , Value_1__c From BIH_Constants__mdt WHERE DeveloperName = 'URL_EXPIRY_hrs'];
        Case c = [SELECT Id FROM Case WHERE Subject = 'Test Case'];
        
        // Setup a test request
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/onlineRegistrationForm';
        req.httpMethod = 'GET';
        req.addParameter('id', c.Id);
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;

        // Call the method to test
        Test.startTest();
        BIH_OnlineRegistrationFormService.GetResponse reqGet = BIH_OnlineRegistrationFormService.http_get();
        Test.stopTest();
    }
    
    @isTest
    public static void notFoundCaseGetTest(){
        BIH_Constants__mdt cons = [Select Id, MasterLabel , DeveloperName , Value_1__c From BIH_Constants__mdt WHERE DeveloperName = 'URL_EXPIRY_hrs'];
        
        // Setup a test request
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/onlineRegistrationForm';
        req.httpMethod = 'GET';
        req.addParameter('id', null);
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;

        // Call the method to test
        Test.startTest();
        BIH_OnlineRegistrationFormService.GetResponse reqGet = BIH_OnlineRegistrationFormService.http_get();
        Test.stopTest();
    }

    @isTest
    public static void notFounTaskGetTest(){
        BIH_Constants__mdt cons = [Select Id, MasterLabel , DeveloperName , Value_1__c From BIH_Constants__mdt WHERE DeveloperName = 'URL_EXPIRY_hrs'];
        Case c = [SELECT Id FROM Case WHERE Subject = 'Test Case2'];
        
        // Setup a test request
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/onlineRegistrationForm';
        req.httpMethod = 'GET';
        req.addParameter('id', c.Id);
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;

        // Call the method to test
        Test.startTest();
        BIH_OnlineRegistrationFormService.GetResponse reqGet = BIH_OnlineRegistrationFormService.http_get();
        Test.stopTest();
    }


    public static String getMockData(String mockName){
        return [SELECT Json_Body__c FROM Integration_Mock_Test_Data__mdt WHERE DeveloperName =: mockName].Json_Body__c;   
    }

}