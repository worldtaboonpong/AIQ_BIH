public without sharing class BIH_OnlineRegistrationFormCtrl /*implements Queueable*/{
    //Map<String, Object> payload;

    public static BIH_OnlineRegistrationFormService.PostResponse savePatientRegistrationForm(Map<String, Object> payload){
        BIH_OnlineRegistrationFormService.PostResponse res = new BIH_OnlineRegistrationFormService.PostResponse();
        BIH_OnlineRegistrationFormService.FormInfo data = new BIH_OnlineRegistrationFormService.FormInfo();
		// proceed to insert patient registration form object
        System.debug('>> req body: '+payload);
        try{
        	Patient_Registration_Form__c form = new Patient_Registration_Form__c(
                Title__c = (String)payload.get('title'),
                First_Name__c = (String)payload.get('firstname'),
                Middle_Name__c = (String)payload.get('middlename'),
                Last_Name__c = (String)payload.get('lastname'),
                Date_of_Birth__c = Date.Valueof((String)payload.get('dob')),
                Gender__c = (String)payload.get('gender'),
                Nationality__c = (String)payload.get('nationality'),
                Country_of_Residence__c = (String)payload.get('countryOfResidence'),
                Preferred_Language__c = (String)payload.get('preferredLanguage'),
                Passport_or_Thai_ID_Card_Number__c = (String)payload.get('passportOrThaiIDCardNumber'),
                Primary_Phone_Number__c = (String)payload.get('primaryPhoneNumber'),
                Email__c = (String)payload.get('email'),
                Client__r = getAccountByHN((String)payload.get('hnnumber')),
                Address__c = (String)payload.get('address'),
                Sub_District__c = (String)payload.get('subdistrict'),
                District__c = (String)payload.get('district'),
                Province__c = (String)payload.get('province'),
                Postcode__c = (String)payload.get('postcode'),
                Are_you_staying_in_a_hotel__c = (Boolean)payload.get('stayInHotel') != null ? (Boolean)payload.get('stayInHotel') : false,
                Name_of_Hotel_Building__c = (String)payload.get('nameOfHotel'),
                Hotel_Room_Number__c = (String)payload.get('hotelRoomNumber'),
                Thai_Province__c = (String)payload.get('thaiProvince'),
                Mobile_Number_in_Thailand__c = (String)payload.get('thaiMobileNumber'),
                Thai_Address__c = (String)payload.get('thaiAddress'),
                Thai_District__c = (String)payload.get('thaiDistrict'),
                Thai_Sub_District__c = (String)payload.get('thaiSubdistrict'),
                Thai_Postcode__c = (String)payload.get('thaiPostcode'),
                Emerg_First_Name__c = (String)payload.get('emergFirstname'),
                Emerg_Last_Name__c = (String)payload.get('emergLastname'),
                Emerg_Contact_Phone__c = (String)payload.get('emergContactPhone'),
                Emerg_Relation_to_Patient__c = (String)payload.get('emergRelation'),
                Do_you_have_Insurance__c = (Boolean)payload.get('haveInsurance') != null? (Boolean)payload.get('haveInsurance') : false,
                Name_of_Insurance_Company__c = (String)payload.get('nameOfInsuranceCompany'),
                Policy_Number__c = (String)payload.get('policyNumber'),
                Group_Number__c = (String)payload.get('groupNumber'),
                Submitted_Date_Time__c = DateTime.ValueofGMT(((String)payload.get('submitDateTime')).replace('T', ' ')),
                Case__c = (String)payload.get('caseId') != null? (String)payload.get('caseId') : null,
                Hospital_Number_HN__c = (String)payload.get('hnnumber') != null? (String)payload.get('hnnumber') : null,
                OwnerId = getQueueId()
            ); 
            
            insert form;
             
            
            if(payload.containsKey('passportOrThaiIDCardCopy')){
                List<Object> passportFileList = new List<Object>();
                passportFileList = (List<Object>)payload.get('passportOrThaiIDCardCopy');
                for(Object file : passportFileList){
                    Map<String, Object> f = (Map<String, Object>)file;
                    uploadFile((String)f.get('fileBase64'),(String)f.get('filename'),form.Id);
                }
            }
    
            if(payload.containsKey('insuranceCardCopy')){
                List<Object> insuranceFileList = new List<Object>();
                insuranceFileList = (List<Object>)payload.get('insuranceCardCopy');
                for(Object file : insuranceFileList){
                    Map<String, Object> f = (Map<String, Object>)file;
                    uploadFile((String)f.get('fileBase64'),(String)f.get('filename'),form.Id);
                }
            }  
            
            /*String resultJson = JSON.serialize(new Map<String, Object>{
                'record' => form
            });*/
            data.form = form;
            
            res.success = true;
            res.code = 200;
            res.message = 'SUCCESS';
            res.data = data;
            return res;
            
        } catch(Exception ex) {
            res.success = false;
            res.code = 500;
            res.message = 'ERROR: '+ex.getMessage(); system.debug('error:'+res.message);
            return res;
        }
        
    }
    
    /*public void execute(System.QueueableContext scope){
        
        
    }*/

    // mapping account with HN to client field
    public static Account getAccountByHN(String hnnumber){
        List<Account> accList = new List<Account>([SELECT Id FROM Account WHERE Hospital_Number_HN__c =: hnnumber]);
        if(accList.size() > 0){
            Account acct = new Account();
            for(Account acc : accList){
                Account accNew = new Account(Hospital_Number_HN__c = hnnumber);
                acct = accNew;
            }
            return acct;
        }else{
            return null;
        }
    } 

    // mapping case with HN Number to case field
    /*public static Case getCaseByHNnumber(String hnnumber){
        List<Case> caseList = new List<Case>([SELECT Id FROM Case WHERE Hospital_Number_HN__c =: hnnumber]);
        if(caseList.size() > 0){
            Case cas = new Case();
            for(Case c : caseList){
                Case cNew = new Case(Hospital_Number_HN__c = hnnumber);
                cas = cNew;
            }
            return cas;
        }else{
            return null;
        }
    }*/ 

    // get Call Agent Team queue
    public static Id getQueueId (){
        Set<Id> qids = (new Map<Id, Group>([SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Call_Agent_Team'])).keySet();
        if(qids.size() > 0){
            Id qid = new List<Id> (qids).get(0);
            return qid;
        }
        return UserInfo.getUserId();
    }

    public static void uploadFile(String base64, String filename, String recordId) {
        ContentVersion cv = createContentVersion(base64, filename);
        ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
        //if (cv == null || cdl == null) { return null; }
        //return cdl.Id;
    }

    public static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
          insert cv;
          return cv;
        } catch(DMLException e) {
          System.debug(e);
          return null;
        }
    }

    public static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        // ShareType is either 'V', 'C', or 'I'
        // V = Viewer, C = Collaborator, I = Inferred
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
}