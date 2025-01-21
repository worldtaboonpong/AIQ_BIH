({
    startSpinner: function (component) {
        component.set('v.loading', true);
    },
    stopSpinner: function (component) {
        component.set('v.loading', false);
    },
	jsBookingDetails: function (component, event, helper) {
        var action = component.get("c.getBookingDetails");
        action.setParams({
            "selHospital": component.get("v.selHospital"),
            "selLocation": component.get("v.selLocation"),
            "selSpecialty": component.get("v.selSpecialty"),
            "selSubSpecialty": component.get("v.selSubSpecialty"),
            "selResource": component.get("v.selResource"),
            "selDate": component.get("v.selDate"),
            "selStartTime": component.get("v.selStartTime"),
            "selEndTime": component.get("v.selEndTime")
        });
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS") {
                //console.log('>>>>> '+component.get("v.isReset"));
                var finalRes = result.getReturnValue();
                component.set("v.hospitals", finalRes.Hospitals);
                component.set("v.locations", finalRes.Locations);
				component.set("v.specialties", finalRes.Specialties);
                component.set("v.subSpecialties", finalRes.SubSpecialties);
                component.set("v.resources", finalRes.Resources);                
                component.set("v.selDate", finalRes.SelDate);
                component.set("v.startTimes", finalRes.StartTimes);
                component.set("v.endTimes", finalRes.EndTimes);
                component.set("v.isReset", true);
                //console.log('>>>>> '+component.get("v.isReset"));
            }
        });
        $A.enqueueAction(action);
    },
    
    jsFindDoctorAndSchedules: function(component, event, helper) {
        var action = component.get("c.findDoctorAndSchedules");
        action.setParams({
            "selHospital": component.get("v.selHospital"),
            "selLocation": component.get("v.selLocation"),
            "selSpecialty": component.get("v.selSpecialty"),
            "selSubSpecialty": component.get("v.selSubSpecialty"),
            "selResource": component.get("v.selResource"),
            "selDate": component.get("v.selDate"),
            "selStartTime": component.get("v.selStartTime"),
            "selEndTime": component.get("v.selEndTime")
        });
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS") {
                var finalRes = result.getReturnValue();
                component.set("v.availResources", finalRes);
                component.set("v.isResources", true);
            }
        });
        $A.enqueueAction(action);
    },
    
    jsFindDoctorTimeSlot: function(component, event, helper) {
        var action = component.get("c.getDoctorTimeSlots");
        action.setParams({
            "selScheduleListId": component.get("v.selScheduleListId"),
            "selDate": component.get("v.selDate"),
            "selTimeFrom": component.get("v.selStartTime"),
            "selTimeTo": component.get("v.selEndTime")
        });
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS") {
                var finalRes = result.getReturnValue();
                component.set("v.selScheduleDoctor", finalRes.SelScheduleDoctor);
                component.set("v.doctorSessions", finalRes.DoctorSessions);
                
                //component.set("v.sessionTimeInterval", finalRes.SessionTimeInterval);
                //component.set("v.sessionDescription", finalRes.SessionDescription);
                //component.set("v.sessionServices", finalRes.SessionServices);
                //component.set("v.scheduleTimes", finalRes.TimeSlots);
            }
        });
        $A.enqueueAction(action);
    },
    
    jsReview: function(component, event, helper) {
        var action = component.get("c.reviewAppointment");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "slotTime": component.get("v.selScheduleTime"),
            "selDate": component.get("v.selDate")
        });
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS") {
                var finalRes = result.getReturnValue();
                component.set("v.relatedCases", finalRes.Cases);
                component.set("v.appointmentRec", finalRes.Appointment);
                component.set("v.bookingStep", "bookSlot");
            }
        });
        $A.enqueueAction(action);
    },
    
    jsBook: function(component, event, helper) {
        var bookingVar = component.get("v.appointmentRec");
        
        if (bookingVar.Case__c == null) {
            helper.displayToast("Appointment Booking", "Please select Related Case.", "error");
        } else if (bookingVar.Interpreter_Required__c == true && bookingVar.Interpreter__c == null) {
            helper.displayToast("Appointment Booking", "Please select Interpreter.", "error");
        } else if (component.get("v.isOverBook") && bookingVar.Overbook_Reason__c == null) {
            helper.displayToast("Appointment Booking", "Please select Overbook Reason.", "error");
        } else {
            var action = component.get("c.bookAppointmentRecord");
            action.setParams({
                "app": bookingVar
            });
            action.setCallback(this, function (result) {
                var state = result.getState();
                if (component.isValid() && state === "SUCCESS") {
                    var finalRes = result.getReturnValue();
                    if (finalRes.includes('Error')) {
                        helper.displayToast("Appointment Booking", finalRes, "error");
                    } else {
                        component.set("v.bookingStep", "findSlot");
                        component.set("v.selLocation", '');
                        component.set("v.selResource", '');
                        component.set("v.isResources", false);
                        component.set("v.appointmentRec.Non_fixed_Time__c", '');
                        component.set("v.appointmentRec.Interpreter_Required__c", false);
                        component.set("v.appointmentRec.Interpreter__c", '');
                        component.set("v.appointmentRec.Notes__c", '');
                        component.set("v.appointmentRec.Patient_Letter_Notes__c", '');
                        
                        helper.displayToast("Appointment Booking", "Appointment successfully booked.", "success");
                        
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": finalRes,
                            "slideDevName": "detail"
                        });
                        navEvt.fire();
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    jsAddTime: function (component, event, helper, time, min){
        let times = time.split(":");
        //clear here more than 24 hours
        min=min%(24*60);
        times[0]=(parseInt(times[0]))+parseInt(min/60) ;
        times[1]=parseInt(times[1])+min%60;
        
        //here control if hour and minutes reach max
        if(times[1]>=60) { times[1]=0 ;times[0]++} ;
        times[0]>=24 ?  times[0]-=24  :null;
        
        //here control if less than 10 then put 0 frond them
        times[0]<10 ? times[0]= "0" + times[0] : null ;
        times[1]<10 ? times[1]= "0" + times[1] : null ;
        
        component.set("v.appointmentRec.End_Time__c", times.join(":"));
    },

    displayToast: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
})