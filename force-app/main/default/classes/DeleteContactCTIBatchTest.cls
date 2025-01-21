@istest
public class DeleteContactCTIBatchTest {
	@istest
    public static void test(){
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Test';
        c.Phone = '66840778797';
        insert c;
        
        Account a = new Account();
        a.FirstName = 'Test';
        a.LastName = 'Test';
        a.Local_First_Name__c = 'Test';
        a.Phone = '66840778797';
        insert a;
        
        Task t = new Task();
        t.WhoId = c.Id;
        insert t;
        
        Case ca = new Case();
        ca.ContactId = c.Id;
        ca.Verified_Patient__c = true;
        ca.Patient__c = a.Id;
        insert ca;
        
        Test.startTest();
        String days = BIH_Constants.DELETE_CTI_CONTACT_DAYS;
        String query = 'SELECT ID,MobilePhone,Phone,AccountId,Firstname,createddate FROM Contact WHERE Phone != null and CreatedDate = LAST_N_DAYS:'+days;
        DeleteContactCTIBatch memberPurge = new DeleteContactCTIBatch(query);
        
        DeleteContactCTISchedule sh1 = new DeleteContactCTISchedule();
        String sch = '0 0 1 * * ?'; system.schedule('DeleteContactCTISchedule Test', sch, sh1); 
        Test.stopTest();
    }
}