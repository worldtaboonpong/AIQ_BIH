public class AppointmentController {
    @AuraEnabled(cacheable=true)
    public static List<Appointment__c> getAvailableAppointments(String doctorId, String startTime, String endTime) {
        // Convert the startTime and endTime from String to Datetime
        Datetime startDateTime = Datetime.valueOf(startTime);
        Datetime endDateTime = Datetime.valueOf(endTime);

        // Query appointments within the given time range for the specified doctor
        List<Appointment__c> appointments = [
            SELECT Id, Doctor__c, Account_name__c, appointment_time__c
            FROM Appointment__c
            WHERE Doctor__c = :doctorId
            AND appointment_time__c >= :startTime
            AND appointment_time__c <= :endTime
            AND Available_Slot__c = true  // Assuming Available_Slot__c indicates if the slot is available
            ORDER BY appointment_time__c ASC
        ];

        return appointments;
    }

    @AuraEnabled
    public static String generateAppointmentPdf(List<Id> appointmentIds) {
        // Retrieve the appointments based on the provided IDs
        List<Appointment__c> appointments = [
            SELECT Id, Doctor__c, Account_name__c, appointment_time__c
            FROM Appointment__c
            WHERE Id IN :appointmentIds
        ];

        // Generate the PDF content as a string
        String pdfContent = '';
        for (Appointment__c appointment : appointments) {
            pdfContent += 'Doctor: ' + appointment.Doctor__c + '\n';
            pdfContent += 'Patient: ' + appointment.Account_name__c + '\n';
            pdfContent += 'Appointment Time: ' + appointment.appointment_time__c + '\n\n';
        }

        return pdfContent;
    }
}