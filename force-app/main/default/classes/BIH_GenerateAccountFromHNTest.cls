@isTest
public class BIH_GenerateAccountFromHNTest {
    @testSetup static void methodName() {
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        accList.get(0).Hospital_Number_HN__c = '000000001';
        update accList.get(0);
        List<Case> caseList = BIH_TestUtils.createCases(1, 'test','Request','Email', true);
        List<User> userList = BIH_TestUtils.createUsers(1, 'FName', 'LName', 'user_test@mail.com', true);

        caseList[0].AccountId = accList[0].id;
        BIH_TestUtils.createServiceTypeMatrixs();
        update caseList;
        
        
    }
    
    @isTest
    public static void positiveTest1(){
        Test.setMock(HttpCalloutMock.class, new BIH_PatientInformationServiceMockImpl());
        Test.startTest();
        List<Id> caseIdList =new List<Id>();
        List<Case> caseList = [Select id,Hospital_Number_HN__c from case];
        
        for(Case c :caseList){
            c.Hospital_Number_HN__c = '000000001';
            caseIdList.add(c.id);
        }
        
        //update caseList;
        
        BIH_GenerateAccountFromHN verifyHN = new BIH_GenerateAccountFromHN(caseIdList);
        database.executeBatch(verifyHN);
        Test.stopTest();
        
    }
    
    @isTest
    public static void positiveTest2(){
        Test.setMock(HttpCalloutMock.class, new BIH_PatientInformationServiceMockImpl());
        Test.startTest();
        List<Id> caseIdList =new List<Id>();
        List<Case> caseList = [Select id,Hospital_Number_HN__c from case];
        
        for(Case c :caseList){
            c.Hospital_Number_HN__c = '000000002';
            caseIdList.add(c.id);
        }
        
        //update caseList;
        
        BIH_GenerateAccountFromHN verifyHN = new BIH_GenerateAccountFromHN(caseIdList);
        database.executeBatch(verifyHN);
        Test.stopTest();
        
    }
    @isTest
    public static void positiveTest3(){
        Test.setMock(HttpCalloutMock.class, new BIH_PatientInformationServiceMockImpl());
         List<Id> caseIdList =new List<Id>();
        List<Case> caseList = [Select id,Hospital_Number_HN__c from case];
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
        for(Case c :caseList){
            c.Hospital_Number_HN__c = '120000003';
            c.AccountId = accList[0].id;
            caseIdList.add(c.id);
        }
        
        //update caseList;
        Test.startTest();
       
        
        BIH_GenerateAccountFromHN verifyHN = new BIH_GenerateAccountFromHN(caseIdList);
        database.executeBatch(verifyHN);
        Test.stopTest();
        
    }
    // @isTest
    // public static void positiveTest4(){
    //     Test.setMock(HttpCalloutMock.class, new BIH_PatientInformationServiceMockImpl());
    //      List<Id> caseIdList =new List<Id>();
    //     List<Case> caseList = [Select id,Hospital_Number_HN__c from case];
    //     List<Account> accList = BIH_TestUtils.createPersonAccounts(1, 'test','test@mail.com', true);
    //     Account acc = new Account();
    //     Case testCase = new Case();
    //     accList.add(acc);
    //     for(Case c :caseList){
    //         c.Hospital_Number_HN__c = '123123123123';
    //         c.AccountId = accList[0].id;
    //         caseIdList.add(c.id);
    //     }
    //     caseIdList.add(testCase.Id);
    //     update caseList;
    //     caseList.add(testCase);
    //     Test.startTest();
       
    //     List<Id> testCaselist = new List<Id>();
    //     testCaselist.add(testCase.Id);
    //     BIH_GenerateAccountFromHN verifyHN = new BIH_GenerateAccountFromHN(caseIdList);
    //  database.executeBatch(verifyHN);
    //  Test.stopTest();
        
    // }

}