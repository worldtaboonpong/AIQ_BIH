public class TC_AppointmentOrdersCtrl {
	@AuraEnabled
    public static List<OrderWrapper> fetchOrders(String recordId) {
        Appointment__c app = [
            SELECT Id, Appointment_Id__c    
            FROM Appointment__c 
            WHERE Id = :recordId
        ];
        return fetchAppointmentOrders(app.Appointment_Id__c);
    }
    
    public static List<OrderWrapper> fetchAppointmentOrders(String appointmentId) {
        List<OrderWrapper> orders = new List<OrderWrapper>();
        
        String inputParam = '?appointmentRowId=' + (appointmentId != null ? appointmentId.replace('||', '-') : '');
        HttpResponse httpRes = TC_TrakCareService.getOrderListResponse(inputParam);
        
        Track_Care_Log__c tcl = new Track_Care_Log__c(
            API_Name__c = 'Appointment Orders', Method__c = 'GET', Request__c = inputParam, 
            Status_Code__c = ''+httpRes.getStatusCode(), Status__c = httpRes.getStatus(), Response__c = httpRes.getBody()
        );
        insert tcl;
        
        if (httpRes.getStatusCode() == 200) {
            TC_AppointmentOrderParser orderObj = TC_AppointmentOrderParser.parse(httpRes.getBody());
            if (orderObj.payload != null) {
                for(TC_AppointmentOrderParser.cls_payload item: orderObj.payload){
                    OrderWrapper ow = new OrderWrapper();
                    ow.Orderitemdesc = item.Orderitemdesc;
                    ow.Orderitemcode = item.Orderitemcode;
                    ow.Orderstatusdesc = item.Orderstatusdesc;
                    orders.add(ow);
                }
            }
        }
        
        return orders;
    }
    
    //Order Wrapper
    public class OrderWrapper {
        @AuraEnabled public String Orderitemdesc;
        @AuraEnabled public String Orderitemcode;
        @AuraEnabled public String Orderstatusdesc;
    }
}