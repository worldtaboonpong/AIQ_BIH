@IsTest
public class BatchAutoSendEmailFirstTimeTest {
        @IsTest(SeeAllData=true) static void testBatchAutoSendEmailFirstTime() {

        ScheduledAutoSendEmailFirstTime pp = new ScheduledAutoSendEmailFirstTime();
        system.schedule('StampScheduledAutoSendEmailFirstTime 1 day 11',  '0 1 * * * ?', pp);

        BatchAutoSendEmailFirstTime obj = new BatchAutoSendEmailFirstTime();
        Database.executeBatch(obj);
    }

}