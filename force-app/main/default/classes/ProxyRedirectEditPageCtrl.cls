public without sharing class ProxyRedirectEditPageCtrl {
    public class Wrapper{
        @AuraEnabled
        public User userObj {get; set;}
        // @AuraEnabled
        // public Case caseObj {get; set;}
        @AuraEnabled
        public String recordTypeName {get; set;}
        @AuraEnabled
        public String recordTypeId {get; set;}

    }
    @AuraEnabled
    public static Wrapper getUserCurrent(String caseId,String recordTypeId) {

        Wrapper wrp =  new Wrapper();

        Map<String,String> getRecordTypeNameBy_IdMap = new Map<String,String>();
        Map<String,String> getRecordTypeIdBy_NameMap = new Map<String,String>();
        
        for(RecordType rec : [SELECT Id,  Name, DeveloperName, Description FROM RecordType WHERE SobjectType = 'Case']) {
            getRecordTypeNameBy_IdMap.put(rec.Id, rec.Name);
            getRecordTypeIdBy_NameMap.put(rec.Name, rec.Id);
            
        }
        wrp.userObj = [SELECT Id, LastName, FirstName, Department, IsActive, ProfileId,Profile.Name,User_Team__c, AccountId FROM User WHERE id =: UserInfo.getUserId()];

        Case cobj = new Case();
        if(caseId != null){
            cobj = [SELECT id,RecordTypeId,RecordType.Name FROM Case WHERE id=:caseId ];
            wrp.recordTypeId = cobj.RecordTypeId;
            wrp.recordTypeName = getRecordTypeNameBy_IdMap.get(cobj.RecordTypeId);
        }else{
            if(recordTypeId != null){
            wrp.recordTypeName = getRecordTypeNameBy_IdMap.get(recordTypeId);
            wrp.recordTypeId = recordTypeId;
            }else{
                
                if(wrp.userObj.User_Team__c != 'Referral Team' && wrp.userObj.User_Team__c != 'Individual Team'){
                    String tmpCheckUserTeam = wrp.userObj.User_Team__c.remove(' Team');
                    for(String name: getRecordTypeNameBy_IdMap.values()){
                        if(name.contains(tmpCheckUserTeam) && !name.contains('Closed')){
                            wrp.recordTypeName = name;
                            wrp.recordTypeId = getRecordTypeIdBy_NameMap.get(name);
                            break;
                        }
                    }
                }else{
                    wrp.recordTypeName = 'Primary Case';
                }
                
            }
        }

        return wrp;
    }
}