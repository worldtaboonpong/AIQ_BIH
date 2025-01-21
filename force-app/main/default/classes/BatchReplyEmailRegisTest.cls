@IsTest
public class BatchReplyEmailRegisTest {
    @IsTest(SeeAllData=true) static void testBatchReplyEmailRegis() {

        ScheduledReplyEmailRegis pp = new ScheduledReplyEmailRegis();
        system.schedule('StampReplyEmailRegis 1 day 11',  '0 1 * * * ?', pp);

        BatchReplyEmailRegis obj = new BatchReplyEmailRegis();
        Database.executeBatch(obj);
    }

}