public class GeneratePDFInvitation {
	public String caseId {get; set;} 
    public Boolean isCopy {get; set;} 
    public Case currentObject {get;set;}
    public Invitation_Letter__c letterObj {get;set;}
    public List<Invitation_Letter_Person__c> patientObj {get;set;}
    public List<Invitation_Letter_Person__c> attendantObj {get;set;}
    
    public String img_signature {get;set;}
    public String name_signature {get;set;}
    public String pos_signature {get;set;}
    public GeneratePDFInvitation(){
        // PDFData = 'Test naja';
        isCopy = false;
        img_signature = BIH_Constants.SIGNATURE_INVITATION_LETTER;
        name_signature =BIH_Constants.NAME_INVITATION_LETTER;
        pos_signature= BIH_Constants.POSITION_INVITATION_LETTER;
     
 
        caseId = ApexPages.currentPage().getParameters().get('id');
        isCopy = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isCopy'));
        letterObj = [SELECT Id,RefCase__c, Generate_Date__c, LetterDear__c,LetterFrom__c, LetterTo__c, LetterSubject__c,LetterCountry__c,LetterCountryText__c, LetterRefNo__c, Content__c, Version__c, Doc_Type__c, Case__c,LetterEmbassyType__c FROM Invitation_Letter__c WHERE Case__r.Id =:caseId ORDER BY LastModifiedDate Desc LIMIT 1];
        List<Invitation_Letter_Person__c> tmpIlp = [SELECT LastModifiedDate,Person_Name__c, Passport_Number__c, Appointment_Date__c, Specialty__c, Person_Type__c, Invitation_Letter__c, Id FROM Invitation_Letter_Person__c WHERE Invitation_Letter__r.Id=:letterObj.Id];
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
    }


}