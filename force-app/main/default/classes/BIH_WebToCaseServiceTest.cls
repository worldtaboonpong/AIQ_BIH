@isTest
public class BIH_WebToCaseServiceTest {
    @isTest
    public static void positiveTest(){
       
        BIH_TestUtils.createFieldMappingForMicroSite();

        
 	Test.startTest();        
        
    string JsonMsg = '{'
    +'"full_name":  "Ms. Anna Tomson",'
    +'"hospital_number":  "0100000001",'
    +'"current_appointment_date":  "2019-07-01T08:00:00.000Z",'
    +'"current_appointment_time": "08:00:00.000Z",'
    +'"arrival_time": "08:00:00.000Z",'
    +'"new_appointment_date":  "2019-07-10T12:00:00.000Z",'
    +'"selected_doctor":  "Same doctor",'
    +'"email":  "mail@mail.com",'
    +'"subject":  "Change Appointment",'
    +'"status":  "New",'
    +'"origin":  "RO Website",'
    +'"priority": "High",'
    +'"file" : [{'
    +    '"file_name": "Upload Medical Reports.png",'
    +    '"file_body": "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAkCAYAAACe0YppAAAAAXNSR0IArs4c6QAAAclJREF'
    +    'UWAnlV71Lw0AUfy+pHzioCLb+AeLi7p9gEWlwddTd0WZ1cEmloIu7o4OgTYSK/geiIIiLa1FSv+qipJQ8L9Ir'
    +    'R5KeNpGe0IPwPu69++X9Xi6XYM40CPo+6FLrO2YbcPCAM2Gqm/Ax+WZdvIf9aeysuZxH0KviGoNHtbKKIz0W+'
    +    '5AtFh4RcUb0/V4n27Vso1u8tGJkT0S3xB/9BCiLkQLLEtPOKQOW9tjz9DkfPxPd3MiE15SxIgVu7B43ZMlp5hJ'
    +    'VkwaQ50orzprGARCN8+CORNqqW85NYOeKBjtXaa0z11bYNrxyrcp22M9tKTACLQHiNA/mkgj3OzrCLAKucFuQQ'
    +    '4IeUZVRrQxYSrXv0wajejTME2W8W+5rtbCq6/TCbS418Gtcj5NS4Kcd5zAuSfS9lk/umB1cPY3/SXVus7DqI0'
    +    'WpBu3suVR5CEqcMgvzOtFCuFwErVYvVc7Dfm5LqQYN9jTQYrYTLLIFvoEzgHm2Z8t8QUGeMr0rsDKqlQHLqSZ'
    +    'wCGNemT66nFIE/56d+Ufc5pJ9BVxzPU5Kgd2SvR6XJPpcy7GZHVw9DWVUDx5wpMfDMNZgv6499StJ8OBRrazi'
    +    'O35k5wvZdVqOuc3FfcAAAAASUVORK5CYII="},'
    +  '{"file_name": "Upload Images.png",'
    +    '"file_body": "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAkCAYAAACe0YppAAAAAXNSR0IArs4c6QAAAclJREFUW'
    +    'AnlV71Lw0AUfy+pHzioCLb+AeLi7p9gEWlwddTd0WZ1cEmloIu7o4OgTYSK/geiIIiLa1FSv+qipJQ8L9IrR5KeNpGe0'
    +    'IPwPu69++X9Xi6XYM40CPo+6FLrO2YbcPCAM2Gqm/Ax+WZdvIf9aeysuZxH0KviGoNHtbKKIz0W+5AtFh4RcUb0/V4n2'
    +    '7Vso1u8tGJkT0S3xB/9BCiLkQLLEtPOKQOW9tjz9DkfPxPd3MiE15SxIgVu7B43ZMlp5hJVkwaQ50orzprGARCN8+COR'
    +    'NqqW85NYOeKBjtXaa0z11bYNrxyrcp22M9tKTACLQHiNA/mkgj3OzrCLAKucFuQQ4IeUZVRrQxYSrXv0wajejTME2W8W'
    +    '+5rtbCq6/TCbS418Gtcj5NS4Kcd5zAuSfS9lk/umB1cPY3/SXVus7DqI0WpBu3suVR5CEqcMgvzOtFCuFwErVYvVc7Df'
    +    'm5LqQYN9jTQYrYTLLIFvoEzgHm2Z8t8QUGeMr0rsDKqlQHLqSZwCGNemT66nFIE/56d+Ufc5pJ9BVxzPU5Kgd2SvR6XJ'
    +    'Ppcy7GZHVw9DWVUDx5wpMfDMNZgv6499StJ8OBRraziJO35k5wvZdVqOuc3FfcAAAAASUVORK5CYII="'
    +   '},{'
    +    '"file_name": "Lab Resuts.png",'
    +    '"file_body": "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAkCAYAAACe0YppAAAAAXNSR0IArs4c6QAAAclJREFUWAnlV7'
    +    '1Lw0AUfy+pHzioCLb+AeLi7p9gEWlwddTd0WZ1cEmloIu7o4OgTYSK/geiIIiLa1FSv+qipJQ8L9IrR5KeNpGe0IPwPu69++X'
    +    '9Xi6XYM40CPo+6FLrO2YbcPCAM2Gqm/Ax+WZdvIf9aeysuZxH0KviGoNHtbKKIz0W+5AtFh4RcUb0/V4n27Vso1u8tGJkT0S3'
    +    'xB/9BCiLkQLLEtPOKQOW9tjz9DkfPxPd3MiE15SxIgVu7B43ZMlp5hJVkwaQ50orzprGARCN8+CORNqqW85NYOeKBjtXaa0z1'
    +    '1bYNrxyrcp22M9tKTACLQHiNA/mkgj3OzrCLAKucFuQQ4IeUZVRrQxYSrXv0wajejTME2W8W+5rtbCq6/TCbS418Gtcj5NS4K'
    +    'cd5zAuSfS9lk/umB1cPY3/SXVus7DqI0WpBu3suVR5CEqcMgvzOtFCuFwErVYvVc7Dfm5LqQYN9jTQYrYTLLIFvoEzgHm2Z8t'
    +    '8QUGeMr0rsDKqlQHLqSZwCGNemT66nFIE/56d+Ufc5pJ9BVxzPU5Kgd2SvR6XJPpcy7GZHVw9DWVUDx5wpMfDMNZgv6499StJ'
    +    '8OBRraziJO35k5wvZdVqOuc3FfcAAAAASUVORK5CYII="}],'
    +'"channel":  "Referral",'
    +'"case_category_lvl_1":  "Appointment",'
    +'"case_category_lvl_2":  "Change Appointment",'
    +'"case_category_lvl_3":  "",'
    +'"web_refId":  "2019070100001",'
    +'"ro_source":  "UAE.bumrungrad.com",'
    +'"lead_source":  "RO UAE",'
    +'"hint_relation_to":  "",'
    +'"additional_infos":  "(remark:waiting doctor)",'
    +'"specialty": "Test Data"'
    +'}';
    //     string JsonMsg = ''+'{"passport_name": "Anna Tomson",'
    // +'"hospital_number": "001000101010",'
    // +'"passport_number": "3546576897",'
    // +'"attendant_name": "Phong Thungmay",'
    // +'"appointment_date": "2019-07-01T08:00:00.000Z",'
    // +'"email": "mail@mail.com",'
    // +'"file": ['
    // +'   {'
    // +'        "file_name": "Passport Copy.png",'
    // +'        "file_body": "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAkCAYAAACe0YppAAAAAXNSR0IArs4c6QAAAclJREFUWAnlV71Lw0AUfy+pHzioCLb+AeLi7p9gEWlwddTd0WZ1cEmloIu7o4OgTYSK/geiIIiLa1FSv+qipJQ8L9IrR5KeNpGe0IPwPu69++X9Xi6XYM40CPo+6FLrO2YbcPCAM2Gqm/Ax+WZdvIf9aeysuZxH0KviGoNHtbKKIz0W+5AtFh4RcUb0/V4n27Vso1u8tGJkT0S3xB/9BCiLkQLLEtPOKQOW9tjz9DkfPxPd3MiE15SxIgVu7B43ZMlp5hJVkwaQ50orzprGARCN8+CORNqqW85NYOeKBjtXaa0z11bYNrxyrcp22M9tKTACLQHiNA/mkgj3OzrCLAKucFuQQ4IeUZVRrQxYSrXv0wajejTME2W8W+5rtbCq6/TCbS418Gtcj5NS4Kcd5zAuSfS9lk/umB1cPY3/SXVus7DqI0WpBu3suVR5CEqcMgvzOtFCuFwErVYvVc7Dfm5LqQYN9jTQYrYTLLIFvoEzgHm2Z8t8QUGeMr0rsDKqlQHLqSZwCGNemT66nFIE/56d+Ufc5pJ9BVxzPU5Kgd2SvR6XJPpcy7GZHVw9DWVUDx5wpMfDMNZgv6499StJ8OBRraziJO35k5wvZdVqOuc3FfcAAAAASUVORK5CYII="'
    // +'    }'
    // +'],'
    // +'"subject": "Visa Invitation Letter",'
    // +'"status": "New",'
    // +'"origin": "Web",'
    // +'"priority": "Normal",'
    // +'"channel": "Referral",'
    // +'"case_category_lvl_1": "Request",'
    // +'"web_refId": "2019070100012",'
    // +'"ro_source": "UAE",'
    // +'"additional_infos":"Test"}';
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/BIH_WebToCaseService';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
       
         BIH_WebToCaseService.create();
        
        Test.stopTest();
        
       
    }
    @isTest
    public static void positiveTest2(){
        Test.startTest();
        string JsonMsg = '{"cancel_appointments":[{"md_code":"0001","request_type":"TEST_REQUEST","request_cancellation_date":"2019-07-01T00:00:00.000Z","additional_appt_cancellation_date":"TEST_additional_appt_cancellation_date","cost_center_cancel":"TEST_COST_CENTER_CANCEL","department_cancel":"TEST_DEPARTMENT_CANCEL","doctor_name":"Dr.Wist","specialty":"TEST_SPECIALTY","patients":[{"hnnumber":"100000001","gender":"Female","date_of_birth":"1971-03-01","app_date":"2019-11-01","end_time":"01:15:00.000Z","service":"TEST_SERVICE","fullname":"Aaa Aaa","fullname_th":"กกก กกก","age":"15","app_time":"01:15:00.000Z","app_status":"TEST_APP_STATUS","location":"Thailand","nationality":"Thai"},{"hnnumber":"100000002","gender":"Female","date_of_birth":"1971-03-02","app_date":"2019-11-02","end_time":"02:15:00.000Z","service":"TEST_SERVICE","fullname":"Bbb Bbb","fullname_th":"กกก กกก","age":"15","app_time":"02:15:00.000Z","app_status":"TEST_APP_STATUS","location":"Thailand","nationality":"Thai"}]},{"md_code":"002","request_type":"test","request_cancellation_date":"2019-07-02T00:00:00.000Z","additional_appt_cancellation_date":"TEST_additional_appt_cancellation_date","cost_center_cancel":"Test","department_cancel":"Test","doctor_name":"Dr.Wiston","specialty":"TEST_SPECIALTY","patients":[{"hnnumber":"100000003","gender":"Female","date_of_birth":"1971-03-03","app_date":"2019-11-03","end_time":"03:15:00.000Z","service":"TEST_SERVICE","fullname":"Ccc Ccc","fullname_th":"กกก กกก","age":"15","app_time":"03:15:00.000Z","app_status":"TEST_APP_STATUS","location":"Thailand","nationality":"Thai"},{"hnnumber":"100000004","gender":"Female","date_of_birth":"1971-03-04","app_date":"2019-11-04","end_time":"04:15:00.000Z","service":"TEST_SERVICE","fullname":"Ddd Ddd","fullname_th":"กกก กกก","age":"15","app_time":"04:15:00.000Z","app_status":"TEST_APP_STATUS","location":"Thailand","nationality":"Thai"}]}]}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/BIH_CancelAppointmentService';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
       
        BIH_CancelAppointmentService.cancelAppointment();
        Test.stopTest();
        
        
    }

   
    
    @isTest
    public static void positiveTest3(){
        BIH_TestUtils.createFieldMappingForMainWebsite();
        
        Test.startTest();
		String JsonMsg = '{"first_name":"Kritsanapong",'
            +'"last_name":"Poomdokmai","email":"ksp@ii.co.th",'
            +'"hospital_number":"1000000001","doctor_name":"Dr. Akarasuda Yamsorn",'
            +'"appointment_date":"2019-12-20T00:00:00.000Z","appointment_time_period":"07:30:00.000Z",'
            +'"new_appointment_date":"2019-12-25T00:00:00.000Z","appointment_time_period_2":"08:30:00.000Z",'
            +'"change_relative_appointment":"False","change_relative_appointment":"True","relative_hn":"1000000002","subject":"Change Appointment",'
            +'"status":"New","origin":"Web","priority":"High","channel":"Individual","lead_source":"Website",'
            +'"case_category_lvl_1":"Appointment","case_category_lvl_2":"Change Appointment","case_category_lvl_3":""'
            +',"appointment_time_period": "08:00-08:59","web_refid":"2019070100001","hint_relation_to":"2019070100011","additional_infos":"(remark:waiting doctor)"}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/BIH_WebToCaseServiceV2';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
       
        BIH_WebToCaseServiceV2.create();
        Test.stopTest();
    }

    @isTest
    public static void positiveTest4(){
        Test.startTest();
        List<Case> casesList = BIH_TestUtils.createCases(2 ,'Urgent Book Appointment DOB: 01/12/1990 HN: 098765432','Appointment','Email', true);
        
        string JsonMsg = '{ "caseId": "'+casesList.get(0).Id+'", "file": ['
        +'{ "file_name": "Passport Copy.png", "file_body": "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAkCAYAAACe0YppAA'
        +'AAAXNSR0IArs4c6QAAAclJREFUWAnlV71Lw0AUfy+pHzioCLb+AeLi7p9gEWlwddTd0WZ1cEmloIu7o4'
        +'OgTYSK/geiIIiLa1FSv+qipJQ8L9IrR5KeNpGe0IPwPu69++X9Xi6XYM40CPo+6FLrO2YbcPCAM2Gqm/'
        +'Ax+WZdvIf9aeysuZxH0KviGoNHtbKKIz0W+5AtFh4RcUb0/V4n27Vso1u8tGJkT0S3xB/9BCiLkQLLEt'
        +'POKQOW9tjz9DkfPxPd3MiE15SxIgVu7B43ZMlp5hJVkwaQ50orzprGARCN8+CORNqqW85NYOeKBjtXaa'
        +'0z11bYNrxyrcp22M9tKTACLQHiNA/mkgj3OzrCLAKucFuQQ4IeUZVRrQxYSrXv0wajejTME2W8W+5rtb'
        +'Cq6/TCbS418Gtcj5NS4Kcd5zAuSfS9lk/umB1cPY3/SXVus7DqI0WpBu3suVR5CEqcMgvzOtFCuFwErV'
        +'YvVc7Dfm5LqQYN9jTQYrYTLLIFvoEzgHm2Z8t8QUGeMr0rsDKqlQHLqSZwCGNemT66nFIE/56d+Ufc5pJ'
        +'9BVxzPU5Kgd2SvR6XJPpcy7GZHVw9DWVUDx5wpMfDMNZgv6499StJ8OBRraziJO35k5wvZdVqOuc3FfcAAAAASUVORK5CYII=" } ] }';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/BIH_WebToCaseAddFile';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
       
        BIH_WebToCaseAddFile.addFiles();
        Test.stopTest();
    }
     @isTest
    public static void negativeTest(){
        
         Test.startTest();
        
        string JsonMsg = '';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/BIH_WebToCaseService';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
       
         BIH_WebToCaseService.create();
        
        Test.stopTest();
        
    }
    @isTest
    public static void negativeTest2(){
        
         Test.startTest();
        
        string JsonMsg = '';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/BIH_WebToCaseServiceV2';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
       
         BIH_WebToCaseServiceV2.create();
        
        Test.stopTest();
        
    }

    @isTest
    public static void negativeTest3(){
        
         Test.startTest();
        
        string JsonMsg = '';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/BIH_WebToCaseAddFile';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
       
        BIH_WebToCaseAddFile.addFiles();
        
        Test.stopTest();
        
    }
}