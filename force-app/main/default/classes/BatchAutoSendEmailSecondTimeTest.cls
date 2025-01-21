@IsTest
public class BatchAutoSendEmailSecondTimeTest {
        @IsTest(SeeAllData=true) static void testBatchAutoSendEmailSecondTime() {

        ScheduledAutoSendEmailFirstTime pp = new ScheduledAutoSendEmailFirstTime();
        system.schedule('StampScheduledAutoSendEmailFirstTime 1 day 11',  '0 1 * * * ?', pp);

        BatchAutoSendEmailSecondTime obj = new BatchAutoSendEmailSecondTime();
        //Database.executeBatch(obj);
    }

}