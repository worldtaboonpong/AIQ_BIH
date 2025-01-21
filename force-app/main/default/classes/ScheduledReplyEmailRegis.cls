global class ScheduledReplyEmailRegis implements Schedulable{
     global void execute(SchedulableContext SC) {
        BatchReplyEmailRegis obj = new BatchReplyEmailRegis();
        //Database.executeBatch(obj);
        Id BatchProcessId = System.enqueueJob(obj);
     }
}