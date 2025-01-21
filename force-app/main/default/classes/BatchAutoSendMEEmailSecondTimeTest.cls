@IsTest
public class BatchAutoSendMEEmailSecondTimeTest {
        @IsTest(SeeAllData=true) static void testBatchAutoSendMEEmailSecondTime() {

        ScheduledAutoSendMEEmailSecondTime pp = new ScheduledAutoSendMEEmailSecondTime();
        system.schedule('StampScheduledAutoSendMEEmailSecondTime 1 day 11',  '0 1 * * * ?', pp);

        BatchAutoSendMEEmailSecondTime obj = new BatchAutoSendMEEmailSecondTime();
        Database.executeBatch(obj);
    }

}