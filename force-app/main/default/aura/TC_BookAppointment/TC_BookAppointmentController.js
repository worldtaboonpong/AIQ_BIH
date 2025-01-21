({

	doInit: function(component, event, helper) {
        component.set("v.selLocation", "");
        component.set("v.selSpecialty", "");
        component.set("v.selSubSpecialty", "");
        component.set("v.selResource", "");
        helper.jsBookingDetails(component, event, helper);
    },
    
    doLocationChange: function(component, event, helper) {
        component.set("v.selSpecialty", "");
        component.set("v.selSubSpecialty", "");
        component.set("v.selResource", "");
        helper.jsBookingDetails(component, event, helper);
    },
    
    handleComponentEvent: function(component, event, helper) {
        var fieldLabelVar = event.getParam("fieldLabel");
        var selectedValVar = event.getParam("selectedValue");
        /*var selItemVar = [];
        selectedValVar.forEach(function(element, index) {
            selItemVar.push(element);
        })*/
        //console.log(fieldLabelVar +' +++++++ '+selectedValVar);
        
        if (fieldLabelVar == 'selSpecialtyId') {
            component.set("v.selSpecialty", selectedValVar);
        } else if (fieldLabelVar == 'selSubSpecialtyId') {
            component.set("v.selSubSpecialty", selectedValVar);
        } else if (fieldLabelVar == 'resourceId') {
            component.set("v.selResource", selectedValVar);
        }
    },
    
    /*handleSearchblePicklistEvt: function(component, event, helper) {
        var fieldLabelVar = event.getParam("fieldLabel");
        var selectedValVar = event.getParam("selectedValue");
        
        alert(fieldLabelVar +' +++++++ '+selectedValVar);
        
        if (fieldLabelVar == 'selSpecialtyId') {
            component.set("v.selSpecialty", selectedValVar);
        } else if (fieldLabelVar == 'selSubSpecialtyId') {
            component.set("v.selSubSpecialty", selectedValVar);
        } else if (fieldLabelVar == 'resourceId') {
            component.set("v.selResource", selectedValVar);
        }
    },*/
    
    doSpecialtyChange: function(component, event, helper) {
        //console.log('--------');
        component.set("v.selSubSpecialty", "");
        component.set("v.selResource", "");
        helper.jsBookingDetails(component, event, helper);
    },
    
    doSubSpecialtyChange: function(component, event, helper) {
        component.set("v.selResource", "");
        helper.jsBookingDetails(component, event, helper);
    },
    
    doReset: function(component, event, helper) {
        component.set("v.selHospital", "BH");
        component.set("v.selLocation", ""); 
        component.set("v.selSpecialty", "");
        component.set("v.selSubSpecialty", "");
        component.set("v.selResource", "");
        component.set("v.selStartTime", "");
        component.set("v.selEndTime", "");
        component.set("v.isReset", false);
        component.set("v.isResources", false);
        helper.jsBookingDetails(component, event, helper);

    },
    
    doFindDoctorAndSchedules: function(component, event, helper) {
        if (!component.get("v.selDate")) {
            helper.displayToast("Appointment Booking", "Please select Date.", "error");
        } else {
            component.set("v.isResources", false);
            component.set("v.selScheduleListId", '');
            component.set("v.activeSections", []);
            helper.jsFindDoctorAndSchedules(component, event, helper);
        }
    },
    
    doFindDoctorTimeSlot: function (component, event, helper) {
        var selActionSection = component.get("v.selScheduleListId");
        var openSections = component.get("v.activeSections");
                
        if (openSections[0] != selActionSection) {
            component.set("v.selScheduleListId", openSections[0]);
            helper.jsFindDoctorTimeSlot(component, event, helper);
        }
    },
    
    doSelectSlot: function (component, event, helper) {
        /*var scheduleTimesVar = component.get("v.scheduleTimes");
        var selScheduleTimeId = event.target.id;
        component.set("v.selScheduleTime", selScheduleTimeId);
        
        scheduleTimesVar.forEach(function(schTimeWrap){
            var scIdVar = component.get("v.selScheduleListId")+'#'+schTimeWrap.slotId+'#'+schTimeWrap.startTime;
            //console.log(scIdVar+'***'+selScheduleTimeId);
            if (scIdVar == selScheduleTimeId) {
                document.getElementById(scIdVar).classList.remove('slds-badge_lightest');
                document.getElementById(scIdVar).classList.add('slds-theme_success');
            } else if (document.getElementById(scIdVar)) {
                document.getElementById(scIdVar).classList.remove('slds-theme_success');
                document.getElementById(scIdVar).classList.add('slds-badge_lightest');
            }
        });*/
        var doctorSessionsVar = component.get("v.doctorSessions");
        var selScheduleTimeId = event.target.id;
        component.set("v.selScheduleTime", selScheduleTimeId);
        
        doctorSessionsVar.forEach(function(doctorSessionsWrap){
            doctorSessionsWrap.timeSlots.forEach(function(schTimeWrap){
                var scIdVar = component.get("v.selScheduleListId")+'#'+schTimeWrap.slotId+'#'+schTimeWrap.startTime;
                //var overBookStatus = schTimeWrap.overBookStatus;
                //console.log(scIdVar+'***'+selScheduleTimeId);
                if (scIdVar == selScheduleTimeId) {
                    if (schTimeWrap.status == 'Avaliable') {
                        document.getElementById(scIdVar).classList.remove('slds-badge_lightest');
                    	document.getElementById(scIdVar).classList.add('slds-theme_success');
                    } else {
                        document.getElementById(scIdVar).classList.remove('slds-theme_warning');
                    	document.getElementById(scIdVar).classList.add('slds-theme_success');
                    }
                    component.set("v.sessionServices", doctorSessionsWrap.services);
                    //console.log(schTimeWrap.status+' >>> '+schTimeWrap.overbookStatus);
                    component.set("v.isOverBook", (schTimeWrap.status != 'Avaliable' && schTimeWrap.overbookStatus == 'Avaliable' ? true : false));
                } else if (document.getElementById(scIdVar)) {
                    if (schTimeWrap.status == 'Avaliable') {
                        document.getElementById(scIdVar).classList.remove('slds-theme_success');
                        document.getElementById(scIdVar).classList.add('slds-badge_lightest');
                    } else {
                        document.getElementById(scIdVar).classList.remove('slds-theme_success');
                        document.getElementById(scIdVar).classList.add('slds-theme_warning');
                    }
                }
            });
        });
    },
    
    doReview: function(component, event, helper) {
        if (component.get("v.selScheduleTime")) {
            helper.jsReview(component, event, helper);
        } else {
            helper.displayToast("Appointment Booking", "Please select Time Slot.", "error");
        }
    },
    
    doBackSelectSlot: function(component, event, helper) {
        component.set("v.bookingStep", "findSlot");
    },
    
    doServiceChange: function(component, event, helper) {
        var sessionServicesVar = component.get("v.sessionServices");
        var selServiceVar = component.get('v.appointmentRec.Service__c');
        sessionServicesVar.forEach(function(sessionSer){
            if (sessionSer.serviceDesc == selServiceVar) {
                component.set("v.appointmentRec.Slot_Length__c", sessionSer.serviceLength);
                component.set("v.appointmentRec.Service_Code__c", sessionSer.servicecode);
                helper.jsAddTime(component, event, helper, component.get("v.appointmentRec.Appointment_Time__c"), sessionSer.serviceLength);
            }
        });
    },
    
    doIntRequiredChange: function(component, event, helper) {
        var intRequiredVar = component.get("v.appointmentRec.Interpreter_Required__c");
        if (!intRequiredVar) {
            component.set("v.appointmentRec.Interpreter__c", '');
        }
    },
    
    doBook: function(component, event, helper) {
        if (!component.get("v.selScheduleTime")) {
            helper.displayToast("Appointment Booking", "Please select Time Slot.", "error");
        } else if (!component.get("v.appointmentRec.Service__c")) {
            helper.displayToast("Appointment Booking", "Please select Service.", "error");
        } else {
            helper.jsBook(component, event, helper);
        }
    },

})