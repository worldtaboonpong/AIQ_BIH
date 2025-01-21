@isTest
public class BIH_TestUtils {
    public static final Id SYSADMIN_PROFILE_ID{
        get
        {
            if(SYSADMIN_PROFILE_ID == null){
                SYSADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
            }
            return SYSADMIN_PROFILE_ID;
        }
        set;
    }
    
    public static final Id AIRPORT_PROFILE_ID{
        get
        {
            if(AIRPORT_PROFILE_ID == null){
                AIRPORT_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'BIH Airport Transport' LIMIT 1].Id;
            }
            return AIRPORT_PROFILE_ID;
        }
        set;
    }
    
    static final String PERSON_ACC_ID = [select Id from RecordType where (DeveloperName='Person_Account') and (SobjectType='Account')].Id;
    
    public static List<Account> accountList {
        get
        {
            if(accountList == null){
                accountList = new List<Account>();
            }
            return accountList;
            
        }set;
    }
    
    public static List<Case> caseList {
        get
        {
            if(caseList == null){
                caseList = new List<Case>();
            }
            return caseList;
            
        }set;
    }
    
    public static List<Contact> contactList {
        get
        {
            if(contactList == null){
                contactList = new List<Contact>();
            }
            return contactList;
            
        }set;
    }
    
    public static List<User> userList {
        get
        {
            if(userList == null){
                userList = new List<User>();
            }
            return userList;
            
        }set;
    }
    
    public static List<EmailMessage> emailMessageList {
        get
        {
            if(emailMessageList == null){
                emailMessageList = new List<EmailMessage>();
            }
            return emailMessageList;
            
        }set;
    }
    
    public static List<User> createUsers(Integer size , String FName , String LName , String Email , Boolean doInsert) {
        List<User> userToCreate = new List<User>();
        for(Integer i = 0;i<size;i++){
            User newUser = new User(FirstName = FName+i , LastName = LName+i, 
                                    UserName=FName+i+LName+i+'@bumrungrad.com',
                                    Email=Email, Alias='TestBIH'+i,
                                    LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', 
                                    CommunityNickname=FName+i+'_'+LName+i+'_'+'BIHTestbih'+i,
                                    ProfileId = SYSADMIN_PROFILE_ID, TimeZoneSidKey='America/New_York',isActive = true
                                    );
            userToCreate.add(newUser);
        }
        
        userList = userToCreate;
        if(doInsert){
            
            insert userToCreate;
        }
        
        return userToCreate;
    }
    
    public static List<User> createEndUsers(Integer size , String FName , String LName , String Email ,Id profileId, Boolean doInsert) {
        List<User> userToCreate = new List<User>();
        for(Integer i = 0;i<size;i++){
            User newUser = new User(FirstName = FName+i , LastName = LName+i, 
                                    UserName=FName+i+LName+i+'@bumrungrad.com',
                                    Email=Email, Alias='TestBIH'+i,
                                    LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', 
                                    CommunityNickname=FName+i+'_'+LName+i+'_'+'BIHTestbih'+i,
                                    ProfileId = profileId, TimeZoneSidKey='America/New_York',isActive = true
                                    );
            userToCreate.add(newUser);
        }
        
        userList = userToCreate;
        if(doInsert){
            
            insert userToCreate;
        }
        
        return userToCreate;
    }
    
    public static void createServiceTypeMatrixs()
    {  
        Service_Type_Matrix__c tmp_serive_type = new Service_Type_Matrix__c();
        tmp_serive_type.Category_Level1_English__c = 'test_cate1';
        tmp_serive_type.Category_Level2_English__c = 'test_cate2';
        tmp_serive_type.Category_Level3_English__c ='test_cate3';
        tmp_serive_type.Responsible_Team__c = System.Label.Referral_Team;
        tmp_serive_type.SLA__c =240;

        Service_Type_Matrix__c tmp_serive_type2 = new Service_Type_Matrix__c();
        tmp_serive_type2.Category_Level1_English__c = 'test_cate1_airport';
        tmp_serive_type2.Category_Level2_English__c = 'test_cate2_airport';
        tmp_serive_type2.Category_Level3_English__c ='test_cate3_airport';
        tmp_serive_type2.Responsible_Team__c = System.Label.Airport_Team;
        tmp_serive_type2.SLA__c =240;

        Service_Type_Matrix__c tmp_serive_type3 = new Service_Type_Matrix__c();
        tmp_serive_type3.Category_Level1_English__c = 'test_cate1_pharmacy';
        tmp_serive_type3.Category_Level2_English__c = 'test_cate2_pharmacy';
        tmp_serive_type3.Category_Level3_English__c ='test_cate3_pharmacy';
        tmp_serive_type3.Responsible_Team__c = System.Label.Pharmacy_Team;
        tmp_serive_type3.SLA__c =240;
        insert tmp_serive_type;
        insert tmp_serive_type2;
        insert tmp_serive_type3;
    }
    public static List<Account> createAccounts(Integer size , String Fname, Boolean doInsert)
    {
        List<Account> accountsToCreate = new List<Account>();
        for(Integer i =0 ; i<size ;++i)
        {   
            Account Acct = new Account(); 
            Acct.Name = 'Test Account '+Fname+' '+i;
            Acct.Phone ='050111222';
            
       		accountsToCreate.add(acct);
            
        }
        accountList = accountsToCreate;
        
        if(doInsert){
            insert accountsToCreate;
        }
        
        return accountsToCreate;
    }
    
    public static List<Account> createPersonAccounts(Integer size , String personName,String personEmail, Boolean doInsert)
    {
        List<Account> accountsToCreate = new List<Account>();
        for(Integer i =0 ; i<size ;++i)
        {   
            Account personAcc = new Account(); 
            personAcc.RecordTypeID = PERSON_ACC_ID;
            personAcc.FirstName = 'F'+personName+i;
            personAcc.LastName = 'L'+personName+i;
            personAcc.PersonEmail = personEmail;
            personAcc.PersonHomePhone = '02123123'+i;
			personAcc.PersonMobilePhone = '02123124'+i;
            personAcc.Hospital_Number_HN__c='0987654321';

       		accountsToCreate.add(personAcc);
            
        }
        accountList = accountsToCreate;
        
        if(doInsert){
            insert accountsToCreate;
        }
        
        return accountsToCreate;
    }
    
    public static List<Case> createCases(Integer size , String Subject,String Category1,String origin, Boolean doInsert){
        List<Case> casesToCreate = new List<Case>();
        for(Integer i =0 ; i<size ;++i)
        {   
            Case c = new Case(); 
            c.Subject = Subject+' '+i;
            c.Case_Category_Level1__c = Category1;
            //c.your_question__c = 'Your Question';
            c.origin = origin;
            
            
       		casesToCreate.add(c);
            
        }
        caseList = casesToCreate;
        
        if(doInsert){
            insert casesToCreate;
        }
        
        return casesToCreate;
        
    }
    
    public static List<Case> createCases2(Integer size , String Subject,String Category1,String origin, Boolean doInsert){
        List<Case> casesToCreate = new List<Case>();
    
        for(Integer i =0 ; i<size ;++i)
        {   
            Case c = new Case(); 
            c.Subject = Subject;
            c.Case_Category_Level1__c = Category1;
            //c.your_question__c = 'Your Question';
            c.origin = origin;
            
            c.Cancellation_Appointment__c =  true;
            c.Status = 'Closed';
            c.channel__c = 'Contact Center';
            c.Close_Case_Reason__c = 'Normal Case';
            
            
            
            
            
       		casesToCreate.add(c);
            
        }
        caseList = casesToCreate;
        
        if(doInsert){
            insert casesToCreate;
        }
        
        return casesToCreate;
        
    }
    
    public static List<EmailMessage> createEmailMessages(Integer size , String subject,Id relatedId, Boolean doInsert)
    {
        List<EmailMessage> emailMessToCreate = new List<EmailMessage>();
        for(Integer i =0 ; i<size ;++i)
        {   
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'test@bumrungrad.com';
            email.CCAddress = 'test@bumrungrad.com';
            email.Incoming = True;
            email.ToAddress= 'info.bihtest@gmail.com';
            email.Subject = subject;
            email.HtmlBody = 'Test email body';
            email.ParentId = relatedId; 
            

       		emailMessToCreate.add(email);
            
        }
        emailMessageList = emailMessToCreate;

        
        if(doInsert){
            insert emailMessToCreate;
        }
        
        return emailMessToCreate;
    }
    public static void createFieldMappingForMicroSite(){

        List<Microsite_Field_Mapping__c> mappingList = new List<Microsite_Field_Mapping__c>();
        List<String> jsonList = new List<String>{'arrival_time','full_name','hospital_number','current_appointment_date',
        'current_appointment_time','new_appointment_date','selected_doctor','email','subject','status','origin',
        'priority','channel','case_category_lvl_1','case_category_lvl_2','case_category_lvl_3','web_refId',
        'ro_source','lead_source','hint_relation_to','additional_infos'};
                
        List<String> fieldSFList = new List<String>{'Web_Arrival_Time__c','Full_Name__c','Hospital_Number_HN__c','Current_Appointment_Date__c','Current_Appointment_Time__c',
        'New_Appointment_Date__c','Selected_Doctor__c','Patient_Email__c','Subject','Status','Origin','Priority',
        'Channel__c','Case_Category_Level1__c','Case_Category_Level2__c','Case_Category_Level3__c','Web_Ref_Id__c',
        'RO_Source__c','Lead_Source__c','Web_Relation_To__c','Web_Additional_Info__c'};
                
                
        for (integer i=0;i < fieldSFList.size() ; i++){
        	Microsite_Field_Mapping__c fmp = new Microsite_Field_Mapping__c();
        	fmp.JSON_Key__c = jsonList.get(i);
        	fmp.Website_Type__c = 'Microsite';
        	fmp.SF_Field_Name__c  = fieldSFList.get(i);
        	fmp.Subject__c = 'Change Appointment';
        	mappingList.add(fmp);    
        }
		insert mappingList;

    }
    public static void createFieldMappingForMainWebsite(){
        List<Microsite_Field_Mapping__c> mappingList = new List<Microsite_Field_Mapping__c>();
        List<String> jsonList = new List<String>{'first_name','last_name','email','hospital_number','doctor_name','appointment_date',
            'appointment_time_period','new_appointment_date','appointment_time_period_2','change_relative_appointment','relative_hn',
            'subject','status','origin','priority','channel','lead_source','case_category_lvl_1','case_category_lvl_2',
            'case_category_lvl_3','web_refid','hint_relation_to','additional_infos'
            };
                
        List<String> fieldSFList = new List<String>{'Sender_First_Name__c','Sender_Last_Name__c','SuppliedEmail','Hospital_Number_HN__c',
            'Web_Doctor_Name__c','Appointment_Date__c','Appointment_Time__c','New_Appointment_Date__c','New_Appointment_Time__c',
            'Change_Relative_Appointment__c','Relative_Hospital_Number__c','Subject','Status','Origin','Priority','Channel__c','Lead_Source__c',
            'Case_Category_Level1__c','Case_Category_Level2__c','Case_Category_Level3__c','Web_Ref_Id__c','Web_Relation_To__c','Web_Additional_Info__c'
            };
                
                
        for (integer i=0;i < fieldSFList.size() ; i++){
        	Microsite_Field_Mapping__c fmp = new Microsite_Field_Mapping__c();
        	fmp.JSON_Key__c = jsonList.get(i);
        	fmp.Website_Type__c = 'Main Website';
        	fmp.SF_Field_Name__c  = fieldSFList.get(i);
        	fmp.Subject__c = 'Change Appointment';
        	mappingList.add(fmp);    
        }
		insert mappingList;

    }
    public static void createFollowUpStep(Id caseId,Id ownerId,String Step){
        Follow_Up_Step__c testFollow = new Follow_Up_Step__c();
        testFollow.Step__c = Step;
        testFollow.Step_Status__c = 'Success';
        testFollow.Phone_SMS_Email__c = '0000000001';
        testFollow.Case__c = caseId;
        testFollow.Contact_Date__c = Datetime.Now();
        testFollow.OwnerId = OwnerId;
        testFollow.Remark__c = 'TEST';
        upsert testFollow;
    }
    public static Online_Service_Log__c createOnlineServiceLog(){
        Online_Service_Log__c tstLog = new Online_Service_Log__c();
        tstLog.User__c = UserInfo.getUserId();
		tstLog.Start_Datetime__c = DateTime.now();
        insert tstLog;

        return tstLog;
    }

    public static List<Case_Keyword__c> createCaseKeyword(){
        List<String> Category = new List<String>{'Drug Information Enquiry','Appointment','Medication Order / Refill'
        ,'General Information','Appointment','Appointment'};
        List<String> CategorySub1 = new List<String>{null,null,null,null,'Change Appointment','Cancel Appointment'};
        List<String> Keyword = new List<String>{'medicine price,drug price,generic,generic medicine,adverse drug reaction, side effect,allergy,allergic to,medication,medicine,list of medication,list of medicine,prescription,ราคายา,ชื่อสามัญทางยา,แพ้ยา, ผลข้างเคียง,อาการไม่พึ่งประสงค์,ยา,สอบถามยา,คำสั่งยา'
        ,'appointment,arrange,book,cancel,check up,consult,discussion,follow-up,invitation letter,postpone,schedule,reservation,reserve,visa,rearrange,upcoming visit,ambulance,admit,admission,reschedule,OPD,confirm,change,make,นัดหมาย,นัดพบแพทย์,เลื่อนนัด,ยกเลิกนัด,เปลี่ยนวัน นัดผ่าตัด,ตรวจสุขภาพ,วีซ่า,ตรวจร่างกาย,ประกัน,นัด,ตรวจ'
        ,'refill,refill presription,out of medicine,รีฟิลยา,ซื้อยาเพิ่ม,ยาหมด'
        ,'cost,price,payment,test,tour,referral,enquiry,exchange rate,invoice,recruit,clinic hours,package,promotion,program,explain, vaccine,question,receipt,claim form,slip,lab,certificate,password,transport,appreciate,insurance,vacancy,attention,hotel,accommodation,pending,result,recommend,advice,job, agent,summary,tourism,map,information, estimate,expense,procedure,record,advise, direction,complain,feedback,unsatisfy,compliment,representative,record,bill,compensate,method, airport,situation,treatment plan,medical report,สอบถาม,ราคา,ค่าใช้จ่าย,ค่าบริการ,แปลผล, ผลตรวจ,สัมภาษณ์,ใบเสร็จ,สำเนา,สมัครงาน, ตำแหน่งงาน,การเดินทาง,โปรโมชั่น,การตลาด,ปรึกษา, ร้องเรียน,ชมเชย,ชื่นชม,คำแนะนำ,อาการ, รักษา,หมอ,ค่ารักษา,โปรโมชั่น,บริการ',
        'change appointment','cancel appointment'};
        List<Double> Order = new List<Double>{3,1,4,2,6,5};
        List<Case_Keyword__c> CaseKeywords = new List<Case_Keyword__c>();
        for (integer i = 0;i<Category.size();i++){
            Case_Keyword__c caseKW = new Case_Keyword__c();
            caseKW.KW_Category__c = Category.get(i);
            caseKW.KW_Sub_Category_Level1__c = CategorySub1.get(i);
            caseKW.Keyword_List__c = Keyword.get(i);
            caseKW.Order_Number__c = Order.get(i);
            CaseKeywords.add(caseKW);
        }
        insert CaseKeywords;
        return CaseKeywords;
    }
}