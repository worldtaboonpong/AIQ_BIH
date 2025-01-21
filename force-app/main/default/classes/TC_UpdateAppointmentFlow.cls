public class TC_UpdateAppointmentFlow {
	@InvocableMethod(label='Send Appointment to TrakCare')
    public static void sendToTrakCare(List<id> ids) {
        calloutTotakcare(ids.get(0));
    }
    
    @future(callout=true)
    public static void calloutTotakcare(string appId) {
        Appointment__c app = [
            SELECT Id, Account__r.Hospital_Number_HN__c, Appointment_Id__c, 
            Notes__c, Patient_Letter_Notes__c, Interpreter_Required__c, Interpreter__c
            FROM Appointment__c
            WHERE Id = :appId
        ];
        
        Map<String, Object> mapData = new Map<String, Object>();
        mapData.put('hn', app.Account__r.Hospital_Number_HN__c);
        mapData.put('appId', app.Appointment_Id__c);
        mapData.put('notes', app.Notes__c != null ? app.Notes__c : '');
        mapData.put('plNotes', app.Patient_Letter_Notes__c != null ? app.Patient_Letter_Notes__c.replaceAll('\n', '&#10;').replaceAll('\r', '&#13;') : '');
        mapData.put('interpreterRequired', app.Interpreter_Required__c == true ? 'Yes' : 'No');
        mapData.put('interpreter', app.Interpreter__c != null ? app.Interpreter__c : '');
        
        String dataJson = JSON.Serialize(mapData);
        HttpResponse httpRes = (Test.isRunningTest() ? new HttpResponse() : TC_TrakCareService.returnUpdateAppResponse(dataJson));
        
        Track_Care_Log__c tcl = new Track_Care_Log__c(
            API_Name__c = 'Update Appointment', Method__c = 'PATCH', Request__c = dataJson, 
            Status_Code__c = ''+httpRes.getStatusCode(), Status__c = httpRes.getStatus(), Response__c = httpRes.getBody()
        );
        insert tcl;
    }
}