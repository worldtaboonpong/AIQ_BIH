public class DataSelector {
    
    public BIH_Constants__mdt getBtnConfig(){
        return [Select Id, MasterLabel , DeveloperName , Value_1__c From BIH_Constants__mdt WHERE DeveloperName = 'VERIFY_BTN_CONFIG'];
    }

    public BIH_Constants__mdt getPDVSEndpoint(){
        return [Select Id, MasterLabel , DeveloperName , Value_1__c From BIH_Constants__mdt WHERE DeveloperName = 'PDVS_ENDPOINT'];
    }

    public Case selectCaseByCaseId(String caseId){
        List<Case> lc =
        [SELECT Id,Patient__c,Hospital_Number_HN__c,SuppliedEmail,Full_Name__c FROM Case where Id =: caseId];
        
        return lc.size()==1?lc.get(0):null;
    }

    public AuthSession selectAuthSessionByUsername(String userName){
        return [Select Id, Users.Name,Users.Username, SessionType, LoginType From AuthSession AuthSession where (LoginType = 'Application' or LoginType = 'SAML Sfdc Initiated SSO') and SessionType = 'UI' and Users.Username =: userName limit 1];
    }
    
    public List<AuthSession> selectOnlineUserSessions(){
        return [Select Id, Users.Name,Users.Username, SessionType, LoginType From AuthSession AuthSession where (LoginType = 'Application' or LoginType = 'SAML Sfdc Initiated SSO') and SessionType = 'UI'];
    }
    
    public List<Platform_Event_Channel_Mapping__c> selectPEMappingThatActive(Set<Id> sessionIds){
        return [SELECT Id, Session__c, Channel__c,User_Name__c FROM Platform_Event_Channel_Mapping__c WHERE Session__c IN: sessionIds];
    }
    
    public List<Platform_Event_Channel_Mapping__c> selectPEMappingThatExpires(Set<Id> sessionIds){
        return [SELECT Id, Session__c, Channel__c,User_Name__c FROM Platform_Event_Channel_Mapping__c WHERE Session__c NOT IN: sessionIds];
    }

    public Account selectAccountById(Id id){
        List<Account> la = [select Id,Name from Account WHERE Id =: id];

        return la.size()==1?la.get(0):null;
    }
}