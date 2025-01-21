public class TC_AppointmentListParser {
	public cls_status status;
	public cls_data data;
	public cls_responseStatus responseStatus;
	public class cls_status {
		public String code;	//200
		public String description;	//success
	}
	public class cls_data {
		public String hn;	//800306303
		public cls_schedules[] schedules;
	}
	public class cls_schedules {
		public cls_schedule schedule;
	}
	public class cls_schedule {
		public cls_doctor doctor;
		public cls_resource resource;
		public cls_location location;
		public cls_slots[] slots;
		public cls_appointments[] appointments;
	}
	public class cls_doctor {
		public String code;	//
		public String description;	//
	}
	public class cls_resource {
		public String code;	//BIHF05OR02
		public String description;	//OR 02 CVT/ORT/NEU
	}
	public class cls_location {
		public String code;	//BIHF05OR
		public String description;	//Operating Room (Building B 5th Floor)
	}
	public class cls_slots {
		public cls_slot slot;
	}
	public class cls_slot {
		//public String date;	//2022-05-26
		public String startTime;	//00:00:00Z
		public String endTime;	//23:59:00Z
	}
	public class cls_appointments {
		public cls_appointment appointment;
	}
	public class cls_appointment {
		public String id;	//4943||1645||1
		public String appDate;	//2022-05-26
		public String appTime;	//00:00:00Z
		public cls_service service;
		public String note;	//
		public String caseId;	//
		public String patientLetterNotes;	//
		public String isInterpreterRequired;	//No
		public cls_interpreter interpreter;
		public String interpreterConfirmed;	//No
		public cls_preferredLanguage preferredLanguage;
		public String nonFixedTime;	//
		public String appStatus;	//Arrived
        public String updateBy;	//User
        public String updateDate;	//2022-05-26
		public String updateTime;	//00:00:00Z
        public cls_details[] details;
	}
	public class cls_service {
		public String code;	//
		public String description;	//
	}
	public class cls_interpreter {
		public String code;	//
		public String description;	//
	}
	public class cls_preferredLanguage {
		public String code;	//
	}
	public class cls_responseStatus {
		public String code;	//SUCCESS
		public String description;	//Completed
	}
	
	public class cls_details {
		public cls_auditTrail auditTrail;
	}
    
	public class cls_auditTrail {
		public String sequence;	//1
		public String field;	//APPT_OEORI_DR
		public String valueChangeFrom;	//
		public String valueChangeTo;	//800594242 : Follow up
		public String action;	//U
	}
    
	public static TC_AppointmentListParser parse(String json){
		return (TC_AppointmentListParser) System.JSON.deserialize(json, TC_AppointmentListParser.class);
	}
}