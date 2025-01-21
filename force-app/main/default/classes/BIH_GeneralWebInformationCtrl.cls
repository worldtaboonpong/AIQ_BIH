public with sharing class BIH_GeneralWebInformationCtrl {
    
    @AuraEnabled
    public static Case getCaseInformation(Id caseId){
        System.debug('caseId: '+caseId);
        //DescribeSObjectResult describeResult = Case.getSObjectType().getDescribe();
        //List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        List<Case> caseObj = new List<Case>();
        
        String query = 'SELECT Id,' +
            getFields('Case','BIH_GeneralWebInformationCtrl')+
            ' ,Parent.CaseNumber,CreatedBy.Name,LastModifiedBy.Name,Account.Name,Patient__r.Name,Account.Hospital_Number_HN__c,Patient__r.Hospital_Number_HN__c'+
            ' FROM Case Where id = :caseId ';
        
        caseObj = Database.query( query );
        if (caseObj[0].Web_Subject__c == Label.Make_an_Appointment || caseObj[0].Web_Subject__c == Label.Change_Appointment_Main_Website || 
            caseObj[0].Web_Subject__c == Label.Cancel_Appointment_Main_Website || caseObj[0].Web_Subject__c == Label.To_Reach_the_Contact_Office_In_My_Country 
            || caseObj[0].Web_Subject__c == Label.To_Reach_Bumrungrad_International){
                if (caseObj[0].Appointment_Time__c != null ){
                    String times = DateTime.newInstance(Date.today(), caseObj[0].Appointment_Time__c).format('HH:mm');
                    caseObj[0].App_Time_Format__c = times;
                }
                if (caseObj[0].New_Appointment_Time__c != null){
                    String times = DateTime.newInstance(Date.today(), caseObj[0].New_Appointment_Time__c).format('HH:mm');
                    caseObj[0].New_Appointment_Time_Format__c = times;
                }
            }
        if (caseObj[0].Cancellation_Appointment__c){
            if (caseObj[0].App_Time__c != null ){
                String times = DateTime.newInstance(Date.today(), caseObj[0].App_Time__c).format('HH:mm');
                caseObj[0].App_Time_Format__c = times;
            }
            if (caseObj[0].End_Time__c != null){
                String times = DateTime.newInstance(Date.today(), caseObj[0].End_Time__c).format('HH:mm');
                caseObj[0].End_Time_Format__c = times;
            }
        }
        return caseObj[0];
    }
    public static String getFields(String ObjectName,String fieldSetName){
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        String fields ='';
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        for(Schema.FieldSetMember fm:fieldSetObj.getFields()){
            if(fields != '' && fields != null){
                fields += ',' +  String.valueOf( fm.getSObjectField());   
            }else{
                fields = String.valueOf( fm.getSObjectField());   
            }
        }
        return fields;
    }
    
}