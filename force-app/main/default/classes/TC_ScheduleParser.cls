public class TC_ScheduleParser {
    public cls_status status;
    public cls_data data;
    public class cls_status {
        public String code;	//200
        public String description;	//success
    }
    public class cls_data {
        public cls_schedules[] schedules;
        public cls_responseStatus responseStatus;
    }
    public class cls_schedules {
        public cls_schedules schedules;
        public cls_doctor doctor;
        public cls_resource resource;
        public cls_location location;
        public cls_hospital hospital;
        public cls_service service;
        public cls_specialty specialty;
        public cls_subSpecialty subSpecialty;
        public cls_sessions[] sessions;
        public cls_slots[] slots;
        public String isAllowOnlineBooking;	//N
        public String surgeon;	//No
        public String anaesthetist;	//No
        public String radiologist;	//No
    }
    public class cls_doctor {
        public String Code;	//181560
        public String Description;	//Kochakorn Panomtham (Dr.)
    }
    public class cls_resource {
        public String code;	//
        public String description;	//
    }
    public class cls_location {
        public String Code;	//BIH60SECLOC
        public String Description;	//60 Seconds Clinic
    }
    public class cls_hospital {
        public String Code;	//BH
        public String Description;	//Bumrungrad International Hospital
    }
    public class cls_service {
        public String code;	//
        public String description;	//
    }
    public class cls_specialty {
        public String Code;	//S208
        public String Description;	//เวชศาสตร์ป้องกัน (ตรวจสุขภาพ) / Preventive Medicine (Check up)
    }
    public class cls_subSpecialty {
        public String Code;	//S209
        public String Description;	//เวชศาสตร์ป้องกัน (ตรวจสุขภาพ) / Preventive Medicine (Check up) (2)
    }
    public class cls_sessions {
        public cls_session session;
    }
    public class cls_session {
        public String sessionId;	//27749||1||7
        public String description;	//
        public cls_services[] services;
    }
    public class cls_services {
        public String code;	//DA001
        public String description;	//New Visit / Walk In
        public String duration;	//10
    }
    public class cls_slots {
        public cls_slot slot;
    }
    public class cls_slot {
        public String id;	//27749||68090
        //public String date;	//2023-06-18
        public String startTime;	//08:00:00Z
        public String endTime;	//08:10:00Z
        public String numberOfAvailable;	//1
        public String status;	//Avaliable
        public String sessionType;	//
        public String sessionId;	//
        public String overBookStatus;	//
        public String numberOfAvailableOverBook;	//
        public String notAvailble;	//
        public String notAvailableReason;	//
        public String notAvailbleRemarks;	//
        public cls_apptList[] apptList;
    }
    
    public class cls_apptList {
		public cls_slotAppt slotAppt;
	}
    
	public class cls_slotAppt {
		public String apptId;	//7237||12625||1
		public String patientName;	//Miss Anoma Pititano
        public String hn;	//800654788
	}
    
    public class cls_responseStatus {
        public String code;	//SUCCESS
        public String description;	//Completed
    }
    
    public static TC_ScheduleParser parse(String json){
        return (TC_ScheduleParser) System.JSON.deserialize(json, TC_ScheduleParser.class);
    }
}