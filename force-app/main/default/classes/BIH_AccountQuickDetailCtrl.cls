public class BIH_AccountQuickDetailCtrl {

    @AuraEnabled
    public static Lead LeadRecordObj { get; set; }
    @AuraEnabled
    public static Account AccountRecordObj { get; set; }

    @AuraEnabled
    public static List<Case> getCaseByAccountId(Id accountId){
        try {
            Account acc = [SELECT id,RecordType.DeveloperName FROM Account WHERE id=:accountId LIMIT 1];
            if(acc.RecordType.DeveloperName  != 'Person_Account'){
                 //**Business Account
                return [SELECT Id, AccountId, Status,CreatedDate FROM Case WHERE AccountId =: accountId ORDER BY createddate];
            }else{
                //Person Account
                return [SELECT Id, AccountId, Status,CreatedDate FROM Case WHERE Patient__c =: accountId ORDER BY createddate];
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;    
        }        
    }
    //  @AuraEnabled
    // public static List<Case> getCaseBySenderId(Id accountId){
    //     try {
    //         return [SELECT Id, AccountId, Status,CreatedDate FROM Case WHERE Sender_Name__c =: accountId AND Status = 'New' ORDER BY createddate];
    //     } catch (Exception e) {
    //         System.debug(e.getMessage());
    //         return null;    
    //     }        
    // }

    @AuraEnabled
    public static User getUserCurrent()
    {
        return [SELECT ID,Name,Profile.Name,User_Team__c,Language_Skill__c,toLabel(LanguageLocaleKey) FROM User WHERE ID=:UserInfo.getUserId() LIMIT 1];
    }

    @AuraEnabled
    public static boolean showContactCenterNote()
    {
        Schema.DescribeFieldResult drField = Account.Contact_Center_Note__c.getDescribe();
        Boolean isMyAccessible = drField.isAccessible();
        return isMyAccessible;
    }

    @AuraEnabled
    public static Account getAccount(Id accountId){
        try {
            return [SELECT Id, Name, LastName, Age__c, Note__c,Contact_Center_Note__c,
                    RO_Remark__c,TrakCare_Note__c,Corporate_Type__c, 
                    PersonBirthdate,RecordTypeId ,RO_Expiry_Date__c,Country__c,
                    RecordType.DeveloperName,Contact_Center_Flag__c 
                    FROM Account 
                    WHERE Id =: accountId LIMIT 1];
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;    
        }        
    }

}