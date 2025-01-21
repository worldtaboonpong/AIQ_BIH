public class TC_BatchUpdateAppointment implements Schedulable, Database.Batchable<sObject>, Database.AllowsCallouts{
    public void execute(SchedulableContext sc){
        Database.executeBatch(new TC_BatchUpdateAppointment(), 10);
    }

    //Start
    public Database.QueryLocator start(Database.BatchableContext BC){
        String soqlString = 'SELECT Id, HN__c, Appointment_Id__c, Appointment_Status__c, '+
            ' Service__c, Service_Code__c, Notes__c, Patient_Letter_Notes__c, '+
            ' Interpreter_Required__c, Interpreter__c, Non_fixed_Time__c '+
            ' FROM Appointment__c WHERE HN__c != null AND Appointment_Id__c != null';
        //' FROM Appointment__c WHERE Id = \'a00A2000006dwK1IAI\'';
        return Database.getQueryLocator(soqlString);
    }

    //Execute
    public void execute(Database.BatchableContext BC, list<Appointment__c> scope){
        callOnlineAppointements(scope);
    }

    //Finish
    public void finish(Database.BatchableContext BC){

    }

    // Method to call Online Appointments
	/**
	 * CHANGE LOG:
	 * - (16 Jan 2025): bypass Appointment trigger to avoid performing callout in batch
	 */
    public static void callOnlineAppointements(list<Appointment__c> appointments) {
        List<Appointment__c> sfAppToUpdate = new List<Appointment__c>();
        List<Track_Care_Log__c> tclToInsert = new List<Track_Care_Log__c>();
        for (Appointment__c sfApp: appointments) {
            Boolean isChanged = false;

            String inputParam = '?hn='+sfApp.HN__c+'&appointmentId='+sfApp.Appointment_Id__c.replace('||', '-');
            try {

                HttpResponse httpRes = TC_TrakCareService.getOnlineAppointmentsResponse(inputParam);
                if (httpRes.getStatusCode() == 200) {
                    TC_AppointmentListParser slParser = TC_AppointmentListParser.parse(httpRes.getBody());

                    if (slParser.status.code != 'ERROR') {
                        for (TC_AppointmentListParser.cls_schedules sch: slParser.data.schedules) {
                            for (TC_AppointmentListParser.cls_appointments app: sch.schedule.appointments) {
                                if (sfApp.Appointment_Status__c != app.appointment.appStatus) {
                                    sfApp.Appointment_Status__c = app.appointment.appStatus;
                                    isChanged = true;
                                }

                                if (sfApp.Service_Code__c != app.appointment.service.code) {
                                    sfApp.Service__c = app.appointment.service.description;
                                    sfApp.Service_Code__c = app.appointment.service.code;
                                    isChanged = true;
                                }

                                if (sfApp.Notes__c != app.appointment.note) {
                                    sfApp.Notes__c = app.appointment.note;
                                    isChanged = true;
                                }

                                if (sfApp.Patient_Letter_Notes__c != app.appointment.patientLetterNotes) {
                                    sfApp.Patient_Letter_Notes__c = app.appointment.patientLetterNotes;
                                    isChanged = true;
                                }

                                Boolean isIntRequired = (app.appointment.isInterpreterRequired == 'Yes' ? true : false);
                                if (sfApp.Interpreter_Required__c != isIntRequired) {
                                    sfApp.Interpreter_Required__c = isIntRequired;
                                    //sfApp.Interpreter__c = app.appointment.interpreter.description;
                                    isChanged = true;
                                }

                                if (app.appointment.interpreter != null && sfApp.Interpreter__c != app.appointment.interpreter.description) {
                                    sfApp.Interpreter__c = app.appointment.interpreter.description;
                                    isChanged = true;
                                }

                                if (sfApp.Non_fixed_Time__c != app.appointment.nonFixedTime) {
                                    sfApp.Non_fixed_Time__c = app.appointment.nonFixedTime;
                                    isChanged = true;
                                }
                            }
                        }
                    }
                }

                if (isChanged) {
                    sfAppToUpdate.add(sfApp);
                }
            } catch(Exception ex) {
                tclToInsert.add(new Track_Care_Log__c(
                    API_Name__c = 'Online Appointments - Status', Method__c = 'GET', Request__c = inputParam,
                    Status__c = 'Error', Response__c = ex.getMessage()
                ));
            }
        }

        if (sfAppToUpdate.size() > 0) {
            //update sfAppToUpdate;
			AppointmentTriggerHandler.getInstance().setBypass();
            Database.update(sfAppToUpdate, false);
			AppointmentTriggerHandler.getInstance().clearBypass();
        }

        if (tclToInsert.size() > 0) {
            insert tclToInsert;
        }
    }
}