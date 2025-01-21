public class TC_ScheduleListParser {
    public cls_status status;
    public cls_payload[] payload;
    
    public class cls_status {
        public String code;	//200
        public String description;	//Get-Schedules-List Success
    }
    
    public class cls_payload {
        public String hospitaldesc;	//Bumrungrad International Hospital
        public String hospitalcode;	//BH
        public String location;	//Women's Center (Building B 2nd Floor)
        public String locationCode;	//BIHF02WOMEN
        public String Specialty;	//สูติศาสตร์ นรีเวชวิทยา / OB/GYN (Women) (2)
        public String SpecialtyCode;
        public String SubSpecialty;	//สูติศาสตร์ นรีเวชวิทยา / OB/GYN (Women)
        public String SubSpecialtyCode;
        public String careProvider;	//Jantra Chennavasin (Dr.)
        public String careCode;	//104497		
        public String sessionDate;	//02/06/2023
        public String sessStartTime;	//09:00:00 
        public String sessEndTime;	//12:00:00
        public String genDateTo;	//31/12/2024
        public String FlagDoctor;	//Y
    }
    
    public static TC_ScheduleListParser parse(String json){
        return (TC_ScheduleListParser) System.JSON.deserialize(json, TC_ScheduleListParser.class);
    }
}