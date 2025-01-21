global class ScheduledStampFirstResponseValue implements Schedulable{
        global void execute(SchedulableContext SC) {
        BatchStampFirstResponseValue obj = new BatchStampFirstResponseValue();
        //Database.executeBatch(obj);
        Id BatchProcessId = System.enqueueJob(obj);
     }

}