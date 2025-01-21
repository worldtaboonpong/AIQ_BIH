public with sharing class DoctorAvailabilityController {

    @AuraEnabled(cacheable=true)
    public static List<Appointment__c> getAvailableSessions(List<Id> doctorIds, DateTime startDateTime, DateTime endDateTime) {
        return [
            SELECT Id, Session_Date__c, Start_Time__c, sessionEnd_Time__c, Doctors__c, Available_Slots__c
            FROM Appointment__c
            WHERE Doctors__c IN :doctorIds
            AND Session_Date__c >= :startDateTime
            AND Session_Date__c <= :endDateTime
            AND Available_Slots__c > 0
        ];
    }
}