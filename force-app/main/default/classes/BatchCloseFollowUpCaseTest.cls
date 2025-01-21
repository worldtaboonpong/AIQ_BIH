@IsTest
public class BatchCloseFollowUpCaseTest {
        @IsTest(SeeAllData=true) static void testBatchCloseFollowUpCase() {

        ScheduledCloseFollowUpCase pp = new ScheduledCloseFollowUpCase();
        system.schedule('StampScheduledCloseFollowUpCase 1 day 11',  '0 1 * * * ?', pp);

        BatchCloseFollowUpCase obj = new BatchCloseFollowUpCase();
        Database.executeBatch(obj);
    }


}