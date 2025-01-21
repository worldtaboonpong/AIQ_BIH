@IsTest
public class RequestAutoSendEmailSecondTimeTest {
        @IsTest(SeeAllData=true) static void testRequestAutoSendEmailSecondTime() {

        Test.startTest();
        ScheduledAutoSendEmailSecondTime pp = new ScheduledAutoSendEmailSecondTime();
        system.schedule('Auto Send Follow up Second Mail',  '0 1 * * * ?', pp);

        BatchAutoSendEmailSecondTime obj = new BatchAutoSendEmailSecondTime();
        Database.executeBatch(obj);
        

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        //RequestCustomNotifcation.sendtouser(userid,c.id,'test','test');

        Test.stopTest();
    }


}