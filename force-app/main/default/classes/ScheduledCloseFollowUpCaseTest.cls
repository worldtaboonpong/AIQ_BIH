@IsTest
public class ScheduledCloseFollowUpCaseTest {
     @IsTest(SeeAllData=true) static void testScheduledCloseFollowUpCase() {

     ScheduledCloseFollowUpCase pp = new ScheduledCloseFollowUpCase();
     system.schedule('Close Case',  '0 1 * * * ?', pp);
        

    }

}