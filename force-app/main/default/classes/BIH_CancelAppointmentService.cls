@RestResource(urlMapping='/BIH_CancelAppointmentService')
global with sharing class BIH_CancelAppointmentService {
    global class BaseResponse {
        global  boolean success {get; set;}
        global  integer code {get; set;}
        global  string message {get; set;}
        global  string parentId {get; set;}
    }
    @HttpPost
    global static BaseResponse cancelAppointment(){
        RestRequest req = RestContext.request;
        String message = '';
        CancelAppointmentDTO cancelApps = new CancelAppointmentDTO();
        Group cc = [SELECT Id, Name, DeveloperName,type FROM Group where name = 'Contact Center Team' and type ='Queue'];
        try {
            cancelApps = CancelAppointmentDTO.parse(req.requestBody.toString());
            // cancelApps = CancelAppointmentDTO.parse(x);
            List<Case> parentCaselist = new List<Case>();
            List<Case> childCaselist = new List<Case>();
            for (CancelAppointmentDTO.Cancel_appointments parentobj : cancelApps.cancel_appointments){
                Case parentCase = new Case();
                parentCase.Cancellation_Appointment__c = true;
                parentCase.RecordTypeId = BIH_Constants.CONTACT_CENTER_CASE_RECORDTYPE;
                parentCase.OwnerId = cc.Id;
                parentCase.Channel__c = 'Contact Center';
                parentCase.Contact_Center_Channel__c = 'Outbound';
                parentCase.Origin = 'Web';
                parentCase.Case_Category_Level1__c = Label.Cancel_Appointment_Cat_1_Default;
                parentCase.Case_Category_Level2__c = Label.Cancel_Appointment_Cat_2_Default;
                parentCase.Case_Category_Level3__c = Label.Cancel_Appointment_Cat_3_Default;
                System.debug('OBJECT : '+parentobj);
                List<CancelAppointmentDTO.Patient> patients = parentobj.patients;
                CancelAppointmentDTO.Patient patient = patients.get(0);
                parentCase.MD_Code__c = parentobj.md_code;
                parentCase.Type_of_Request__c = parentobj.request_type;
                parentCase.Appt_Cancellation_Date__c = Date.valueOf(parentobj.request_cancellation_date);
                parentCase.Additional_Appt_Cancellation_Date__c = parentobj.additional_appt_cancellation_date;
                parentCase.Cost_Center_Cancel__c = parentobj.cost_center_cancel;
                parentCase.Department_Cancel__c = parentobj.department_cancel;
                parentCase.Doctor_Name__c = parentobj.doctor_name;
                parentCase.Specialty__c = parentobj.specialty;
                parentCase.Requestor__c = parentobj.requestor;
                if (patient != null){
                    parentCase.Subject = Label.Cancel_Appointment_Cat_1_Default + ':' + Label.Cancel_Appointment_Cat_2_Default + ':'+Label.Cancel_Appointment_Cat_3_Default +' (HN:' +patient.hnnumber +')';
                    parentCase.Hospital_Number_HN__c = patient.hnnumber;
                    parentCase.Full_Name__c = patient.fullname;
                    parentCase.Full_Name_Thai__c = patient.fullname_th;                
                    parentCase.Gender__c = patient.gender;
                    if (patient.date_of_birth != null){
                        parentCase.Date_of_Birth__c =  Date.valueOf(patient.date_of_birth);
                    }
                    parentCase.App_Date__c = Date.valueOf(patient.app_date);
                    if (patient.end_time != null){
                        String strTimeChange = patient.end_time;
                        String[] strTimeSplit = strTimeChange.split(':');
                        Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                                ,Integer.valueOf(strTimeSplit[1]) //min
                                                                ,0                                //sec
                                                                ,0).addHours(-7);  
                        parentCase.End_Time__c = timeChange;
                    }
                    parentCase.Service__c = patient.service;
                    parentCase.Age__c = patient.age;
                    if (patient.app_time != null){
                        String strTimeChange = patient.app_time;                    
                        String[] strTimeSplit = strTimeChange.split(':');
                        Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                                ,Integer.valueOf(strTimeSplit[1]) //min
                                                                ,0                                //sec
                                                                ,0).addHours(-7);   
                        parentCase.App_Time__c = timeChange;
                    }
                    parentCase.Appt_Status__c = patient.app_status;
                    parentCase.Location__c = patient.location;
                    parentCase.Nationality__c = patient.nationality;
                    parentCaselist.add(parentCase);

                for (integer i = 1 ; i <patients.size();i++){
                    Case childCase = new Case();
                    childCase.MD_Code__c = parentobj.md_code;
                    childCase.Type_of_Request__c = parentobj.request_type;
                    childCase.Appt_Cancellation_Date__c = Date.valueOf(parentobj.request_cancellation_date);
                    childCase.Additional_Appt_Cancellation_Date__c = parentobj.additional_appt_cancellation_date;
                    childCase.Cost_Center_Cancel__c = parentobj.cost_center_cancel;
                    childCase.Department_Cancel__c = parentobj.department_cancel;
                    childCase.Doctor_Name__c = parentobj.doctor_name;
                    childCase.Specialty__c = parentobj.specialty;
                    childCase.Hospital_Number_HN__c = patients[i].hnnumber;
                    childCase.Full_Name__c = patients[i].fullname;
                    childCase.Full_Name_Thai__c = patients[i].fullname_th;                
                    childCase.Gender__c = patients[i].gender;
                    if (patients[i].date_of_birth != null){
                        childCase.Date_of_Birth__c =  Date.valueOf(patients[i].date_of_birth);
                    }
                    childCase.App_Date__c = Date.valueOf(patients[i].app_date);
                    if (patients[i].end_time != null){
                        String strTimeChange = patients[i].end_time;
                        String[] strTimeSplit = strTimeChange.split(':');
                        Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                                ,Integer.valueOf(strTimeSplit[1]) //min
                                                                ,0                                //sec
                                                                ,0).addHours(-7);  
                        childCase.End_Time__c = timeChange;
                    }
                    childCase.Service__c = patients[i].service;
                    childCase.Age__c = patients[i].age;
                    if (patients[i].app_time != null){
                        String strTimeChange = patients[i].app_time;                    
                        String[] strTimeSplit = strTimeChange.split(':');
                        Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                                ,Integer.valueOf(strTimeSplit[1]) //min
                                                                ,0                                //sec
                                                                ,0).addHours(-7);   
                        childCase.App_Time__c = timeChange;
                    }
                    childCase.Appt_Status__c = patients[i].app_status;
                    childCase.Location__c = patients[i].location;
                    childCase.Nationality__c = patients[i].nationality;
                    childCaselist.add(childCase);
                }
            }
            }
            system.debug('parentCaselist'+parentCaselist);
            insert parentCaselist;
            for (Case parent : parentCaselist){
                message += parent.Id +',';
                for (Case child : childCaselist){
                    if (parent.MD_Code__c == child.Md_Code__c){
                        child.ParentId = parent.Id;
                        child.Cancellation_Appointment__c = true;
                        child.RecordTypeId = BIH_Constants.CONTACT_CENTER_CASE_RECORDTYPE;
                        child.OwnerId = cc.Id;
                        child.Requestor__c = parent.Requestor__c;
                        child.Channel__c = 'Contact Center';
                        child.Contact_Center_Channel__c = 'Outbound';
                        child.Origin = 'Web';
                        child.Subject = Label.Cancel_Appointment_Cat_1_Default + ':' + Label.Cancel_Appointment_Cat_2_Default + ':'+Label.Cancel_Appointment_Cat_3_Default +' (HN:' +child.Hospital_Number_HN__c +')';
                        child.Case_Category_Level1__c = Label.Cancel_Appointment_Cat_1_Default;
                        child.Case_Category_Level2__c = Label.Cancel_Appointment_Cat_2_Default;
                        child.Case_Category_Level3__c = Label.Cancel_Appointment_Cat_3_Default;
                    }
                }
            }
            system.debug('childCaselist'+childCaselist);
            insert childCaselist;
            // System.debug('mapjson: '+mapJson);
            system.debug('cancelApps'+cancelApps);
            system.debug('cancelApps1'+cancelApps.cancel_appointments);

            } catch (Exception ex) {
                BaseResponse resp = new BaseResponse();
                resp.success =   false;
                resp.code    =   400;
                resp.message = 'transaction was fail. Error : '+ex;
                system.debug('resp'+resp);
                return resp;
            }
        
        BaseResponse resp = new BaseResponse();
        resp.success =   true;
        resp.code    =   200;
        resp.parentId = message;
        // resp.message = 'files was create completed'+ ' OBJECT : '+data_i;
        resp.message = 'files was create completed';
        system.debug('resp'+resp);

        return resp;

    }
}