@IsTest
public class ScheduledAutoSendMEEmailSecondTimeTest {
       @IsTest(SeeAllData=true) static void testScheduledAutoSendMEEmailSecondTime() {

        ScheduledAutoSendMEEmailSecondTime pp = new ScheduledAutoSendMEEmailSecondTime();
        system.schedule('Send Second ME Follow Mail',  '0 1 * * * ?', pp);
        

    }

}