@IsTest
public class RequestAutoSendMEEmailSecondTimeTest {
        @IsTest(SeeAllData=true) static void testRequestAutoSendMEEmailSecondTime() {

        Test.startTest();
        ScheduledAutoSendMEEmailSecondTime pp = new ScheduledAutoSendMEEmailSecondTime();
        system.schedule('Auto Send ME Follow up Second Mail',  '0 1 * * * ?', pp);

        BatchAutoSendMEEmailSecondTime obj = new BatchAutoSendMEEmailSecondTime();
        Database.executeBatch(obj);
        

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        //RequestCustomNotifcation.sendtouser(userid,c.id,'test','test');

        Test.stopTest();
    }

}