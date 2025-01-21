global class ScheduledAutoSendMECL implements Schedulable{
        global void execute(SchedulableContext SC) {
        BatchAutoSendMECL obj = new BatchAutoSendMECL();
        Database.executeBatch(obj);
        //Id BatchProcessId = System.enqueueJob(obj);
     }

}