@isTest
public class DetectionLanguageServiceTest {
    // @isTest 
    // static void testPositive() {
    //     Test.startTest();  
        
    //     Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

    //     User u = [SELECT Id FROM User WHERE ProfileId =: p1.Id AND IsActive = true LIMIT 1];
        
    //     MessagingChannel msChannel = new MessagingChannel(MessageType = 'Facebook', 
    //                                                       MessagingPlatformKey = '3101029539980000',
    //                                                       DeveloperName = 'TEST_PAGE_001',
    //                                                       MasterLabel = 'Test Page 001');
    //     System.runAs(u){            
    //     	insert msChannel;
    //     }
        
    //     MessagingEndUser msUserObj = new MessagingEndUser(Name = 'Test Test',
    //                             MessagingChannelId = msChannel.Id,
    //                             MessageType = 'Facebook',
    //                             MessagingPlatformKey = msChannel.MessagingPlatformKey);
    //     insert msUserObj;
        
    //     List<MessagingSession> msObj = new List<MessagingSession>{
    //         new MessagingSession(MessagingChannelId = msChannel.Id,
    //                     MessagingEndUserId = msUserObj.Id,
    //                     Status = 'Waiting')};
    //     insert msObj;
        
    //     List<SocialPost> spObj = new List<SocialPost>{
    //         new SocialPost(Name='Post', Content='Good Morning')};
    //     insert spObj;
        
    //     String textOther = 'Good Morning';
        
    //     // Set mock callout class 
    //     Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    //     if (msObj.size() > 0){
    //         DetectionLanguageService.makeCallout(msObj[0].Id, textOther, 'MessagingSession');            
    //     }
    //     if (spObj.size() > 0){
    //         DetectionLanguageService.callFromSocialPostProcess(spObj);
    //         DetectionLanguageService.makeCallout(spObj[0].Id, textOther, 'SocialPost');            
    //     }
                   
    //     Test.stopTest();
    // }
}