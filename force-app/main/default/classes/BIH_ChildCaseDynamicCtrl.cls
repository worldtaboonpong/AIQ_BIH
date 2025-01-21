public with sharing class BIH_ChildCaseDynamicCtrl {
	// public BIH_ChildCaseDynamicCtrl() {
		
	// }
	@AuraEnabled
    public static void saveCases(List<Case> ListCase){
        system.debug('ListCase'+ListCase);
        try {
            Insert ListCase;
        } catch (Exception e) {
            System.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
        
    } 
    
    @AuraEnabled
    public static Case find_CaseById(Id get_caseid) {
        System.debug('caseId: '+get_caseid);
        DescribeSObjectResult describeResult = Case.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        List<Case> caseObj = new List<Case>();

        String query = 'SELECT ' +
                        String.join( fieldNames, ',' ) +
                        ' ,Parent.CaseNumber,CreatedBy.Name,LastModifiedBy.Name,Account.Name,Patient__r.Name,Account.Hospital_Number_HN__c,Patient__r.Hospital_Number_HN__c'+
                        ' FROM ' +
                         describeResult.getName()  +
                        ' Where id = :get_caseid ';

        caseObj = Database.query( query );
        
		return caseObj[0];
    }

    @AuraEnabled
    public static List<String> getPickListValuesChannel(){
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Case.Channel__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    @AuraEnabled
    public static Map<String,Mapping_Channel_with_User_Team__mdt> mapDataChildcase (){
        
            Map<String,Mapping_Channel_with_User_Team__mdt> mapChildcase = new Map<String,Mapping_Channel_with_User_Team__mdt>();
            for(Mapping_Channel_with_User_Team__mdt mapChild : [Select Id, MasterLabel, Channel__c, Owner_Type__c,Queue_Name__c ,Child_Case__c,Record_Type_Name__c  from Mapping_Channel_with_User_Team__mdt]){
                if (mapChild.Child_case__c == true){
                mapChildcase.put(mapChild.Channel__c,mapChild);
                }
            }
    
        return mapChildcase;
    }

    @AuraEnabled
    public static Map<String,Group> ownerMap (){
        // system.debug('ownerName: '+ownerName);
        Map<String,Group> ownerMaps = new Map<String,Group>();
        for (Group mapOwner : [SELECT Id, Name, DeveloperName, Type FROM Group WHERE Type='Queue']){
            ownerMaps.put(mapOwner.Name,mapOwner);
        }
        // List<Group> owner = [SELECT Id, Name, DeveloperName, Type FROM Group WHERE Type=:ownerName];
        // system.debug('ownerMaps: '+ownerMaps);
        
        return ownerMaps;
    }
    @AuraEnabled
    public static Map<String,RecordType> recordTypeMap (){
        Map<String,RecordType> recordMaps = new Map<String,RecordType>();
        // RecordType record = [SELECT Id, DeveloperName, Name FROM RecordType WHERE DeveloperName= :recordName];
        for (RecordType mapRecord :[SELECT Id, DeveloperName, Name FROM RecordType]){
            recordMaps.put(mapRecord.DeveloperName, mapRecord);
        }
        // system.debug('recordMaps: '+recordMaps);
    
        return recordMaps;
    }
}