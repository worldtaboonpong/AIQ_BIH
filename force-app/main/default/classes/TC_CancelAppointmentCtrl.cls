public class TC_CancelAppointmentCtrl {
	@AuraEnabled
    public static String cancelAppointments(String appId, Appointment__c appDetail) {
        Appointment__c app = [SELECT Id, Appointment_Id__c FROM Appointment__c WHERE Id = :appId];
        String message = appointmentCancelledCallout(appId, app.Appointment_Id__c, appDetail);
        return message;
    }

    public static String appointmentCancelledCallout(String sfId, String tcId, Appointment__c appDetail) {
        appDetail.Cancelled_By__c = Userinfo.getName();
        appDetail.Cancelled_Date__c = Datetime.now().format('yyyy-MM-dd');
        appDetail.Cancelled_Time__c = Datetime.now().format('HH:mm:ss');
        
        String message = '';
        Map<String, Object> mapData = new Map<String, Object>();
        mapData.put('appointmentId', tcId);
        mapData.put('reasonForCancelCode', appDetail.Reason_for_Cancellation__c);
        mapData.put('reasonForCancelFreeText', appDetail.Free_Text_Reason_for_Cancellation__c);
        mapData.put('discontinueOrder', (appDetail.Discontinue_Orders__c == true ? '1' : '0'));
        mapData.put('userName', appDetail.Cancelled_By__c);
        mapData.put('ipAddress', '');
        
        String dataJson = JSON.Serialize(mapData);
        HttpResponse httpRes = TC_TrakCareService.returnCancelBookingResponse(dataJson);
        
        if (httpRes.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(httpRes.getBody());
            Map<String, Object> rMap = (Map<String, Object>)responseMap.get('status');
            if (''+rMap.get('code') == 'ERROR') {
                message = 'Error: '+ rMap.get('description');
            } else {
                if (String.isNotEmpty(sfId)) {
                    appDetail.Id = sfId;
                    appDetail.Appointment_Status__c = 'Cancelled';
                    update appDetail;
                }
                message = 'Appointment Cancelled Successfully !!';
            }
        } else {
            message = 'Error: '+ httpRes.getStatus();
        }
        
        Track_Care_Log__c tcl = new Track_Care_Log__c(
            API_Name__c = 'Cancel Booking', Method__c = 'POST', Request__c = dataJson, 
            Status_Code__c = ''+httpRes.getStatusCode(), Status__c = httpRes.getStatus(), Response__c = httpRes.getBody()
        );
        insert tcl;
        
        return message;
    }
}