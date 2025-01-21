@IsTest
public class RequestReplyEmailRegisTest {
     @IsTest(SeeAllData=true) static void testRequestReplyEmailRegis() {

        Test.startTest();
        ScheduledReplyEmailRegis pp = new ScheduledReplyEmailRegis();
        system.schedule('Auto Send Warning Mail',  '0 1 * * * ?', pp);

        BatchReplyEmailRegis obj = new BatchReplyEmailRegis();
        //Database.executeBatch(obj);
        

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        //RequestCustomNotifcation.sendtouser(userid,c.id,'test','test');

        Test.stopTest();
    }

}