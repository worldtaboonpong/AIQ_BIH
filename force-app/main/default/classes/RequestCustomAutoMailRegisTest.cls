@IsTest
public class RequestCustomAutoMailRegisTest {
    @IsTest(SeeAllData=true) static void testRequestCustomAutoMailRegis() {

        Test.startTest();
        ScheduledCaseAutoMailRegis pp = new ScheduledCaseAutoMailRegis();
        system.schedule('Auto Send Warning Mail',  '0 1 * * * ?', pp);

        BatchCaseAutoMailRegis obj = new BatchCaseAutoMailRegis();
        Database.executeBatch(obj);
        

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        //RequestCustomNotifcation.sendtouser(userid,c.id,'test','test');

        Test.stopTest();
    }

}