@IsTest
public class BatchAutoSendMEEmailFirstTimeTest {
    @IsTest(SeeAllData=true) static void testBatchAutoSendMEEmailFirstTime() {

        ScheduledAutoSendMEEmailFirstTime pp = new ScheduledAutoSendMEEmailFirstTime();
        system.schedule('StampScheduledAutoSendMEEmailFirstTime 1 day 11',  '0 1 * * * ?', pp);

        BatchAutoSendMEEmailFirstTime obj = new BatchAutoSendMEEmailFirstTime();
        Database.executeBatch(obj);
    }

}