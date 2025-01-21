/**
 * CHANGE LOG:
 * - (16 Jan 2025): init AppointmentTriggerHandler to perform logic on Appointment__c
 */
public with sharing class AppointmentTriggerHandler {
    public static AppointmentTriggerHandler instance;
    public static AppointmentTriggerHandler getInstance() {
        if (instance == null) {
            instance = new AppointmentTriggerHandler();
        }
        return instance;
    }

    public Boolean isActive = true;
    public List<Appointment__c> newRecords;
    public Map<Id, Appointment__c> oldMap;

    public Boolean isTriggerActivated() {
        return this.isActive;
    }

    public void setParams(List<Appointment__c> newRecords, Map<Id, Appointment__c> oldMap) {
        this.newRecords = newRecords;
        this.oldMap = oldMap;
    }

    public void setBypass() {
        this.isActive = false;
    }

    public void clearBypass() {
        this.isActive = true;
    }

    public void executeAfterUpdate() {
        this.sendUpdatedAppointmentToTrakcare();
    }

    // ----- START AFTER UPDATE LOGIC -----
    /**
     * Warning: this method is not supported for bulk update Appointment__c since we can not perform callout more than 50 times per transaction
     */
    private void sendUpdatedAppointmentToTrakcare() {
        List<Appointment__c> updatedAppointments = new List<Appointment__c>();
        for (Appointment__c appointment : this.newRecords) {
            Appointment__c oldAppointment = this.oldMap.get(appointment.Id);
            if (
                appointment.Notes__c != oldAppointment.Notes__c ||
                appointment.Patient_Letter_Notes__c != oldAppointment.Patient_Letter_Notes__c ||
                appointment.Interpreter__c != oldAppointment.Interpreter__c ||
                appointment.Interpreter_Required__c != oldAppointment.Interpreter_Required__c
            ) {
                updatedAppointments.add(appointment);
            }
        }
        if (!updatedAppointments.isEmpty()) {
            for (Appointment__c updatedAppointment : updatedAppointments) {
                calloutUpdateAppointment(updatedAppointment.Id);
            }
        }
    }
    // ----- END AFTER UPDATE LOGIC -----

    // ----- START PRIVATE SERVICE -----
    @future(callout=true)
    private static void calloutUpdateAppointment(string appId) {
        Appointment__c app = [
            SELECT
                Id,
                Account__r.Hospital_Number_HN__c,
                Appointment_Id__c,
                Notes__c,
                Patient_Letter_Notes__c,
                Interpreter_Required__c,
                Interpreter__c
            FROM Appointment__c
            WHERE Id = :appId
        ];
        Map<String, Object> mapData = new Map<String, Object>();
        mapData.put('hn', app.Account__r.Hospital_Number_HN__c);
        mapData.put('appId', app.Appointment_Id__c);
        mapData.put('notes', app.Notes__c != null ? app.Notes__c : '');
        mapData.put('plNotes', app.Patient_Letter_Notes__c != null ? app.Patient_Letter_Notes__c : '');
        mapData.put('interpreterRequired', app.Interpreter_Required__c == true ? 'Yes' : 'No');
        mapData.put('interpreter', app.Interpreter__c != null ? app.Interpreter__c : '');
        String dataJson = JSON.Serialize(mapData);
        HttpResponse httpRes = TC_TrakCareService.returnUpdateAppResponse(dataJson);
        Track_Care_Log__c tcl = new Track_Care_Log__c(
            API_Name__c = 'Update Appointment',
            Method__c = 'PATCH',
            Request__c = dataJson,
            Status_Code__c = '' + httpRes.getStatusCode(),
            Status__c = httpRes.getStatus(),
            Response__c = httpRes.getBody()
        );
        insert tcl;
    }
    // ----- END PRIVATE SERVICE -----
}
