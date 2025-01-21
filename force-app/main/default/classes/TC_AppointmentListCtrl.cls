public class TC_AppointmentListCtrl {
    public static Boolean isFromPdf = false;
        
    @AuraEnabled
    public static Map<String, Object> fetchAppointments(String recordId) {
        Account acc = [SELECT Id, Hospital_Number_HN__c FROM Account WHERE Id = :recordId];
        //Set<String> setAppointmentId = new Set<String>();
        
        List<AppointmentWrapper> cancelApps = new List<AppointmentWrapper>();
        List<AppointmentWrapper> pastApps = new List<AppointmentWrapper>();
        List<AppointmentWrapper> upcomingApps = new List<AppointmentWrapper>();
        
        Date todayDate = date.today();
        String soqlQuery = 'SELECT ' + string.join(getAllFields('Appointment__c'),',') +' FROM Appointment__c WHERE Account__c = :recordId AND Appointment_Id__c != null ORDER BY Appointment_Date_Time__c DESC';
        Map<String, Appointment__c> sfAppointments = new Map<String, Appointment__c>();
        for (Appointment__c app: Database.query(soqlQuery)) {
            sfAppointments.put(app.Appointment_Id__c, app);
            /*AppointmentWrapper appWrap = new AppointmentWrapper();
            appWrap.appTcId = app.Appointment_Id__c;
            appWrap.appSfId = app.Id;
            appWrap.appName = app.Name;
            appWrap.appLocation = app.Location__c;
            appWrap.appDoctor = app.Doctor__c;
            appWrap.appDate = ((Datetime)app.Appointment_Date__c).format('EEEE') +' '+ app.Appointment_Date__c.format();
            appWrap.appTime = app.Appointment_Time__c;
            appWrap.appStatus = app.Appointment_Status__c;
            appWrap.appNote = app.Notes__c;
            appWrap.appSource = 'SalesForce';
                
            if (app.Appointment_Status__c == 'Cancelled') {
                cancelApps.add(appWrap);
            } else if (app.Appointment_Date__c < todayDate) {
                pastApps.add(appWrap);
            } else {
                upcomingApps.add(appWrap);
            }
            setAppointmentId.add(app.Appointment_Id__c);*/
        }
        
        String inputParam = '?hn='+acc.Hospital_Number_HN__c;
        HttpResponse httpRes = TC_TrakCareService.getOnlineAppointmentsResponse(inputParam);        
        if (httpRes.getStatusCode() == 200) {
            TC_AppointmentListParser slParser = TC_AppointmentListParser.parse(httpRes.getBody());
            
            if (slParser.status.code != 'ERROR') {
                Integer count = 1;
                for (TC_AppointmentListParser.cls_schedules sch: slParser.data.schedules) {
                    for (TC_AppointmentListParser.cls_appointments app: sch.schedule.appointments) {
                        //if (!setAppointmentId.contains(app.appointment.id)) {
                        if (sfAppointments.containsKey(app.appointment.id)) {
                            Appointment__c sfapp = sfAppointments.get(app.appointment.id);
                            AppointmentWrapper appWrap = new AppointmentWrapper();
                            appWrap.appIndex = count;
                            appWrap.appTcId = sfapp.Appointment_Id__c;
                            appWrap.appSfId = sfapp.Id;
                            appWrap.appName = sfapp.Name;
                            appWrap.appLocation = sfapp.Location__c;
                            appWrap.appDoctor = sfapp.Doctor__c;
                            appWrap.appDate = ((Datetime)sfapp.Appointment_Date__c).format('EEEE') +' '+ sfapp.Appointment_Date__c.format();
                            appWrap.appDateStr = sfapp.Appointment_Date__c.format();
                            appWrap.appTime = sfapp.Appointment_Time__c;
                            appWrap.appStatus = (app.appointment.appStatus != sfapp.Appointment_Status__c ? app.appointment.appStatus : sfapp.Appointment_Status__c);
                            appWrap.appNote = sfapp.Notes__c;
                            appWrap.patientLetterNotes = sfapp.Patient_Letter_Notes__c;
                            appWrap.appSource = 'SalesForce';
                            appWrap.appNonFixedTime = sfapp.Non_fixed_Time__c;
                            
                            if (appWrap.appStatus == 'Cancelled') {
                                cancelApps.add(appWrap);
                            } else if (sfapp.Appointment_Date__c < todayDate) {
                                pastApps.add(appWrap);
                            } else {
                                upcomingApps.add(appWrap);
                            }
                            //upcomingApps.add(appWrap);
                        } else {
                            Date appDate = Date.valueOf(app.appointment.appDate); 
                            
                            AppointmentWrapper appWrap = new AppointmentWrapper();
                            appWrap.appIndex = count;
                            appWrap.appTcId = app.appointment.id;
                            appWrap.appSfId = '';
                            appWrap.appName = '';
                            appWrap.appLocation = sch.schedule.location.description;
                            appWrap.appDoctor = sch.schedule.doctor.description;
                            appWrap.appDate = ((Datetime)appDate).format('EEEE') +' '+ appDate.format();
                            appWrap.appDateStr = appDate.format();
                            appWrap.appTime = (app.appointment.appTime != null ? app.appointment.appTime.replace(':00Z', '') : '');
                            appWrap.appStatus = app.appointment.appStatus;
                            appWrap.appNote = app.appointment.note;
                            appWrap.patientLetterNotes = app.appointment.patientLetterNotes;
                            appWrap.appSource = 'TrackCare';
                            appWrap.appNonFixedTime = app.appointment.nonFixedTime;
                            
                            if (appWrap.appStatus == 'Cancelled') {
                                cancelApps.add(appWrap);
                            } else if (appDate < todayDate) {
                                pastApps.add(appWrap);
                            } else {
                                upcomingApps.add(appWrap);
                            } 
                        }
                        //}
                        count = count + 1;
                    }
                }
            }
        }
        
        if (!TC_AppointmentListCtrl.isFromPdf) {
            Track_Care_Log__c tcl = new Track_Care_Log__c(
                API_Name__c = 'Online Appointments - List', Method__c = 'GET', Request__c = inputParam, 
                Status_Code__c = ''+httpRes.getStatusCode(), Status__c = httpRes.getStatus(), 
                Response__c = (httpRes.getBody().length() > 131071 ? httpRes.getBody().left(131071) : httpRes.getBody())
            );
            insert tcl;
        }
        
        Map<String, Object> mapObjects = new Map<String, Object>();
        mapObjects.put('Upcoming', upcomingApps);
        mapObjects.put('Past', pastApps);
        mapObjects.put('Cancel', cancelApps);
        return mapObjects; 
    }
    
    @AuraEnabled
    public static Map<String, Object> viewAppointment(String recordId, String appTcId) {
        Account acc = [SELECT Id, Hospital_Number_HN__c FROM Account WHERE Id = :recordId];
        
        Map<String, Object> mapObjects = new Map<String, Object>();
        
        String inputParam = '?hn='+acc.Hospital_Number_HN__c+'&appointmentId='+appTcId.replace('||', '-');
        HttpResponse httpRes = TC_TrakCareService.getOnlineAppointmentsResponse(inputParam);        
        if (httpRes.getStatusCode() == 200) {
            TC_AppointmentListParser slParser = TC_AppointmentListParser.parse(httpRes.getBody());
            
            if (slParser.status.code != 'ERROR') {
                for (TC_AppointmentListParser.cls_schedules sch: slParser.data.schedules) {
                    mapObjects.put('Doctor', sch.schedule.doctor.description);
                    mapObjects.put('Location', sch.schedule.location.description);
                    for (TC_AppointmentListParser.cls_appointments app: sch.schedule.appointments) {
                        Date appDate = (app.appointment.appDate != null ? Date.valueOf(app.appointment.appDate) : null);
                        
                        mapObjects.put('AppDate', (appDate != null ? ((Datetime)appDate).format('d-MM-YYYY') : ''));
                        mapObjects.put('AppTime', (app.appointment.appTime != null ? app.appointment.appTime.replace(':00Z', '') : ''));
                        mapObjects.put('Service', app.appointment.service.description);
                        mapObjects.put('NonFixedTime', app.appointment.nonFixedTime);
                        mapObjects.put('InterpreterRequired', app.appointment.isInterpreterRequired);
                        mapObjects.put('Interpreter', app.appointment.interpreter.description);
                        mapObjects.put('Notes', app.appointment.note);
                        mapObjects.put('PatientLetterNotes', app.appointment.patientLetterNotes);
                        mapObjects.put('AppointmentStatus', app.appointment.appStatus);
                    }
                }
            }
        }
        
        Track_Care_Log__c tcLog = new Track_Care_Log__c(
            API_Name__c = 'Online Appointments - View', Method__c = 'GET', Request__c = inputParam, 
            Status_Code__c = ''+httpRes.getStatusCode(), Status__c = httpRes.getStatus(), 
            Response__c = (httpRes.getBody().length() > 131071 ? httpRes.getBody().left(131071) : httpRes.getBody())
        );
        insert tcLog;
        
        return mapObjects; 
    }
    
    @AuraEnabled
    public static void viewSfAppointment(String recordId) {
        List<Appointment__c> appointments = [
            SELECT Id, HN__c, Appointment_Id__c, Appointment_Status__c, Service__c, Service_Code__c, 
            Notes__c, Patient_Letter_Notes__c, Interpreter_Required__c, Interpreter__c, Non_fixed_Time__c,
            Reason_for_Cancellation__c, Free_Text_Reason_for_Cancellation__c, Cancelled_By__c, Cancelled_Date__c, Cancelled_Time__c
            FROM Appointment__c WHERE Id = :recordId AND HN__c != null AND Appointment_Id__c != null
        ];
        if (appointments.size() > 0) {
            TC_BatchUpdateAppointment.callOnlineAppointements(appointments);
        }
    }
    
    @AuraEnabled
    public static String cancelAppointments(String sfId, String tcId, Appointment__c appDetail) {
        String message = TC_CancelAppointmentCtrl.appointmentCancelledCallout(sfId, tcId, appDetail);
        return message;
    }
    
    @AuraEnabled
    public static List<TC_AppointmentOrdersCtrl.OrderWrapper> fetchAppointmentOrders(String appointmentId) {
        return TC_AppointmentOrdersCtrl.fetchAppointmentOrders(appointmentId);
    }
    
    public static List<String> getAllFields(String sobjectname){
        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(sobjectname).getDescribe().SObjectType.getDescribe().fields.getMap();
        List<String> accessiblefields = new List<String>();
        for(Schema.SObjectField field : fields.values()){
            //if(field.getDescribe().isAccessible()) {
                accessiblefields.add(field.getDescribe().getName());
            //}
        }
        return accessiblefields;
    }
    
    //Appointment Wrapper
    public class AppointmentWrapper{
        @AuraEnabled public Integer appIndex;
        @AuraEnabled public String appTcId;
        @AuraEnabled public String appSfId;
        @AuraEnabled public String appName;
        @AuraEnabled public String appLocation;
        @AuraEnabled public String appDoctor;
        @AuraEnabled public String appDate;
        @AuraEnabled public String appDateStr;
        @AuraEnabled public String appTime;
        @AuraEnabled public String appStatus;
        @AuraEnabled public String appNote;
        @AuraEnabled public String patientLetterNotes;
        @AuraEnabled public String appSource;
        @AuraEnabled public String appNonFixedTime;
        /*@AuraEnabled public String appReasonCancel;
        @AuraEnabled public String appReasonCancelText;
        @AuraEnabled public String appReasonCancelUser;*/
    }
}