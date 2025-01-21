public class PreRegistrationSync {
	@InvocableMethod
    public static void sync (List<id> ids) {
      Case syncCase = [Select Id,PreRegistration__c,Title_Patient__c,First_Name_Patient__c,Middle_Name_Patient__c,Last_Name_Patient__c,Date_Of_Birth_Patient__c,Gender_Patient__c,Nationality_New_Patient__c,Country_of_Ressidence_Patient__c,Preferred_Language_Patient__c,Thai_ID_Card_Number_Patient__c,Passport_Number_Patient__c,Primary_Phone_New_Patient__c,Email_New_Patient__c,Address_foreign__c,Town_City_foreign__c,State_Province_foreign__c,Postcode_foreign__c,Address_Thailand__c,State_Province_Thailand__c,Mobile_Number_In_Thailand__c, Town_City_Existing_Patient__c,District_Thailand__c, State_Province_Existing_Patient__c,Postcode_Thailand__c,Health_Insurance_Co__c,MemberID__c,PolicyNumber__c from Case where Id=:ids.get(0)];  
    }
}