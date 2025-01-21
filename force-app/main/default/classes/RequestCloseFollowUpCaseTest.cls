@IsTest
public class RequestCloseFollowUpCaseTest {
        @IsTest(SeeAllData=true) static void testRequestCloseFollowUpCase() {

        Test.startTest();
        ScheduledCloseFollowUpCase pp = new ScheduledCloseFollowUpCase();
        system.schedule('Auto Close Case',  '0 1 * * * ?', pp);

        BatchCloseFollowUpCase obj = new BatchCloseFollowUpCase();
        Database.executeBatch(obj);
        

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        //RequestCustomNotifcation.sendtouser(userid,c.id,'test','test');

        Test.stopTest();
    }

}