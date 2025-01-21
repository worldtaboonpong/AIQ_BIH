@IsTest
public class ScheduledCaseAutoMailRegisTest {
    @IsTest(SeeAllData=true) static void testScheduledCaseAutoMailRegis() {

        ScheduledCaseAutoMailRegis pp = new ScheduledCaseAutoMailRegis();
        system.schedule('Case Auto Mail Regis',  '0 1 * * * ?', pp);

        BatchCaseAutoMailRegis obj = new BatchCaseAutoMailRegis();
        Database.executeBatch(obj);

    }

}