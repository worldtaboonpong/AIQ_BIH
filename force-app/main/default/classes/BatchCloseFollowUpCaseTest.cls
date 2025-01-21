@IsTest
public class BatchCloseFollowUpCaseTest {
     public static final Id Clinic_PROFILE_ID{
        get
        {
            if(Clinic_PROFILE_ID == null){
                Clinic_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'Clinic - Genomics' LIMIT 1].Id;
            }
            return Clinic_PROFILE_ID;
        }
        set;
    }
    
    public static final Id Clinic_ROLE_ID{
        get
        {
            if(Clinic_ROLE_ID == null){
                Clinic_ROLE_ID = [SELECT Id FROM UserRole WHERE Name = 'Clinic - Genomics' LIMIT 1].Id;
            }
            return Clinic_ROLE_ID;
        }
        set;
    }
    @IsTest
    static void testBatchCloseFollowUPCase() {
        Test.startTest(); 
       	 
        User u = new User(
            FirstName = 'FName', 
            LastName = 'LName',  
            UserName='FNameLName@bumrungrad.com',
            Email='FNameLName@bumrungrad.com',
            Alias='TestBIH',
            LocaleSidKey='en_US', 
            LanguageLocaleKey='en_US', 
            EmailEncodingKey='UTF-8', 
            ProfileId = Clinic_PROFILE_ID,
            UserRoleId = Clinic_ROLE_ID,
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
                Close_Case_Reason__c =  'CL Out',
                Pass_to_Doctor_Date__c =  Date.newinstance(2024, 7, 5),
                IsFirstFollowupMailSent__c = True,
                IsSecondFollowupMailSent__c = True,
                Reply_from_Doctor_Date__c =  Date.newinstance(2024, 7, 6)
            );
            insert c;
            
            System.debug('************************************' );
            System.debug('caseList BIH : ' + c);
            
            
            List<Case> caseList = [select id,OwnerId,Follow_Up_Start_Time__c ,
        IsFirstFollowupMailSent__c,IsSecondFollowupMailSent__c,Status
            from case 
            where ME_Follow_Up_Start_Time__c  <    : datetime.now().AddDays(-6)
            and Status = 'Pending'
            and IsFirstFollowupMailSent__c = true 
            and IsSecondFollowupMailSent__c = true
            and ((Pass_to_Doctor_Date__c = null) OR (Pass_to_Doctor_Date__c != null and Reply_from_Doctor_Date__c != null))  
            and (NOT (Owner.UserRole.Name LIKE 'Clinic%' OR Owner.Name LIKE 'Clinic%'))  order by createddate desc limit 20];
            
            System.debug('************************************' );
            System.debug('caseList size : ' + caseList.size());
            
            //List<Case> caseList = BIH_TestUtils.createCases(1, 'FirstResponse','Request','Email', true);
            ScheduledCloseFollowUpCase pp = new ScheduledCloseFollowUpCase();
            system.schedule('ScheduledCloseFollowUpCase 1 day 11',  '0 1 * * * ?', pp);
            
            
            
            BatchCloseFollowUpCase obj = new BatchCloseFollowUpCase();
            Database.executeBatch(obj);
          }
        Test.stopTest();
    }

}