public class TC_BatchCreateScheduleList implements Database.Batchable<sObject>, Database.AllowsCallouts {
    //Start
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, Name, Hospital_Code__c FROM TrakCareHospitalConfiguration__c');
    }
    
    //Execute
    public void execute(Database.BatchableContext BC, list<TrakCareHospitalConfiguration__c> scope){
        //String inputParam = '?dateFrom='+Datetime.now().format('yyyy-MM-dd')+'&dateTo='+Datetime.now().format('yyyy-MM-dd')+'&hospital='+scope.get(0).Hospital_Code__c;
        String inputParam = '?hospital='+scope.get(0).Hospital_Code__c;
        try {
            HttpResponse httpRes = TC_TrakCareService.getSchedulesMasterResponse(inputParam);
            
            List<Schedule_List__c> slToCreate = new List<Schedule_List__c>();
            if (httpRes.getStatusCode() == 200) {
                TC_ScheduleListParser slParser = TC_ScheduleListParser.parse(httpRes.getBody());
                if (slParser != null && slParser.payload != null) {
                    for (TC_ScheduleListParser.cls_payload slp: slParser.payload) {
                        slToCreate.add(new Schedule_List__c(
                            Hospital__c = slp.hospitaldesc, Hospital_Code__c = slp.hospitalcode, Location__c = slp.location, Location_Code__c = slp.locationCode, 
                            Specialty__c = slp.Specialty, Specialty_Code__c = slp.SpecialtyCode, Sub_Specialty__c = slp.SubSpecialty, Sub_Specialty_Code__c = slp.SubSpecialtyCode, 
                            Care_Provider__c = slp.careProvider, Care_Provider_Code__c = slp.careCode, Flag_Doctor__c = slp.FlagDoctor
                        ));
                    }
                    
                    if (slToCreate.size() > 0) {
                        insert slToCreate;
                    }  
                }
            }
        } catch(Exception ex) {
            Track_Care_Log__c tcl = new Track_Care_Log__c(
                API_Name__c = 'Schedule Master', Method__c = 'GET', Request__c = inputParam, 
                Status__c = 'Error', Response__c = ex.getMessage()
            );
            insert tcl;
        }
    }
    
    //Finish
    public void finish(Database.BatchableContext BC){
        
    }
}