global class ScheduledAutoSendEmailFirstTime implements Schedulable{
	global void execute(SchedulableContext SC) {
        BatchAutoSendEmailFirstTime obj = new BatchAutoSendEmailFirstTime();
        //Database.executeBatch(obj);
        Id BatchProcessId = System.enqueueJob(obj);
     }
}