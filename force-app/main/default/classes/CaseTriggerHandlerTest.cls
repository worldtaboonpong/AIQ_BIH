@isTest
public class CaseTriggerHandlerTest {
    @isTest
    public static void positiveTest(){
        
        Case_Keyword__c kw = new Case_Keyword__c();
        kw.KW_Category__c = 'Appointment';
        kw.Keyword_List__c = 'Appointment';
        insert kw;
        
        Test.startTest();
        
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1 , 'Test001','BIHTest@bumrungradtest.com', true);
        List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321','Appointment','Email', true);
        // List<Case> casesList2 = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321','Appointment','Email', true);
        
        // for (Case c:casesList2){
        //     c.ParentId = casesList.get(0).Id;
        // }
        // update casesList2;

       	casesList.get(0).Status = 'In Progress';
        casesList.get(0).SuppliedEmail = 'BIHTest@bumrungradtest.com';
        update casesList;
        
        //closed case
        casesList.get(0).Status = 'Closed';
        casesList.get(0).Close_Case_Reason__c = 'Normal Case';
        update casesList;
        
        BIH_TestUtils.createServiceTypeMatrixs();
        casesList.get(1).Case_Category_Level1__c = 'test_cate1';
        casesList.get(1).Case_Category_Level2__c = 'test_cate2';
        casesList.get(1).Case_Category_Level3__c = 'test_cate3';
        update casesList.get(1);

        
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void positiveCancellationTest(){
        Test.startTest();
        List<Case_Keyword__c> caseKeyword = BIH_TestUtils.createCaseKeyword();
        for (Case_Keyword__c kw : caseKeyword){
            kw.KW_Sub_Category_Level1__c = 'test';
        }
        update caseKeyword;
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1 , 'Test001','BIHTest@bumrungradtest.com', true);
        List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321','Appointment','Web', true);     
        List<Case> casesList2 = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321','Appointment','Web', true);     
        Follow_Up_Step__c fw = new Follow_Up_Step__c();
        for (Case c:casesList2){
            Case cc = new Case();
            cc.ParentId = casesList.get(0).Id;
        }
        update casesList2;
        casesList.get(0).Follow_Up_Step__c = 'Call 3';
        update casesList;
        fw.Case__c = casesList.get(0).id;
        fw.Step__c = 'Call 3';
        fw.Step_Status__c = 'Success';
        insert fw;

        fw.Step_Status__c = 'Unsuccess';
        update fw;
        //closed case
        casesList.get(0).Status = 'Closed';
        casesList.get(0).Cancellation_Appointment__c = true;
        casesList.get(0).Close_Case_Reason__c = 'Normal Case';
        casesList.get(0).Channel__c = 'Contact Center';
        casesList.get(0).Case_Category_Level2__c = 'Book Appointment w/ requested Dr.';
        casesList.get(0).Case_Category_Level3__c = 'Regular Appointment-Single';
        casesList.get(0).Payor_Type__c = 'Insured';
        
        update casesList;
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void positiveTest2(){
        Test.startTest();
        List<Case_Keyword__c> caseKeyword = BIH_TestUtils.createCaseKeyword();
        List<Account> accList = BIH_TestUtils.createPersonAccounts(1 , 'Test001','BIHTest@bumrungradtest.com', true);

        for (Case_Keyword__c kw : caseKeyword){
            kw.KW_Sub_Category_Level1__c = 'test';
        }
        update caseKeyword;
        System.Debug('caseKeyword: '+caseKeyword);
        BIH_TestUtils.createServiceTypeMatrixs();
        Case cases1 = new Case();
        cases1.Subject = 'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321';
        cases1.Origin = 'Web';
        cases1.Case_Category_Level1__c = 'test_cate1';
        cases1.Case_Category_Level2__c = 'test_cate2';
        cases1.Case_Category_Level3__c = 'test_cate3';
        cases1.Patient__c = accList.get(0).Id;
        cases1.AccountId = accList.get(0).Id;
        insert cases1;

        Case cases2 = new Case();
        cases2.Subject = 'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321';
        cases2.Origin = 'Web';
        cases2.Case_Category_Level1__c = 'test_cate1_airport';
        cases2.Case_Category_Level2__c = 'test_cate2_airport';
        cases2.Case_Category_Level3__c = 'test_cate3_airport';
        cases2.Patient__c = accList.get(0).Id;
        insert cases2;

        Case cases3 = new Case();
        cases3.Subject = 'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321';
        cases3.Origin = 'Web';
        cases3.Case_Category_Level1__c = 'test_cate1_pharmacy';
        cases3.Case_Category_Level2__c = 'test_cate2_pharmacy';
        cases3.Case_Category_Level3__c = 'test_cate3_pharmacy';
        cases3.SuppliedEmail = 'test@test.co.th';
        insert cases3;

        Case cases4 = new Case();
        cases4.Subject = 'Urgent Book Appointment DOB: 01/12/1990 HN: 0987654321';
        cases4.Origin = 'Email';
        insert cases4;

        EmailMessage email = new EmailMessage();
        email.Subject = 'Urgent Health Fair Promotion 2019: 17-18 Aug 2019 // Warissara Mattakunnamai HN102325337 ( DOB:8-January-1992 )';
        email.FromName = 'TEST FROMNAME';
        email.FromAddress = 'test@test.co.th';
        email.RelatedToId = cases4.Id;
        insert email;


        CaseTriggerHandler.convertStringtoDate('21/07/2007','21/07/2007');
        CaseTriggerHandler.convertStringtoDateByMonthFormat('2017-07-21 00:00:00','2017-07-21 00:00:00');
        CaseTriggerHandler.convertStringtoDateByMonthFormat('8-January-1992','8-January-1992');
        
        Test.stopTest();
    }
    
    
    @isTest
    static void test_createAccountAndAssociateCase(){
    
        Case oCase = new Case();
        oCase.Subject = 'Urgent Book Appointment Test 1';
        oCase.Origin = 'Email';
        oCase.Web_Phone__c = '040000000';
        oCase.Case_From_MB__c=true;
        oCase.Full_Name__c='Test';
        oCase.SuppliedEmail = 'test@test.com';
        insert oCase;
        
        Test.startTest();
            Case oCase2 = new Case();
            oCase2.Subject = 'Urgent Book Appointment Test 2';
            oCase2.Origin = 'Email';
            oCase2.Web_Phone__c = '040000000';
        	oCase2.Case_From_MB__c=true;
        	oCase2.Full_Name__c='Test';
        	oCase2.SuppliedEmail = 'test@test.com';
            insert oCase2;  
        Test.stopTest();
    }
}