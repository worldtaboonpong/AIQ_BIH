trigger EmailMessageTrigger on EmailMessage (before insert,after insert) {

    Boolean RunTrigger = BIH_Constants.IS_RUNTRIGGER;
    
    //check email is reply from external team , case status update to "In Progress"
    if(RunTrigger || Test.isRunningTest()){ 
    if(Trigger.isInsert &&Trigger.isAfter){
        System.debug('######## Start EmailMessageTrigger After Insert ########');
        EmailMessageTriggerHandler.handleAfterInsert(Trigger.new);

    }
    }
    
    
}