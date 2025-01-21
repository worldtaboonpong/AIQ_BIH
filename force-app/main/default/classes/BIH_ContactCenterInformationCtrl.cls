public class BIH_ContactCenterInformationCtrl {
    @AuraEnabled
    public static Case getContactCenterInfo(String contactcaseId) {
    
    //Check to make sure all fields are accessible to this user
    // Case ContactInfo = [SELECT Id,Caller_Name__c,Contact_Number__c,Building__c,
    // Department__c,Service_Detail__c,Contact_Center_Channel__c,Escalate_to__c,Escalate_Date__c,
    // Case_Solution__c,Doctor__c,Patient_s_Room_Department__c,Type_of_SMS__c,Symptoms_Diseases__c,
    // Contact_Center_Source__c,Contact_Center_Attendee__c,Specialty_Doctor__c,IV_Team_Name__c,
    // Send_SMS__c,Medical_Procedure__c,Contact_Center_Other_Source__c,
    // Contact_Center_Follower__c,Not_App_Reason__c ,App_Time_Status__c ,
    // App_Time__c,App_Date__c,App_Date_Liaison__c,Postpone_Date__c ,Interpreter_Language__c
    // FROM Case WHERE Id = :contactcaseId ];


    DescribeSObjectResult describeResult = Case.getSObjectType().getDescribe();
    List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = 'SELECT ' +
                        String.join( fieldNames, ',' ) +
                        ' FROM ' +
                        describeResult.getName()  +
                        ' Where id = :contactcaseId ';
        Case ContactInfo = (case)Database.query( query );

    if (ContactInfo.App_Time__c != null){
        String times = DateTime.newInstance(Date.today(), ContactInfo.App_Time__c).format('HH:mm');
        ContactInfo.App_Time_Format__c = times;
    }

    return ContactInfo;
    }

}