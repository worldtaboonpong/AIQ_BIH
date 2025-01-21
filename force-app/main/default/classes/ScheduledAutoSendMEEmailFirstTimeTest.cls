@IsTest
public class ScheduledAutoSendMEEmailFirstTimeTest {
       @IsTest(SeeAllData=true) static void testScheduledAutoSendMEEmailFirstTim() {

        ScheduledAutoSendMEEmailFirstTime pp = new ScheduledAutoSendMEEmailFirstTime();
        system.schedule('Send First ME Follow Mail',  '0 1 * * * ?', pp);
        

    }

}