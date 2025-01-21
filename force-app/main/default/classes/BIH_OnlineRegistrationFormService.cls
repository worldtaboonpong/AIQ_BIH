@RestResource(urlMapping='/onlineRegistrationForm/*')
global without sharing class BIH_OnlineRegistrationFormService {
    
    global class GetResponse {
        global  Boolean success {get; set;}
        global  Integer code {get; set;}
        global  String message {get; set;}
        global  CaseInfo data {get;set;}
    }

    global class CaseInfo {
        global String caseId {get;set;}
        global String title {get;set;}
        global String firstname {get;set;}
        global String middlename {get;set;}
        global String lastname {get;set;}
        global String phonenumber {get;set;}
        global String hnnumber {get;set;}
        global Date dob {get;set;}
        global String email {get;set;}
        global String gender {get;set;}
        global String nationality {get;set;}
        global String residence {get;set;}
        global String taskId {get;set;}
        global DateTime urlExpiryDateTime {get;set;}
        global String threadId {get;set;}
    }

    global class PostResponse {
        global  Boolean success {get; set;}
        global  Integer code {get; set;}
        global  String message {get; set;}
        global  FormInfo data {get;set;}
    }

    global class FormInfo {
        global Patient_Registration_Form__c form {get;set;}
    }

    @httpGet
    global static GetResponse http_get(){ 
        RestRequest req = RestContext.request;
        GetResponse res = new GetResponse(); 
        CaseInfo data = new CaseInfo();
        String caseId = req.params.get('id');
        List<Case> result = new List<Case>([SELECT Id, Sender_First_Name__c,Account.MiddleName,Account.Salutation, Sender_Last_Name__c, 
                                                    Gender__c,Account_Gender__c, Date_of_Birth__c, Nationality__c,Phone__c,Hospital_Number_HN__c,
                                                    Country_of_Residence__c, SuppliedEmail,Case_Thread_Id__c,Account_First_Name__c,Account_Last_Name__c
                        FROM Case 
                        WHERE Id =: caseId]);
        if(result.size() >0){
            List<Task> task = new List<Task>([SELECT Id,URL_Expiry_DateTime__c FROM Task WHERE WhatId =: caseId ORDER BY CreatedDate DESC NULLS LAST LIMIT 1]);
            if(task.size() > 0){
               if(task.get(0).URL_Expiry_DateTime__c >= System.Now() ){
                   
                    data.caseId = result.get(0).Id;
                    data.firstname = result.get(0).Account_First_Name__c;
                    data.lastname = result.get(0).Account_Last_Name__c;
                   	data.phonenumber = result.get(0).Phone__c;
                   	data.hnnumber = result.get(0).Hospital_Number_HN__c;
                    data.dob = result.get(0).Date_of_Birth__c;
                    data.email = result.get(0).SuppliedEmail;
                    data.gender = result.get(0).Account_Gender__c;
                    data.nationality = result.get(0).Nationality__c;
                    data.residence = result.get(0).Country_of_Residence__c;
                   	data.taskId = task.get(0).Id;
                    data.urlExpiryDateTime = task.get(0).URL_Expiry_DateTime__c;
                   	data.threadId = result.get(0).Case_Thread_Id__c;
                   
                    res.success = true;
                    res.code = 200;
                    res.message = 'SUCCESS';
                    res.data = data;
                    return res;
                
                }else {
                    data.taskId = task.get(0).Id;
                    data.urlExpiryDateTime = task.get(0).URL_Expiry_DateTime__c;

                    res.success = false;
                    res.code = 403;
                    res.message = 'URL EXPIRED';
                    res.data = data;
                    return res;
                } 
            }else {
               		data.caseId = result.get(0).Id;
                    data.firstname = result.get(0).Account_First_Name__c;
                    data.lastname = result.get(0).Account_Last_Name__c;
                   	data.phonenumber = result.get(0).Phone__c;
                   	data.hnnumber = result.get(0).Hospital_Number_HN__c;
                    data.dob = result.get(0).Date_of_Birth__c;
                    data.email = result.get(0).SuppliedEmail;
                    data.gender = result.get(0).Account_Gender__c;
                    data.nationality = result.get(0).Nationality__c;
                    data.residence = result.get(0).Country_of_Residence__c;
                   	data.threadId = result.get(0).Case_Thread_Id__c;
                   
                    res.success = true;
                    res.code = 200;
                    res.message = 'SUCCESS';
                    res.data = data;
                    return res;
            }
        }else {
            res.success = false;
            res.code = 404;
            res.message = 'NOT FOUND';
            res.data = null;
            return res;
        }
    }

    @HttpPost
    global static PostResponse http_post() {
        RestRequest req = RestContext.request;
        //RestResponse res = RestContext.response;
        PostResponse res = new PostResponse();
        Map<String, Object> payload = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());
        
        if(payload.containsKey('passportOrThaiIDCardCopy')){
            List<Object> passportFileList = new List<Object>();
            passportFileList = (List<Object>)payload.get('passportOrThaiIDCardCopy');
            for(Object file : passportFileList){
                Map<String, Object> f = (Map<String, Object>)file;
                if(!f.containsKey('fileBase64') || !f.containsKey('filename') || 
                    String.isBlank((String)f.get('fileBase64')) || String.isBlank((String)f.get('filename')) ){

                    res.success = false;
                    res.code = 402;
                    res.message = 'MISSING FILE INFORMATION';
                    return res;
                }
            }     
        }
        
        if(payload.containsKey('insuranceCardCopy')){
            List<Object> insuranceFileList = new List<Object>();
            insuranceFileList = (List<Object>)payload.get('insuranceCardCopy');
            for(Object file : insuranceFileList){
                Map<String, Object> f = (Map<String, Object>)file;
                if(!f.containsKey('fileBase64') || !f.containsKey('filename') || 
                    String.isBlank((String)f.get('fileBase64')) || String.isBlank((String)f.get('filename'))){
                    
                    res.success = false;
                    res.code = 402;
                    res.message = 'MISSING FILE INFORMATION';
                    return res;
                }
            }     
        }

        // check required field
        if(payload.containsKey('firstname')  && String.isNotBlank((String)payload.get('firstname')) && 
            payload.containsKey('lastname') && String.isNotBlank((String)payload.get('lastname')) && payload.containsKey('email') && String.isNotBlank((String)payload.get('email')) && 
            payload.containsKey('submitDateTime') && String.isNotBlank((String)payload.get('submitDateTime'))){
            
            res = BIH_OnlineRegistrationFormCtrl.savePatientRegistrationForm(payload);
            return res;
        }
        // missing required field. 
        else {
            res.success = false;
            res.code = 401;
            res.message = 'MISSING REQUIRED FIELD';
            return res;
        }
        
    }
    
}