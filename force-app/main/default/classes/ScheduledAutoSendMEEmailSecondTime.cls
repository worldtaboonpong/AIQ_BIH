global class ScheduledAutoSendMEEmailSecondTime implements Schedulable{
    global void execute(SchedulableContext SC) {
        BatchAutoSendMEEmailSecondTime obj = new BatchAutoSendMEEmailSecondTime();
        Database.executeBatch(obj);
        //Id BatchProcessId = System.enqueueJob(obj);
     }

}