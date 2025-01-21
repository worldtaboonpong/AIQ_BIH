global class ScheduledAutoCloseRegist7Days implements Schedulable{
    global void execute(SchedulableContext SC) {
        BatchAutoCloseRegist7Days obj = new BatchAutoCloseRegist7Days();
        Database.executeBatch(obj);
        //Id BatchProcessId = System.enqueueJob(obj);
    }
}