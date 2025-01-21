global class ScheduledCaseAutoMailRegis3rd implements Schedulable{
    global void execute(SchedulableContext SC) {
        BatchCaseAutoMailRegis3rd obj = new BatchCaseAutoMailRegis3rd();
        //Database.executeBatch(obj);
        Id BatchProcessId = System.enqueueJob(obj);
        // Seconds Minutes Hours Day_of_month Month Day_of_week Optional_year

        // run at anonymuse look up schedue job
        /*ScheduledCaseNotify pp = new ScheduledCaseNotify();
        system.schedule('Notify Case Over 1 day 1',  '0 0 * * * ?', pp);
        system.schedule('Notify Case Over 1 day 2',  '0 15 * * * ?', pp);
        system.schedule('Notify Case Over 1 day 3',  '0 30 * * * ?', pp);
        system.schedule('Notify Case Over 1 day 4',  '0 45 * * * ?', pp);
        */
    }

}