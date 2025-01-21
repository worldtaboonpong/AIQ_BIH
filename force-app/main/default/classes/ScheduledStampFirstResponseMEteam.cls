global class ScheduledStampFirstResponseMEteam implements Schedulable{
    	global void execute(SchedulableContext SC) {
        BatchStampFirstResponseMEteam obj = new BatchStampFirstResponseMEteam();
        //Database.executeBatch(obj);
        Id BatchProcessId = System.enqueueJob(obj);
     }

}