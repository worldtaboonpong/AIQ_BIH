public with sharing class AppointmentCardController {
    @AuraEnabled(cacheable=true)
    public static List<Appointment__c> getAppointmentsForAccount(Id accountId) {
        // Modify as needed, assuming Account__c links the appointment to an account
        return [SELECT Id, Appointment_Id__c, Appointment_Time__c, Appointment_Status__c 
                FROM Appointment__c 
                WHERE Account__c = :accountId];
    }
}