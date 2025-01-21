public class LiveChatTranscriptTriggerHandler {
    /*
   public static Id INDI_CASE_QUEUE_ID {get{
        if(INDI_CASE_QUEUE_ID==null){
            INDI_CASE_QUEUE_ID = [SELECT Id, Name, DeveloperName,type FROM Group where DeveloperName = 'Individual_Team_Case' and type ='Queue'].Id;
        }
        return INDI_CASE_QUEUE_ID;
    }set;}

    public static void handleBeforeUpdate(List<LiveChatTranscript> chatList) {
        /-*Set<Id> chatId = new Set<Id>();

        Map<Id,LiveChatButton> mapChatButton = new Map<Id,LiveChatButton>([SELECT Id, QueueId, DeveloperName FROM LiveChatButton]);
        for(LiveChatTranscript lc: chatList){ 
             string queueId = mapChatButton.get(lc.LiveChatButtonId).QueueId;

            
        }*-/
       
    }
    
    public static void handleAfterInsert(List<LiveChatTranscript> chatList) {
        Map<Id,Id> caseIdAndqueueId = new Map<Id,Id>();
        for(LiveChatTranscript lc: chatList){ 
            if(lc.status == 'Missed'){
                caseIdAndqueueId.put(lc.CaseId,INDI_CASE_QUEUE_ID);
            }
            
        }
        
        List<Case> listCase = [Select id,ownerid from case where id in:caseIdAndqueueId.keyset()];
        
        if(listCase.size() > 0){
            for(Case c : listCase){
                if(caseIdAndqueueId.get(c.id)!=null){
                    c.ownerId = caseIdAndqueueId.get(c.id);
                }
                
            }
        }
        
        update listCase;
    }
        
*/
    
}