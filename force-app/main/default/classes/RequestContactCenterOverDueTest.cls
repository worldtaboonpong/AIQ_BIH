@IsTest
public class RequestContactCenterOverDueTest {
    public static final Id CC_Rec_ID{
        get
        {
            if(CC_Rec_ID == null){
                CC_Rec_ID = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName ='Contact_Center_Case'LIMIT 1].Id;
            }
            return CC_Rec_ID;
        }
        set;
    }
    public static final Id CC_PROFILE_ID{
        get
        {
            if(CC_PROFILE_ID == null){
                CC_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'BIH Contact Center' LIMIT 1].Id;
            }
            return CC_PROFILE_ID;
        }
        set;
    }
    
    public static final Id CC_ROLE_ID{
        get
        {
            if(CC_ROLE_ID == null){
                CC_ROLE_ID = [SELECT Id FROM UserRole WHERE Name = 'BIH CC Officer - Best' LIMIT 1].Id;
            }
            return CC_ROLE_ID;
        }
        set;
    }
    @IsTest
    static void testRequestContactCenterOverDue() {
         User u = new User(
            FirstName = 'FName', 
            LastName = 'LName',  
            UserName='FNameLName@bumrungrad.com',
            Email='FNameLName@bumrungrad.com',
            Alias='TestBIH',
            LocaleSidKey='en_US', 
            LanguageLocaleKey='en_US', 
            EmailEncodingKey='UTF-8', 
            //CommunityNickname='BIHTestbih',
            ProfileId = CC_PROFILE_ID,
            UserRoleId = CC_ROLE_ID,
            TimeZoneSidKey='America/New_York',
            isActive = true
        
        );
        insert u;
        System.runAs(u) {
              Account acc = new Account(
                Salutation = 'Mr.',
                FirstName = 'Edward',
                MiddleName = 'Beby',
                LastName = 'Lasttest',
                Gender__c = 'Male',
                Date_of_Birth__c = Date.newinstance(1958, 3, 5),
                Country_of_Residence__c = 'Belgium'
            );
            insert acc;
             Case c = new Case(
                Subject = 'Test Case',
                AccountId = acc.Id,
                SuppliedEmail = 'test@email.com',
                Hospital_Number_HN__c = '0012345678',
                OwnerId = u.Id,
                Channel__c = 'Contact Center',
                CC_Case_Over_Due__c = false,
                SLA__c = -20,
                Status = 'New',
                RecordTypeId = CC_Rec_ID,
                Caller_Name__c = 'BIH',
                Contact_Number__c = '66894899130' 
            );
            insert c;
            
             System.debug('************************************' );
            System.debug('caseList BIH : ' + c);
            
            
             List<Case> caseList = [Select Id, Channel__c,OwnerId,CaseNumber,SLA_Overdue_Flag__c,CC_Case_Over_Due__c,owner.name,Owner_Role__c,RecordType.Name,Created_By_Role__c  From Case                               
            	Where Status != 'Closed'                   
            	And Channel__c = 'Contact Center'
                And SLA_Overdue_Flag__c = true
                And CC_Case_Over_Due__c = false 
                And (owner.name like '%Contact%' or Created_By_Role__c  like 'BIH CC%')
                AND RecordType.name like 'Contact%'
                AND Owner.Name != 'Registration Team'
                 order by createddate desc limit 100];
            
            System.debug('************************************' );
            System.debug('caseList size : ' + caseList.size());
            
            //List<Case> caseList = BIH_TestUtils.createCases(1, 'FirstResponse','Request','Email', true);
            ScheduledContactCenterOverDue pp = new ScheduledContactCenterOverDue();
            system.schedule('RequestContactCenterOverDue 1 day 11',  '0 1 * * * ?', pp);
            
            
            
            BatchContactCenterOverDue obj = new BatchContactCenterOverDue();
        	Database.executeBatch(obj);
            
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
          }
		/*
        Test.startTest();
        ScheduledStampFirstResponseValue pp = new ScheduledStampFirstResponseValue();
        system.schedule('RequestStampFirstResponseValue',  '0 1 * * * ?', pp);

        BatchStampFirstResponseValue obj = new BatchStampFirstResponseValue();
        Database.executeBatch(obj);
        

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        //RequestCustomNotifcation.sendtouser(userid,c.id,'test','test');

        Test.stopTest();
		*/
    }
}