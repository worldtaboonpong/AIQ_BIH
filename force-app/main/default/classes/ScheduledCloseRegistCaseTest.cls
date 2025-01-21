@IsTest
public class ScheduledCloseRegistCaseTest {
    @IsTest(SeeAllData=true) static void testScheduledCloseRegistCase() {

        ScheduledCloseRegistCase pp = new ScheduledCloseRegistCase();
        system.schedule('Auto Close Case',  '0 1 * * * ?', pp);
        

    }

}