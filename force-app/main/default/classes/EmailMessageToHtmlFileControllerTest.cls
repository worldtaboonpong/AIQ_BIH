@isTest
private class EmailMessageToHtmlFileControllerTest {
    @isTest
    static void testSaveAsHtmlFile() {
        // Create a test EmailMessage record
        EmailMessage testEmailMessage = new EmailMessage(
            Subject = 'Test Subject',
            TextBody = 'Test Text Body',
            HtmlBody = '<p>Test HTML Body</p>',
            Status = '1'
        );
        insert testEmailMessage;

        // Create a new instance of the controller and pass the test EmailMessage record's Id
        ApexPages.StandardController stdController = new ApexPages.StandardController(testEmailMessage);
        EmailMessageToHtmlFileController controller = new EmailMessageToHtmlFileController(stdController);

        // Call the saveAsHtmlFile method
        Test.startTest();
        PageReference resultPage = controller.saveAsHtmlFile();
        Test.stopTest();

        // Assert that the resultPage is not null, indicating successful file creation
        System.assertNotEquals(null, resultPage);

        // Retrieve the created Attachment record
        Attachment createdAttachment = [SELECT Id, ParentId, Body, Name, ContentType FROM Attachment WHERE ParentId = :testEmailMessage.Id LIMIT 1];

        // Assert that the Attachment record is created successfully
        System.assertNotEquals(null, createdAttachment);

        // Assert that the Attachment details are as expected
        System.assertEquals(testEmailMessage.Id, createdAttachment.ParentId);
        System.assertEquals(Blob.valueOf('<p>Test HTML Body</p>'), createdAttachment.Body);
        System.assertEquals('EmailMessageContent.html', createdAttachment.Name);
        System.assertEquals('text/html', createdAttachment.ContentType);
    }

    @isTest
    static void testSaveAsHtmlFileWithInvalidId() {
        // Create a new instance of the controller with an invalid EmailMessage Id
        ApexPages.StandardController stdController = new ApexPages.StandardController(new EmailMessage());
        EmailMessageToHtmlFileController controller = new EmailMessageToHtmlFileController(stdController);

        // Call the saveAsHtmlFile method
        Test.startTest();
        PageReference resultPage = controller.saveAsHtmlFile();
        Test.stopTest();

        // Assert that the resultPage is null, indicating failure
        System.assertEquals(null, resultPage);

        // Assert that an error message is added to the ApexPages messages
        List<ApexPages.Message> messages = ApexPages.getMessages();
        System.assertEquals(1, messages.size());
        System.assertEquals(ApexPages.Severity.ERROR, messages[0].getSeverity());
    }
}