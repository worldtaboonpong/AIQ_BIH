@isTest
public class BIH_GlobalFunctionTest {
    @isTest
    public static void positiveTest(){
        
        Test.startTest();
        BIH_TestUtils.createServiceTypeMatrixs();
        BIH_CustomLookUpController.fetchLookUpValues('ref','Group','','Name','','','SOSL');
        BIH_CustomLookUpController.fetchLookUpValues('ref','Group','','Name','','','SQL');
    
    	BIH_PicklistOption pl = new BIH_PicklistOption('Test','Test');
        
        Test.stopTest();
    }

}