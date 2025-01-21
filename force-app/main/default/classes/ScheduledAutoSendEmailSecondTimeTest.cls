@IsTest
public class ScheduledAutoSendEmailSecondTimeTest {
       @IsTest(SeeAllData=true) static void testScheduledAutoSendEmailSecondTime() {

        ScheduledAutoSendEmailSecondTime pp = new ScheduledAutoSendEmailSecondTime();
        system.schedule('Send Second Follow Mail',  '0 1 * * * ?', pp);
        

    }

}