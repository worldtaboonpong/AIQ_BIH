({
    jsDoInit : function(component, event, helper) {
        var action = component.get("c.fetchAppointments");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var upcomingRecords = response.getReturnValue().Upcoming;
                upcomingRecords.forEach(function(record){
                    if (record.appSfId) {
                        record.linkName = '/'+record.appSfId;
                    }
                });
                component.set("v.upcomingData", upcomingRecords);
                
                var pastRecords = response.getReturnValue().Past;
                pastRecords.forEach(function(record){
                    if (record.appSfId) {
                        record.linkName = '/'+record.appSfId;
                    }
                });
                component.set("v.inPastData", pastRecords);
                
                var cancelRecords = response.getReturnValue().Cancel;
                cancelRecords.forEach(function(record){
                    if (record.appSfId) {
                        record.linkName = '/'+record.appSfId;
                    }
                });
                component.set("v.cancelData", cancelRecords);
            }
        });
        $A.enqueueAction(action);
    },
    
    jsOk : function(component, event, helper) {
        var appointmentVar = component.get("v.appointment");
        if (appointmentVar.Reason_for_Cancellation__c == null) {
            helper.showToast("Cancel Appointment", "Please select Reason for Cancellation", "error");
        } else {
            var action = component.get("c.cancelAppointments");
            action.setParams({
                "sfId": component.get("v.selSfId"),
                "tcId": component.get("v.selTcId"),
                "appDetail": appointmentVar
            });
            action.setCallback(this, function (result) {
                var responseString = result.getReturnValue();
                if(!responseString.includes('Error')) {
                    helper.showToast("Cancel Appointment", responseString, "success");
                    component.set("v.isCancel", false);
                    window.location.reload();
                } else {
                    helper.showToast("Cancel Appointment", responseString, "error");
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    jsFetchOrders : function(component, event, helper) {
        var action = component.get("c.fetchAppointmentOrders");
        action.setParams({
            "appointmentId": component.get("v.selTcId")
        });
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                component.set("v.recordList", result.getReturnValue());
                
                component.set("v.isOrders", true);
            }
        });
        $A.enqueueAction(action);
    },
    
    jsViewAppointment : function(component, event, helper, appTcIdVar) {
        var action = component.get("c.viewAppointment");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "appTcId": appTcIdVar
        });
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                component.set("v.appData", result.getReturnValue());
                component.set("v.isView", true);
            }
        });
        $A.enqueueAction(action);
    },
    
    jsRedirectToRecord: function (component, event, helper, recordIdVar) {
        var action = component.get("c.viewSfAppointment");
        action.setParams({
            "recordId": recordIdVar
        });
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                var navServiceVar = component.find("navService");
                var pageReference = {
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: recordIdVar,
                        objectApiName: "Appointment__c",
                        actionName: "view"
                    }
                };
                navServiceVar.navigate(pageReference);
            }
        });
        $A.enqueueAction(action);        
    },
    
    showToast : function(title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
})