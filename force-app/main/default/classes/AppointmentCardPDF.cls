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
    public String DOB1 {get;set;}
    public String AgeInYearsMonthsDays {get;set;}
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
        
        Mapping_Salutation__mdt[] mappings = [SELECT Salutation_Eng__c, Salutation_Thai__c FROM Mapping_Salutation__mdt];
        
        apptObj = [SELECT Id,Account__r.Hospital_Number_HN__c,Account__r.Salutation, Account__r.Name,HN_Barcode__c, Account__r.PersonBirthdate, Account__r.Age__c,
                   Appointment_Date__c,Appointment_Time__c,Non_fixed_Time__c , Doctor__c, Location__c,Patient_Letter_Notes__c,Account__r.Nationality__c,
                   Account__r.Local_First_Name__c, Account__r.Local_Last_Name__c, Account__r.Local_Middle_Name__c from Appointment__c where Case__c =: caseId and Appointment_Status__c != 'Cancelled'and Appointment_Date__c >= TODAY order by Appointment_Date__c,Appointment_Time__c];
       
        for (Appointment__c appt : apptObj) {
            for (Mapping_Salutation__mdt mapping : mappings) {
                if (appt.Account__r.Salutation == mapping.Salutation_Eng__c) {
                   Salutation = mapping.Salutation_Thai__c;
                    break; // Exit the loop once a match is found
                }
            }
        }
        
        if (!apptObj.isEmpty()) {
            Hospital_Number_HN = apptObj[0].Account__r.Hospital_Number_HN__c;
        } 
        
        if (apptObj[0].Account__r.Nationality__c != null) {
            if (apptObj[0].Account__r.Nationality__c == 'Thai') {
                if (apptObj[0].Account__r.Local_First_Name__c != null ) {
                    if (Salutation != null) {
                        Name = Salutation+' '+apptObj[0].Account__r.Local_First_Name__c+' '+apptObj[0].Account__r.Local_Last_Name__c;
                    }else{
                        Name = apptObj[0].Account__r.Local_First_Name__c+' '+apptObj[0].Account__r.Local_Last_Name__c;
                    }
                    
                } else {
                    Name = apptObj[0].Account__r.Salutation+' '+apptObj[0].Account__r.Name;
                }
            } else {
                Name = apptObj[0].Account__r.Salutation+' '+apptObj[0].Account__r.Name;
            }
        } else {
            Name = apptObj[0].Account__r.Salutation+' '+apptObj[0].Account__r.Name;
        }
        
        
        // Calculate age in years, months, and days
        /*
        Date today = Date.today();
        Date birthdate = apptObj[0].Account__r.PersonBirthdate;
        Integer years = today.year() - birthdate.year();
        Integer months = today.month() - birthdate.month();
        Integer days = today.day() - birthdate.day();
        if (days < 0) {
            months--;
            days += Date.daysInMonth(birthdate.year(), birthdate.month());
        }
        
        if (months < 0) {
            years--;
            months += 12;
        }

        // Format the age
        AgeInYearsMonthsDays  = years + 'Y ' + months + 'M ' + days + 'D';
		*/
        Integer days = 0;
        Integer months = 0;
        Integer years = 0;
        Date a = apptObj[0].Account__r.PersonBirthdate; // Initial Date
        Date b = Date.today(); // Today or Final Date
        Integer monthDiff = a.monthsBetween(b);
        if (b.day() > a.day()){
            days = b.day() - a.day();
        }else{
            monthDiff--;
            Date d;
            if(b.month()==1){
                d = Date.newInstance(b.year()-1,12,a.day());
            }else{
                d = Date.newInstance(b.year(),b.month()-1,a.day());
            }
            days = d.daysBetween(b);
        }
        
        if(monthDiff>=12){
            years = monthDiff/12;
            months = Math.Mod(monthDiff, 12);
        }else{
            months = monthDiff;
        }
        AgeInYearsMonthsDays  = years + 'Y ' + months + 'M ' + days + 'D';
        System.debug(years + ' Years '+ months + ' Months ' + days + ' Days ');
        
        if (apptObj[0].Account__r.Nationality__c != 'Thai') {
            Map<Integer, String> monthMap = new Map<Integer, String>{
                            1 => 'Jan', 2 => 'Feb', 3 => 'Mar', 4 => 'Apr', 5 => 'May', 6 => 'Jun',
                                7 => 'Jul', 8 => 'Aug', 9 => 'Sep', 10 => 'Oct', 11 => 'Nov', 12 => 'Dec'
                                };
            Integer monthNumberDOB = apptObj[0].Account__r.PersonBirthdate.month();
            String monthTextDOB = monthMap.containsKey(monthNumberDOB) ? monthMap.get(monthNumberDOB) : ''; 
            DOB1 = apptObj[0].Account__r.PersonBirthdate.day() + ' ' + monthTextDOB + ' ' + apptObj[0].Account__r.PersonBirthdate.year();
            //DOB = apptObj[0].Account__r.PersonBirthdate; 
        }else{
             Map<Integer, String> monthMap = new Map<Integer, String>{
                            1 => 'ม.ค.', 2 => 'ก.พ.', 3 => 'มี.ค.', 4 => 'เม.ย.', 5 => 'พ.ค.', 6 => 'มิ.ย.',
                                7 => 'ก.ค.', 8 => 'ส.ค.', 9 => 'ก.ย.', 10 => 'ต.ค.', 11 => 'พ.ย.', 12 => 'ธ.ค.'
                                };
            Integer monthNumberDOB = apptObj[0].Account__r.PersonBirthdate.month();
            String monthTextDOB = monthMap.containsKey(monthNumberDOB) ? monthMap.get(monthNumberDOB) : ''; 
            DOB1 = apptObj[0].Account__r.PersonBirthdate.day() + ' ' + monthTextDOB + ' ' + (apptObj[0].Account__r.PersonBirthdate.year()+543);
            //DOB = apptObj[0].Account__r.PersonBirthdate; 
        }
        
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
                    
                    if (item.Account__r.Nationality__c != 'Thai') {
                        Map<Integer, String> monthMap = new Map<Integer, String>{
                            1 => 'Jan', 2 => 'Feb', 3 => 'Mar', 4 => 'Apr', 5 => 'May', 6 => 'Jun',
                                7 => 'Jul', 8 => 'Aug', 9 => 'Sep', 10 => 'Oct', 11 => 'Nov', 12 => 'Dec'
                                };
                                    Integer monthNumber = item.Appointment_Date__c.month();
                        String monthText = monthMap.containsKey(monthNumber) ? monthMap.get(monthNumber) : ''; 
                        lw.datestr = item.Appointment_Date__c.day() + ' ' + monthText + ' ' + item.Appointment_Date__c.year();
                        
                    }else{
                        Map<Integer, String> monthMap = new Map<Integer, String>{
                            1 => 'ม.ค.', 2 => 'ก.พ.', 3 => 'มี.ค.', 4 => 'เม.ย.', 5 => 'พ.ค.', 6 => 'มิ.ย.',
                                7 => 'ก.ค.', 8 => 'ส.ค.', 9 => 'ก.ย.', 10 => 'ต.ค.', 11 => 'พ.ย.', 12 => 'ธ.ค.'
                                };
                                    Integer monthNumber = item.Appointment_Date__c.month();
                        String monthText = monthMap.containsKey(monthNumber) ? monthMap.get(monthNumber) : ''; 
                        lw.datestr = item.Appointment_Date__c.day() + ' ' + monthText + ' ' + (item.Appointment_Date__c.year()+543);
                        
                    }
                    //lw.datestr =String.valueof(item.Appointment_Date__c).format('dd-MM-yyyy');
                    
                    if (item.Non_fixed_Time__c != null) {
                        lw.timestr = item.Non_fixed_Time__c;
                    } else {
                        lw.timestr = item.Appointment_Time__c;
                    }
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
        @AuraEnabled
        public String nationality {get;set;}
    }
    
    




}