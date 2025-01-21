@IsTest
public class ScheduledAutoSendEmailFirstTimeTest {
        @IsTest(SeeAllData=true) static void testScheduledAutoSendEmailFirstTime() {

        ScheduledAutoSendEmailFirstTime pp = new ScheduledAutoSendEmailFirstTime();
        system.schedule('Send First Follow Mail',  '0 1 * * * ?', pp);
        

    }

}