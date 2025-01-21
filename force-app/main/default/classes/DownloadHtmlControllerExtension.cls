public class DownloadHtmlControllerExtension {
    public String emailMessageId { get; set; }
    public String htmlBody { get; private set; }

    public DownloadHtmlControllerExtension() {
        // Initialize the emailMessageId here
        emailMessageId = ApexPages.currentPage().getParameters().get('id');

        // Retrieve EmailMessage HTMLBody
        EmailMessage emailMessage = [SELECT Id, HtmlBody FROM EmailMessage WHERE Id = :emailMessageId LIMIT 1];
        htmlBody = emailMessage.HtmlBody;
    }

    public Blob getPdfContent() {
        // Create a Visualforce page to render as PDF
        PageReference pdfPage = Page.EmailMessageToPdf;
        pdfPage.getParameters().put('id', emailMessageId);
        Blob pdfBlob = pdfPage.getContentAsPDF();

        return pdfBlob;
    }
}