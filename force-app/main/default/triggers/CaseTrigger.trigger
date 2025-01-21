trigger CaseTrigger on Case (before update,after update,before insert,after insert,before delete,after delete) {
    
    Boolean RunTrigger = BIH_Constants.IS_RUNTRIGGER;
    if(RunTrigger || Test.isRunningTest()){ 
    
    if(Trigger.isUpdate&&Trigger.isAfter){
        if(CaseTriggerHandler.countAfterUpdate==0){
            CaseTriggerHandler.countAfterUpdate++;
            System.debug('######## Start CaseTriggerHandler After Update ########');
            CaseTriggerHandler.handleAfterUpdate(Trigger.oldMap, Trigger.NewMap);
        }
    }
    if(Trigger.isUpdate &&Trigger.isBefore){
        if(CaseTriggerHandler.countBeforeUpdate==0){
            CaseTriggerHandler.countBeforeUpdate++;

            System.debug('######## Start CaseTriggerHandler Before Update ########');
            CaseTriggerHandler.handleBeforeUpdate(Trigger.oldMap, Trigger.NewMap); 
        }
    }
    
    if(Trigger.isInsert &&Trigger.isAfter){
        System.debug('######## Start CaseTriggerHandler After Insert ########');
        CaseTriggerHandler.handleAfterInsert(Trigger.new);

    }
    
    if(Trigger.isInsert &&Trigger.isBefore){
        System.debug('######## Start CaseTriggerHandler Before Insert ########');
        CaseTriggerHandler.handleBeforeInsert(Trigger.new);

        /* Platform Event */
            //  List<Update_Case_Event__e> caseEventList = new List<Update_Case_Event__e>();
            
            // for(Case c : trigger.new)
            // {            
            //     //========= Event Publish ==================
            //     Update_Case_Event__e cuce = new Update_Case_Event__e();
                
            //     cuce.Case_Id__c = c.id;
            //     caseEventList.add(cuce);
            // }
            
            
            
            // if( caseEventList.size() > 0 )
            // {
            //     // Call method to publish events.
            //     List<Database.SaveResult> results = EventBus.publish(caseEventList);
            //     // Inspect publishing result for each event
            //     for (Database.SaveResult sr : results) {
            //         if (sr.isSuccess()) {
            //             System.debug('Successfully published event.');
            //         } else {
            //             for(Database.Error err : sr.getErrors()) {
            //                 System.debug('Error returned: ' +
            //                             err.getStatusCode() +
            //                             ' - ' +
            //                             err.getMessage());
            //             }
            //         }       
            //     } 
            // }
         /* Platform Event */
    }


   }

    
}