@IsTest
public class RequestAutoSendEmailFirstTimeTest {
         @IsTest(SeeAllData=true) static void testRequestAutoSendEmailFirstTime() {

        Test.startTest();
        ScheduledAutoSendEmailFirstTime pp = new ScheduledAutoSendEmailFirstTime();
        system.schedule('Auto Send Follow up First Mail',  '0 1 * * * ?', pp);

        BatchAutoSendEmailFirstTime obj = new BatchAutoSendEmailFirstTime();
        //Database.executeBatch(obj);
        

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        //RequestCustomNotifcation.sendtouser(userid,c.id,'test','test');

        Test.stopTest();
    }

}