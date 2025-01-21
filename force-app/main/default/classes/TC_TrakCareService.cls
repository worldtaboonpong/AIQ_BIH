public class TC_TrakCareService {
    public static HttpResponse getSchedulesMasterResponse(String inputParam){
        TrakCareAPIConfiguration__c apiConfig = TrakCareAPIConfiguration__c.getOrgDefaults();
        HttpResponse res = getTrakCareResponse(apiConfig.Schedule_Master_Endpoint__c+inputParam, apiConfig);
        return res;
    }

	/*public static HttpResponse getSchedulesListResponse(String inputParam){
        TrakCareAPIConfiguration__c apiConfig = TrakCareAPIConfiguration__c.getOrgDefaults();
        HttpResponse res = getTrakCareResponse(apiConfig.Get_Schedule_List_Endpoint__c+inputParam, apiConfig);
        return res;
    }*/

    public static HttpResponse getSchedulesResponse(String inputParam){
        TrakCareAPIConfiguration__c apiConfig = TrakCareAPIConfiguration__c.getOrgDefaults();
        HttpResponse res = getTrakCareResponse(apiConfig.Get_Schedules_Endpoint__c+inputParam, apiConfig);
        return res;
    }

    public static HttpResponse returnBookingResponse(String jsonBody){
        TrakCareAPIConfiguration__c apiConfig = TrakCareAPIConfiguration__c.getOrgDefaults();
        HttpResponse res = postTrakCareResponse(apiConfig.Booking_Endpoint__c, apiConfig, jsonBody);
        return res;
    }

    public static HttpResponse returnCancelBookingResponse(String jsonBody){
        TrakCareAPIConfiguration__c apiConfig = TrakCareAPIConfiguration__c.getOrgDefaults();
        HttpResponse res = postTrakCareResponse(apiConfig.Cancel_Appointment_Endpoint__c, apiConfig, jsonBody);
        return res;
    }

    public static HttpResponse getOrderListResponse(String inputParam){
        TrakCareAPIConfiguration__c apiConfig = TrakCareAPIConfiguration__c.getOrgDefaults();
        HttpResponse res = getTrakCareResponse(apiConfig.Appointment_Order_List_Endpoint__c+inputParam, apiConfig);
        return res;
    }

    public static HttpResponse returnPreRegistrationResponse(String jsonBody){
        TrakCareAPIConfiguration__c apiConfig = TrakCareAPIConfiguration__c.getOrgDefaults();
        HttpResponse res = postTrakCareResponse(apiConfig.Pre_Registration_Endpoint__c, apiConfig, jsonBody);
        return res;
    }

    public static HttpResponse getOnlineAppointmentsResponse(String inputParam){
        TrakCareAPIConfiguration__c apiConfig = TrakCareAPIConfiguration__c.getOrgDefaults();
        HttpResponse res = getTrakCareResponse(apiConfig.Online_Appointments_Endpoint__c+inputParam, apiConfig);
        return res;
    }

    public static HttpResponse getPatientResponse(String inputParam){
        TrakCareAPIConfiguration__c apiConfig = TrakCareAPIConfiguration__c.getOrgDefaults();
		HttpResponse res = getTrakCareResponse(apiConfig.Patient_Endpoint__c+inputParam, apiConfig);
        return res;
    }

    public static HttpResponse returnUpdateAppResponse(String jsonBody){
        TrakCareAPIConfiguration__c apiConfig = TrakCareAPIConfiguration__c.getOrgDefaults();
        HttpResponse res = patchTrakCareResponse(apiConfig.Update_Appointment_Endpoint__c, apiConfig, jsonBody);
        return res;
    }

    //Method to GET Response
    public static HttpResponse getTrakCareResponse(String endpointUrl, TrakCareAPIConfiguration__c apiConfig){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointUrl);
        req.setMethod('GET');
        req.setTimeout(120000);
        req.setHeader('X-Username',apiConfig.X_Username__c);
        req.setHeader('X-Service-Name',apiConfig.X_Service_Name__c);
        req.setHeader('X-Request-UUID',apiConfig.X_Request_UUID__c);
        req.setHeader('X-ProxyUser-Ip',apiConfig.X_ProxyUser_Ip__c);
        req.setHeader('Content-Type','application/json');
        req.setHeader('clientId',apiConfig.ClientId__c);
        req.setHeader('clientSecret',apiConfig.Client_Secret__c);

        Http http = new Http();
        HttpResponse res = http.send(req);
        return res;
    }

    //Method to POST Response
    public static HttpResponse postTrakCareResponse(String endpointUrl, TrakCareAPIConfiguration__c apiConfig, String jsonBody){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointUrl);
        req.setMethod('POST');
        req.setBody(jsonBody);
        req.setTimeout(120000);
        req.setHeader('X-Username',apiConfig.X_Username__c);
        req.setHeader('X-Service-Name',apiConfig.X_Service_Name__c);
        req.setHeader('X-Request-UUID',apiConfig.X_Request_UUID__c);
        req.setHeader('X-ProxyUser-Ip',apiConfig.X_ProxyUser_Ip__c);
        req.setHeader('Content-Type','application/json');
        req.setHeader('clientId',apiConfig.ClientId__c);
        req.setHeader('clientSecret',apiConfig.Client_Secret__c);

        Http http = new Http();
        HttpResponse res = http.send(req);
        return res;
    }

    //Method to PATCH Response
    public static HttpResponse patchTrakCareResponse(String endpointUrl, TrakCareAPIConfiguration__c apiConfig, String jsonBody){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointUrl);
        req.setMethod('PATCH');
        req.setBody(jsonBody);
        req.setTimeout(120000);
        req.setHeader('X-Username',apiConfig.X_Username__c);
        req.setHeader('X-Service-Name',apiConfig.X_Service_Name__c);
        req.setHeader('X-Request-UUID',apiConfig.X_Request_UUID__c);
        req.setHeader('X-ProxyUser-Ip',apiConfig.X_ProxyUser_Ip__c);
        req.setHeader('Content-Type','application/json');
        req.setHeader('clientId',apiConfig.ClientId__c);
        req.setHeader('clientSecret',apiConfig.Client_Secret__c);

        Http http = new Http();
        HttpResponse res = http.send(req);
        return res;
    }
}