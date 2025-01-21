@IsTest
public class TC_BatchRemoveScheduleListTest {
    @TestSetup
    static void setup() {
        TC_TestDataFactory.insertConfigData();
    }
    
	@IsTest
    static void unitTest01() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TC_TrakCareServiceMock(
            TC_TrakCareServiceMock.schedulesListResponse
        ));
        
        TC_BatchRemoveScheduleList tbrslCtrl = new TC_BatchRemoveScheduleList();
        String sch = '0 0 23 * * ?'; 
        system.schedule('TC_BatchRemoveScheduleListTest', sch, tbrslCtrl); 
        Test.stopTest();
    }
}