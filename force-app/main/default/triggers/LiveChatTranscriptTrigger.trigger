trigger LiveChatTranscriptTrigger on LiveChatTranscript (before update,after update,before insert,after insert) {
    Boolean RunTrigger = BIH_Constants.IS_RUNTRIGGER;
    if (RunTrigger || Test.isRunningTest()){

       if(Trigger.isUpdate &&Trigger.isBefore){
          System.debug('######## Start LiveChatTranscriptTrigger Before Update ########');
          LiveChatTranscriptTriggerHandler.handleBeforeUpdate(Trigger.new);
       }
        
        if(Trigger.isUpdate &&Trigger.isAfter){
          System.debug('######## Start LiveChatTranscriptTrigger After Update ########');
          LiveChatTranscriptTriggerHandler.handleAfterInsert(Trigger.new);
       }
    }
}