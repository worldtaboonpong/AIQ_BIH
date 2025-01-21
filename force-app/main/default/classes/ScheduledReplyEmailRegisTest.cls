@IsTest
public class ScheduledReplyEmailRegisTest {
    @IsTest(SeeAllData=true) static void testScheduledReplyEmailRegis() {

        ScheduledReplyEmailRegis pp = new ScheduledReplyEmailRegis();
        system.schedule('Patient Reply to Case',  '0 1 * * * ?', pp);
        

    }

}