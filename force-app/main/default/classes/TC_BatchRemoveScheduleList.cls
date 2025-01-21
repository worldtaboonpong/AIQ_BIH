public class TC_BatchRemoveScheduleList implements Database.Batchable<sObject>, Schedulable{
	public void execute(SchedulableContext sc){
        Database.executeBatch(new TC_BatchRemoveScheduleList(), 200);
    }
    
    //Start
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id FROM Schedule_List__c');
    }
    
    //Execute
    public void execute(Database.BatchableContext BC, list<Schedule_List__c> scope){
        delete scope;
    }
    
    //Finish
    public void finish(Database.BatchableContext BC){
        Database.executeBatch(new TC_BatchCreateScheduleList(), 1);
    }
}