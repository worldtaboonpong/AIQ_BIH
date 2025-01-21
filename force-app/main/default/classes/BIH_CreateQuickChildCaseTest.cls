@isTest
public class BIH_CreateQuickChildCaseTest {
    @isTest
    public static void unitTest01(){

        List<Account> accList = BIH_TestUtils.createPersonAccounts(1 , 'Test001','BIHTest@bumrungradtest.com', true);
        List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        
        Case c = new Case(); 
        c.AccountId = accList.get(0).Id;
        c.Subject = 'Test naja HN: 098765432';
        c.Case_Category_Level1__c = 'Appointment';
        c.origin = 'Web';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Registration Case').getRecordTypeId();
        c.ParentId = casesList.get(1).id;
        c.Status = 'Pending';
        c.Pending_Reason__c = 'testing';
        c.Building__c = 'test1';
        c.Department__c = 'test1';
        insert c;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        
        Case caseObj = [
        	SELECT Id, Status, Building__c, Department__c, Case_Category_Level1__c, Case_Category_Level2__c,
            Case_Category_Level3__c
            FROM Case WHERE id = :c.Id  
        ];
        
        Test.startTest();
        BIH_CreateQuickChildCase.getUserProfile();
        BIH_CreateQuickChildCase.createQuickCase(c.Id);
        Test.stopTest();
    }

}