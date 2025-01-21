@IsTest
public class TC_TestDataFactory {
	/**
	 * CHANGE LOG:
	 * - (16 Jan 2025): add param Update_Appointment_Endpoint__c to support test
	 */
	public static void insertConfigData() {
        TrakCareHospitalConfiguration__c tchConfig = new TrakCareHospitalConfiguration__c();
        tchConfig.Name = 'Test BH';
        tchConfig.Hospital_Code__c = 'BH';
        insert tchConfig;

        TrakCareAPIConfiguration__c tcaConfig = new TrakCareAPIConfiguration__c();
        tcaConfig.Appointment_Order_List_Endpoint__c = 'https://salesforceapitest.bumrungrad.com';
        tcaConfig.Booking_Endpoint__c = 'https://salesforceapitest.bumrungrad.com';
        tcaConfig.Cancel_Appointment_Endpoint__c = 'https://salesforceapitest.bumrungrad.com';
        tcaConfig.Get_Schedule_List_Endpoint__c = 'https://salesforceapitest.bumrungrad.com';
        tcaConfig.Get_Schedules_Endpoint__c = 'https://salesforceapitest.bumrungrad.com';
        tcaConfig.Online_Appointments_Endpoint__c = 'https://salesforceapitest.bumrungrad.com';
        tcaConfig.Pre_Registration_Endpoint__c = 'https://salesforceapitest.bumrungrad.com';
        tcaConfig.Schedule_Master_Endpoint__c = 'https://salesforceapitest.bumrungrad.com';
		tcaConfig.Update_Appointment_Endpoint__c = 'https://salesforceapitest.bumrungrad.com';
        tcaConfig.ClientId__c = '123456';
        tcaConfig.Client_Secret__c = '123456';
        tcaConfig.X_ProxyUser_Ip__c = '172.168.1.10';
        tcaConfig.X_Request_UUID__c = '123456';
        tcaConfig.X_Service_Name__c = '123456';
        tcaConfig.X_Username__c = '123456';
        insert tcaConfig;

        List<Schedule_List__c> slToCreate = new List<Schedule_List__c>();
        slToCreate.add(new Schedule_List__c(
            Hospital__c = 'Test', Hospital_Code__c = 'BH', Location__c = 'Test', Location_Code__c = 'BICF15N15D',
            Specialty__c = 'Test', Specialty_Code__c = 'S118', Sub_Specialty__c = 'Test', Sub_Specialty_Code__c = 'S105',
            Care_Provider__c = 'Test', Care_Provider_Code__c = '67389', Flag_Doctor__c = 'Y'
        ));
        insert slToCreate;
    }
}