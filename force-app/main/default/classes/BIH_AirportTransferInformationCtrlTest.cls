@isTest
public class BIH_AirportTransferInformationCtrlTest {
    @isTest
    public static void positiveTest(){
        Test.startTest();
        List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321','Appointment','Email', true);
        List<string> picklst = new List<string>();
        picklst.add('Arrival_Time__c');
        BIH_AirportTransferInformationCtrl.getPickListValuesIntoList(picklst);
        BIH_AirportTransferInformationCtrl.getWrapperInfo(casesList.get(0).id);
        Test.stopTest();
        
    }
}