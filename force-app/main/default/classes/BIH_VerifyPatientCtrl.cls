public without sharing class BIH_VerifyPatientCtrl {
    // public BIH_VerifyPatientCtrl() {
        
    // }
    public class ResponVerifyWrapper{
        @AuraEnabled
        public List<BIH_PatientInformationService.patientInfoData> patientList {get;set;}
        @AuraEnabled
        public String ErrorMessage {get;set;}
    }
    @AuraEnabled
    public static ResponVerifyWrapper getAccountByHN(String hnNumber,String Firstname,String Lastname,String Email,String DateOfBirth,String Gender){
        ResponVerifyWrapper rbw = new ResponVerifyWrapper();
        List<BIH_PatientInformationService.patientInfoData> pTnfo = new List<BIH_PatientInformationService.patientInfoData>();

        try {
            if(hnNumber != null  || Firstname != null  || Lastname != null || Email != null || DateOfBirth != null || Gender != null){
                if(hnNumber != null && hnNumber.length() > 8){
                    System.debug('-- Only HN Number --');
                    BIH_PatientInformationService.getPatientInformation(hnnumber);
                }else{
                    System.debug('-- By Part of String --');
                    BIH_PatientInformationService.getPatientInformation(Firstname,Lastname,Email,DateOfBirth,Gender);
                }
                pTnfo = BIH_PatientInformationService.patientInformation;
                System.debug(rbw);
            }else{
                rbw.ErrorMessage = 'There is no patient information to verify ';
            }
            rbw.patientList = pTnfo;
            return rbw;
        } catch (Exception e) {
            rbw.ErrorMessage = e.getMessage();
            System.debug(e.getMessage());
            return rbw;    
        }        
    }
    @AuraEnabled
    public static Account getAccountByName(String name){
        string tmp = '%'+name+'%';
        try {
            return null;//[SELECT Id, Name, LastName,Hospital_Number_HN__c, PersonBirthdate,RecordTypeId ,RO_Expiry_Date__c,Country__c,RecordType.DeveloperName FROM Account WHERE Name LIKE:tmp LIMIT 1];
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;    
        }        
    }
    @AuraEnabled
    public static Account verifyAccountByHN(BIH_PatientInformationService.patientInfoData infoObj){
        // BIH_PatientInformationService.patientInfoData pTnfo = new BIH_PatientInformationService.patientInfoData();
        System.debug(infoObj);
        Account tmpacc = new Account();
        BIH_PatientInformationService.patientInfoData pInfo = new BIH_PatientInformationService.patientInfoData();
        BIH_PatientInformationService.getPatientInformation(infoObj.hn);
        pInfo = BIH_PatientInformationService.patientInformation[0]; 
        System.debug('--verifyAccountByHN-- pInfo : '+pInfo); 
        String regEmailPatten = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Boolean isRegEmail = Pattern.matches(regEmailPatten,pInfo.email);
        Boolean isRegEmail2 = Pattern.matches(regEmailPatten,pInfo.email2);
        try{
            if(pInfo!=null){
            
            List<Account> accObj = [SELECT Id,Note__c, Name,LastName,Email2__c,Hospital_Number_HN__c,PersonEmail, PersonBirthdate,Gender__c,RecordTypeId ,RO_Expiry_Date__c,Country__c,RecordType.DeveloperName FROM Account WHERE Hospital_Number_HN__c=:pInfo.hn ORDER BY LastModifiedDate DESC];
            System.debug('accObj : '+accObj.size());
            System.debug('accObj : '+accObj);
            if(accObj.size() > 0){
                tmpacc.id = accObj[0].id;
                tmpacc.Hospital_Number_HN__c = accObj[0].Hospital_Number_HN__c;
            }else{
                tmpacc.Hospital_Number_HN__c = pInfo.hn;
            }
           
            
            tmpacc.Salutation = pInfo.title;
            tmpacc.firstName = pInfo.firstName;
            tmpacc.lastName = pInfo.lastName;
            tmpacc.Gender__c = pInfo.gender;
            tmpacc.Phone = pInfo.mobilePhone;
            tmpacc.PersonHomePhone = pInfo.homePhone;
            tmpacc.Nationality__c = pInfo.nationality;
            if(pInfo.nationality == 'Thai' && pInfo.idCardNumber != '' && pInfo.idCardNumber != null ){
                tmpacc.National_ID_Passport_Number__c = pInfo.idCardNumber;
            }else{
                tmpacc.National_ID_Passport_Number__c = pInfo.passportNumber;
            }
            // if(pInfo.passportNumber != null && pInfo.passportNumber != ''){
            //     tmpacc.National_ID_Passport_Number__c = pInfo.passportNumber;
            // }else{
            //     tmpacc.National_ID_Passport_Number__c = pInfo.idCardNumber;
            // }
            tmpacc.Country__c = pInfo.country;
            tmpacc.Country_of_Residence__c = pInfo.countryOfResident;
            tmpacc.Preferred_Language__c = pInfo.preferredLanguage;
            
            tmpacc.Office_Phone__c = pInfo.officePhone;
            tmpacc.TrakCare_Note__c = pInfo.note;
            tmpacc.Local_First_Name__c = pInfo.localFirstName;
            tmpacc.Local_Last_Name__c = pInfo.localLastName;
            tmpacc.Loyalty_Code__c = pInfo.loyaltyCode;
            tmpacc.Loyalty_Description__c = pInfo.loyaltyDescription;
            tmpacc.V_Address__c = pInfo.address;
            tmpacc.V_City_Area__c = pInfo.cityArea;
            tmpacc.V_Suburb__c = pInfo.suburb;
            tmpacc.V_State__c = pInfo.state;
            tmpacc.V_postCode__c = pInfo.postCode;
            tmpacc.V_Foreign_PostCode__c = pInfo.foreignPostCode;
            tmpacc.V_Expiry_Date__c =  pInfo.payDateTo;       
            tmpacc.V_Health_Insurance_Company__c = pInfo.payor;
            tmpacc.V_Policy_Number__c = pInfo.policyNo;
            tmpacc.V_Member_ID__c = pInfo.memberID;
            
            tmpacc.is_Verified__c = true;
            tmpacc.Verified_Date__c = Datetime.now();
            if(pInfo.alertMessages.size() > 0){
                string tmpstring ='';
                for(BIH_PatientInformationService.alertMessages am: pInfo.alertMessages){
                    tmpstring += tmpacc.Note__c+'\n\n code : '+am.code;
                    tmpstring +=  '\n description : '+am.description;
                    tmpstring +=  '\n message : '+am.message;
                    tmpstring +=  '\n type : '+am.type;
                }
                tmpacc.Note__c = tmpstring;
            }
             if(!isRegEmail && pInfo.email != ''){
                tmpacc.Note__c  = (tmpacc.Note__c != null ? tmpacc.Note__c : '')+'\n\n Email is Invaild format : '+pInfo.email;
            } else{
                tmpacc.PersonEmail = pInfo.email;
            }
            //Main Website Phase not use
            /*if(!isRegEmail2 && pInfo.email2 != ''){
                tmpacc.Note__c  = (tmpacc.Note__c != null ? tmpacc.Note__c : '') +'\n\n Email2 is Invaild format : '+pInfo.email2;
            } else{
                tmpacc.Email2__c = pInfo.email2;
            }*/
            if(pInfo.dateOfBirth != null && pInfo.dateOfBirth !=''){
                tmpacc.PersonBirthdate = Date.ValueOf(pInfo.dateOfBirth);
            }else{
                // tmpacc.PersonBirthdate = Date.ValueOf(pInfo.dateOfBirth);
                tmpacc.Note__c  = tmpacc.Note__c+'\n\nDate is Empty.';
            }
            
            upsert tmpacc;

            System.debug(pInfo.gender);
            System.debug(tmpacc);
            
                // account testacc = [SELECT id,Name From Account WHERE id=:tmpacc.id];
                //  System.debug('tmpacc : '+testacc);
            }
        }catch(DMLException error){
            Boolean canSave = true;
            DMLException errorTmp = error;
            String note = (tmpacc.Note__c != null && tmpacc.Note__c != '') ? tmpacc.Note__c : '';
            system.debug('errorTmp : '+errorTmp);
            //system.debug('errorTmp : '+errorTmp.getDmlFieldNames(0));
            do{ 
                try{
                    if(errorTmp.getDmlFieldNames(0).size()>0){
                        System.debug('error.getDmlFieldNames(0) : '+errorTmp.getDmlFieldNames(0));
                        tmpacc.put(errorTmp.getDmlFieldNames(0).get(0),'');
                        note += '\n\n'+ errorTmp.getDmlMessage(0) + ' (Field : '+errorTmp.getDmlFieldNames(0)+')';
                    }else if(String.valueof(errorTmp).contains('FIELD_INTEGRITY_EXCEPTION')){
                        string fieldname = String.valueof(errorTmp).substringBetween('\"','\"');
                        system.debug('fieldname : '+fieldname);
                        if(fieldname.contains('.')){
                            system.debug( fieldname.split('\\.'));
                            fieldname = fieldname.split('\\.')[1];
                        }
                        tmpacc.put(fieldname,'');
                        note += '\n\n'+ System.Label.Verify_Patient_ERR_001 + ' (Field : '+fieldname+')';
                    }
                    // tmpacc[error.getDmlFieldNames(0)] = null;
                    tmpacc.Note__c = note;
                    upsert tmpacc;
                    canSave = true; 
  

                }catch(DMLException error2){
                    errorTmp = error2;
                    canSave = false;
                }
            }while(!canSave);
            
        }
            tmpacc.Name = pInfo.fullName;
        
        
        String sTmp = 'tmpacc';
        sTmp += ' ';
        sTmp += ':';
        sTmp += ' ';
        sTmp += '';
        sTmp += '';
        sTmp += '';
        sTmp += '';
        sTmp += '';
        sTmp += '';
        sTmp += '';
        sTmp += '';
        sTmp += '';
        sTmp += '';
        sTmp += '';
        sTmp += '';
        sTmp += '';
        sTmp += '';
        sTmp += '';
        System.debug('sTmp : '+tmpacc);
        
        return tmpacc;
    }
}