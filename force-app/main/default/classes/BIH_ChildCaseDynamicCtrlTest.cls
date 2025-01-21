@isTest
public class BIH_ChildCaseDynamicCtrlTest {
    @isTest
    public static void positiveTest(){
        Test.startTest();
        
		List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true); 
        
        //BIH_ChildCaseDynamicCtrl.saveCases(casesList);
        BIH_ChildCaseDynamicCtrl.find_CaseById(casesList.get(0).id);
		BIH_ChildCaseDynamicCtrl.getPickListValuesChannel();
        BIH_ChildCaseDynamicCtrl.mapDataChildcase();
        BIH_ChildCaseDynamicCtrl.ownerMap();
        BIH_ChildCaseDynamicCtrl.recordTypeMap();
        
        Test.stopTest();
    }
    
    public static void negativeTest(){
        //Case test = new Case();
        //BIH_ChildCaseDynamicCtrl.find_CaseById(test.Id);
    }
}