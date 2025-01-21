public with sharing class AvailableAppointmentController {
    @AuraEnabled(cacheable=true)
    public static List<Appointment__c> getAvailableAppointments() {
        // Convert current time to string format, matching Appointment_Time__c format
        String currentTime = DateTime.now().format('yyyy-MM-dd HH:mm:ss');
        
        return [SELECT Id, Appointment_Id__c, Appointment_Time__c, Appointment_Status__c 
                FROM Appointment__c 
                WHERE Appointment_Status__c = 'Available' 
                AND Appointment_Time__c >= :currentTime];
    }
}