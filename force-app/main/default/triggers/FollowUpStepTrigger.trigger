trigger FollowUpStepTrigger on Follow_Up_Step__c (before insert,after insert,after update) {
	Boolean RunTrigger = BIH_Constants.IS_RUNTRIGGER;
    if (RunTrigger || Test.isRunningTest()){

        if (Trigger.isInsert && Trigger.isAfter){
            System.debug('######## Start FollowUpStepTriggerHandler Before Insert ########');
            FollowUpStepTriggerHandler.handleAfterInsert(Trigger.new);
        }

        if (Trigger.isUpdate && Trigger.isAfter){
            System.debug('######## Start FollowUpStepTriggerHandler Before Insert ########');
            FollowUpStepTriggerHandler.handleAfterUpdate(Trigger.new);
        }
    }
}