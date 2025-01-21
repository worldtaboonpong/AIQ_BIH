@IsTest
public class RequestAutoSendMECLTest {
        @IsTest(SeeAllData=true) static void testRequestAutoSendMECL() {

        Test.startTest();
        ScheduledAutoSendMECL pp = new ScheduledAutoSendMECL();
        system.schedule('Auto Send ME CL Follow up Mail',  '0 1 * * * ?', pp);

        BatchAutoSendMECL obj = new BatchAutoSendMECL();
        Database.executeBatch(obj);
        

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        //RequestCustomNotifcation.sendtouser(userid,c.id,'test','test');

        Test.stopTest();
    }

}