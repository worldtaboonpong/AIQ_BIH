@isTest
public class BIH_EditEndosementCtrlTest {
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
    
    @isTest
    public static void EditEndosementCtrl01Test(){
        
        Test.startTest();
        
        System.debug('INDIVIDUAL_ROLE_ID:'+INDIVIDUAL_ROLE_ID);
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
            
			c.Subject = 'Test Case1';
            BIH_EditEndosementCtrl.UpdateCaseRecordEndosement(c);
            //c.AccountId = 'Test Case1';
            c.OwnerId = c.id;
            BIH_EditEndosementCtrl.UpdateCaseRecordEndosement(c);
            BIH_EditEndosementCtrl.getcaseforendosement(c.id, 2);
             
         }
        
        Test.stopTest();
        
    }
}