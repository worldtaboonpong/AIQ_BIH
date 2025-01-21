public without sharing class ProxyRedirectFollowUpStepCtrl {
    public class Wrapper{
        @AuraEnabled
        public Follow_Up_Step__c followUpObj {get;set;}
        @AuraEnabled
        public String defaultLevel{get;set;}
    }
    @AuraEnabled
    public static Wrapper getTopLevelFollowUp(String caseId) {
        Wrapper wrap = new Wrapper();
        String[] step = Label.Follow_Up_Step_Default_Step.split(',');
        try {
            Follow_Up_Step__c topLevelFollowUp = [SELECT Id, Step__c, Remark__c, Contact_Date__c,
            Case__c, Phone_SMS_Email__c, Step_Status__c FROM Follow_Up_Step__c WHERE Case__c = :caseId
            ORDER BY Step__c DESC LIMIT 1];
        
            wrap.followUpObj = topLevelFollowUp;
            if (topLevelFollowUp.Step__c == step[0]){
                wrap.defaultLevel = step[1];
            }else if (topLevelFollowUp.Step__c == step[1]){
                wrap.defaultLevel = step[2];
            }else if (topLevelFollowUp.Step__c == step[2]){
                wrap.defaultLevel = step[3];
            }else if (topLevelFollowUp.Step__c == step[3]){
                wrap.defaultLevel = step[4];
            }else if (topLevelFollowUp.Step__c == step[4]){
                wrap.defaultLevel = step[4];
            }else {
                wrap.defaultLevel = step[0];
            }
            return wrap;

        } catch (Exception e) {
            Wrapper wraps = new Wrapper();
            wraps.defaultLevel = step[0];
            return wraps;
        }
        
        
    }
}