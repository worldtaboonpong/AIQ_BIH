public with sharing class BIH_AirportTransferInformationCtrl {


    public class Wrapper {
        @AuraEnabled
        public Case caseObj {get; set;}
        @AuraEnabled
        public Map<String,List<BIH_PicklistOption>> pickListValue {get; set;}
        @AuraEnabled
        public string checkInTime{get;set;}
        @AuraEnabled
        public string checkOutTime{get;set;}
    }
    public static Map<String,List<BIH_PicklistOption>> getPickListValuesIntoList( List<String> field_name) {
		Map<String,List<BIH_PicklistOption>> values = new Map<String,List<BIH_PicklistOption>>();
		for(String fn : field_name) {
            List<BIH_PicklistOption> tmpList = BIH_PickListDescCtrl.describe('Case',BIH_Constants.AIRPORT_TRANSFER_CASE_RECORDTYPE,fn);
			values.put(fn,tmpList);
		}	
		return values;
   }
   
   @AuraEnabled
    public static Wrapper getWrapperInfo(String caseId){
        Wrapper wrapper = new Wrapper();
        try {
            
            DescribeSObjectResult describeResult = Case.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
            String query = 'SELECT ' +
                            String.join( fieldNames, ',' ) +
                            ' FROM ' +
                            describeResult.getName()  +
                            ' Where id = :caseId ';

            wrapper.caseObj = (case)Database.query( query );

            wrapper.checkInTime = string.valueof(wrapper.caseObj.Check_In_Time__c);
            wrapper.checkOutTime = string.valueof(wrapper.caseObj.Check_Out_Time__c) ;


           return wrapper;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return wrapper;    
        }        
    }

}