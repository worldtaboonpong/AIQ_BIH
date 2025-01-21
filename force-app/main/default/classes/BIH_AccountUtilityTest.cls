@isTest
public class BIH_AccountUtilityTest {
    @isTest
    public static void positiveTest(){
        Test.startTest();
        
        List<Account> accPersonList = BIH_TestUtils.createPersonAccounts(1 , 'Test001','BIHTest@bumrungradtest.com', true);
        List<Account> accList = BIH_TestUtils.createAccounts(1 , 'test001', true);
        
        BIH_AccountQuickDetailCtrl.LeadRecordObj = null;
        BIH_AccountQuickDetailCtrl.AccountRecordObj = null;
        
        BIH_AccountQuickDetailCtrl.getCaseByAccountId(accPersonList.get(0).id);
        BIH_AccountQuickDetailCtrl.getCaseByAccountId(accList.get(0).id);
        BIH_AccountQuickDetailCtrl.getAccount(accList.get(0).id);
        BIH_AccountQuickDetailCtrl.getUserCurrent();
        BIH_AccountQuickDetailCtrl.showContactCenterNote();
        
        Test.stopTest();
    }
    
    @isTest
    public static void negativeTest(){ 
        Account acc = new Account();
        BIH_AccountQuickDetailCtrl.getCaseByAccountId(acc.Id);
        BIH_AccountQuickDetailCtrl.getAccount(acc.Id);
    }
}