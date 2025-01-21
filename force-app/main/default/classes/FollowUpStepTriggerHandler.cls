public class FollowUpStepTriggerHandler {

    // public static Map<String,Account> mapCasewithFollowUpStep {get{
    //     if(mapEmailwthAccount==null){
    //         mapEmailwthAccount = new Map<String,Account>();
    //     }
    //     return mapEmailwthAccount;
    // }set;}

    public static void handleAfterUpdate(List<Follow_Up_Step__c> newList){
        List<Case> caseList = new List<Case>();
        Map<Id, Case> newMap = new Map<Id, Case>();
        Set<Id> caseIdSet = new Set<Id>();
        for (Follow_Up_Step__c followup : newList){
            caseIdSet.add(followup.Case__c);
        }
        for (Case c : [SELECT Id,Follow_Up_Status__c,Follow_Up_Step__c FROM Case WHERE Id in:caseIdSet]){
            newMap.put(c.Id, c);
        }

        System.debug('FOLLOW UP CASE: '+newList);
        try {
            for (Follow_Up_Step__c a : newList){
            if (a.Step__c != null || a.Step__c != ''){
                Case c = new Case();
                String followUpStep = newMap.get(a.Case__c).Follow_Up_Step__c;
                if (followUpStep == a.Step__c){
                    c.Id = a.Case__c;
                    c.Follow_Up_Status__c = a.Step_Status__c;
                    c.Follow_Up_Step__c = a.Step__c;
                    caseList.add(c);
                }
            }
        }
        Update caseList;
        } catch (Exception e) {
            System.debug('FOLLOWUP AFTER UPDATE : '+e.getMessage());
        }
    }


    public static void handleAfterInsert(List<Follow_Up_Step__c> newList){
        List<Case> caseList = new List<Case>();
        System.debug('FOLLOW UP CASE: '+newList);
        try {
            for (Follow_Up_Step__c a : newList){
                if (a.Step__c != null || a.Step__c != ''){
                    Case c = new Case();
                    c.Id = a.Case__c;
                    c.Follow_Up_Status__c = a.Step_Status__c;
                    c.Follow_Up_Step__c = a.Step__c;
                    caseList.add(c);
                }
        }
        Update caseList;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
    }
}