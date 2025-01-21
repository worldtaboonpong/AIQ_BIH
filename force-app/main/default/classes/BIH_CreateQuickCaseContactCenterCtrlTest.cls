@isTest
public class BIH_CreateQuickCaseContactCenterCtrlTest {
    @isTest
    public static void positiveTest(){
        Test.startTest();
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1 , 'Test001','BIHTest@bumrungradtest.com', true);
        List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        //Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = [SELECT Id FROM User WHERE User_Team__c = 'Contact Center Team' AND IsActive = true LIMIT 1];
        
        Id Person_Account_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account act = new Account();
        act.Hospital_Number_HN__c = '1212312121';
        act.FirstName = 'Megetba';
        act.LastName = 'AAA';
        act.Nationality__c = 'American';
        act.PersonBirthdate = Date.newInstance(1990, 04, 02);
        act.RecordTypeId = Person_Account_RECORDTYPE;
        insert act;
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Test';
        con.Phone = '66840778797';
        insert con;
        
        
        Case c = new Case();
        system.debug('act.id+'+act.id);
        
        c.Subject = 'Test naja HN: 098765432';
        c.Case_Category_Level1__c = 'Appointment';
        c.origin = 'Web';
        c.ParentId = casesList.get(1).id;
        c.App_Date__c = System.today(); 
        c.Channel__c = 'Individual';
        c.Lead_Source__c = 'Email';
        c.accountid = act.id;
        insert c;
        
        BIH_CreateQuickCaseContactCenterCtrl.createQuickCase(act.id);
        BIH_CreateQuickCaseContactCenterCtrl.createQuickCase(con.id);
        BIH_CreateQuickCaseContactCenterCtrl.getUserProfile();
        
        Test.stopTest();     
            
    }

}