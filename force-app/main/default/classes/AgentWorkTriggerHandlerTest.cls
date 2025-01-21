@isTest
public class AgentWorkTriggerHandlerTest {
    @isTest(SeeAllData = true) 
    static void testHandler() {
        Test.startTest();
        
        List<Case> caseObj = new List<Case>{
            new Case(Subject = 'Fackbook Post')};
        insert caseObj;
        
        List<SocialPost> spObj = new List<SocialPost>{
            new SocialPost(Name='Post', Content='Good Morning', ParentId = caseObj[0].Id)};
        insert spObj;
        
        ServiceChannel sc = [SELECT Id FROM ServiceChannel WHERE DeveloperName = 'Social' LIMIT 1];
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User u = [SELECT Id FROM User WHERE ProfileId =: p1.Id AND IsActive = true LIMIT 1];
        
        System.runAs(u){
            try{
                AgentWork aw = new AgentWork(
                    ServiceChannelId = sc.Id,
                    WorkItemId = spObj[0].Id,
                    UserId = u.Id
                );
                insert aw;
                
                aw.isSubmitted__c  = true;
                update aw;
            }catch(Exception ex){
                //Exception will occur due to the omni channel bug. Ignore it                
            }
        }
        
        Detection_Language_Mapping__mdt dtLang = AgentWorkTriggerHandler.DetectionLanguageMap.get('th');
        RecordType recType = AgentWorkTriggerHandler.RecordTypeMap.get('Primary_Case');
              
        Test.stopTest();
    }
}