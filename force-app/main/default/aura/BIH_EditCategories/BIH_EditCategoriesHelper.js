({
    startSpinner: function (component) {
        component.set('v.loading', true);
    },
    stopSpinner: function (component) {
        component.set('v.loading', false);
    },
     displayToast: function (component, type, message) {
         helper.startSpinner(component);
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            type: type,
            message: message
        });
        toastEvent.fire();
         helper.stopSpinner(component);
    },
    
    getWrapper: function (component, event, helper) {
       helper.startSpinner(component);
        var recordCaseId = component.get('v.recordId');
        var getRecordTypeId = component.get("v.recordTypeId");
        console.log('recordId : ', recordCaseId);
        console.log('getRecordTypeId: ', getRecordTypeId);
        var actionPromise = new Promise(function (resolve, reject) {
            
            var action = component.get('c.getPickListValueWrapper');
            action.setParams({
                "caseId": recordCaseId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();
                    // console.log('returnValues : ', res);
                    component.set('v.CaseCateLVL_1', res.keyCateLvL1);
                    component.set('v.MapCaseCateLVL_1', res.mapCaseLvl1);
                    component.set('v.MapCaseCateLVL_2', res.mapCaseLvl2);
                    component.set('v.MapCaseCateLVL_3', res.mapCaseLvl3);
                     
                    
                    component.set('v.MapSLA', res.mapSLA);
                    component.set('v.MapDynamicGroup', res.mapDynamicGroup);
                    
                    
                    component.set('v.MapServiceDetailEN', res.mapServiceDetailEN);
                    component.set('v.MapServiceDetailTH', res.mapServiceDetailTH);
                    
                    component.set('v.MapScriptEN', res.mapScriptEN);
                    component.set('v.MapScriptTH', res.mapScriptTH);
                    
                    
                    
                    component.set('v.PickList', res.PickListValue);
                    // console.log('PicklistValues: ',res.PickListValue);
                    component.set('v.buildingMap', res.buildingMap);
                    component.set("v.keyBuilding", res.keyBuilding);
                    
                    // console.log('buildingMap',res.buildingMap);
                    component.set('v.MapQuickCase', res.mapQuickCase);
                    component.set('v.KeyQuickCase', res.keyQuickCase);
                    component.set('v.MapDoctorAll', res.mapDoctorAll);
                    component.set('v.close_case_reasonPickList', res.closeReason);
                    
                    
                    // Map1
                    component.set('v.MapQuickCase1', res.mapQuickCase1);
                    component.set('v.KeyQuickCase1', res.keyQuickCase1);
                    
                    // Map2
                    component.set('v.MapQuickCase2', res.mapQuickCase2);
                    component.set('v.KeyQuickCase2', res.keyQuickCase2);
                    
                    
                    
                    var cObj = component.get('v.caseObj');
                    if (cObj.RecordTypeId == undefined || cObj.RecordTypeId == null || cObj.RecordTypeId == '') {
                        cObj.RecordTypeId = res.DefalutRecordId;
                        getRecordTypeId = res.DefalutRecordId;
                    }
                    component.set('v.caseObj', cObj);
                     
                    if (res.recordTypeMap[getRecordTypeId] == 'Airport Transfer Case') {
                        component.set('v.isAirportTransferRecordType', true);
                    } 
                    
                    
                    if (res.UserLogInInfo.Language_Skill__c == 'Thai'){
                        component.set('v.THTemplate', true);
                    }
                    component.set('v.UserObj', res.UserLogInInfo);
                    
                    
                    
                    resolve(res);
                    // ccw.mapCaseLvl2 = cate1Cate2;
                    // ccw.keyCateLvL2 = cate2Cate3.keySet();
                    // ccw.mapCaseLvl3 = cate2Cate3;
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            // console.log("Error message: " +
                            //     errors[0].message);
                            helper.displayToast(component, "Error", errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    // reject(Error('Invalid value: Task Object'))
                }
            });
            
            $A.enqueueAction(action);
            
            
        });
        actionPromise.then(
            function (res) {
                console.log("actionPromise");
                // if (recordCaseId != undefined && recordCaseId != null) {
                var action = component.get("c.getCaseAndPatientInformation");
                action.setParams({
                    "caseId": recordCaseId,
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var returnValues = response.getReturnValue();
                        console.log(':::::::::::::: Method c.getCaseAndPatientInformation ::::::::::::::');
                        console.log('pickListValueWrapper : ', res);
                        console.log('CaseAndPatientInformationWrapper : ', returnValues);
                        if (recordCaseId != undefined && recordCaseId != null) {
                            console.log(' recordCaseId null');
                            setTimeout(() => {
                                
                                var cmp = component
                                
                                const empApi = cmp.find('empApi');
                                
                                // Uncomment below line to enable debug logging (optional)
                                // empApi.setDebugFlag(true);
                                
                                // Register error listener and pass in the error handler function
                                empApi.onError($A.getCallback(error => {
                                // Error can be any type of error 
                                // (subscribe, unsubscribe...)
                                console.error('EMP API error: ', JSON.stringify(error));
                            }));
                            
                            
                            // Get the channel from the input box
                            const channel = '/event/Publish_Verify_Button'+returnValues.CaseObject.Platform_Event_Channel__c+'__e';
                            // Replay option to get new events
                            const replayId = -1;
                            
                            // Subscribe to an event
                            empApi.subscribe(channel, replayId, $A.getCallback(eventReceived => {
                                // Process event (this is called each time we receive an event)
                                console.log('Received event ', JSON.stringify(eventReceived));
                                
                                // console.log(eventReceived.data.payload.Case_Id__c);
                                
                                // console.log(cmp.get('v.recordId'));
                                if(eventReceived.data.payload.Case_Id__c === cmp.get('v.recordId')){
                                
                                cmp.set('v.caseObj.Verified_Patient__c',true);
                                
                                
                                helper.startSpinner(component);
                                var action = cmp.get("c.getCaseAndPatientInformationUpdated");
                                action.setParams({
                                "caseId": cmp.get("v.recordId")
                            });
                                             
                                             helper.serverSideCall(cmp, action).then(
                                function (result) {
                                    
                                    console.log(result);
                                    
                                    cmp.set('v.senderNameValue',result.PatientObject);
                                    cmp.set('v.patientNameValue',result.PatientObject);
                                    
                                    cmp.set('v.caseObj.Hospital_Number_HN__c',result.CaseObject.Hospital_Number_HN__c);
                                    cmp.set('v.caseObj.SuppliedEmail',result.CaseObject.SuppliedEmail);
                                    cmp.set('v.caseObj.Full_Name__c',result.CaseObject.Full_Name__c);
                                    
                                    
                                    helper.stopSpinner(cmp);
                                    
                                }
                            ).catch(
                                function (error) {
                                    helper.stopSpinner(cmp);
                                }
                            );
                            
                        }
                    }))
                    .then(subscription => {
                        // Subscription response received.
                        // We haven't received an event yet.
                        //console.log('Subscription request sent to: ', subscription.channel);
                        // Save subscription to unsubscribe later
                       // cmp.set('v.subscription', subscription);
                    });
                        
                        
                        component.set('v.CaseCateLVL_2', res.mapCaseLvl2[returnValues.CaseObject.Case_Category_Level1__c]);
                        component.set('v.CaseCateLVL_3', res.mapCaseLvl3[returnValues.CaseObject.Case_Category_Level2__c + ':' + returnValues.CaseObject.Case_Category_Level1__c]);
                        // component.set('v.ArriveTimeList', res.flightMap[returnValues.CaseObject.Flight_Number__c]);
                        // component.set('v.SegmentList', res.paymentMap[returnValues.CaseObject.Method_Of_Payment__c]);
                        component.set("v.departmentList", res.buildingMap[returnValues.CaseObject.Building__c]);
                        component.set('v.caseObj', returnValues.CaseObject);
                        
                        
                        // console.log('caseObj: ',returnValues.CaseObject);
                        
                        //component.set('v.checkInTime', returnValues.checkInTime);
                        //component.set('v.checkOutTime', returnValues.checkOutTime);
                        
                        //component.set('v.numberDynamicGroup', res.mapDynamicGroup[returnValues.CaseObject.Case_Category_Level3__c + ':' + returnValues.CaseObject.Case_Category_Level2__c + ':' + returnValues.CaseObject.Case_Category_Level1__c])
                        //console.log('numberDynamicGroup : ',JSON.stringify(component.get('v.numberDynamicGroup')));
                        
                        if (res.recordTypeMap[returnValues.CaseObject.RecordTypeId] == 'Airport Transfer Case') {
                        component.set('v.isAirportTransferRecordType', true);
                        component.set('v.isRequiredSenderEmail', false);
                        console.log(' returnValues.CaseObject.Airport_Rep_Name__c' + returnValues.CaseObject.Airport_Rep_Name__c);
                        if (returnValues.CaseObject.Airport_Rep_Name__c != null) {
                        var airportRepName = returnValues.CaseObject.Airport_Rep_Name__c.split(";");
                        component.set('v.defaultRepOptions', airportRepName);
                    }
                    } else if (res.recordTypeMap[returnValues.CaseObject.RecordTypeId] == 'Contact Center Case') {
                        component.set('v.isContactCenter', true);
                    } else if (res.recordTypeMap[returnValues.CaseObject.RecordTypeId] == 'Clinic Case') {
                        component.set('v.isRequiredSenderEmail', false);
                    }
                        component.set('v.patientObj', returnValues.PatientObject);
                        component.set('v.senderObj', returnValues.SenderObject);
                        // console.log('returnValues.UserCurrentInfo : ', returnValues.UserCurrentInfo);
                        
                        component.set('v.CaseCateLVL_2_disableField', false);
                        component.set('v.CaseCateLVL_3_disableField', false);
                        if (returnValues.UserCurrentInfo != null && returnValues.UserCurrentInfo != undefined) {
                        component.set('v.ownerType', 'user');
                        component.set('v.isOwnerTypeUser', true);
                        component.set('v.caseOwnerValue', returnValues.UserCurrentInfo);
                    } else {
                        component.set('v.ownerType', 'queue');
                        component.set('v.isOwnerTypeUser', false);
                        component.set('v.caseOwnerValue', returnValues.GroupCurrentInfo);
                    }
                        // console.log('----001----');
                        
                        component.set('v.patientNameValue', returnValues.PatientObject);
                        if (returnValues.SenderObject != null) {
                        component.set('v.senderNameValue', returnValues.SenderObject);
                        component.set('v.senderNameValue.Email__c', returnValues.CaseObject.SuppliedEmail);
                    } else {
                        component.set('v.senderNameValue', null);
                    }
                        // console.log('----002----');
                        if (returnValues.DoctorObject != null) {
                        component.set('v.doctorNameValue', returnValues.DoctorObject);
                    } else {
                        component.set('v.doctorNameValue', null);
                    }
                        // console.log('----003----');
                        if (returnValues.PendingPersonObject != null) {
                        component.set('v.personReasonNameValue', returnValues.PendingPersonObject);
                    } else {
                        component.set('v.personReasonNameValue', null);
                    }
                        // console.log('----004----');
                        
                        var status = component.get('v.caseObj.Status');
                        //  console.log('status'+status);
                        component.set('v.caseObj.Status', status == "New" ? "In Progress" : status);
                        
                        if(returnValues.CaseObject.Campaign_Master__c != null && returnValues.CaseObject.Campaign_Master__c != '' && returnValues.CaseObject.Campaign_Master__c != undefined){
                        var checkCmp = component.find("add_campaign");
                        checkCmp.set("v.checked",true);
                        component.set('v.isShowCampaignDetail',true);
                        helper.getCampaginList(component, event, helper);
                        helper.getCampaginDetail(component, event, helper);
                        component.set('v.isCampaignLoading',true);
                        
                    }
                          
                          if(component.get('v.caseObj.App_Time__c') != undefined && component.get('v.caseObj.App_Time__c') != '' || component.get('v.caseObj.App_Time__c') == 0){
                        
                        console.log('=================apptem jaaa');
                        
                        var dateObj = new Date(component.get('v.caseObj.App_Time__c')); 
                        // Get hours from the timestamp 
                        var hours = new Date(dateObj.setHours(dateObj.getHours() - 7)).getHours(); 
                        // Get minutes part from the timestamp 
                        var minutes = dateObj.getMinutes(); 
                        // Get seconds part from the timestamp 
                        var seconds = dateObj.getSeconds(); 
                        var formattedTime = hours.toString().padStart(2, '0') + ':' +  
                            minutes.toString().padStart(2, '0') + ':' +  
                            seconds.toString().padStart(2, '0')+ '.000Z'; 
                        component.set('v.caseObj.App_Time__c',formattedTime);
                    }
                    
                    // console.log('value : ',value);
                    
                    
                   // helper.stopSpinner(component);
                    
                    if( res.UserLogInInfo.User_Team__c.includes("Contact Center")  && !(res.recordTypeMap[returnValues.CaseObject.RecordTypeId].includes("Contact Center Case"))){
                        component.set('v.CaseCateLVL_2', null);
                        component.set('v.CaseCateLVL_3', null);
                        component.set('v.caseObj.Case_Category_Level1__c', "");
                        component.set('v.caseObj.Case_Category_Level2__c', "");
                        component.set('v.caseObj.Case_Category_Level3__c', "");
                    }
                }, 50);
                
                setTimeout(() => {
                    console.log(' %%%%%%%%');
                    component.set('v.caseObj', returnValues.CaseObject);
                    console.log(' %%%%%%%%');
                    //component.set('v.isCampaignLoading',false);
                    helper.stopSpinner(component);
                }, 50);
                    
                    
                } else {
                    console.log('else RecordTypeId : ', getRecordTypeId);
                    
                    console.log(' recordCaseId null');
                    component.set('v.caseObj.Channel__c', "Contact Center");
                    component.set('v.caseObj.Status', "New");
                    component.set('v.caseObj.Priority', "High");
                    component.set('v.caseObj.Origin', "Phone");
                    component.set('v.caseObj.Contact_Center_Channel__c', "Inbound");
                    component.set('v.caseObj.RecordTypeId', component.get('v.recordTypeId'));
                    //     console.log('OwnerObj : ', component.get('v.OwnerObj'));
                    var thisOwner = component.get('v.OwnerObj');
                    console.log('thisOwner : ', thisOwner);
                    if (thisOwner != null) {
                    if (thisOwner.Id.startsWith("003")){
                    component.set('v.patientNameValue', null);
                    console.log('TESTTTTT: ',component.get('v.senderNameValue'));
                    if (component.get('v.senderNameValue').Id == null || component.get('v.senderNameValue').Id == ''){
                    component.set('v.senderNameValue', null);
                }
                    
                    component.set('v.caseObj.Caller_Name__c', thisOwner.Name);
                    component.set('v.caseObj.Contact_Number__c', thisOwner.Phone);
                    component.set('v.caseOwnerValue', component.get('v.UserObj'));
                    component.set('v.caseObj.ContactId', thisOwner.Id);
                }else {
                    component.set('v.patientNameValue', thisOwner);
                    component.set('v.senderNameValue', thisOwner);
                    component.set('v.caseOwnerValue', component.get('v.UserObj'));
                    component.set('v.caseObj.Caller_Name__c', thisOwner.Name);
                    component.set('v.caseObj.Contact_Number__c', thisOwner.Phone);
                    component.set('v.caseObj.Hospital_Number_HN__c', thisOwner.Hospital_Number_HN__c);
                    
                    if(thisOwner.IsPersonAccount){
                    component.set('v.caseObj.SuppliedEmail',thisOwner.PersonEmail);
                }else{
                    component.set('v.caseObj.SuppliedEmail',thisOwner.Email__c);
                }
                }
                } else {
                    
                    component.set('v.caseOwnerValue', component.get('v.UserObj'));
                    component.set('v.patientNameValue', null);
                    component.set('v.senderNameValue', null);
                }
                   // helper.stopSpinner(component);
                    
                }
                    
                } else if (state === "ERROR") {
                    
                    var errors = response.getError();
                    if (errors) {
                    if (errors[0] && errors[0].message) {
                    // console.log("Error message: " +
                    //     errors[0].message);
                    helper.displayToast(component, "Error", errors[0].message);
                }
                } else {
                    console.log("Unknown error");
                }
                }
                });
                    $A.enqueueAction(action);
                    
                    
                },
                    function (error) {
                    helper.stopSpinner(component);
                    helper.displayToast(component, "Warning", error.message);
                });
                },
                   // getCampaginList: function (component, event, helper) {},
                    //getvaccinenamelist: function (component, event, helper) {},     
                    serverSideCall: function (component, action) {
                        return new Promise(function (resolve, reject) {
                            action.setCallback(this,
                                               function (response) {
                                                   var state = response.getState();
                                                   if (state === "SUCCESS") {
                                                       resolve(response.getReturnValue());
                                                   } else {
                                                       reject(new Error(response.getError()));
                                                   }
                                               });
                            $A.enqueueAction(action);
                        });
                    },
                    
                })