global with sharing class BIH_PicklistOption {
	@AuraEnabled
    global String value{get;set;}

    @AuraEnabled
    global String label{get;set;}

    global BIH_PicklistOption(String value, String label){
        this.value = value;
        this.label = label;
    }
}