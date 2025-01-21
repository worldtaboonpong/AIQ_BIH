public class TC_PatientAlertParser{
	public cls_status status;
	public cls_data data;
	public cls_responseStatus responseStatus;
	public class cls_status {
		public Integer code;	//200
		public String description;	//success
	}
	public class cls_data {
		public String hn;	//800654788
		public cls_iconProfile[] iconProfile;
		public cls_patientAlert[] patientAlert;
	}
	public class cls_iconProfile {
		public cls_patientDataIcon patientDataIcon;
	}
	public class cls_patientDataIcon {
		public String iconCode;	//TC.gotAllergy
		public String iconDescription;	//Patient has Allergies
		public String iconPath;	//../custom/THBI/images/icon/bihallergy.png
	}
	public class cls_patientAlert {
		public cls_patientDataAlert patientDataAlert;
	}
	public class cls_patientDataAlert {
		public String alertCategory;	//Breastfeeding
		public String alert;	//Breast Feeding
		public String onsetDate;	//07/03/2024
		public String patientMessage;
		public String status;	//Active
	}
    public class cls_responseStatus {
		public String code;	//SUCCESS
		public String description;	//Completed
	}
	public static TC_PatientAlertParser parse(String json){
		return (TC_PatientAlertParser) System.JSON.deserialize(json, TC_PatientAlertParser.class);
	}
}