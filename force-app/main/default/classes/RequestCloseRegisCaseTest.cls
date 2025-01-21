@IsTest
public class RequestCloseRegisCaseTest {
    @IsTest(SeeAllData=true) static void testRequestCloseRegistCase() {

        Test.startTest();
        ScheduledCloseRegistCase pp = new ScheduledCloseRegistCase();
        system.schedule('Auto Close Case',  '0 1 * * * ?', pp);

        BatchAutoCloseRegistCase obj = new BatchAutoCloseRegistCase();
        Database.executeBatch(obj);
        

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        //RequestCustomNotifcation.sendtouser(userid,c.id,'test','test');

        Test.stopTest();
    }

}