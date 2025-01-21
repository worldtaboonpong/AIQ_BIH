public without sharing class BIH_CreateQuickCaseContactCenterCtrl {
    // public class Wrapper{
    //     public String status{get;set;}
    //     public String message{get;set;}
    //     public String caseId{get;set;}
    // }
    @AuraEnabled
    public static User getUserProfile(){
        User us = [SELECT id,User_Team__c,Profile.Name,ProfileId FROM User WHERE id=:UserInfo.getUserId()];
        return us;
    }
    @AuraEnabled
    public static Case createQuickCase(String recordId){
        Case caseObj = new Case();
        // Wrapper wrp = new Wrapper();
        // User us = [SELECT id,User_Team__c,Profile.Name,ProfileId FROM User WHERE id=:UserInfo.getUserId()];
        if(recordId.startsWith('003')){
            Contact ct = [SELECT id,Name,Phone FROM Contact WHERE id=:recordId ];

            caseObj.ContactId = ct.Id;
            caseObj.Caller_Name__c = ct.Name;
            caseObj.Contact_Number__c = ct.Phone;
            caseObj.Subject = 'N/A';
            
        }else if(recordId.startsWith('001')){
            Account acc = [SELECT id,Name,Phone,RecordTypeId,IsPersonAccount FROM Account WHERE id=:recordId ];
            if(acc.IsPersonAccount){
                caseObj.Patient__c = acc.Id;
                caseObj.AccountId = acc.Id;
            }else{
                caseObj.AccountId = acc.Id;
            }
            caseObj.Caller_Name__c = acc.Name;
            caseObj.Contact_Number__c = acc.Phone;
            caseObj.Subject = 'N/A';

        }

        caseObj.Status = 'New';
        caseObj.Priority = 'High';
        caseObj.Origin = 'Phone';
        caseObj.Contact_Center_Channel__c = 'Inbound';
        caseObj.Channel__c = 'Contact Center';
        caseObj.Is_Quick_Case_Create__c =true;
        caseObj.RecordTypeId = BIH_Constants.CONTACT_CENTER_CASE_RECORDTYPE;
        insert caseObj;
        return caseObj;
    }
}