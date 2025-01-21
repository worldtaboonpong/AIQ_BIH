@IsTest
public with sharing class RequestCustomNotifcationTest {
    @IsTest(SeeAllData=true) static void testRequestCustomNotifcation() {

        Test.startTest();
        ScheduledCaseNotify pp = new ScheduledCaseNotify();
        system.schedule('Notify Case Over 1 day 11',  '0 1 * * * ?', pp);

        BatchCaseNotify obj = new BatchCaseNotify();
        Database.executeBatch(obj);

        /*
        List<String> userid = new List<String>();

        List<user> users = [select id,Name,profile.Name from user where Id =:UserInfo.getUserId()];                  
        Id testuser; 

        for(user u :users)
        {
            //testuser = u.Id;
            //break;
            userid.add(u.Id);
        }*/

        //Test.startTest();

        /*Case TCase = new Case(
            Subject = 'Test',
            CaseNumber = 123456
        );
        insert TCase;
        Quote q1 = new Quote(
            OpportunityId = opp1.id,        
            Name = 'Test Quote 12',
            Pricebook2Id = standardPricebook2.id,
            ExpirationDate = eDate
        );
        insert q1;*/

        //Case c = new Case(); 
        //c.Subject = 'Test naja HN: 098765432';
        //c.Case_Category_Level1__c = 'Appointment';
        //c.your_question__c = 'Your Question';
        //c.origin = 'Web';
        //c.ParentId = casesList.get(1).id;
        //insert c;

        //Database.BatchableContext bc = new Database.BatchableContext();
        //QueueableContext context = new QueueableContext();
        //RequestCustomNotifcation.execute(context);
        

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        //RequestCustomNotifcation.sendtouser(userid,c.id,'test','test');

        Test.stopTest();
    }
}