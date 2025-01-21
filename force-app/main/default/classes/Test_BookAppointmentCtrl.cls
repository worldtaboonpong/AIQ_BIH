public class Test_BookAppointmentCtrl {
    @AuraEnabled
    public static Map<String, Object> getBookingDetails(
        String selHospital, String selLocation, String selSpecialty, String selSubSpecialty,
        String selResource, String selDate, String selStartTime, String selEndTime
    ) {
        List<PicklistWrapper> hospitals = new List<PicklistWrapper>();
        Map<String, TrakCareHospitalConfiguration__c> tcHospitalMap = TrakCareHospitalConfiguration__c.getAll();
        for (TrakCareHospitalConfiguration__c tcHospital: tcHospitalMap.values()) {
            PicklistWrapper picklistWrap = new PicklistWrapper();
            picklistWrap.label = tcHospital.Name;
            picklistWrap.value = tcHospital.Hospital_Code__c;
            hospitals.add(picklistWrap);
        }
        Map<String, Object> filteredMap = filterScheduleLists(selHospital, selLocation, selSpecialty, selSubSpecialty, selResource);
        
        Map<String, Object> mapObjects = new Map<String, Object>();
        mapObjects.put('Hospitals', hospitals);
        mapObjects.put('Locations', filteredMap.get('Locations'));
        mapObjects.put('Specialties', filteredMap.get('Specialties'));
        mapObjects.put('SubSpecialties', filteredMap.get('SubSpecialties'));
        mapObjects.put('Resources', filteredMap.get('Resources'));
        mapObjects.put('SelDate',  Date.today());
        mapObjects.put('StartTimes', getStartEndTimes());
        mapObjects.put('EndTimes', getStartEndTimes());
        return mapObjects;
    }
    
    public static Map<String, Object> filterScheduleLists (
        String selHospital, String selLocation, String selSpecialty, String selSubSpecialty, String selResource
    ) {
        List<Schedule_List__c> slList;
        String soqlQuery = 'SELECT ' + string.join(getAllFields('Schedule_List__c'),',') +' FROM Schedule_List__c WHERE Hospital_Code__c = :selHospital';
        soqlQuery += ' ORDER BY Location__c ASC, Specialty__c ASC, Sub_Specialty__c ASC, Care_Provider__c ASC';
        
        Set<String> setLocations = new Set<String>();
        Set<String> setSpecialties = new Set<String>();
        Set<String> setSubSpecialties = new Set<String>();
        Set<String> setResources = new Set<String>();
        List<PicklistWrapper> locations = new List<PicklistWrapper>();
        List<PicklistWrapper> specialties = new List<PicklistWrapper>();
        List<PicklistWrapper> subSpecialties = new List<PicklistWrapper>();
        List<PicklistWrapper> resources = new List<PicklistWrapper>();
        
        for (Schedule_List__c sl: Database.query(soqlQuery)) {
            if (
                !String.isEmpty(sl.Location__c) && !setLocations.contains(sl.Location__c)
            ) {
                PicklistWrapper picklistWrap = new PicklistWrapper();
                picklistWrap.label = sl.Location__c;
                picklistWrap.value = sl.Location_Code__c;
                locations.add(picklistWrap);
                setLocations.add(sl.Location__c);
            }
            
            if (
                (String.isEmpty(selLocation) || (!String.isEmpty(sl.Location_Code__c) && sl.Location_Code__c == selLocation)) && 
                !String.isEmpty(sl.Specialty__c) && !setSpecialties.contains(sl.Specialty__c)
            ) {
                PicklistWrapper picklistWrap = new PicklistWrapper();
                picklistWrap.label = sl.Specialty__c;
                picklistWrap.value = sl.Specialty_Code__c;
                specialties.add(picklistWrap);
                setSpecialties.add(sl.Specialty__c);
            }
            
            if (
                (String.isEmpty(selLocation) || (!String.isEmpty(sl.Location_Code__c) && sl.Location_Code__c == selLocation)) && 
                (String.isEmpty(selSpecialty) || (!String.isEmpty(sl.Specialty_Code__c) && sl.Specialty_Code__c == selSpecialty)) &&
                !String.isEmpty(sl.Sub_Specialty__c) && !setSubSpecialties.contains(sl.Sub_Specialty__c)
            ) {
                PicklistWrapper picklistWrap = new PicklistWrapper();
                picklistWrap.label = sl.Sub_Specialty__c;
                picklistWrap.value = sl.Sub_Specialty_Code__c;
                subSpecialties.add(picklistWrap);
                setSubSpecialties.add(sl.Sub_Specialty__c);
            }
            
            if (
                (String.isEmpty(selLocation) || (!String.isEmpty(sl.Location_Code__c) && sl.Location_Code__c == selLocation)) && 
                (String.isEmpty(selSpecialty) || (!String.isEmpty(sl.Specialty_Code__c) && sl.Specialty_Code__c == selSpecialty)) && 
                (String.isEmpty(selSubSpecialty) || (!String.isEmpty(sl.Sub_Specialty_Code__c) && sl.Sub_Specialty_Code__c == selSubSpecialty)) && 
                !String.isEmpty(sl.Care_Provider__c) && !setResources.contains(sl.Care_Provider__c)
            ) {
                PicklistWrapper picklistWrap = new PicklistWrapper();
                picklistWrap.label = sl.Care_Provider__c;
                picklistWrap.value = sl.Care_Provider_Code__c;
                resources.add(picklistWrap);
                setResources.add(sl.Care_Provider__c);
            }
        }
        
        Map<String, Object> mapObjects = new Map<String, Object>();
        mapObjects.put('Locations', locations);
        mapObjects.put('Specialties', specialties);
        mapObjects.put('SubSpecialties', subSpecialties);
        mapObjects.put('Resources', resources);
        return mapObjects;
    }
    
    public static List<String> getStartEndTimes(){
        List<String> timeSlots = new List<String>{
            '08:00', '08:15', '08:30', '08:45', '09:00', '09:15', '09:30', '09:45', '10:00',
            '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00', '12:15', '12:30',
            '12:45', '13:00', '13:15', '13:30', '13:45', '14:00', '14:15', '14:30', '14:45',
            '15:00', '15:15', '15:30', '15:45', '16:00', '16:15', '16:30', '16:45'
        };
        return timeSlots;
    }
    
    @AuraEnabled
    public static List<DoctorWrapper> findDoctorAndSchedules (
        String selHospital, String selLocation, String selSpecialty, String selSubSpecialty, 
        String selResource, String selDate, String selStartTime, String selEndTime
    ) {
        List<DoctorWrapper> doctorWrappers = new List<DoctorWrapper>();
        String soqlQuery = 'SELECT ' + string.join(getAllFields('Schedule_List__c'),',') +' FROM Schedule_List__c WHERE Hospital_Code__c = :selHospital';
        if (!String.isEmpty(selLocation)) {
            soqlQuery += ' AND Location_Code__c = :selLocation';
        }
        if (!String.isEmpty(selSpecialty)) {
            soqlQuery += ' AND Specialty_Code__c = :selSpecialty';
        }
        if (!String.isEmpty(selSubSpecialty)) {
            soqlQuery += ' AND Sub_Specialty_Code__c = :selSubSpecialty';
        }
        if (!String.isEmpty(selResource)) {
            soqlQuery += ' AND Care_Provider_Code__c = :selResource';
        }
        soqlQuery += ' ORDER BY Care_Provider__c ASC';
        
        for (Schedule_List__c sl: Database.query(soqlQuery)) {
            DoctorWrapper dsw = new DoctorWrapper();
            dsw.doctorName = sl.Care_Provider__c;
            dsw.docSlotKey = sl.Id;
            doctorWrappers.add(dsw);
        }
        return doctorWrappers;
    }
    
    public static List<String> getAllFields(String sobjectname){
        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(sobjectname).getDescribe().SObjectType.getDescribe().fields.getMap();
        List<String> accessiblefields = new List<String>();
        for(Schema.SObjectField field : fields.values()){
            if(field.getDescribe().isAccessible()) {
                accessiblefields.add(field.getDescribe().getName());
            }
        }
        return accessiblefields;
    }
    
    @AuraEnabled
    public static Map<String, Object> getDoctorTimeSlots(String selScheduleListId, String selDate, String selTimeFrom, String selTimeTo){
        Schedule_List__c sl = [
            SELECT Id, Location__c, Care_Provider__c, Care_Provider_Code__c, Location_Code__c
            FROM Schedule_List__c 
            WHERE Id = :selScheduleListId
        ];
        
        String message = '';
        List<String> sessionIds = new List<String>();
        Map<String, SessionWrapper> mapSessionDetails = new Map<String, SessionWrapper>();
        Map<String, List<SlotWrapper>> mapSessionTimeSlots = new Map<String, List<SlotWrapper>>();
        
        //String startTime = '';
        //String endTime = '';
        //SessionWrapper sessionWrap = new SessionWrapper();
        //List<SlotWrapper> timeSlots = new List<SlotWrapper>();
        
        String inputParam = '?doctor='+sl.Care_Provider_Code__c+'&location='+sl.Location_Code__c+'&dateFrom='+selDate;
        if (String.isNotEmpty(selTimeFrom) && String.isNotEmpty(selTimeTo)) {
            inputParam = inputParam + '&timeFrom=' + selTimeFrom + '&timeTo='+selTimeTo;
        }
        HttpResponse httpRes = TC_TrakCareService.getSchedulesResponse(inputParam);
        
        try {
            if (httpRes.getStatusCode() == 200) {
                TC_ScheduleParser slParser = TC_ScheduleParser.parse(httpRes.getBody());
                
                if (slParser.status.code != 'ERROR') {
                    for (TC_ScheduleParser.cls_schedules sch: slParser.data.schedules) {
                        for (TC_ScheduleParser.cls_sessions csession: sch.schedules.sessions) {
                            SessionWrapper sessWrapper = new SessionWrapper();
                            
                            TC_ScheduleParser.cls_session session = csession.session;
                            List<ServiceWrapper> services = new List<ServiceWrapper>();
                            for (TC_ScheduleParser.cls_services service: session.services) {
                                ServiceWrapper serWrap = new ServiceWrapper();
                                serWrap.servicecode = service.code;
                                serWrap.serviceDesc = service.description;
                                serWrap.serviceLength = service.duration;
                                services.add(serWrap);
                            }
                            
                            //sessionWrap.sessionDesc = session.description;
                            //sessionWrap.services = services;
                            
                            sessWrapper.sessionDesc = session.description;
                            sessWrapper.services = services;
                            mapSessionDetails.put(session.sessionId, sessWrapper);
                            sessionIds.add(session.sessionId);
                        }
                        
                        for (TC_ScheduleParser.cls_slots cslot: sch.schedules.slots) {
                            TC_ScheduleParser.cls_slot slot = cslot.slot;
                            
                            SlotWrapper sw = new SlotWrapper();
                            sw.slotId = slot.id;
                            sw.status = slot.status;
                            sw.startTime = slot.startTime.replace(':00Z', '');
                            sw.endTime = slot.endTime.replace(':00Z', '');
                            
                            /*timeSlots.add(sw);
                            if (startTime == '') {
                                startTime = slot.startTime.replace(':00Z', '');
                            }
                            endTime = slot.endTime.replace(':00Z', '');
                            */
                            if (!mapSessionTimeSlots.containsKey(slot.sessionId)) {
                                mapSessionTimeSlots.put(slot.sessionId, new List<SlotWrapper>());
                            }
                            mapSessionTimeSlots.get(slot.sessionId).add(sw);
                        }
                    }
                    
                    
                } else {
                    message = 'Error: ' + slParser.status.description;
                }
            } else {
                message = 'Error: ' + httpRes.getStatus();
            }
        } catch(Exception ex) {
            message = 'Error: ' + ex.getMessage();
        }
        
        Track_Care_Log__c tcl = new Track_Care_Log__c(
            API_Name__c = 'Schedule', Method__c = 'GET', Request__c = inputParam, 
            Status_Code__c = ''+httpRes.getStatusCode(), Status__c = httpRes.getStatus(), Response__c = httpRes.getBody()
        );
        insert tcl;
        
        List<SessionWrapper> doctorSessions = new List<SessionWrapper>();
        for (String sessId: sessionIds) {
            SessionWrapper sesswrap = mapSessionDetails.get(sessId);
            List<SlotWrapper> slotWrapList = mapSessionTimeSlots.get(sessId);
            
            String sessionSlotStr = '';
            if (slotWrapList.size() > 0) {
                Integer slotLen = slotWrapList.size();
                sessionSlotStr = slotWrapList.get(0).startTime + ' - ' + slotWrapList.get(slotLen-1).endTime;
            }
            
            SessionWrapper swrap = new SessionWrapper();
            swrap.sessionId = sessId;
            swrap.sessionDesc = sesswrap.sessionDesc;
            swrap.sessionSlot = sessionSlotStr;
            swrap.services = sesswrap.services;
            swrap.timeSlots = slotWrapList;
            doctorSessions.add(swrap);
        }
        
        String nameOfDay = '';
        if (selDate != null && selDate.trim() != '') {
            nameOfDay = ((Datetime)Date.valueOf(selDate)).format('EEEE')+' ';
        }
        
        Map<String, Object> mapObjects = new Map<String, Object>();
        mapObjects.put('SelScheduleDoctor', sl.Location__c +' | '+ sl.Care_Provider__c + ' | ' + nameOfDay + selDate);
        mapObjects.put('DoctorSessions', doctorSessions);
        
        //mapObjects.put('SessionTimeInterval', startTime +' - '+ endTime);
        //mapObjects.put('SessionDescription', sessionWrap.sessionDesc);
        //mapObjects.put('SessionServices', sessionWrap.services);
        //mapObjects.put('TimeSlots', timeSlots);
        return mapObjects;
    }
    
    @AuraEnabled
    public static Map<String, Object> reviewAppointment(String recordId, String slotTime, String selDate) {
        List<String> slTime = slotTime.split('#');
        Schedule_List__c sl = [
            SELECT Id, Hospital__c, Location__c, Care_Provider__c, Specialty__c, Sub_Specialty__c,
            Hospital_Code__c, Location_Code__c, Care_Provider_Code__c, Specialty_Code__c, Sub_Specialty_Code__c
            FROM Schedule_List__c 
            WHERE Id = :slTime.get(0) LIMIT 1
        ];
        
        List<Case> cases = [SELECT Id, CaseNumber, Team_Name__c, Subject FROM Case WHERE Patient__c = :recordId AND Status != 'Closed' AND Status != 'Merged'];
        
        Appointment__c app = new Appointment__c(Account__c = recordId);
        app.Hospital__c = sl.Hospital__c;
        app.Location__c = sl.Location__c;
        app.Doctor__c = sl.Care_Provider__c;
        app.Specialty__c = sl.Specialty__c;
        app.Sub_Specialty__c = sl.Sub_Specialty__c;
        app.Hospital_Code__c = sl.Hospital_Code__c;
        app.Location_Code__c = sl.Location_Code__c;
        app.Doctor_Code__c = sl.Care_Provider_Code__c;
        app.Specialty_Code__c = sl.Specialty_Code__c;
        app.Sub_Specialty_Code__c = sl.Sub_Specialty_Code__c;
        app.Appointment_Date__c = Date.valueOf(selDate);
        app.Slot_Id__c = slTime.get(1);
        app.Appointment_Time__c = slTime.get(2);
        app.Appointment_Status__c = 'Booked';
        app.Case__c = (cases.size() > 0 ? cases.get(0).Id : null);
        app.Interpreter_Required__c = false;
        app.Interpreter__c = null;
        
        Map<String, Object> mapObjects = new Map<String, Object>();
        mapObjects.put('Cases', cases);
        mapObjects.put('Appointment', app);
        return mapObjects;
    }
    
    @AuraEnabled
    public static String bookAppointmentRecord(Appointment__c app) {
        String message = '';
        Account acc = [SELECT Id, Hospital_Number_HN__c FROM Account WHERE Id = :app.Account__c];
        List<Case> cases = [SELECT Id, CaseNumber FROM Case WHERE Id = :app.Case__c];

        Map<String, Object> mapData = new Map<String, Object>();
        mapData.put('hn', acc.Hospital_Number_HN__c);
        mapData.put('doctor', app.Doctor_Code__c);
        mapData.put('resource', '');
        mapData.put('location', app.Location_Code__c);
        mapData.put('date', DateTime.newInstance(app.Appointment_Date__c.year(), app.Appointment_Date__c.month(), app.Appointment_Date__c.day()).format('yyyy-MM-dd'));
        mapData.put('time', app.Appointment_Time__c+':00Z');
        mapData.put('service', app.Service_Code__c);
        mapData.put('slotId', app.Slot_Id__c);
        mapData.put('note', app.Notes__c != null ? app.Notes__c : '');
        mapData.put('patientLetterNotes', app.Patient_Letter_Notes__c != null ? app.Patient_Letter_Notes__c : '');
        mapData.put('nonFixedTime', app.Non_fixed_Time__c != null ? app.Non_fixed_Time__c : '');
        mapData.put('isInterpreterRequired', app.Interpreter_Required__c == true ? 'Yes' : 'No');
        mapData.put('interpreter', app.Interpreter__c != null ? app.Interpreter__c : '');
        mapData.put('caseId', cases.size() > 0 ? cases.get(0).CaseNumber + ' | ' + cases.get(0).Id : '');
        
        String dataJson = JSON.Serialize(mapData);
        HttpResponse httpRes = TC_TrakCareService.returnBookingResponse(dataJson);
        try {
            if (httpRes.getStatusCode() == 200) {
                TC_BookingParser bkParser = TC_BookingParser.parse(httpRes.getBody());
                
                if (bkParser.status.code != 'ERROR') {
                    app.Appointment_Id__c = bkParser.data.appointment.id;
                    insert app;
                    
                    message = app.Id;
                } else {
                    message = 'Error: ' + bkParser.status.description;
                }
            } else {
                message = 'Error: ' + httpRes.getStatus();
            }
        } catch(Exception ex) {
            message = 'Error: ' + ex.getMessage();
        }
        
        Track_Care_Log__c tcl = new Track_Care_Log__c(
            API_Name__c = 'Booking', Method__c = 'POST', Request__c = dataJson, 
            Status_Code__c = ''+httpRes.getStatusCode(), Status__c = httpRes.getStatus(), Response__c = httpRes.getBody()
        );
        insert tcl;
        
        return message;
    }
    
    //Picklist Wrapper
    public class PicklistWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    //Doctor Wrapper
    public class DoctorWrapper{
        @AuraEnabled public String doctorName;
        @AuraEnabled public String docSlotKey;
    }
    
    //Session Wrapper
    public class SessionWrapper{
        @AuraEnabled public String sessionId;
        @AuraEnabled public String sessionDesc;
        @AuraEnabled public String sessionSlot;
        @AuraEnabled public List<ServiceWrapper> services;
        @AuraEnabled public List<SlotWrapper> timeSlots;
    }
    
    //Service Wrapper
    public class ServiceWrapper{
        @AuraEnabled public String servicecode;
        @AuraEnabled public String serviceDesc;
        @AuraEnabled public String serviceLength;
    }
    
    //Slot Wrapper
    public class SlotWrapper{
        @AuraEnabled public String slotId;
        @AuraEnabled public String status;
        @AuraEnabled public String startTime;
        @AuraEnabled public String endTime;
    }
}