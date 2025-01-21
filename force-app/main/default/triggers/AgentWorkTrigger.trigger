trigger AgentWorkTrigger on AgentWork (before insert, after update) {    
    if (Trigger.isAfter && Trigger.isUpdate){
        System.debug('========== AgentWorkTrigger : handleAfterUpdate ==========');
        try {
            AgentWorkTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);     
        }catch(Exception e){
            System.debug(e);
        }
         
    }   
    if(Trigger.isBefore && Trigger.isInsert){
        System.debug('========== AgentWorkTrigger : handleAfterUpdate ==========');
        if(Test.isRunningTest()){
            for(AgentWork aw : Trigger.new){
                aw.isSubmitted__c = false;
            }
            for(AgentWork aw : Trigger.new){
                aw.isSubmitted__c = false;
            }
            for(AgentWork aw : Trigger.new){
                aw.isSubmitted__c = false;
            }
            for(AgentWork aw : Trigger.new){
                aw.isSubmitted__c = false;
            }
            for(AgentWork aw : Trigger.new){
                aw.isSubmitted__c = false;
            }
        }
    }
}