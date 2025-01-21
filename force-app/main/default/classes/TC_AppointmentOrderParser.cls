public class TC_AppointmentOrderParser{
	public cls_status status;
	public cls_payload[] payload;
	public class cls_status {
		public String code;	//200
		public String description;	//Get-Order-List Success
	}
	public class cls_payload {
		public String Orderstatusdesc;	//Postponed
		public String Orderitemcode;	//DA001
		public String HN;	//800306302
		public String Orderitemdesc;	//New Visit / Walk In
		public String Appointmentrowid;	//27749||68330||1
		public String Orderstatuscode;	//S
	}
	public static TC_AppointmentOrderParser parse(String json){
		return (TC_AppointmentOrderParser) System.JSON.deserialize(json, TC_AppointmentOrderParser.class);
	}
}