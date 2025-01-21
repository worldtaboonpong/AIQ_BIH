@IsTest
public class RequestAutoSendMEEmailFirstTimeTest {
        @IsTest(SeeAllData=true) static void testRequestAutoSendMEEmailFirstTime() {

        Test.startTest();
        ScheduledAutoSendMEEmailFirstTime pp = new ScheduledAutoSendMEEmailFirstTime();
        system.schedule('Auto Send ME Follow up First Mail',  '0 1 * * * ?', pp);

        BatchAutoSendMEEmailFirstTime obj = new BatchAutoSendMEEmailFirstTime();
        Database.executeBatch(obj);
        

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        //RequestCustomNotifcation.sendtouser(userid,c.id,'test','test');

        Test.stopTest();
    }

}