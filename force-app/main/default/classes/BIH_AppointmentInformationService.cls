global with sharing class BIH_AppointmentInformationService {
	global string hn;
	global string username ;
	global string startDate;
	global string endDate;
		
		
	global class AppointmentInfoRequest{
		@AuraEnabled
		public String serviceName {get;set;}
		@AuraEnabled
		public String serviceCode {get;set;}
		@AuraEnabled
		public String updatedUserName {get;set;}
		@AuraEnabled
		public String updatedUserId {get;set;}
		@AuraEnabled
		public String locationName {get;set;}
		@AuraEnabled
		global String doctorName {get;set;}
		@AuraEnabled
		global String visitNumber{get;set;} 
		@AuraEnabled
		global String visitDateTime{get;set;}
		@AuraEnabled
		global Integer visitStatus{get;set;}
		@AuraEnabled
		global Integer visitType{get;set;}
		@AuraEnabled
		global Integer appointmentStatus{get;set;}
		@AuraEnabled
		global String hn{get;set;}
		@AuraEnabled
		global String mdCode{get;set;}
		@AuraEnabled
		global String locationCode{get;set;}
		@AuraEnabled
		global String note{get;set;}
		@AuraEnabled
		global String appointmentDateTime{get;set;}
		@AuraEnabled
		global String visitStatusString{
			get{
				String tmp = '';
				if(this.visitStatus == 0 ){
					tmp = 'PreAdmission';
				}else if(this.visitStatus == 1){
					tmp = 'Current';
				}else if(this.visitStatus == 2){
					tmp = 'Discharged';
				}
				return tmp;
			}
			set;
		}
		@AuraEnabled
		global String visitTypeString{
			get{
				String tmp = '';
				if(this.visitType == 0 ){
					tmp = 'OPD';
				}else if(this.visitType == 1){
					tmp = 'IPD';
				}else if(this.visitType == 2){
					tmp = 'ER';
				}
				return tmp;
			}
			set;
		}
		@AuraEnabled
		global String appointmentStatusString{
			get{
				String tmp = '';
				if(this.appointmentStatus == 0 ){
					tmp = 'WaitingForConfirmation';
				}else if(this.appointmentStatus == 1){
					tmp = 'Confirm';
				}else if(this.appointmentStatus == 2){
					tmp = 'Cancel';
				}else if(this.appointmentStatus == 3){
					tmp = 'Arrived';
				}else if(this.appointmentStatus == 4){
					tmp = 'Rejected';
				}
				return tmp;
			}
			set;
		}
	}
	global static List<AppointmentInfoRequest> getAppointmentInformation(string hnNumber) {
		Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        // Set Request Header
        req.setHeader('Ocp-Apim-Subscription-Key',BIH_Constants.SUBSCRIPTION_KEY);
		req.setTimeout(Integer.ValueOf(BIH_Constants.SET_TIMEOUT_SERVICE));
        // String endpoint ='https://bihtest.azure-api.net/crm/v1/Patient/appointment/list/'+hn+'/'+username+'/'+startDate+'/'+endDate+'';
		Date today = Date.today();
		Datetime last6month = today.addMonths(-3);
		Datetime next12month = today.addMonths(3);
		
		String endpoint =BIH_Constants.END_POINT_APPOINTMENT_LIST+hnNumber+'/'+BIH_Constants.SERVICE_USERNAME_TRAKCARE+'/'+last6month.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'')+'/'+next12month.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        
		req.setEndpoint(endpoint);//app config end point
		System.debug(endpoint);
        HttpResponse res = http.send(req);
		System.debug(res.getBody());
    	List<AppointmentInfoRequest> air = (List<AppointmentInfoRequest>) System.JSON.deserialize(res.getBody(), List<AppointmentInfoRequest>.class);
		System.debug(air);
		// System.debug(air[0].visitTypeString);
		return air;
	}
}