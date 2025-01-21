public with sharing class AppointmentBookingListcontroller {
    
    @AuraEnabled(cacheable=true)
    public static List<Appointment__c> getUpcomingAppointments() {
        System.debug('getUpcomingAppointments method is called');
        
        // Format the current date-time in the same format as your text field
        String currentDate = Datetime.now().format('yyyy-MM-dd HH:mm'); // Adjust this format to match your text field

        List<Appointment__c> upcomingAppointments = [
            SELECT Id, appointment_id__c, appointment_status__c, Account_name__c, appointment_time__c, End_time__c
            FROM Appointment__c 
            WHERE appointment_status__c IN ('TC', 'SF')
            AND appointment_time__c > :currentDate
            ORDER BY appointment_time__c ASC
        ];

        System.debug('Number of Appointments: ' + upcomingAppointments.size());
        return upcomingAppointments;
    }
    
    @AuraEnabled
    public static String generateAppointmentPdf(List<Id> appointmentIds) {
        System.debug('generateAppointmentPdf method is called');
        
        // Get the appointments based on the selected appointment IDs
        List<Appointment__c> selectedAppointments = [
            SELECT appointment_id__c, appointment_status__c, Account_name__c, appointment_time__c, End_time__c
            FROM Appointment__c
            WHERE Id IN :appointmentIds
        ];
        
        // Logic to generate PDF content (simplified)
        String pdfContent = 'Appointment Details:\n';
        for (Appointment__c appointment : selectedAppointments) {
            pdfContent += 'ID: ' + appointment.appointment_id__c + ', Account: ' + appointment.Account_name__c 
                        + ', Time: ' + appointment.appointment_time__c + ', Status: ' + appointment.appointment_status__c + '\n';
        }

        // Return the PDF content as a base64 encoded string (placeholder for actual PDF generation)
        // You'd replace this with actual logic to generate a PDF
        String base64EncodedPdf = EncodingUtil.base64Encode(Blob.valueOf(pdfContent));
        
        System.debug('PDF Content: ' + pdfContent);
        return base64EncodedPdf;
    }
}