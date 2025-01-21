global without sharing  class BIH_DoctorScheduleService {
    global class TimeSlot {
		@AuraEnabled
		global String code{get;set;}
		@AuraEnabled
		global String startTime{get;set;}
		@AuraEnabled
		global String endTime{get;set;}
		@AuraEnabled
		global String locationCode{get;set;}
		@AuraEnabled
		global String location{get;set;}
		@AuraEnabled
		global Boolean isAvailable{get;set;}
	}
    // global class doctorSchedule{
    //     global List<TimeSlot> timeSlot{get;set;}
    // }
    global static List<TimeSlot> getDoctorSchedule(string mdCode,Datetime startdate,Datetime enddate) {
        String tmpStartDate = startdate.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        String tmpEndDate = enddate.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        //2019-01-05T13:45:00
		Http http = new Http();
        HttpRequest req = new HttpRequest();
		
        req.setMethod('GET');
		req.setTimeout(Integer.ValueOf(BIH_Constants.SET_TIMEOUT_SERVICE));
        // Set Request Header
        String params = 'MDCode='+mdCode+'&'+'StartDate='+tmpStartDate+'&'+'EndDate='+tmpEndDate;
        req.setHeader('Ocp-Apim-Subscription-Key',BIH_Constants.SUBSCRIPTION_KEY);
        //String endpoint = BIH_Constants.END_POINT_DOCTOR_SCHEDULE+params;
        //Change Endpoint by Kwanhatai 5-1-2024
        String endpoint = 'https://salesforceapitest.bumrungrad.com/ex-sfdc/api/v1/schedules?doctor=53101&resource=&location=BICF15N15A&service=&dateForm=2023-06-12&dateTo=&userName=&ipAddress= ';
        req.setEndpoint(endpoint);//app config end point
		System.debug(endpoint);

        HttpResponse res = http.send(req);
		//System.debug(res.getBody());
		List<TimeSlot> tmpslot = new List<TimeSlot>();
		// System.debug(res.getStatusCode());
		if(res.getStatusCode() == 200 || res.getStatusCode() == 206){
    		tmpslot = (List<TimeSlot>) System.JSON.deserialize(res.getBody(), List<TimeSlot>.class);
		}else{
			system.debug(res.getStatusCode()+' : '+res.getBody() );
		}
        System.debug('tmpslot : '+tmpslot);

        return tmpslot ;
    }
}