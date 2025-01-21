global without sharing class BIH_PatientInformationService {
    global class patientInfoData {
        @AuraEnabled
        global String hn{get;set;}
        @AuraEnabled
        global String dateOfBirth{get;set;}
        @AuraEnabled
        global String title{get;set;}
        @AuraEnabled
        global String firstName{get;set;}
        @AuraEnabled
        global String lastName{get;set;}
        @AuraEnabled
        global integer sex{get;set;}
        @AuraEnabled
        global String email{get;set;}
        @AuraEnabled
        global String mobilePhone{get;set;}
        @AuraEnabled
        global String homePhone{get;set;}
        @AuraEnabled
        global String nationality{get;set;}
        @AuraEnabled
        global String passportNumber{get;set;}
        @AuraEnabled
        global String country{get;set;}
        @AuraEnabled
        global String countryOfResident{get;set;}
        @AuraEnabled
        global String idCardNumber{get;set;}
        @AuraEnabled
        global String preferredLanguage{get;set;}
        @AuraEnabled
        global String email2{get;set;}
        @AuraEnabled
        global String officePhone{get;set;}
        @AuraEnabled
        global String note{get;set;}
        @AuraEnabled
        global String localFirstName{get;set;}
        @AuraEnabled
        global String localLastName{get;set;}
        @AuraEnabled
        global String loyaltyCode{get;set;}
        @AuraEnabled
        global String loyaltyDescription{get;set;}
        @AuraEnabled
        global String address{get;set;}
        @AuraEnabled
        global String cityArea{get;set;}
        @AuraEnabled
        global String suburb{get;set;}
        @AuraEnabled
        global String state{get;set;}       
        @AuraEnabled
        global String postCode{get;set;}
        @AuraEnabled
        global String foreignPostCode{get;set;}
        @AuraEnabled
        global String payor{get;set;}
        @AuraEnabled
        global DateTime payDateTo{get;set;}
        @AuraEnabled
        global String policyNo{get;set;}
        @AuraEnabled
        global String memberID{get;set;}
        @AuraEnabled
        global List<alertMessages> alertMessages;
        
        // global String gender;
        global String getGender(integer sex){
            if(sex == 1){
                return 'Male';
            }else if(sex == 2){
                return 'Female';
            }else{
                return 'Unidentified';
            }
        }
        @AuraEnabled
        global string gender{
            get{
                if(this.sex == 1){
                return 'Male';
                }else if(this.sex == 2){
                    return 'Female';
                }else{
                    return 'Unidentified';
                }
            }
            set;
        }
        @AuraEnabled
        global string fullName{
            get{
                return this.firstName +' '+this.lastName;
            }
            set;
        }
    }
    global class alertMessages {
        @AuraEnabled
        global Integer type{get;set;}
        @AuraEnabled
        global String hn{get;set;}
        @AuraEnabled
        global String code{get;set;}
        @AuraEnabled
        global String description{get;set;}
        @AuraEnabled
        global String message{get;set;}
        @AuraEnabled
        global String createdAt{get;set;}
    }
    global static List<patientInfoData> patientInformation{get;set;}

    // global static patientInfoData getPatientInformation(string hnNumber) {
    //  Http http = new Http();
    //     HttpRequest req = new HttpRequest();
    //     req.setMethod('GET');
    //     // Set Request Header
    //     req.setHeader('Ocp-Apim-Subscription-Key','42b00c43837d41b48dcbbba7510d990d');

    //     String endpoint ='https://bihtest.azure-api.net/crm/v1/Patient/profile?hn='+hnNumber+'&username=nct@ii.co.th';
    //     req.setEndpoint(endpoint);//app config end point
    //     HttpResponse res = http.send(req);
    //  System.debug(res.getBody());
    //  // System.debug ();
    //  return (patientInfoData) System.JSON.deserialize(res.getBody(), patientInfoData.class);
    // }

    global static void getPatientInformation(string hnNumber) {
        // List<Case> currentCase = [SELECT Id FROM Case WHERE Hospital_Number_HN__c  = :hnNumber];
        // System.debug('currentCase: '+currentCase);
        Online_Service_Log__c logs = new Online_Service_Log__c();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        // String dt = DateTime.Now().format('yyyyMMddHHmmss');
        // logs.Name = dt;
        logs.User__c = UserInfo.getUserId();
        logs.Hospital_Number__c = hnNumber;
        logs.Start_Datetime__c = DateTime.now();
        // Set Request Header
        req.setHeader('Ocp-Apim-Subscription-Key',BIH_Constants.SUBSCRIPTION_KEY);
        logs.Service_Name__c = System.Label.INT_Patient_Information;
        
        String endpoint =BIH_Constants.END_POINT_PATIENT_BY_HN+hnNumber+'&username='+BIH_Constants.SERVICE_USERNAME_TRAKCARE;
        req.setEndpoint(endpoint);//app config end point
        logs.Endpoint__c = endpoint;
        
        System.debug('endpoint:'+endpoint);

        HttpResponse res = http.send(req);
        logs.Status_Code__c = String.valueOf(res.getStatusCode());
        logs.End_Datetime__c = DateTime.now();

        System.debug('RESPONSE REQ:'+res.getBody());
        List<patientInfoData> tmpList = new List<patientInfoData>();
        if(res.getStatusCode() == 200 || res.getStatusCode() == 206){
            patientInfoData tmpPatientInformation = (patientInfoData) System.JSON.deserialize(res.getBody(), patientInfoData.class);
            System.debug('tmpPatientInformation :'+tmpPatientInformation);
            if(tmpPatientInformation != null ){
                tmpList.add(tmpPatientInformation);
                patientInformation = tmpList;
                logs.Error_Message__c = null;
                logs.Is_Success__c = true;
            }
            System.debug('patientInformation :'+patientInformation);
        }else{
            patientInformation = tmpList;
            system.debug(res.getStatusCode()+' : '+res.getBody() );
            logs.Error_Message__c = res.getBody();
            logs.Is_Success__c = false;

        }
        insert logs;
        if (req.getBody() != null && req.getBody() != ''){
            OnlineServiceLog.generateContentVersionRequest(logs,req.getBody());
        }else {
            OnlineServiceLog.generateContentVersionRequest(logs,endpoint);
        }
        if (res.getBody() != null && res.getBody() != '') {
            OnlineServiceLog.generateContentVersionResponse(logs,res.getBody());
        }

    }

    global static void getPatientInformation(string Firstname,string Lastname,string Email,string DateOfBirth,string Gender) {
        // https://bihtest.azure-api.net/crm/v1/Patient/search[?Firstname][&Lastname][&Email][&DateOfBirth][&Gender]
        Datetime tmpDate ;
        if(DateOfBirth != '' && DateOfBirth != null){
            tmpDate = Date.ValueOf(DateOfBirth);
        }
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        Online_Service_Log__c logs = new Online_Service_Log__c();
        
        req.setMethod('GET');
        // String dt = DateTime.Now().format('yyyyMMddHHmmss');
        // logs.Name = dt;
        logs.User__c = UserInfo.getUserId();
        logs.Start_Datetime__c = DateTime.now();
        req.setTimeout(Integer.ValueOf(BIH_Constants.SET_TIMEOUT_SERVICE));
        // Set Request Header
        req.setHeader('Ocp-Apim-Subscription-Key',BIH_Constants.SUBSCRIPTION_KEY);
        String tmp_firstname =  Firstname != null && Firstname != ''    ? 'Firstname='+Firstname.replace(' ', '%20')+'&' : '';
        String tmp_lastname =   Lastname != null && Lastname != ''      ? 'Lastname='+Lastname.replace(' ', '%20')+'&' : '';
        String tmp_email =      Email != null && Email != ''            ? 'Email='+Email+'&' : '';
        String tmp_dob =        DateOfBirth != null && DateOfBirth != ''? 'DateOfBirth='+tmpDate.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'')+'&' : '';
        String tmp_gender =     Gender != null && Gender != ''          ? 'Gender='+Gender+'&' : '';
        String params = tmp_firstname+tmp_lastname+tmp_email+tmp_dob+tmp_gender;
        String endpoint = BIH_Constants.END_POINT_PATIENT_BY_STRING+params.removeEnd('&');
        req.setEndpoint(endpoint);//app config end point
        System.debug('endpoint:'+endpoint);
        logs.Endpoint__c = endpoint;
        logs.Service_Name__c = System.Label.INT_Search_Patient;
        HttpResponse res = http.send(req);
        logs.End_Datetime__c = DateTime.now();
        logs.Status_Code__c = String.valueOf(res.getStatusCode());
        System.debug('RESPONSE REQ:'+res.getBody());
        List<patientInfoData> tmpList = new List<patientInfoData>();
        System.debug(res.getStatusCode());
        if(res.getStatusCode() == 200 || res.getStatusCode() == 206){
            tmpList = (List<patientInfoData>) System.JSON.deserialize(res.getBody(), List<patientInfoData>.class);
            System.debug('tmpList : '+tmpList);
            patientInformation = tmpList;
            logs.Error_Message__c = null;
            logs.Is_Success__c = true;
        }else{
            system.debug(res.getStatusCode()+' : '+res.getBody() );
            logs.Error_Message__c = res.getBody();
            logs.Is_Success__c = false;
        }

        insert logs;
        if (req.getBody() != null && req.getBody() != ''){
            OnlineServiceLog.generateContentVersionRequest(logs,req.getBody());
        }else {
            OnlineServiceLog.generateContentVersionRequest(logs,endpoint);
        }
        if (res.getBody() != null && res.getBody() != '') {
            OnlineServiceLog.generateContentVersionResponse(logs,res.getBody());
        }
    }

}