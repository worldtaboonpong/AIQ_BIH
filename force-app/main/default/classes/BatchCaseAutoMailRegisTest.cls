@IsTest
public class BatchCaseAutoMailRegisTest {
        @IsTest(SeeAllData=true) static void testBatchCaseAutoMailRegis() {

        ScheduledCaseAutoMailRegis pp = new ScheduledCaseAutoMailRegis();
        system.schedule('SendAuto Email 1 day 11',  '0 1 * * * ?', pp);

        BatchCaseAutoMailRegis obj = new BatchCaseAutoMailRegis();
        Database.executeBatch(obj);
        

        // run at anonymuse look up schedue job
        /*ScheduledCaseNotify pp = new ScheduledCaseNotify();
        system.schedule('Notify Case Over 1 day 1',  '0 0 * * * ?', pp);
        system.schedule('Notify Case Over 1 day 2',  '0 15 * * * ?', pp);
        system.schedule('Notify Case Over 1 day 3',  '0 30 * * * ?', pp);
        system.schedule('Notify Case Over 1 day 4',  '0 45 * * * ?', pp);
        */

    }

}