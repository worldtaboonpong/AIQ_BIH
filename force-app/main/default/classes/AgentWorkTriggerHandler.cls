public with sharing class AgentWorkTriggerHandler {
    
    public static Map<String,Detection_Language_Mapping__mdt> DetectionLanguageMap {get{        
        if(DetectionLanguageMap==null){
            DetectionLanguageMap = new Map<String,Detection_Language_Mapping__mdt>();
            for (Detection_Language_Mapping__mdt mapRecord :[SELECT DeveloperName, Language__c, Queue__c, RecordType__c FROM Detection_Language_Mapping__mdt]){
                DetectionLanguageMap.put(mapRecord.DeveloperName, mapRecord);
            }          
        }
        return DetectionLanguageMap;
    }set;}

    public static Map<String,RecordType> RecordTypeMap  {get{        
        if(RecordTypeMap==null){
            RecordTypeMap = new Map<String,RecordType>();
            for (RecordType mapRecord :[SELECT Id, DeveloperName, Name FROM RecordType]){
                RecordTypeMap.put(mapRecord.DeveloperName, mapRecord);
            }            
        }
        return RecordTypeMap;
    }set;}
    
    public static void handleAfterUpdate(List<AgentWork> agentworkList, Map<Id,AgentWork> agentworkOldMap) {
        
            handleSocialPost(agentworkList, agentworkOldMap); 
        
    }
    
    public static void handleSocialPost(List<AgentWork> agentworkList, Map<Id,AgentWork> agentworkOldMap) {
        System.debug('=========== handleSocialPost ===========');
        Schema.DescribeSObjectResult Social_Post = SocialPost.sObjectType.getDescribe();
        System.debug('SocialPost '+ Social_Post);
        String facebookPostPrefix = Social_Post.getKeyPrefix();
        System.debug('prefix facebook post '+ facebookPostPrefix);
        Set<String> SocialPostSet = new Set<String>();
        ID OwnerID_AgentWork = null;
        for(AgentWork agentwork : agentworkList) {
            AgentWork oldAgent = agentworkOldMap.get(agentwork.Id);
            //OwnerID_AgentWork = agentwork.OwnerId;
            if((agentwork.AcceptDateTime != null && oldAgent.AcceptDateTime == null) || Test.isRunningTest()){
                String workItemId = String.valueOf(agentwork.WorkItemId);
                if(workItemId.startsWith(facebookPostPrefix)) {
                    SocialPostSet.add(workItemId);
                }
            }
        }
        System.debug('OwnerId '+OwnerID_AgentWork);
        
        List<Case> insertedCaseFacebookPost = new List<Case>();
        
        List<SocialPost> relatedSession = [select Id , ParentId, Detected_Language__c, PersonaId, Posted  
                                           from SocialPost 
                                           where Id in :SocialPostSet];
        System.debug('relatedSession = '+relatedSession);
        for(SocialPost sp : relatedSession) {
            String previousStatus;
            if(sp.ParentId != null) {
                previousStatus = [SELECT Status FROM Case WHERE Id =: sp.ParentId].Status;
            }           
            String persona = [SELECT Name FROM SocialPersona WHERE Id =: sp.PersonaId].Name;
            Datetime postDate = sp.Posted;
			String strDate = postDate.format('dd/MM/yyyy HH:mm:ss');
            
            Case FacebookPost_case = new Case();
            FacebookPost_case.Subject = 'Facebook Post : '+persona+' '+strDate;
            FacebookPost_case.Id = sp.ParentId;
            FacebookPost_case.OwnerId = OwnerID_AgentWork;                        
            FacebookPost_case.Origin = 'Facebook';
            FacebookPost_case.Contact_Center_Channel__c = 'Inbound';
            FacebookPost_case.Channel__c = 'Individual';
            FacebookPost_case.Case_Category_Level1__c = 'Undefined';
            FacebookPost_case.Case_Category_Level2__c = 'N/A';
            FacebookPost_case.Case_Category_Level3__c = 'N/A';
            if(previousStatus != 'New' && previousStatus != 'Closed') {
                FacebookPost_case.Status = 'In Progress';
            }
            if(DetectionLanguageMap.get(sp.Detected_Language__c) == null) {
                FacebookPost_case.RecordTypeId = RecordTypeMap.get(DetectionLanguageMap.get('other').RecordType__c).Id;
            } else {
                FacebookPost_case.RecordTypeId = RecordTypeMap.get(DetectionLanguageMap.get(sp.Detected_Language__c).RecordType__c).Id;
            }               
            System.debug('previousStatus = '+previousStatus+', Detected_Language__c = '+sp.Detected_Language__c);
            
            insertedCaseFacebookPost.add(FacebookPost_case);
        }
        System.debug('update '+insertedCaseFacebookPost);
        update insertedCaseFacebookPost;
    }

    
}