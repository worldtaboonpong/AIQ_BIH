@isTest
public class MessagingSessionTriggerHandlerTest {
    // @isTest
    // static void testHandler() {
    //     Test.startTest();              
    //     String recType = MessagingSessionTriggerHandler.DetectionLanguageMap.get('Facebook_th').RecordType__c;
    //     String recId = MessagingSessionTriggerHandler.RecordTypeMap.get(recType).Id;
    //     List<Case> caseObj = new List<Case>{
    //         new Case(Status = 'New',
    //                  Priority = 'High',
    //                  Contact_Center_Channel__c = 'Inbound',
    //                  Channel__c = 'Contact Center',
    //                  RecordTypeId = recId,
    //                  Case_Category_Level1__c = 'N/A',
    //                  Case_Category_Level2__c = 'N/A',
    //                  Case_Category_Level3__c = 'N/A',
    //                  Origin = 'Facebook Messenger',
    //                  Subject = '[Test] Test')};
    //     insert caseObj;
        
    //     Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

    //     User u = [SELECT Id FROM User WHERE ProfileId =: p1.Id AND IsActive = true LIMIT 1];
        
    //     // MessagingChannel msChannel = new MessagingChannel(MessageType = 'Facebook', 
    //     //                                                   MessagingPlatformKey = '3101029539980000',
    //     //                                                   DeveloperName = 'TEST_PAGE_001',
    //     //                                                   MasterLabel = 'Test Page 001');
    //     System.runAs(u){            
    //         //insert msChannel;
    //     }
       
    //     // List<MessagingEndUser> msUserObj = new List<MessagingEndUser>{
    //     //     new MessagingEndUser(Name = 'Test Test',
    //     //                         MessagingChannelId = msChannel.Id,
    //     //                         MessageType = 'Facebook',
    //     //                         MessagingPlatformKey = msChannel.MessagingPlatformKey)};
    //     //insert msUserObj;
        
    //     // List<MessagingSession> msObj = new List<MessagingSession>();
    //     // msObj.add(new MessagingSession(MessagingChannelId = msChannel.Id,
    //     //                          MessagingEndUserId = msUserObj[0].Id,
    //     //                          Status = 'Waiting',
    //     //                          CaseId = caseObj[0].Id,
    //     //                          StartTime = System.today()));                                  
    //     // insert msObj;
        
    //     // MessagingSessionTriggerHandler.searchMessagingCase(msUserObj[0].Id);
    //     // MessagingSessionTriggerHandler.updateCaseStatus(caseObj[0].Id, 'In Progress');
               
    //     Test.stopTest();
    // }

}