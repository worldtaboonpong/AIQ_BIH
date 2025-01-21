@IsTest
public with sharing class ScheduledCaseNotifyTest {
    @IsTest(SeeAllData=true) static void testScheduledCaseNotify() {

        ScheduledCaseNotify pp = new ScheduledCaseNotify();
        system.schedule('Notify Case Over 1 day 11',  '0 1 * * * ?', pp);
        //system.schedule('Notify Case Over 1 day 2',  '0 15 * * * ?', pp);


        // run at anonymuse look up schedue job
        /*ScheduledCaseNotify pp = new ScheduledCaseNotify();
        system.schedule('Notify Case Over 1 day 1',  '0 0 * * * ?', pp);
        system.schedule('Notify Case Over 1 day 2',  '0 15 * * * ?', pp);
        system.schedule('Notify Case Over 1 day 3',  '0 30 * * * ?', pp);
        system.schedule('Notify Case Over 1 day 4',  '0 45 * * * ?', pp);
        */


    }
}