public class RcRefGenerator {
    @AuraEnabled
    public static String generateRcRef(String caseId) {
        // Get the current year
        String currentYearPrefix = String.valueOf(Date.today().year()).right(2);

        // Query to get the latest Rc_ref__c value from the Case object
        Case lastCase = [SELECT RCREF__c  FROM Case WHERE RCREF__c  != null ORDER BY CreatedDate DESC LIMIT 1];

        String lastRcRef = lastCase.RCREF__c;
        Integer lastNumber = 0;

        // Check if the prefix matches the current year
        if (lastRcRef != null && lastRcRef.startsWith(currentYearPrefix)) {
            // Extract the number part and increment it
            lastNumber = Integer.valueOf(lastRcRef.substring(3));
        }

        // Generate the new Rc_ref__c value
        String newRcRef = currentYearPrefix + '-' + String.valueOf(lastNumber + 1);

        // Update the Rc_ref__c field of the current Case
        Case currentCase = [SELECT Id FROM Case WHERE Id = :caseId];
        currentCase.RCREF__c = newRcRef;
        update currentCase;

        return newRcRef;
    }
}