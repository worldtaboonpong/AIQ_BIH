public class BIH_FollowUpStepCtrl {
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
    }@AuraEnabled        
    public static Map<String, List<BIH_PicklistOption>> getPickListValuesMap(){
        Map<String, List<BIH_PicklistOption>> picklistMap = getDependencyFieldValues('Step__c', 'Step_Status__c');
        System.debug('picklistMap'+picklistMap);
        return picklistMap;
    }
    @AuraEnabled        
    public static List<String> getPickListValuesIntoList(String objectType, String selectedField){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        System.debug(fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        System.debug(ple);
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }

    public static Map<String, List<BIH_PicklistOption>> getDependencyFieldValues(String FieldAPIName1st, String FieldAPIName2nd)
    {
        Schema.sObjectType sobjectType = Follow_Up_Step__c.getSObjectType();
        Schema.DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = sobjectDescribe.fields.getMap();

        Schema.SObjectField ctrlField = fieldMap.get(FieldAPIName1st);
        Schema.SObjectField targetField = fieldMap.get(FieldAPIName2nd);

        Map<String, List<BIH_PicklistOption>> dependencyField = BIH_FieldDescribeUtil.getDependentOptionsImpl(targetField, ctrlField);
        return dependencyField;
    }
    @AuraEnabled        
    public static DateTime getDatetime(){
        DateTime dt = DateTime.now();
        return dt;
    }
   @AuraEnabled 
    public static user getCurrentUser(){
       User u = [select id,Name from User where id =: userInfo.getUserId()];
        return u;
    }
    @AuraEnabled
    public static Follow_Up_Step__c SaveFollowUp (String Step,String Step_Status,String Phone_SMS_Email,DateTime Contact_Date,
                                                Id CaseId,Id OwnerId,String Remark){
        try {
            Follow_Up_Step__c followUpObj = new Follow_Up_Step__c();
            followUpObj.Step__c = Step;
            followUpObj.Step_Status__c = Step_Status;
            followUpObj.Phone_SMS_Email__c = Phone_SMS_Email;
            followUpObj.Contact_Date__c = Contact_Date;
            followUpObj.Case__c = CaseId;
            followUpObj.OwnerId = OwnerId;
            followUpObj.Remark__c = Remark;
            insert followUpObj;
            return followUpObj;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
}