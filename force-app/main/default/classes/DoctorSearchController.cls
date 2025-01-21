public with sharing class DoctorSearchController {
    
    @AuraEnabled(cacheable=true)
    public static List<Doctor__c> searchDoctors(DateTime startDateTime, DateTime endDateTime, String specialty) {
        return [SELECT Id, Name FROM Doctor__c 
                WHERE Specialty__c = :specialty 
                AND Availability_Status__c = 'Available' 
                AND Id IN (
                    SELECT Doctor__c FROM Session__c 
                    WHERE Session_Date__c >= :startDateTime 
                    AND Session_Date__c <= :endDateTime 
                    AND Available_Slots__c > 0
                )];
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getSpecialtyOptions() {
        // Query all Doctor records without DISTINCT
        List<Doctor__c> doctors = [SELECT Specialty__c FROM Doctor__c];
        
        // Use a Set to ensure uniqueness
        Set<String> specialties = new Set<String>();
        
        // Add each Specialty__c value to the Set
        for (Doctor__c doc : doctors) {
            if (doc.Specialty__c != null) {
                specialties.add(doc.Specialty__c);
            }
        }
        
        // Convert the Set to a List and return
        return new List<String>(specialties);
    }
}