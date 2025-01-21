public with sharing class PatientAppointmentController {
    @AuraEnabled(cacheable=true)
    public static List<Appointment__c> getAppointmentsForAccount(Id accountId) {
        // Assuming Account__c is the field linking the appointment to an account/patient
        return [SELECT Id, Appointment_Id__c, Appointment_Time__c, Appointment_Status__c 
                FROM Appointment__c 
                WHERE Account__c = :accountId];
    }
}