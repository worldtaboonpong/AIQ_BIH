public without sharing class Preregistrationcls {
    public Document passport{get;set;}
    public Document thaiId{get;set;}
    public Case editCase{get;set;}
    public String newCaseStr { get; set;} 
    public String CaseID{get;set;}
    public Boolean Iseditableform{get;set;}
    public String caseNumber{get;set;}
    public String patientName{get;set;}
    public String pgLanguage{get;set;}
    
    public Preregistrationcls (ApexPages.StandardController controller){
        passport = new Document();
        thaiId = new Document();
        editCase = new Case();
        CaseID =  controller.getId();
        Iseditableform = false;
        
        String langParam = ApexPages.CurrentPage().getParameters().get('lang');
        pgLanguage = langParam != null ? langParam : 'en';
        
        init();
    }
    
    public void init() {
        if(CaseID != null && CaseID != ''){
            editCase = [
                Select Id,CaseNumber,Town_City_Thailand__c,PreRegistration__c,Title_Patient__c, Staying_In_Hotel__c,
                First_Name_Patient__c,Middle_Name_Patient__c,Last_Name_Patient__c,Date_Of_Birth_Patient__c,
                Gender_Patient__c,Nationality_New_Patient__c,Country_of_Ressidence_Patient__c,Preferred_Language_Patient__c,
                Thai_ID_Card_Number_Patient__c,Passport_Number_Patient__c,Primary_Phone_New_Patient__c,Email_New_Patient__c,
                Address_foreign__c,Town_City_foreign__c,State_Province_foreign__c,Postcode_foreign__c,Address_Thailand__c,
                State_Province_Thailand__c,Mobile_Number_In_Thailand__c, Town_City_Existing_Patient__c,District_Thailand__c, 
                State_Province_Existing_Patient__c,Postcode_Thailand__c,Health_Insurance_Co__c,MemberID__c,PolicyNumber__c,
                Sub_district_Thailand__c
                from Case where Id=:CaseID
            ];  
            
            caseNumber = editCase.CaseNumber;
            patientName = editCase.First_Name_Patient__c + ' ' +editCase.Last_Name_Patient__c;
            if(!editCase.PreRegistration__c){
                Iseditableform =  true;
            }else{
                Iseditableform =  false;
            }
            editCase.Staying_In_Hotel__c = (editCase.Staying_In_Hotel__c == null ? '' : editCase.Staying_In_Hotel__c);
            
                        newCaseStr =  String.escapeSingleQuotes(JSON.Serialize(editCase,true));
                    }
                }
    
    @RemoteAction
    public static String updateCase(String caseStr, String roomNo, String subDisForeign) {
        String returnUrl = Label.PreReg_Thank_URL;
        
        Case ca = (Case) JSON.deserialize(caseStr, Case.class);
        if (ca.Country_of_Ressidence_Patient__c != 'Thailand' && ca.Staying_In_Hotel__c == 'Yes' && roomNo != '') {
            ca.Address_foreign__c = (ca.Address_foreign__c != null && ca.Address_foreign__c != '' ? ca.Address_foreign__c+', ' : '') + roomNo;
        } else if (ca.Country_of_Ressidence_Patient__c != 'Thailand' && ca.Staying_In_Hotel__c == 'No' && subDisForeign != '') {
            ca.Address_foreign__c = (ca.Address_foreign__c != null && ca.Address_foreign__c != '' ? ca.Address_foreign__c+', ' : '') + subDisForeign;
        }
        ca.PreRegistration__c = true;
        update ca;
        
        List<Case> caseObjs = [SELECT Id, eConsent_Status__c, eConsent_Link__c FROM Case WHERE Id = :ca.Id];
        if (caseObjs.size() > 0 && caseObjs.get(0).eConsent_Link__c != null) {
            returnUrl = caseObjs.get(0).eConsent_Link__c;
        }
        return returnUrl;
    }
    
    @RemoteAction
    public static void fileUpload(String base64Data,String fileName,String CaseId) {
        //System.debug('File ' + base64Data);
        //System.debug('File Name==> ' + fileName);
        //System.debug('File Name==> ' + CaseId);
        
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = Encodingutil.base64Decode(base64Data.substring(base64Data.indexOf(',') + 1));//EncodingUtil.base64Decode(base64Data);
        cv.Title = fileName;
        cv.PathOnClient = filename;
        insert cv;
        
        //system.debug('cv' + cv.id);
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = CaseId;
        cdl.ShareType = 'V';
        insert cdl;
    }
        
    public String getGender() { 
        Map<String,String> options = new Map<String,String>();
        options.put('Female','Female');
        options.put('Male','Male');
        options.put('','--- Please select ---');
        return String.escapeSingleQuotes(JSON.serialize(options)); 
    }
    
    public String getTitles2() { 
        Map<String,String> options = new Map<String,String>();
        //options.put('Ambassador','Ambassador');     
        //options.put('Dr.','Dr.');
        options.put('Miss (Girl)','Miss (Girl)');
        options.put('Masters','Masters');
        options.put('Ms.','Ms.');
        options.put('Miss','Miss');
        options.put('Mrs.','Mrs.');
        options.put('Mr.','Mr.');
        options.put('','--- Please select ---');
        return String.escapeSingleQuotes(JSON.serialize(options)); 
    }
    
    public String getLanguages() {
        Map<String,String> options = new Map<String,String>();
        options.put('Vietnamese','Vietnamese');
        options.put('Thai','Thai');
        options.put('Russian','Russian');
        options.put('Korean','Korean');
        options.put('Japanese','Japanese');
        options.put('Hindi','Hindi');
        options.put('German','German');
        options.put('French','French');
        options.put('English','English');
        options.put('Chinese','Chinese');
        options.put('Cambodian','Cambodian');
        options.put('Burmese','Burmese');
        options.put('Bengali','Bengali');
        options.put('Arabic','Arabic');
        options.put('Amheric','Amheric');
        options.put('','--- Please select ---');
        return String.escapeSingleQuotes(JSON.serialize(options)); 
    }
    public String getPatientAllergy() { 
        Map<String,String> options = new Map<String,String>();
        options.put('No','No');
        options.put('Yes','Yes');
        options.put('','--- Please select ---');
        return String.escapeSingleQuotes(JSON.serialize(options));
    }
    public String getRelationship() { 
        Map<String,String> options = new Map<String,String>();
        options.put('Younger sister','Younger sister');
        options.put('Younger brother','Younger brother');
        options.put('Wife','Wife');
        options.put('Uncle','Uncle');
        options.put('Step-mother','Step-mother');
        options.put('Step-Father','Step-Father');
        options.put('Spouse','Spouse');
        options.put('Son-in-Law','Son-in-Law');
        options.put('Son','Son');
        options.put('Sister-in-Law','Sister-in-Law');
        options.put('Sister','Sister');
        options.put('Secretary','Secretary');
        options.put('Other','Other');
        options.put('Other Relative','Other Relative');
        options.put('Other Relative','Other Relative');
        options.put('Niece','Niece');
        options.put('Nephew','Nephew');
        options.put('Mother-in-law','Mother-in-law');
        options.put('Mother','Mother');
        options.put('Husband','Husband');
        options.put('Grandson','Grandson');
        options.put('Grandmother','Grandmother');
        options.put('Grandfather','Grandfather');
        options.put('Granddaughter','Granddaughter');
        options.put('Friend/ Neighbour','Friend/ Neighbour');
        options.put('Father-in-law','Father-in-law');
        options.put('Father','Father');
        options.put('Employer','Employer');
        options.put('Employee','Employee');
        options.put('Elder sister','Elder sister');
        options.put('Elder brother','Elder brother');
        options.put('Daughter-in law','Daughter-in law');
        options.put('Daughter','Daughter');
        options.put('Cousin','Cousin');
        options.put('Contact','Contact');
        options.put('Brother-in-law','Brother-in-law');
        options.put('Brother','Brother');
        options.put('Aunt','Aunt');
        options.put('','--- Please select ---');
        return String.escapeSingleQuotes(JSON.serialize(options)); 
    }
    public String getCountries() {
        /*options.put('Zimbabwe','Zimbabwe');
        options.put('Zambia','Zambia');
        options.put('Wales','Wales');
        options.put('Vietnam','Vietnam');
        options.put('Venezuela','Venezuela');
        options.put('Uruguay','Uruguay');
        options.put('United Arab Emirates','United Arab Emirates');
        options.put('Ukraine','Ukraine');
        options.put('Turkey','Turkey');
        options.put('Tunisia','Tunisia');
        options.put('Tonga','Tonga');
        options.put('Thailand','Thailand');
        options.put('Tajikistan','Tajikistan');
        options.put('Taiwan','Taiwan');
        options.put('Syria','Syria');
        options.put('Switzerland','Switzerland');
        options.put('Sweden','Sweden');
        options.put('Sudan','Sudan');
        options.put('Sri Lanka','Sri Lanka');
        options.put('Spain','Spain');
        options.put('South Korea','South Korea');
        options.put('South Africa','South Africa');
        options.put('Slovakia','Slovakia');
        options.put('Singapore','Singapore');
        options.put('Serbia','Serbia');
        options.put('Senegal','Senegal');
        options.put('Scotland','Scotland');
        options.put('Saudi Arabia','Saudi Arabia');
        options.put('Russia','Russia');
        options.put('Romania','Romania');
        options.put('Qatar','Qatar');
        options.put('Portugal','Portugal');
        options.put('Poland','Poland');
        options.put('Philippines','Philippines');
        options.put('Peru','Peru');
        options.put('Paraguay','Paraguay');
        options.put('Panama','Panama');
        options.put('Pakistan','Pakistan');
        options.put('Oman','Oman');
        options.put('Norway','Norway');
        options.put('Nigeria','Nigeria');
        options.put('Nicaragua','Nicaragua');
        options.put('New Zealand','New Zealand');
        options.put('Netherlands','Netherlands');
        options.put('Nepal','Nepal');
        options.put('Namibia','Namibia');
        options.put('Mozambique','Mozambique');
        options.put('Morocco','Morocco');
        options.put('Mongolia','Mongolia');
        options.put('Mexico','Mexico');
        options.put('Malta','Malta');
        options.put('Mali','Mali');
        options.put('Malaysia','Malaysia');
        options.put('Lithuania','Lithuania');
        options.put('Libya','Libya');
        options.put('Lebanon','Lebanon');
        options.put('Latvia','Latvia');
        options.put('Laos','Laos');
        options.put('Kuwait','Kuwait');
        options.put('Kenya','Kenya');
        options.put('Jordan','Jordan');
        options.put('Japan','Japan');
        options.put('Jamaica','Jamaica');
        options.put('Italy','Italy');
        options.put('Israel','Israel');
        options.put('Ireland','Ireland');
        options.put('Iraq','Iraq');
        options.put('Iran','Iran');
        options.put('Indonesia','Indonesia');
        options.put('India','India');
        options.put('Iceland','Iceland');
        options.put('Hungary','Hungary');
        options.put('Honduras','Honduras');
        options.put('Haiti','Haiti');
        options.put('Guatemala','Guatemala');
        options.put('Greece','Greece');
        options.put('Ghana','Ghana');
        options.put('Germany','Germany');
        options.put('France','France');
        options.put('Finland','Finland');
        options.put('Fiji','Fiji');
        options.put('Ethiopia','Ethiopia');
        options.put('Estonia','Estonia');
        options.put('England','England');
        options.put('El Salvador','El Salvador');
        options.put('Egypt','Egypt');
        options.put('Ecuador','Ecuador');
        options.put('Dominican Republic','Dominican Republic');
        options.put('Denmark','Denmark');
        options.put('Czech Republic','Czech Republic');
        options.put('Cuba','Cuba');
        options.put('Croatia','Croatia');
        options.put('Costa Rica','Costa Rica');
        options.put('Colombia','Colombia');
        options.put('China','China');
        options.put('Chile','Chile');
        options.put('Canada','Canada');
        options.put('Cameroon','Cameroon');
        options.put('Cambodia','Cambodia');
        options.put('Bulgaria','Bulgaria');
        options.put('Brazil','Brazil');
        options.put('Botswana','Botswana');
        options.put('Bolivia','Bolivia');
        options.put('Belgium','Belgium');
        options.put('Bangladesh','Bangladesh');
        options.put('Bahrain','Bahrain');
        options.put('Austria','Austria');
        options.put('Australia','Australia');
        options.put('Argentina','Argentina');
        options.put('Algeria','Algeria');
        options.put('Albania','Albania');
        options.put('Afghanistan','Afghanistan');*/
		List<PicklistWrapper> pwList = new List<PicklistWrapper>();
        for( Schema.PicklistEntry pv : Case.Country_of_Residence__c.getDescribe().getPicklistValues()){
            PicklistWrapper pw = new PicklistWrapper();
            pw.label = pv.getLabel();
            pw.value = pv.getValue();
            pwList.add(pw);
		}
        
        Map<String,String> options = new Map<String,String>();
        for(Integer count = pwList.size() - 1; count >= 0; count--){
            options.put(pwList.get(count).value, pwList.get(count).label);
        }
        options.put('','--- Please select ---');
        return String.escapeSingleQuotes(JSON.serialize(options)); 
    }
    
    public String getNationality() {  
        /*options.put('Zimbabwean','Zimbabwean');
        options.put('Zambian','Zambian');
        options.put('Yemeni','Yemeni');
        options.put('Vietnamese','Vietnamese');
        options.put('Venezuelan','Venezuelan');
        options.put('Uzbekistani','Uzbekistani');
        options.put('Uruguayan','Uruguayan');
        options.put('Ukrainian','Ukrainian');
        options.put('Ugandan','Ugandan');
        options.put('Turkish','Turkish');
        options.put('Tunisian','Tunisian');
        options.put('Thai','Thai');
        options.put('Tanzanian','Tanzanian');
        options.put('Taiwanese','Taiwanese');
        options.put('Swiss','Swiss');
        options.put('Swedish','Swedish');
        options.put('Sudanese','Sudanese');
        options.put('Sri Lankan','Sri Lankan');
        options.put('Spanish','Spanish');
        options.put('South African','South African');
        options.put('Somali','Somali');
        options.put('Slovakian','Slovakian');
        options.put('Singaporean','Singaporean');
        options.put('Seychellois','Seychellois');
        options.put('Serbia','Serbian');
        options.put('Senegalese','Senegalese');
        options.put('Saudi Arabian','Saudi Arabian');
        options.put('Russian','Russian');
        options.put('Romanian','Romanian');
        options.put('Qatari','Qatari');
        options.put('Portugees','Portugees');
        options.put('Polish','Polish');
        options.put('Peruvian','Peruvian');
        options.put('Paraguayan','Paraguayan');
        options.put('Panamanian','Panamanian');
        options.put('Pakistani','Pakistani');
        options.put('Omani','Omani');
        options.put('Norwegian','Norwegian');
        options.put('Nigerian','Nigerian');
        options.put('New Zealander','New Zealander');
        options.put('Nepalese','Nepalese');
        options.put('Namibian','Namibian');
        options.put('Moroccan','Moroccan');
        options.put('Montenegro','Montenegrin');
        options.put('Mongolian','Mongolian');
        options.put('Monacan','Monacan');
        options.put('Mexican','Mexican');
        options.put('Mauritian','Mauritian');
        options.put('Maldivan','Maldivan');
        options.put('Malaysian','Malaysian');
        options.put('Macau','Macau');
        options.put('Luxembourger','Luxembourger');
        options.put('Lithunian','Lithunian');
        options.put('Lebanese','Lebanese');
        options.put('Laotian','Laotian');
        options.put('Kuwaiti','Kuwaiti');
        options.put('Korean','Korean');
        options.put('Kenyan','Kenyan');
        options.put('Kazakhstani','Kazakhstani');
        options.put('Kazakhstani','Kazakhstani');
        options.put('Jordanian','Jordanian');
        options.put('Japanese','Japanese');
        options.put('Jamaican','Jamaican');
        options.put('Italian','Italian');
        options.put('Israeli','Israeli');
        options.put('Irish','Irish');
        options.put('Iraqi','Iraqi');
        options.put('Iranian','Iranian');
        options.put('Indonesian','Indonesian');
        options.put('Indian','Indian');
        options.put('Icelander','Icelander');
        options.put('Hungarian','Hungarian');
        options.put('Guyanese','Guyanese');
        options.put('Guinean','Guinean');
        options.put('Greek','Greek');
        options.put('Ghanaian','Ghanaian');
        options.put('German','German');
        options.put('Georgian','Georgian');
        options.put('French','French');
        options.put('Finnish','Finnish');
        options.put('Filipino','Filipino');
        options.put('Fijian','Fijian');
        options.put('Ethiopian','Ethiopian');
        options.put('Estonian','Estonian');
        options.put('Emirati','Emirati');
        options.put('Egyptian','Egyptian');
        options.put('Ecuadorean','Ecuadorean');
        options.put('Dutch','Dutch');
        options.put('Dominican','Dominican');
        options.put('Danish','Danish');
        options.put('Czech','Czech');
        options.put('Cypriot','Cypriot');
        options.put('Cuban','Cuban');
        options.put('Croatian','Croatian');
        options.put('Costa Rican','Costa Rican');
        options.put('Congolese','Congolese');
        options.put('Columbian','Columbian');
        options.put('Chinese','Chinese');
        options.put('Chinese','Chinese');
        options.put('Chilean','Chilean');
        options.put('Chadian','Chadian');
        options.put('Canadian','Canadian');
        options.put('Cameroonian','Cameroonian');
        options.put('Cambodian','Cambodian');
        options.put('Burmese','Burmese');
        options.put('Bulgarian','Bulgarian');
        options.put('Brunei','Brunei');
        options.put('British','British');
        options.put('Brazilian','Brazilian');
        options.put('Bolivian','Bolivian');
        options.put('Bhutanese','Bhutanese');
        options.put('Bermuda','Bermuda');
        options.put('Belizean','Belizean');
        options.put('Belgian','Belgian');
        options.put('Belarusian','Belarusian');
        options.put('Barbadian','Barbadian');
        options.put('Bangladeshi','Bangladeshi');
        options.put('Bahrainian','Bahrainian');
        options.put('Bahameese','Bahameese');
        options.put('Austrian','Austrian');
        options.put('Australian','Australian');
        options.put('Arubian','Arubian');
        options.put('Armenian','Armenian');
        options.put('Argentine','Argentine');
        options.put('Antarctic','Antarctic');
        options.put('Anguillan','Anguillan');
        options.put('Angolian','Angolian');
        options.put('Andorian','Andorian');
        options.put('American','American');
        options.put('Afghani','Afghani');*/
        List<PicklistWrapper> pwList = new List<PicklistWrapper>();
        for( Schema.PicklistEntry pv : Account.Nationality__c.getDescribe().getPicklistValues()){
            PicklistWrapper pw = new PicklistWrapper();
            pw.label = pv.getLabel();
            pw.value = pv.getValue();
            pwList.add(pw);
		}
        
        Map<String,String> options = new Map<String,String>();
        for(Integer count = pwList.size() - 1; count >= 0; count--){
            options.put(pwList.get(count).value, pwList.get(count).label);
        }
        options.put('','--- Please select ---');
        return String.escapeSingleQuotes(JSON.serialize(options)); 
    } 
    
    public class PicklistWrapper {
        public String label {get; set;}
        public String value {get; set;}
    }
}