@IsTest
public class BatchAutoCloseRegistCaseTest {
    @IsTest(SeeAllData=true) static void testAutoCloseRegistCase() {

        ScheduledCloseRegistCase pp = new ScheduledCloseRegistCase();
        system.schedule('Regist Auto Close Case 1 day 11',  '0 1 * * * ?', pp);

        BatchAutoCloseRegistCase obj = new BatchAutoCloseRegistCase();
        Database.executeBatch(obj);
    }

}