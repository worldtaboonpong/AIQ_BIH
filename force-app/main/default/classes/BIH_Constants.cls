public without sharing class BIH_Constants {

	public static Map<string , BIH_Constants__mdt> Constants {
        get{
            if (null == Constants) {
                Constants = new Map<string , BIH_Constants__mdt>();
                for (List<BIH_Constants__mdt> cons : [Select Id, MasterLabel , DeveloperName , Value_1__c From BIH_Constants__mdt]) {
                    for (BIH_Constants__mdt con : cons) {
                        Constants.put(con.DeveloperName , con);
                    }
                }
            }
            return Constants;
        }
		set;
    }
    public static final Id      PRIMARY_CASE_RECORDTYPE         =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Primary Case').getRecordTypeId();
    public static final Id      AIRPORT_TRANSFER_CASE_RECORDTYPE=  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airport Transfer Case').getRecordTypeId();
    public static final Id      PHARMACY_CASE_RECORDTYPE        =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pharmacy Case').getRecordTypeId();
    public static final Id      CONTACT_CENTER_CASE_RECORDTYPE  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Contact Center Case').getRecordTypeId();
	// public static final Id      CLINIC_CASE_RECORDTYPE          =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clinic Case').getRecordTypeId();
    public static final String  END_POINT_APPOINTMENT_LIST     	=  Constants.containsKey('END_POINT_APPOINTMENT_LIST') 	? Constants.get('END_POINT_APPOINTMENT_LIST').Value_1__c 	: 'https://bihtest.azure-api.net/crm/v1/Patient/appointment/list/';
    public static final String  END_POINT_SMS_MESSAGE     	    =  Constants.containsKey('END_POINT_SMS_MESSAGE') 	    ? Constants.get('END_POINT_SMS_MESSAGE').Value_1__c 	    : 'https://bihtest.azure-api.net/crm/v1/Notification/sms/send';
	public static final String  END_POINT_PATIENT_BY_HN     	=  Constants.containsKey('END_POINT_PATIENT_BY_HN') 	? Constants.get('END_POINT_PATIENT_BY_HN').Value_1__c 		: 'https://bihtest.azure-api.net/crm/v1/Patient/profile?hn=';
	public static final String  END_POINT_PATIENT_BY_STRING     =  Constants.containsKey('END_POINT_PATIENT_BY_STRING') ? Constants.get('END_POINT_PATIENT_BY_STRING').Value_1__c 	: 'https://bihtest.azure-api.net/crm/v1/Patient/search?';
    public static final String  END_POINT_DOCTOR_SCHEDULE       =  Constants.containsKey('END_POINT_DOCTOR_SCHEDULE')   ? Constants.get('END_POINT_DOCTOR_SCHEDULE').Value_1__c 	: 'https://bihtest.azure-api.net/crm/v1/Doctors/schedules?';
    public static final String  SERVICE_USERNAME_TRAKCARE     	=  Constants.containsKey('SERVICE_USERNAME_TRAKCARE') 	? Constants.get('SERVICE_USERNAME_TRAKCARE').Value_1__c 	: 'nct@ii.co.th';
	public static final String  SET_TIMEOUT_SERVICE     		=  Constants.containsKey('SET_TIMEOUT_SERVICE') 		? Constants.get('SET_TIMEOUT_SERVICE').Value_1__c 			: '5000';
	public static final String  SUBSCRIPTION_KEY     			=  Constants.containsKey('SUBSCRIPTION_KEY') 			? Constants.get('SUBSCRIPTION_KEY').Value_1__c 				: '42b00c43837d41b48dcbbba7510d990d';
    public static final String  SIGNATURE_INVITATION_LETTER     =  Constants.containsKey('SIGNATURE_INVITATION_LETTER') ? Constants.get('SIGNATURE_INVITATION_LETTER').Value_1__c 	: 'SignatureInvitaionLetter';
    public static final String  NAME_INVITATION_LETTER          =  Constants.containsKey('NAME_INVITATION_LETTER') 		? Constants.get('NAME_INVITATION_LETTER').Value_1__c 		: 'Dr. Nipat Kulabkaw';
    public static final String  POSITION_INVITATION_LETTER      =  Constants.containsKey('POSITION_INVITATION_LETTER') 	? Constants.get('POSITION_INVITATION_LETTER').Value_1__c 	: 'Senior Director, International Patient Experience';
    public static final Boolean IS_RUNTRIGGER      				=  Constants.containsKey('IS_RUNTRIGGER') 				? Boolean.valueOf(Constants.get('IS_RUNTRIGGER').Value_1__c): Boolean.valueOf('True');
    public static final String  DELETE_CTI_CONTACT_DAYS     	=  Constants.containsKey('DELETE_CTI_CONTACT_DAYS') 		? Constants.get('DELETE_CTI_CONTACT_DAYS').Value_1__c 			: '1';
}