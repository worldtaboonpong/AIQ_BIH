public class AppointmentCardPDF {
	public String caseId {get; set;} 
    public Boolean isCopy {get; set;} 
    public Case currentObject {get;set;}
    public Invitation_Letter__c letterObj {get;set;}
    public List<Invitation_Letter_Person__c> patientObj {get;set;}
    public List<Invitation_Letter_Person__c> attendantObj {get;set;}
    
    public List<Appointment__c> apptObj {get;set;}
    
    
    
    public String img_signature {get;set;}
    public String name_signature {get;set;}
    public String pos_signature {get;set;}
    
    public String Hospital_Number_HN {get;set;}
    public String Salutation {get;set;}
    public String Name {get;set;}
    public Date DOB {get;set;}
    public String Age {get;set;}
    public String Barcode {get;set;}
    
    Integer page = 0;
        
    //public String HN_Barcode {get;set;}
    public Integer pageSize {get;set;}
    public Map<Integer, PagesWrapper> mapPageWrapper {get;set;}
    public List<LineItemsWrapper> itemsWrapper {get;set;}
    
    public AppointmentCardPDF(){
        isCopy = false;
        img_signature = BIH_Constants.SIGNATURE_INVITATION_LETTER;
        name_signature =BIH_Constants.NAME_INVITATION_LETTER;
        pos_signature= BIH_Constants.POSITION_INVITATION_LETTER;
     
 
        caseId = ApexPages.currentPage().getParameters().get('id');
        isCopy = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isCopy'));
        
        
        apptObj = [SELECT Id,Account__r.Hospital_Number_HN__c,Account__r.Salutation, Account__r.Name,HN_Barcode__c, Account__r.PersonBirthdate, Account__r.Age__c,
                   Appointment_Date__c,Appointment_Time__c, Doctor__c, Location__c,Patient_Letter_Notes__c  from Appointment__c where Case__c =: caseId order by Appointment_Date__c,Appointment_Time__c];
       	Hospital_Number_HN = apptObj[0].Account__r.Hospital_Number_HN__c;
        Salutation = apptObj[0].Account__r.Salutation;
        Name = apptObj[0].Account__r.Name;
        DOB = apptObj[0].Account__r.PersonBirthdate;
        Age = apptObj[0].Account__r.Age__c; 
        
        String barcodelink = 'https://bwipjs-api.metafloor.com/?bcid=code128&text='+Hospital_Number_HN+'&scale=2&rotate=N&includetext&backgroundcolor=ffffff';
        Barcode = barcodelink; 
        System.debug('*********barcodelink*******'+barcodelink);
        //HN_Barcode = apptObj[0].Account__r.Hospital_Number_HN__c;
        
        letterObj = [SELECT Id,RefCase__c, Generate_Date__c, LetterDear__c,LetterFrom__c, LetterTo__c, LetterSubject__c,LetterCountry__c,LetterCountryText__c, LetterRefNo__c, Content__c, Version__c, Doc_Type__c, Case__c,LetterEmbassyType__c FROM Invitation_Letter__c WHERE Case__r.Id =:caseId ORDER BY LastModifiedDate Desc LIMIT 1];
        List<Invitation_Letter_Person__c> tmpIlp = [SELECT LastModifiedDate,Person_Name__c, Passport_Number__c, Appointment_Date__c, Specialty__c, 
                                                    Person_Type__c, Invitation_Letter__c, Id FROM Invitation_Letter_Person__c WHERE Invitation_Letter__r.Id=:letterObj.Id];
        System.debug(letterObj);
        System.debug(tmpIlp);
        List<Invitation_Letter_Person__c> pObj = new List<Invitation_Letter_Person__c>();
        List<Invitation_Letter_Person__c> aObj = new List<Invitation_Letter_Person__c>();
        for(Invitation_Letter_Person__c tmp :tmpIlp){
             System.debug('---tmp---');
            if(tmp.Person_Type__c == 'Patient'){
                pObj.add(tmp);
            }else{
                aObj.add(tmp);
            }
        }
        if(pObj.size() == 0){
            pObj.add(new Invitation_Letter_Person__c());
        }
        // if(aObj.size() == 0){
        //     aObj.add(new Invitation_Letter_Person__c());
        // }
        patientObj = pObj;
        attendantObj = aObj;
        
        
        ////
        //
        //1, items
        //2, items
       	mapPageWrapper = new Map<Integer, PagesWrapper>();
        
        Integer itemperpage = 4;
        Integer i = 1;
        Integer modItems = math.mod(apptObj.size(), itemperpage);
        Integer pages = modItems > 0 ?  (apptObj.size()/ itemperpage) + 1 : (apptObj.size()/ itemperpage);
        System.debug('********apptObj.size()*******'+apptObj.size());
        System.debug('********pages*******'+pages);
        this.pageSize = pages; 
        Integer startIdx = 0;
        for (Integer p = 1; p <= pages; p++)
        {
             PagesWrapper wpage = new PagesWrapper();
            itemsWrapper = new List<LineItemsWrapper>();
            

            for (Integer idx = startIdx; idx < (p*itemperpage); idx++){
                if(idx < apptObj.size()) {
                    Appointment__c item = apptObj[idx];
                    LineItemsWrapper lw = new LineItemsWrapper();
                    
                    //lw.datestr =String.valueof(item.Appointment_Date__c).format('dd-MM-yyyy');
                    lw.datestr = item.Appointment_Date__c.day() + '/' + item.Appointment_Date__c.month() + '/' + item.Appointment_Date__c.year();
                    lw.timestr = item.Appointment_Time__c;
                    lw.care1 = item.Doctor__c; 
                    lw.care2 =item.Location__c;
                    lw.care3 =item.Patient_Letter_Notes__c;
                    System.debug('********count line*******'+item.Patient_Letter_Notes__c.countMatches('\n'));
                    itemsWrapper.add(lw);
                }
            }
            startIdx=(p*itemperpage);
            wpage.lineitems = itemsWrapper;
            
            mapPageWrapper.put(p, wpage);
            
        }
        System.debug('********mapPageWrapper*******'+mapPageWrapper.size());
        
    }       
    
    public class PagesWrapper{
        public List<LineItemsWrapper> lineitems {get;set;} 
    }
    
    public class LineItemsWrapper{
        @AuraEnabled
        public String datestr {get;set;}
        @AuraEnabled
        public String timestr {get;set;}
        @AuraEnabled
        public String care1 {get;set;}
        @AuraEnabled
        public String care2 {get;set;}
        @AuraEnabled
        public String care3 {get;set;}
    }
    
    



}