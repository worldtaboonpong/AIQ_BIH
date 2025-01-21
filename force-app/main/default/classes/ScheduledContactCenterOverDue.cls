global class ScheduledContactCenterOverDue implements Schedulable{
     global void execute(SchedulableContext SC) {
        BatchContactCenterOverDue obj = new BatchContactCenterOverDue();
        //Database.executeBatch(obj);
        Id BatchProcessId = System.enqueueJob(obj);
     }
}