global class CancelAppointmentDTO {

	global class Cancel_appointments {
		public String md_code {get;set;}
		public String request_type { get; set; }
        public String request_cancellation_date {get; set;}
        public String additional_appt_cancellation_date {get; set;}
        public String cost_center_cancel {get; set;}
        public String department_cancel {get; set;}
        public String doctor_name {get; set;}
        public String specialty {get; set;}
        public String requestor {get;set;}
		public List<Patient> patients{get;set;}
	}

	global class Patient {
		public String hnnumber { get; set; }
        public String gender { get; set; }
        public String date_of_birth { get; set; }
        public String app_date { get; set; }
        public String end_time { get; set; }
        public String service { get; set; }
        public String fullname { get; set; }
        public String fullname_th { get; set; }
        public String age { get; set; }
        public String app_time { get; set; }
        public String app_status { get; set; }
        public String location { get; set; }
        public String nationality { get; set; }
	}

	global List<Cancel_appointments> cancel_appointments;

	
	global static CancelAppointmentDTO parse(String json) {
		return (CancelAppointmentDTO) System.JSON.deserialize(json, CancelAppointmentDTO.class);
	}
}