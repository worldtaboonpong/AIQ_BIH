global class ScheduledAutoSendMEEmailFirstTime implements Schedulable{
    global void execute(SchedulableContext SC) {
        BatchAutoSendMEEmailFirstTime obj = new BatchAutoSendMEEmailFirstTime();
        //Database.executeBatch(obj);
        Id BatchProcessId = System.enqueueJob(obj);
     }
}