@IsTest
public class BatchAutoSendMECLTest {
    @IsTest(SeeAllData=true) static void testBatchAutoSendMECL() {

        ScheduledAutoSendMECL pp = new ScheduledAutoSendMECL();
        system.schedule('StampScheduledAutoSendMECL 1 day 11',  '0 1 * * * ?', pp);

        BatchAutoSendMECL obj = new BatchAutoSendMECL();
        Database.executeBatch(obj);
    }

}