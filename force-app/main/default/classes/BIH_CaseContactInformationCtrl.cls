public without sharing class BIH_CaseContactInformationCtrl {
    public class Wrapper {
        @AuraEnabled
        public Case caseObj{get;set;}
        @AuraEnabled
        public User userObj{get;set;}
    }
	@AuraEnabled
    public static Wrapper getCaseContactInformation(String caseId) {
        
        String chn = PDVSService.getPlatformEventChannel();

        Case updateCase = new Case();
        updateCase.Id = caseId;
        updateCase.Platform_Event_Channel__c = chn;
        //update updateCase;

        List<CasePlatformEventMapping__c> listCase = [select Id,Platform_Event_Channel__c,Case_Id__c from CasePlatformEventMapping__c WHERE Case_Id__c =: caseId];
        if(listCase.size()==0){
            CasePlatformEventMapping__c cpem = new CasePlatformEventMapping__c();
            cpem.Case_Id__c = caseId;
            cpem.Platform_Event_Channel__c = Integer.valueOf(chn);
            insert cpem;
        }else{
            CasePlatformEventMapping__c cpem = new CasePlatformEventMapping__c();
            cpem.Id = listCase.get(0).Id;
            cpem.Case_Id__c = caseId;
            cpem.Platform_Event_Channel__c = Integer.valueOf(chn);
            update cpem;
        }
        

        Wrapper wrap = new Wrapper();
        Case c  = [SELECT Id, AccountId,Account.Name,Patient__c,Patient__r.Name, Hospital_Number_HN__c,Gender__c 
                ,Sender_HN__c,SuppliedEmail,Sender_Phone__c,Patient_Email__c,Phone__c,Country_of_Residence__c,Nationality__c
                ,Verified_Patient__c,Full_Name__c,Date_of_Birth__c,RecordType.Name,CaseNumber,Sender_Type__c,Platform_Event_Channel__c 
                FROM Case WHERE Id=:caseId];

        User u  = [SELECT ID,Name,Profile.Name,User_Team__c,Language_Skill__c,toLabel(LanguageLocaleKey) FROM User WHERE ID=:UserInfo.getUserId() LIMIT 1];

        c.Platform_Event_Channel__c = chn;
        wrap.caseObj = c;
        wrap.userObj = u;
        System.debug('Patient Case: '+ wrap);
    
        return wrap;
        // return null;
    }
    @AuraEnabled
    public static string getBtnConfig(){
        BIH_Constants__mdt cons = new DataSelector().getBtnConfig();
        return cons.Value_1__c;
    }
    @AuraEnabled
    public static string getPDVSEndpoint(){
        BIH_Constants__mdt cons = new DataSelector().getPDVSEndpoint();
        return cons.Value_1__c;
    }
    @AuraEnabled
    public static string getUserName(){
        return UserInfo.getUserName();
    }
    @AuraEnabled
    public static string getClientId(String caseId){
        String id = new DataSelector().selectCaseByCaseId(caseId)?.Patient__c;
        return id;
    }
    @AuraEnabled
    public static string publishRequest(String caseId){
        List<Request_Event__e> inkEvents = new List<Request_Event__e>();
				inkEvents.add(new Request_Event__e(	Body__c=caseId));



                // Call method to publish events
                List<Database.SaveResult> results = EventBus.publish(inkEvents);
                
                // Inspect publishing result for each event
                for (Database.SaveResult sr : results) {
                    if (sr.isSuccess()) {
                        System.debug('Successfully published event.');
                    } else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Error returned: ' +
                                        err.getStatusCode() +
                                        ' - ' +
                                        err.getMessage());
                        }
                    }       
                }

                return '';
    }
    @AuraEnabled
    public static string getSessionId(){
        String id = [Select Id, Users.Name,Users.Username, SessionType, LoginType From AuthSession AuthSession where (LoginType = 'Application' or LoginType = 'SAML Sfdc Initiated SSO') and SessionType = 'UI' and Users.Username =: UserInfo.getUserName() limit 1]?.Id;
        return id;
    }
    @AuraEnabled
    public static Case saveCase(Case caseObj) {
        Case c  = caseObj;
        try{
            System.debug('caseObj :'+caseObj);
            update c;
            c = [SELECT Id, AccountId,Account.Name,Patient__c,Patient__r.Name, Hospital_Number_HN__c,Gender__c 
                    ,Sender_HN__c,SuppliedEmail,Sender_Phone__c,Patient_Email__c,Phone__c,Country_of_Residence__c,Nationality__c
                    ,Verified_Patient__c,Full_Name__c,Date_of_Birth__c
                    FROM Case WHERE Id=:caseObj.Id];
        }catch(DMLException ex){
            System.debug(ex.getMessage());
            String errorMessage = ex.getMessage();
            Integer occurence;
            if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                errorMessage = errorMessage.mid(occurence, errorMessage.length());
                occurence = errorMessage.lastIndexOf(':');
                errorMessage = errorMessage.mid(0, occurence);
            }
            else {
                errorMessage = ex.getMessage();
            }
            throw new AuraHandledException(errorMessage);
        }
        return c;
    }
    @AuraEnabled
    public static Account getNotefromAccount(Id accId){
        Account acc = [SELECT Id,Name,Note__c FROM Account WHERE Id= :accId ];
        return acc;
    }
}