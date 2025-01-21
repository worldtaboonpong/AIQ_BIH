public class SessionDataCreator {

    // Method to create test data for Session__c
    public static void createSessionData() {
        // List to hold Session__c records
        List<Session__c> sessions = new List<Session__c>();
        
        // Create new Session__c records
        sessions.add(new Session__c(
            Session_Date__c = Date.today().addDays(10),  // Correct field name
            Start_Time__c = Time.newInstance(9, 0, 0, 0),
            End_Time__c = Time.newInstance(10, 0, 0, 0),
            Doctor__c = 'a0B1I0000003hQ5UAE', // Replace with a valid Doctor Id
            Available_Slots__c = 5 // Correct field name
        ));
        
        sessions.add(new Session__c(
            Session_Date__c = Date.today().addDays(20),  // Correct field name
            Start_Time__c = Time.newInstance(14, 0, 0, 0),
            End_Time__c = Time.newInstance(15, 0, 0, 0),
            Doctor__c = 'a0B1I0000003hQ5UAE', // Replace with a valid Doctor Id
            Available_Slots__c = 0 // Correct field name
        ));
        
        // Insert records into the database
        try {
            insert sessions;
        } catch (DmlException e) {
            System.debug('Error inserting Session__c records: ' + e.getMessage());
        }
    }
}