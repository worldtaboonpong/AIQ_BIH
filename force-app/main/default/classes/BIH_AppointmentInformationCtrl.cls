public with sharing class BIH_AppointmentInformationCtrl {
	// public BIH_AppointmentInformationCtrl() {
		
	// }
	@AuraEnabled
    public static List<BIH_AppointmentInformationService.AppointmentInfoRequest> getAppointmentInformation(String hnNumber) {
        List<BIH_AppointmentInformationService.AppointmentInfoRequest> data = BIH_AppointmentInformationService.getAppointmentInformation(hnNumber);
		System.debug('data :' +data);
		return data;
    }
	@AuraEnabled
    public static Account getAccount(String accountId) {
        // List<BIH_AppointmentInformationService.AppointmentInfoRequest> data = BIH_AppointmentInformationService.getAppointmentInformation(hnNumber);
		// System.debug('data :' +data);
		return [SELECT id,Hospital_Number_HN__c FROM Account WHERE Id=:accountId];
    }
}