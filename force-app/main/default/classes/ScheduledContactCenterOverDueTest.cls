@IsTest
public class ScheduledContactCenterOverDueTest {
        @IsTest(SeeAllData=true) static void testScheduledContactCenterOverDue() {

        ScheduledContactCenterOverDue pp = new ScheduledContactCenterOverDue();
        system.schedule('Send CC OverDue',  '0 1 * * * ?', pp);
        

    }

}