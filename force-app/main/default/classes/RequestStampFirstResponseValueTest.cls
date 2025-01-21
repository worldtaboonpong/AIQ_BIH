@IsTest
public class RequestStampFirstResponseValueTest {
    public static final Id INDIVIDUAL_PROFILE_ID{
        get
        {
            if(INDIVIDUAL_PROFILE_ID == null){
                INDIVIDUAL_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'BIH Individual' LIMIT 1].Id;
            }
            return INDIVIDUAL_PROFILE_ID;
        }
        set;
    }
    
    public static final Id INDIVIDUAL_ROLE_ID{
        get
        {
            if(INDIVIDUAL_ROLE_ID == null){
                INDIVIDUAL_ROLE_ID = [SELECT Id FROM UserRole WHERE Name = 'BIH Individual Officer' LIMIT 1].Id;
            }
            return INDIVIDUAL_ROLE_ID;
        }
        set;
    }
    @IsTest
    static void testRequestStampFirstResponseValue() {
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
            ProfileId = INDIVIDUAL_PROFILE_ID,
            UserRoleId = INDIVIDUAL_ROLE_ID,
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
                OwnerId = u.Id
            );
            insert c;
            
             System.debug('************************************' );
            System.debug('caseList May : ' + c);
            
            
             List<Case> caseList = [select id,owner.name,Owner_Role__c   
                from case 
                where createddate = THIS_YEAR
                AND (owner.name like '%Refer%' or Owner.name like '%Individual%' or Owner_Role__c  like '%Refer%' or Owner_Role__c   like '%Indivi%')
                Order by createddate desc Limit 10000];
            
            System.debug('************************************' );
            System.debug('caseList size : ' + caseList.size());
            
            //List<Case> caseList = BIH_TestUtils.createCases(1, 'FirstResponse','Request','Email', true);
            ScheduledStampFirstResponseValue pp = new ScheduledStampFirstResponseValue();
            system.schedule('RequestStampFirstResponseValue 1 day 11',  '0 1 * * * ?', pp);
            
            
            
            BatchStampFirstResponseValue obj = new BatchStampFirstResponseValue();
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