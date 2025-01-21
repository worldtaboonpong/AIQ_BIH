@IsTest
public class BatchStampFirstResponseMEteamTest {

    public static final Id MEDICAL_ENQUIRY_PROFILE_ID{
        get
        {
            if(MEDICAL_ENQUIRY_PROFILE_ID == null){
                MEDICAL_ENQUIRY_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'BIH Medical Enquiry-Staff' LIMIT 1].Id;
            }
            return MEDICAL_ENQUIRY_PROFILE_ID;
        }
        set;
    }
    public static final Id MEDICAL_ENQUIRY_ROLE_ID{
        get
        {
            if(MEDICAL_ENQUIRY_ROLE_ID == null){
                MEDICAL_ENQUIRY_ROLE_ID = [SELECT Id FROM UserRole WHERE Name = 'BIH Medical Enquiry' LIMIT 1].Id;
            }
            return MEDICAL_ENQUIRY_ROLE_ID;
        }
        set;
    }
    @IsTest
    static void testBatchStampFirstResponseMEteam() {
     
       	 System.debug('MEDICAL_ENQUIRY_ROLE_ID:'+MEDICAL_ENQUIRY_ROLE_ID);
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
            ProfileId = MEDICAL_ENQUIRY_PROFILE_ID,
            UserRoleId = MEDICAL_ENQUIRY_ROLE_ID,
            TimeZoneSidKey='America/New_York',
            isActive = true
        
        );
        insert u;
        /*
        Account acc = new Account(
            Salutation = 'Mr.',
            FirstName = 'Edward',
            MiddleName = 'Beby',
            LastName = 'Lasttest',
            Gender__c = 'Male',
            Date_of_Birth__c = Date.newinstance(1958, 3, 5),
            Country_of_Residence__c = 'Belgium'
        );
        insert acc;*/
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
                AND (owner.name like '%Medical Enquiry%'or Owner_Role__c  like '%Medical Enquiry%' or RecordType.Name = 'Medical Enquiry')
                Order by createddate desc Limit 10000];
            
            System.debug('************************************' );
            System.debug('caseList size : ' + caseList.size());
            
            //List<Case> caseList = BIH_TestUtils.createCases(1, 'FirstResponse','Request','Email', true);
            ScheduledStampFirstResponseMEteam pp = new ScheduledStampFirstResponseMEteam();
            system.schedule('ScheduledStampFirstResponseMEteam 1 day 11',  '0 1 * * * ?', pp);
            
            
            
            BatchStampFirstResponseMEteam obj = new BatchStampFirstResponseMEteam();
            //Database.executeBatch(obj);
          }
        /*
        //create case
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
        system.schedule('ScheduledStampFirstResponseValue 1 day 11',  '0 1 * * * ?', pp);
		
        
        
        BatchStampFirstResponseValue obj = new BatchStampFirstResponseValue();
        Database.executeBatch(obj);*/
        
        
        
    }

}