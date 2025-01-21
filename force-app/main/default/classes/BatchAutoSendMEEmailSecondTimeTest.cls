@IsTest
public class BatchAutoSendMEEmailSecondTimeTest {
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
    static void testBatchAutoSendMEEmailSecondTime() {
        User u = new User(
            FirstName = 'FName', 
            LastName = 'LName',  
            UserName='FNameLName@bumrungrad.com',
            Email='FNameLName@bumrungrad.com',
            Alias='TestBIH',
            LocaleSidKey='en_US', 
            LanguageLocaleKey='en_US', 
            EmailEncodingKey='UTF-8', 
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
                Channel__c = 'Medical Enquiry',
                Status = 'Closed',
                Caller_Name__c = 'BIH',
                Contact_Number__c = '66894899130',
                ME_Follow_Up_Start_Time__c = System.today().addDays(-5),
                Case_Category_Level1__c = 'Medical Enquiry',
                Send_1st_ME_Email__c = false,
                Close_Case_Reason__c = 'NMI',
                New_ME_Email__c = false,  
                IsMEFirstFollowupMailSent__c = true,
                Send_ME_Email_Followup_2nd_Time__c = false
                 
            );
            insert c;
            
            System.debug('************************************' );
            System.debug('caseList BIH : ' + c);
            
            
            List<Case> caseList = [select id,OwnerId,ME_Follow_Up_Start_Time__c ,
            Subject,Status
            from case 
            where ME_Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-5)
            and CreatedDate >2023-10-10T19:22:36.584+07:00            
            and  Status = 'Closed'
            and ( Close_Case_Reason__c = 'NMI' or Close_Case_Reason__c = 'DR/NMI')
            and ME_Follow_Up_Start_Time__c   != null
            and IsMEFirstFollowupMailSent__c = true
            and Send_ME_Email_Followup_2nd_Time__c = false
            and New_ME_Email__c = false   limit 20];
            
            System.debug('************************************' );
            System.debug('caseList size : ' + caseList.size());
            
            //List<Case> caseList = BIH_TestUtils.createCases(1, 'FirstResponse','Request','Email', true);
            ScheduledAutoSendMEEmailSecondTime pp = new ScheduledAutoSendMEEmailSecondTime();
            system.schedule('StampScheduledAutoSendMEEmailSecondTime 1 day 11',  '0 1 * * * ?', pp);
    
            BatchAutoSendMEEmailSecondTime obj = new BatchAutoSendMEEmailSecondTime();
            Database.executeBatch(obj);
            

          }
    }

}