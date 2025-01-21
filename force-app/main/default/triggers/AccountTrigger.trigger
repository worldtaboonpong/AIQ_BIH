trigger AccountTrigger on Account (before update,after update,before insert,after insert,before delete,after delete) {
    Boolean RunTrigger = BIH_Constants.IS_RUNTRIGGER;
    if(RunTrigger || Test.isRunningTest()){ 
        
        if(Trigger.isInsert &&Trigger.isAfter){
            System.debug('######## Start AccountTriggerHandler Before Insert ########');
            AccountTriggerHandler.handleAfterInsert(Trigger.new);
        }

        if(Trigger.isUpdate &&Trigger.isBefore){
            System.debug('######## Start AccountTriggerHandler Before Update ########');
            AccountTriggerHandler.handleBeforeUpdate(Trigger.oldMap, Trigger.NewMap); 
        }
    }

}