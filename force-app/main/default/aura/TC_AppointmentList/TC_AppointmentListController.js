({
	doInit: function(component, event, helper) {
        component.set('v.tableUpColumn', [
            /*{
                label: 'Name', fieldName: 'linkName', type: 'url', 
                typeAttributes: {label: { fieldName: 'appName' }, target: '_blank', tooltip: { fieldName: 'appNote'}}
            },*/
            //{label: 'Id', fieldName: 'appTcId', type: 'text'},
            {label: 'Location', fieldName: 'appLocation', type: 'text'},
            {label: 'Doctor', fieldName: 'appDoctor', type: 'text'},
            {label: 'Date', fieldName: 'appDate', type: 'text'},
            {label: 'Time', fieldName: 'appTime', type: 'text'},
            {label: 'Status', fieldName: 'appStatus', type: 'text'},
            {label: 'Source', fieldName: 'appSource', type: 'text'},
            {
                type: "button", typeAttributes: {
                    label: 'Cancel',
                    name: 'Cancel',
                    title: 'Cancel',
                    disabled: false,
                    value: 'Cancel',
                    iconPosition: 'left'
                }
            },
            {
                type: "button", typeAttributes: {
                    label: 'Orders',
                    name: 'Orders',
                    title: 'Orders',
                    disabled: false,
                    value: 'Orders',
                    iconPosition: 'left'
                }
            },
            {
                type: "button", typeAttributes: {
                    label: 'View',
                    name: 'View',
                    title: 'View',
                    disabled: false,
                    value: 'View',
                    iconPosition: 'left'
                }
            }
        ]);
        
        component.set('v.tableOtColumn', [
            /*{
                label: 'Name', fieldName: 'linkName', type: 'url', 
                typeAttributes: {label: { fieldName: 'appName' }, target: '_blank', tooltip: { fieldName: 'appNote'}}
            },*/
            //{label: 'Id', fieldName: 'appTcId', type: 'text'},
            {label: 'Location', fieldName: 'appLocation', type: 'text'},
            {label: 'Doctor', fieldName: 'appDoctor', type: 'text'},
            {label: 'Date', fieldName: 'appDate', type: 'text'},
            {label: 'Time', fieldName: 'appTime', type: 'text'},
            {label: 'Status', fieldName: 'appStatus', type: 'text'},
            {label: 'Source', fieldName: 'appSource', type: 'text'},
            {
                type: "button", typeAttributes: {
                    label: 'View',
                    name: 'View',
                    title: 'View',
                    disabled: false,
                    value: 'View',
                    iconPosition: 'left'
                }
            }
        ]);
        
        helper.jsDoInit(component, event, helper);
    },
    
    doActionOnRecord : function(component, event, helper) {
        var selectedRow = event.getParam('row')
        var actionName = event.getParam('action').name;
        if (actionName == 'Cancel') {
            component.set("v.selSfId", selectedRow.appSfId);
            component.set("v.selTcId", selectedRow.appTcId);
            component.set("v.isCancel", true);
        } else if (actionName == 'Orders') {
            component.set("v.selTcId", selectedRow.appTcId);
            helper.jsFetchOrders(component, event, helper);
        }  else if (actionName == 'View') {
            if (selectedRow.appSfId) {
                helper.jsRedirectToRecord(component, event, helper, selectedRow.appSfId);
            }else{
                helper.jsViewAppointment(component, event, helper, selectedRow.appTcId);
            }
        }
    },
    
    doActionOnRecordSelect : function(component, event, helper){
        var selRows = event.getParam('selectedRows');
        //console.table(selRows);
        var selectedRowsIds = [];
        for(var i=0;i<selRows.length;i++){
            console.table(selRows[i]);
            selectedRowsIds.push(selRows[i].appIndex);  
        }
        //console.log('>>> '+selectedRowsIds);
        component.set("v.appointList", selectedRowsIds);
    },
    
    doOk: function(component, event, helper) {
        helper.jsOk(component, event, helper);
    },
    
    doCancel: function(component, event, helper) {
        component.set("v.isCancel", false);
    },
    
    doOrdersCancel: function(component, event, helper) {
        component.set("v.isOrders", false);
    },
    
    doViewCancel: function(component, event, helper) {
        component.set("v.isView", false);
    },
    
    doSendEmail: function(component, event, helper) {
        var appointListVar = component.get("v.appointList");
        console.log('>>> '+appointListVar.length);
        if (appointListVar && appointListVar.length > 0) {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url":"/apex/MultipleAppointmentCardPDF?accId="+component.get("v.recordId")+ '&selectedRowsIds='+component.get("v.appointList")
            });
            urlEvent.fire();
        } else {
            helper.showToast("Appointment Card", "Please select one Appointment", "error");
        }
    },
})