global class ScheduledAutoSendEmailSecondTime implements Schedulable{
    	global void execute(SchedulableContext SC) {
        BatchAutoSendEmailSecondTime obj = new BatchAutoSendEmailSecondTime();
        //Database.executeBatch(obj);
        Id BatchProcessId = System.enqueueJob(obj);
     }

}