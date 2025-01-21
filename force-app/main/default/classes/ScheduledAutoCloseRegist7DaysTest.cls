@IsTest
public class ScheduledAutoCloseRegist7DaysTest {
     @IsTest(SeeAllData=true) static void testScheduledAutoCloseRegist7Days() {

     ScheduledAutoCloseRegist7Days pp = new ScheduledAutoCloseRegist7Days();
     system.schedule('Close Case',  '0 1 * * * ?', pp);
        

    }

}