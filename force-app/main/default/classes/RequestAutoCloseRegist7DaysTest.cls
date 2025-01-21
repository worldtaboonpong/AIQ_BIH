@IsTest
public with sharing class RequestAutoCloseRegist7DaysTest {
        
    	@IsTest(SeeAllData=true) 
    	static void testRequestAutoCloseRegist7Days() {

        Test.startTest();
            
            
            
            
        ScheduledAutoCloseRegist7Days pp = new ScheduledAutoCloseRegist7Days();
        system.schedule('Auto Close Case',  '0 1 * * * ?', pp);
            

        BatchAutoCloseRegist7Days obj = new BatchAutoCloseRegist7Days();
        Database.executeBatch(obj);
        
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        //RequestCustomNotifcation.sendtouser(userid,c.id,'test','test');

        Test.stopTest();
    }
    public static final Id REGISTRATION_PROFILE_ID{
        get
        {
            if(REGISTRATION_PROFILE_ID == null){
                REGISTRATION_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'BIH Registration Supervisor' LIMIT 1].Id;
            }
            return REGISTRATION_PROFILE_ID;
        }
        set;
    }
    public static final Id REGISTRATION_ROLE_ID{
        get
        {
            if(REGISTRATION_ROLE_ID == null){
                REGISTRATION_ROLE_ID = [SELECT Id FROM UserRole WHERE Name = 'BIH Registration Manager' LIMIT 1].Id;
            }
            return REGISTRATION_ROLE_ID;
        }
        set;
    }
    
    @IsTest
    static void testAutoCloseRegist7Days() {
        User u = new User(
            FirstName = 'FName', 
            LastName = 'LName',  
            UserName='FNameLName@bumrungrad.com',
            Email='FNameLName@bumrungrad.com',
            Alias='TestBIH',
            LocaleSidKey='en_US', 
            LanguageLocaleKey='en_US', 
            EmailEncodingKey='UTF-8', 
            ProfileId = REGISTRATION_PROFILE_ID,
            UserRoleId = REGISTRATION_ROLE_ID,
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
            //insert acc;
             Case c = new Case(
                Subject = 'Test Case',
                AccountId = acc.Id,
                SuppliedEmail = 'test@email.com',
                Hospital_Number_HN__c = '0012345678',
                OwnerId = u.Id,
                Sent_Registration_Email_DateTime__c = System.today().addDays(-8),
                Status = 'New' ,
                Reply_From_Registration_Patient__c = False,
                Pass_to_Doctor_Date__c = Date.newinstance(2023, 10, 3),
                Reply_from_Doctor_Date__c = Date.newinstance(2023, 10, 10)
                 
            );
            insert c;
            
            Case c2 = new Case(
                Subject = 'Test Case1',
                AccountId = acc.Id,
                SuppliedEmail = 'test@email.com',
                Hospital_Number_HN__c = '0012345678',
                OwnerId = u.Id,
                Sent_Registration_Email_DateTime__c = System.today().addDays(-8),
                Status = 'New' ,
                Reply_From_Registration_Patient__c = False
                 
            );
            insert c2;
            
            List<Case> caseList = [select id,OwnerId, Reply_From_Registration_Patient__c,Sent_Registration_Email_DateTime__c ,
                                   Sent_Email_Regist_2nd_Time__c,Status
                                   from case 
                                   where Sent_Registration_Email_DateTime__c  <    : datetime.now().AddDays(-7)
                                   and (Owner.name = 'Registration Team' or   
                                        Owner.UserRole.name =  'BIH Registration Manager' )
                                   and (Status != 'Closed')
                                   and Reply_From_Registration_Patient__c   = false   
                                   and Pass_to_Doctor_Date__c != null 
                                   and Reply_from_Doctor_Date__c != null  
                                  ];
            ScheduledAutoCloseRegist7Days pp = new ScheduledAutoCloseRegist7Days();
            //system.schedule('RequestAutoCloseRegist7Days 1 day 11',  '0 1 * * * ?', pp);
            
            Test.startTest();
             System.enqueueJob(new RequestAutoCloseRegist7Days());
          	Test.stopTest();
            
            //BatchAutoCloseRegist7Days obj = new BatchAutoCloseRegist7Days();
            //Database.executeBatch(obj);
            
            //Database.BatchableContext bc;
            //BatchAutoCloseRegist7Days.execute(bc,caseList);
            //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        }
    }

}