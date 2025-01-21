public class EmailMessageToHtmlFileController {
    public String emailMessageId { get; set; }
    public String htmlBody { get; private set; }

    public EmailMessageToHtmlFileController(ApexPages.StandardController stdController) {
        // Initialize the emailMessageId here
        emailMessageId = stdController.getId();

        // Retrieve EmailMessage HTMLBody
        if (String.isNotBlank(emailMessageId)) {
            EmailMessage emailMessage = [SELECT Id, HtmlBody FROM EmailMessage WHERE Id = :emailMessageId LIMIT 1];
            htmlBody = emailMessage != null ? emailMessage.HtmlBody : null;
        }
    }

    public PageReference saveAsHtmlFile() {
        String fileName = 'EmailMessageContent.html';

        // Create a new Attachment record
        Attachment attachment = new Attachment();
        attachment.ParentId = emailMessageId; // Attach to the EmailMessage record
        attachment.Body = Blob.valueOf(htmlBody);
        attachment.Name = fileName;
        attachment.ContentType = 'text/html';

        try {
            // Insert the Attachment record
            insert attachment;

            // Optionally, you can also provide a link for the user to download the file
            PageReference redirectPage = new PageReference('/' + attachment.Id);
            redirectPage.setRedirect(true);
            return redirectPage;
        } catch (DmlException e) {
            // Handle any potential exceptions during the insert operation
            ApexPages.addMessages(e);
            return null;
        }
    }
}