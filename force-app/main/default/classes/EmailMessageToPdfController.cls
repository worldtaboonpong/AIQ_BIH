public class EmailMessageToPdfController {
    public String emailMessageId { get; set; }
    public String htmlBody { get; private set; }

    public EmailMessageToPdfController() {
        // Initialize the emailMessageId here
        emailMessageId = ApexPages.currentPage().getParameters().get('id');

        // Retrieve EmailMessage HTMLBody
        EmailMessage emailMessage = [SELECT Id, HtmlBody FROM EmailMessage WHERE Id = :emailMessageId LIMIT 1];
        htmlBody = emailMessage.HtmlBody;
    }

    public PageReference saveAsHtmlFile() {
        String fileName = 'EmailMessageContent.html';

        // Create a new Attachment record
        Attachment attachment = new Attachment();
        attachment.ParentId = emailMessageId; // Attach to the EmailMessage record
        attachment.Body = Blob.valueOf(htmlBody);
        attachment.Name = fileName;
        attachment.ContentType = 'text/html';

        // Insert the Attachment record
        insert attachment;

        // Optionally, you can also provide a link for the user to download the file
        PageReference redirectPage = new PageReference('/' + attachment.Id);
        redirectPage.setRedirect(true);
        return redirectPage;
    }
}