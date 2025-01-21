public with sharing class EmailPrintControllerExtension {
    private final EmailMessage emailMessage;

    public EmailPrintControllerExtension(ApexPages.StandardController stdController) {
        // Include the HtmlBody field in the SOQL query
        this.emailMessage = [SELECT Id, HtmlBody,TextBody FROM EmailMessage WHERE Id = :stdController.getId()];
    }

    public String getEmailContent() {
        return emailMessage.HtmlBody;
    }
}