public with sharing class MultipleSessionController {
    @AuraEnabled(cacheable=true)
    public static List<Appointment__c> getAppointmentsForAccount(Id accountId) {
        return [SELECT Id, Appointment_Id__c, Appointment_Time__c, Appointment_Status__c 
                FROM Appointment__c 
                WHERE Account__c = :accountId];
    }
}