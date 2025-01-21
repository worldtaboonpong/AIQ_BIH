public with sharing class BIH_EditEndosementCtrl {

 	public class EndosementWrapper {
        @AuraEnabled
        public Case caseEndosememt {get; set;}
        @AuraEnabled
        public string caseIdendosememt{get;set;}
        @AuraEnabled
        public string recordtypeEndosement{get;set;}
    }
    
    @AuraEnabled
    public static EndosementWrapper getcaseforendosement(string caseId, Integer param)
    { 
        Case cas = new Case();
        EndosementWrapper wrapperEndos = new EndosementWrapper();
        if(caseId!=null&&caseId!=''){
            cas =[SELECT id, recordTypeId, ME_Endorsement__c FROM Case where id =: caseId LIMIT 1];
			wrapperEndos.caseEndosememt = cas;
            wrapperEndos.caseIdendosememt = cas.id;
            wrapperEndos.recordtypeEndosement = cas.recordTypeId;
            system.debug('*************************************');
            system.debug('ME_Endosement__c'+wrapperEndos.caseEndosememt.ME_Endorsement__c);
        }
        return wrapperEndos;
    }
    
    @AuraEnabled
    public static boolean UpdateCaseRecordEndosement(case caseObj)
    { 
		try {
        	update caseObj;
         	return true;
        } catch (Exception e) {
             return false;
        }
    }
    
   

 


    


}