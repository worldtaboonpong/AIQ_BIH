global class ScheduledCloseRegistCase implements Schedulable{
    global void execute(SchedulableContext SC) {
        BatchAutoCloseRegistCase obj = new BatchAutoCloseRegistCase();
        //Database.executeBatch(obj);
        Id BatchProcessId = System.enqueueJob(obj);
    }
}