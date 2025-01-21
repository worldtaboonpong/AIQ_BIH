global class ScheduledCloseFollowUpCase implements Schedulable{
    global void execute(SchedulableContext SC) {
        BatchCloseFollowUpCase obj = new BatchCloseFollowUpCase();
        //Database.executeBatch(obj);
        Id BatchProcessId = System.enqueueJob(obj);
    }
}