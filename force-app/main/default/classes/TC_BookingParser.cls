public class TC_BookingParser {
	public cls_status status;
	public cls_data data;
	
    public class cls_status {
		public String code;	//200
		public String description;	//success
	}
	public class cls_data {
		public String hn;	//800306302
		public cls_appointment appointment;
		public cls_responseStatus responseStatus;
	}
	public class cls_appointment {
		public String id;	//27749||68288||1
		//public String date;	//2023-06-21
		//public String time;	//11:00:00Z
	}
	public class cls_responseStatus {
		public String code;	//SUCCESS
		public String description;	//Completed
	}
    
	public static TC_BookingParser parse(String json){
		return (TC_BookingParser) System.JSON.deserialize(json, TC_BookingParser.class);
	}
}