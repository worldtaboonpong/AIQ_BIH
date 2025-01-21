@isTest
public class AccountTriggerHandlerTest {
    @isTest
    public static void positiveTest(){
        Test.startTest();
        
        List<Account> accList = BIH_TestUtils.createAccounts(1 , 'test001', true);
        accList.get(0).email__c = 'BIHTest001@bumrungradtest.com';
        accList.get(0).email2__c = 'BIHTest002@bumrungradtest.com';
        accList.get(0).email3__c = 'BIHTest003@bumrungradtest.com';
        accList.get(0).email4__c = 'BIHTest004@bumrungradtest.com';
        
        update accList.get(0);
        Test.stopTest();
    }

}