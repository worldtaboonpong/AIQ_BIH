({
    getParentId: function (component, event, helper) {
        var parentRecordId = component.get('v.parentId');
        //console.log('parentRecordId',parentRecordId);

        if(parentRecordId != '' && parentRecordId != null && parentRecordId != undefined && !parentRecordId.startsWith("500")){
            //set account id
            if(parentRecordId.startsWith("001")){
                component.set('v.accountId',parentRecordId);
                var actionPromise = new Promise(function (resolve, reject) {
                    var action = component.get('c.getParentIdOnFocusTab');
                        action.setParams({
                            "accountId": parentRecordId, //get accountId for parent tab
                        });
                        action.setCallback(this, function (response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var returnValues = response.getReturnValue();
    
                                component.set('v.OwnerObj', returnValues);
                                //console.log('v.OwnerObj', returnValues);
    
                                resolve(returnValues);
                            } else if (state === "ERROR") {
                                var errors = response.getError();
                                if (errors) {
                                    if (errors[0] && errors[0].message) {
                                        //console.log(errors);
    
                                        // //console.log("Error message: " +
                                        //     errors[0].message);
                                        helper.displayToast(component, "Error", errors[0].message);
                                    }
                                } else {
                                    //console.log("Unknown error");
                                }
                                reject(Error('Invalid value: Task Object'))
                            }
                        });
                        $A.enqueueAction(action);
                    });
                    actionPromise.then(
                        function (returnValues) {
                            helper.getWrapper(component, event, helper);
    
                        }
                    );
            }
            //set contact id
            else if(parentRecordId.startsWith("003")){
                var actionPromise = new Promise(function (resolve, reject) {
                    var action = component.get('c.getContactParentIdOnFocusTab');
                        action.setParams({
                            "contactId": parentRecordId, //get contactId from page ref
                        });
                        action.setCallback(this, function (response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var returnValues = response.getReturnValue();
                                component.set('v.OwnerObj', returnValues);
                                //console.log('v.OwnerObj', returnValues);
    
                                resolve(returnValues);
                            } else if (state === "ERROR") {
                                var errors = response.getError();
                                if (errors) {
                                    if (errors[0] && errors[0].message) {
                                        //console.log(errors);
    
                                        // //console.log("Error message: " +
                                        //     errors[0].message);
                                        helper.displayToast(component, "Error", errors[0].message);
                                    }
                                } else {
                                    //console.log("Unknown error");
                                }
                                reject(Error('Invalid value: Task Object'))
                            }
                        });
                        $A.enqueueAction(action);
                    });
    
                    actionPromise.then(
                        function (returnValues) {
                            //console.log('=====Promise=====');
                            var actions = component.get('c.getSenderAccountByContact');
                            // var contactId = component.get('v.parentId');
                            //console.log('=====getSenderAccountByContact===== contact:',parentRecordId);
                            actions.setParams({
                                "ContactId" : parentRecordId
                            });
                            actions.setCallback(this, function (Response){
                                var state = Response.getState();
                                //console.log('STATE: ',state);
                                
                                if (state === 'SUCCESS'){
                                    //console.log('=====getSenderAccountByContact=====');
                                    var returnSender = Response.getReturnValue();
                                    //console.log('Sender returnSender: ',returnSender);
                                    if (returnSender != null) {
                                        component.set('v.senderNameValue',returnSender);
                                        
                                    }
                                    //console.log('=====getSenderAccountByContact=====');
                    
                                }else if (state === 'ERROR'){
                                    var errors = Response.getError();
                                    //console.log(errors);
                                    if (errors) {
                                        if (errors[0] && errors[0].message) {
                                            //console.log(errors);
                    
                                            // //console.log("Error message: " +
                                            //     errors[0].message);
                                            helper.displayToast(component, "Error", errors[0].message);
                                        }
                                    } else {
                                        //console.log('UNKNOWN ERROR: ',state);
                    
                                    }
                                }
                            });
                            $A.enqueueAction(actions);
                            helper.getWrapper(component, event, helper);
                        }
                    );

            }
        }
        else{    

            //console.log('Parent not found.');
            var workspaceAPI = component.find("workspace");
            workspaceAPI.getFocusedTabInfo().then(function (response) {
                workspaceAPI.getTabInfo({
                    tabId: response.parentTabId
                }).then(function (res) {
                    // component.set('v.recordId',res.recordId);
                    // //console.log(res.recordId);
                    var getAccountIdFromTab = res.recordId;
                    var actionPromise = new Promise(function (resolve, reject) {
                        var action = component.get('c.getParentIdOnFocusTab');
                        action.setParams({
                            "accountId": getAccountIdFromTab, //get accountId for parent tab
                        });
                        action.setCallback(this, function (response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var returnValues = response.getReturnValue();
                                component.set('v.OwnerObj', returnValues);
                                //console.log('v.OwnerObj', returnValues);

                                resolve(returnValues);
                            } else if (state === "ERROR") {
                                var errors = response.getError();
                                if (errors) {
                                    if (errors[0] && errors[0].message) {
                                        //console.log(errors);

                                        // //console.log("Error message: " +
                                        //     errors[0].message);
                                        helper.displayToast(component, "Error", errors[0].message);
                                    }
                                } else {
                                    //console.log("Unknown error");
                                }
                                reject(Error('Invalid value: Task Object'))
                            }
                        });
                        $A.enqueueAction(action);
                    });
                    actionPromise.then(
                        function (returnValues) {
                            helper.getWrapper(component, event, helper);
                        }
                    );
                });
            }).catch(function (error) {
                //console.log(error);
            });
        }
    },
    // getSenderAccountByContact: function(component, event, helper, parentRecordId){
        
    // },
   startSpinner: function (component) {
        console.log('-- start spinner--');

        component.set('v.loading', true);
    },
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
    stopSpinner: function (component) {
        console.log('-- stop spinner--');
        component.set('v.loading', false);
    },
    
    hideModal: function (component, event, helper) {
        component.set("v.ShowModule", false);
    },
    showModal: function (component, event, helper) {
        component.set("v.ShowModule", true);
    },
    getWrapper: function (component, event, helper) {
        // var action = component.get('c.getPickListValuesIntoList');
        var recordCaseId = component.get('v.recordId');
        var getRecordTypeId = component.get("v.recordTypeId");
        //console.log('recordId : ', recordCaseId);
        //console.log('getRecordTypeId: ', getRecordTypeId);
        var actionPromise = new Promise(function (resolve, reject) {

            var action = component.get('c.getPickListValueWrapper');
            action.setParams({
                "recordTypeId": getRecordTypeId,
                "caseId": recordCaseId,
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();
                    // //console.log('returnValues : ', res);
                    component.set('v.CaseCateLVL_1', res.keyCateLvL1);
                    component.set('v.MapCaseCateLVL_1', res.mapCaseLvl1);
                    component.set('v.MapCaseCateLVL_2', res.mapCaseLvl2);
                    component.set('v.MapCaseCateLVL_3', res.mapCaseLvl3);
                    // //console.log('v.CaseCateLVL_1', res.keyCateLvL1);
                    // //console.log('v.MapCaseCateLVL_1', res.mapCaseLvl1);
                    // //console.log('v.MapCaseCateLVL_2', res.mapCaseLvl2);
                    // //console.log('v.MapCaseCateLVL_3', res.mapCaseLvl3);

                    component.set('v.MapSLA', res.mapSLA);
                    component.set('v.MapDynamicGroup', res.mapDynamicGroup);
                    // //console.log('v.MapSLA', res.mapSLA);
                    // //console.log('v.MapSLACC', res.mapSLACC);

                    component.set('v.MapServiceDetailEN', res.mapServiceDetailEN);
                    component.set('v.MapServiceDetailTH', res.mapServiceDetailTH);

                    component.set('v.MapScriptEN', res.mapScriptEN);
                    component.set('v.MapScriptTH', res.mapScriptTH);
                    
                    
                    // //console.log('res.mapServiceDetailTH', res.mapServiceDetailTH);
                    // //console.log('res.mapServiceDetailEN', res.mapServiceDetailEN);

                    component.set('v.PickList', res.PickListValue);
                    // //console.log('PicklistValues: ',res.PickListValue);
                    component.set('v.buildingMap', res.buildingMap);
                    component.set("v.keyBuilding", res.keyBuilding);

                    // //console.log('buildingMap',res.buildingMap);
                    component.set('v.MapQuickCase', res.mapQuickCase);
                    component.set('v.KeyQuickCase', res.keyQuickCase);
                    component.set('v.MapDoctorAll', res.mapDoctorAll);
                    component.set('v.close_case_reasonPickList', res.closeReason);

                    var cObj = component.get('v.caseObj');
                    if (cObj.RecordTypeId == undefined || cObj.RecordTypeId == null || cObj.RecordTypeId == '') {
                        cObj.RecordTypeId = res.DefalutRecordId;
                        getRecordTypeId = res.DefalutRecordId;
                    }
                    component.set('v.caseObj', cObj);
                    // //console.log(JSON.parse(JSON.stringify(component.get('v.PickList'))));
                    // //console.log('getRecordTypeId -1 : ' + getRecordTypeId);
                    // //console.log('Team :', res.recordTypeMap[getRecordTypeId]);
                    // //console.log('Map: ', res.recordTypeMap);
                    if (res.recordTypeMap[getRecordTypeId] == 'Airport Transfer Case') {
                        component.set('v.isAirportTransferRecordType', true);
                    } 
                    // else if (res.recordTypeMap[getRecordTypeId] == 'Contact Center Case') {
                    //     component.set('v.isContactCenter', true);
                    // } else if (res.recordTypeMap[getRecordTypeId] == 'Clinic Case') {
                    //     component.set('v.isClinicRecordType', true);
                    //     // //console.log('----------------ret');

                    // }
                    
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
                            // //console.log("Error message: " +
                            //     errors[0].message);
                            helper.displayToast(component, "Error", errors[0].message);
                        }
                    } else {
                        //console.log("Unknown error");
                    }
                    // reject(Error('Invalid value: Task Object'))
                }
            });
            $A.enqueueAction(action);


        });
        actionPromise.then(
            function (res) {
                // if (recordCaseId != undefined && recordCaseId != null) {
                var action = component.get("c.getCaseAndPatientInformation");
                action.setParams({
                    "caseId": recordCaseId,
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var returnValues = response.getReturnValue();
                        //console.log(':::::::::::::: Method c.getCaseAndPatientInformation ::::::::::::::');
                        //console.log('pickListValueWrapper : ', res);
                        //console.log('CaseAndPatientInformationWrapper : ', returnValues);
                        if (recordCaseId != undefined && recordCaseId != null) {
                            //console.log(' recordCaseId null');
                            setTimeout(() => {

                                var cmp = component

                                const empApi = cmp.find('empApi');

                                // Uncomment below line to enable debug logging (optional)
                                // empApi.setDebugFlag(true);
                        
                                // Register error listener and pass in the error handler function
                                empApi.onError($A.getCallback(error => {
                                    // Error can be any type of error (subscribe, unsubscribe...)
                                    console.error('EMP API error: ', JSON.stringify(error));
                                }));
                        
                                
                                // Get the channel from the input box
                                const channel = '/event/Publish_Verify_Button'+returnValues.CaseObject.Platform_Event_Channel__c+'__e';
                                // Replay option to get new events
                                const replayId = -1;
                        
                                // Subscribe to an event
                                empApi.subscribe(channel, replayId, $A.getCallback(eventReceived => {
                                    // Process event (this is called each time we receive an event)
                                    //console.log('Received event ', JSON.stringify(eventReceived));
                        
                                    // //console.log(eventReceived.data.payload.Case_Id__c);
                        
                                    // //console.log(cmp.get('v.recordId'));
                                    if(eventReceived.data.payload.Case_Id__c === cmp.get('v.recordId')){
                        
                                        cmp.set('v.caseObj.Verified_Patient__c',true);
                                        //helper.closeFocusedTab(component, event, helper); 
                        
                                        helper.startSpinner(component);
                                        var action = cmp.get("c.getCaseAndPatientInformationUpdated");
                                        action.setParams({
                                            "caseId": cmp.get("v.recordId")
                                        });
                                
                                        helper.serverSideCall(cmp, action).then(
                                            function (result) {
                                                
                                                //console.log(result);
                        
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
                                    cmp.set('v.subscription', subscription);
                                });
                                
                                
                                component.set('v.CaseCateLVL_2', res.mapCaseLvl2[returnValues.CaseObject.Case_Category_Level1__c]);
                                component.set('v.CaseCateLVL_3', res.mapCaseLvl3[returnValues.CaseObject.Case_Category_Level2__c + ':' + returnValues.CaseObject.Case_Category_Level1__c]);
                                // component.set('v.ArriveTimeList', res.flightMap[returnValues.CaseObject.Flight_Number__c]);
                                // component.set('v.SegmentList', res.paymentMap[returnValues.CaseObject.Method_Of_Payment__c]);
                                component.set("v.departmentList", res.buildingMap[returnValues.CaseObject.Building__c]);
                                component.set('v.caseObj', returnValues.CaseObject);
                               

                                // //console.log('caseObj: ',returnValues.CaseObject);

                                component.set('v.checkInTime', returnValues.checkInTime);
                                component.set('v.checkOutTime', returnValues.checkOutTime);

                                component.set('v.numberDynamicGroup', res.mapDynamicGroup[returnValues.CaseObject.Case_Category_Level3__c + ':' + returnValues.CaseObject.Case_Category_Level2__c + ':' + returnValues.CaseObject.Case_Category_Level1__c])
                                //console.log('numberDynamicGroup : ',JSON.stringify(component.get('v.numberDynamicGroup')));
                                
                                if (res.recordTypeMap[returnValues.CaseObject.RecordTypeId] == 'Airport Transfer Case') {
                                    component.set('v.isAirportTransferRecordType', true);
                                    component.set('v.isRequiredSenderEmail', false);
                                    //console.log(' returnValues.CaseObject.Airport_Rep_Name__c' + returnValues.CaseObject.Airport_Rep_Name__c);
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
                                // //console.log('returnValues.UserCurrentInfo : ', returnValues.UserCurrentInfo);

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
                                // //console.log('----001----');

                                component.set('v.patientNameValue', returnValues.PatientObject);
                                if (returnValues.SenderObject != null) {
                                    component.set('v.senderNameValue', returnValues.SenderObject);
                                    component.set('v.senderNameValue.Email__c', returnValues.CaseObject.SuppliedEmail);
                                } else {
                                    component.set('v.senderNameValue', null);
                                }
                                // //console.log('----002----');
                                if (returnValues.DoctorObject != null) {
                                    component.set('v.doctorNameValue', returnValues.DoctorObject);
                                } else {
                                    component.set('v.doctorNameValue', null);
                                }
                                // //console.log('----003----');
                                if (returnValues.PendingPersonObject != null) {
                                    component.set('v.personReasonNameValue', returnValues.PendingPersonObject);
                                } else {
                                    component.set('v.personReasonNameValue', null);
                                }
                                // //console.log('----004----');

                                var status = component.get('v.caseObj.Status');
                                //  //console.log('status'+status);
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

                                    //console.log('=================apptem jaaa');
                                    
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
                                
                                // //console.log('value : ',value);

                                // helper.ohandleSelect(component, event, component.get('v.ownerType'));
                                helper.stopSpinner(component);
                                // //console.log('----005----');
                                // if( res.UserLogInInfo.User_Team__c.includes("Contact Center")  && res.recordTypeMap[returnValues.CaseObject.RecordTypeId] != 'Contact Center Case' ){
                                if( res.UserLogInInfo.User_Team__c.includes("Contact Center")  && !(res.recordTypeMap[returnValues.CaseObject.RecordTypeId].includes("Contact Center Case"))){
                                    component.set('v.CaseCateLVL_2', null);
                                    component.set('v.CaseCateLVL_3', null);
                                    component.set('v.caseObj.Case_Category_Level1__c', "");
                                    component.set('v.caseObj.Case_Category_Level2__c', "");
                                    component.set('v.caseObj.Case_Category_Level3__c', "");
                                }
                            }, 50);

                            setTimeout(() => {
                                //console.log(' %%%%%%%%');
                                component.set('v.caseObj', returnValues.CaseObject);
                                //console.log(' %%%%%%%%');
                                component.set('v.isCampaignLoading',false);
                            }, 1250);
                            
                            // //console.log(component.get('v.caseOwnerValue'));
                        } else {
                            //console.log('RecordTypeId : ', getRecordTypeId);
                            
                            //console.log(' recordCaseId null');
                            component.set('v.caseObj.Channel__c', "Contact Center");
                            component.set('v.caseObj.Status', "New");
                            component.set('v.caseObj.Priority', "High");
                            component.set('v.caseObj.Origin', "Phone");
                            component.set('v.caseObj.Contact_Center_Channel__c', "Inbound");
                            component.set('v.caseObj.RecordTypeId', component.get('v.recordTypeId'));
                            //     //console.log('OwnerObj : ', component.get('v.OwnerObj'));
                            var thisOwner = component.get('v.OwnerObj');
                            //console.log('thisOwner : ', thisOwner);
                            if (thisOwner != null) {
                                if (thisOwner.Id.startsWith("003")){
                                    component.set('v.patientNameValue', null);
                                    //console.log('TESTTTTT: ',component.get('v.senderNameValue'));
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
                                // component.set('v.caseOwnerValue', null);
                                component.set('v.caseOwnerValue', component.get('v.UserObj'));
                                component.set('v.patientNameValue', null);
                                component.set('v.senderNameValue', null);
                            }
                            helper.stopSpinner(component);

                        }

                    } else if (state === "ERROR") {

                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                // //console.log("Error message: " +
                                //     errors[0].message);
                                helper.displayToast(component, "Error", errors[0].message);
                            }
                        } else {
                            //console.log("Unknown error");
                        }
                    }
                });
                $A.enqueueAction(action);

                // } else {
                //     //new case
                //     //console.log('OwnerObj : ', component.get('v.OwnerObj'));
                //     if (component.get('v.OwnerObj') != null) {
                //         component.set('v.caseOwnerValue', component.get('v.UserObj'));
                //         component.set('v.patientNameValue', component.get('v.OwnerObj'));
                //         component.set('v.senderNameValue', null);
                //     } else {
                //         component.set('v.caseOwnerValue', null);
                //         component.set('v.patientNameValue', null);
                //         component.set('v.senderNameValue', null);
                //     }

                //     helper.stopSpinner(component);
                // }
            },
            function (error) {
                helper.stopSpinner(component);
                helper.displayToast(component, "Warning", error.message);
            });
    },
    /*getAccountOfContact: function (component, event, helper){

        var accountid = component.get('v.OwnerObj.AccountId');
        var actionPromise = new Promise(function (resolve, reject) {
            var action = component.get('c.getParentIdOnFocusTab');
                action.setParams({
                    "accountId": accountid, //get accountId for parent tab
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var returnValues = response.getReturnValue();

                        component.set('v.senderNameValue', returnValues);
                        //console.log('v.senderNameValue', returnValues);

                        resolve(returnValues);
                    } else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                //console.log(errors);

                                // //console.log("Error message: " +
                                //     errors[0].message);
                                helper.displayToast(component, "Error", errors[0].message);
                            }
                        } else {
                            //console.log("Unknown error");
                        }
                        reject(Error('Invalid value: Task Object'))
                    }
                });
                $A.enqueueAction(action);
            });
            actionPromise.then(
                function (returnValues) {
                    //helper.getWrapper(component, event, helper);

                }
            );
    },*/
    displayToast: function (component, type, message) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            type: type,
            message: message,
        });
        toastEvent.fire();
    },
    parseObj: function (objFields) {
        return JSON.parse(JSON.stringify(objFields));
    },
    ohandleSelect: function (component, event, value) {
        // This will contain the index (position) of the selected lightning:menuItem
        // //console.log('helper');
        component.set('v.caseOwnerValue', null);
        // Find all menu items
        if (value == 'user') {
            component.set('v.isOwnerTypeUser', true);
            component.set("v.ownerType", value);
        } else {
            component.set('v.isOwnerTypeUser', false);
            component.set("v.ownerType", value);
        }

    },
    validateField: function (component, event, helper) {
        var isValid = true;
        var isRequiredSenderEmail = component.get('v.isRequiredSenderEmail');
        // //console.log('-- Validation --');

        var message = 'Please complete all required fields';
        var caseObj = component.get('v.caseObj');
        // component.find('sender_email').showHelpMessageIfInvalid();
        if (component.get('v.caseOwnerValue') == null) {
            isValid = false;
            // message = 'Please complete Case Owner field'
        }

        // //console.log('caseObj.Subject : ' + caseObj.Subject);
        // if (caseObj.Caller_Name__c == '' || caseObj.Caller_Name__c == undefined) {
        //     isValid = false;
        //     component.find('caller_name').showHelpMessageIfInvalid();
        //     // message = 'Please complete Subject field'
        // }
        // //console.log('caseObj.SuppliedEmail : ' + caseObj.SuppliedEmail);
        // if ((caseObj.Contact_Number__c == '' || caseObj.Contact_Number__c == undefined)) {
        //     isValid = false;
        //     component.find('contact_number').showHelpMessageIfInvalid();
        //     // message = 'Please complete Sender Email field'
        // }
        //  //console.log('caseObj.SuppliedEmail : ' + caseObj.SuppliedEmail);
        if ((caseObj.Contact_Center_Channel__c == '' || caseObj.Contact_Center_Channel__c == undefined)) {
            isValid = false;
            component.find('contact_center_channel').showHelpMessageIfInvalid();
            // message = 'Please complete Sender Email field'
        }

        // //console.log('caseObj.Case_Category_Level1__c : ' + caseObj.Case_Category_Level1__c);
        if (caseObj.Case_Category_Level1__c == '' || caseObj.Case_Category_Level1__c == undefined) {
            isValid = false;
            component.find('case_category_lvl_1').showHelpMessageIfInvalid();
            // message = 'Please complete Case Category Level1 field'
        }
        if (caseObj.Case_Category_Level2__c == '' || caseObj.Case_Category_Level2__c == undefined) {
            isValid = false;
            component.find('case_category_lvl_2').showHelpMessageIfInvalid();
            // message = 'Please complete Case Category Level1 field'
        }
        if (caseObj.Case_Category_Level3__c == '' || caseObj.Case_Category_Level3__c == undefined) {
            isValid = false;
            component.find('case_category_lvl_3').showHelpMessageIfInvalid();
            // message = 'Please complete Case Category Level1 field'
        }
        //console.log(' caseObj.Escalate_Date__c ::: ', caseObj.Escalate_Date__c);
        //console.log(' caseObj.Escalate_to__c ::: ', caseObj.Escalate_to__c);
        
        if ( caseObj.Escalate_to__c != '' && caseObj.Escalate_to__c != undefined && caseObj.Escalate_to__c != null && ( caseObj.Escalate_Date__c == '' || caseObj.Escalate_Date__c == undefined|| caseObj.Escalate_Date__c == null)) {
            isValid = false;
            component.find('escalate_date').showHelpMessageIfInvalid();
        }
        // //console.log('caseObj.Origin : ' + caseObj.Origin);
        if (caseObj.Origin == '' || caseObj.Origin == undefined) {
            isValid = false;
            component.find('case_origin').showHelpMessageIfInvalid();
            // message = 'Please complete Case Origin field'
        }
        // //console.log('caseObj.Channel__c : ' + caseObj.Channel__c);
        if (caseObj.Channel__c == '' || caseObj.Channel__c == undefined) {
            isValid = false;
            component.find('channel').showHelpMessageIfInvalid();
            // message = 'Please complete Channel field'
        }

        var isShowCampaignDetail = component.get('v.isShowCampaignDetail');
        if (isShowCampaignDetail) {
            if (caseObj.Campaign_Master__c == '' || caseObj.Campaign_Master__c == undefined) {
                isValid = false;
                component.find('campaign_name').showHelpMessageIfInvalid();
                // message = 'Please complete Channel field'
            }
            if (caseObj.Campaign_Interest_Type__c == '' || caseObj.Campaign_Interest_Type__c == undefined) {
                isValid = false;
                component.find('interest_case').showHelpMessageIfInvalid();
                // message = 'Please complete Channel field'
            }
            
        }


        // //console.log('-- isValid : ' + isValid);
        if (!isValid) {
            helper.displayToast(component, 'Error', message);
        }
        // //console.log('-- END Validation --');
        return isValid;
    },
    refreshFocusedTab: function (component, event, helper) {
        console.log('Start Refresh Tab Helper');
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            console.log(JSON.stringify(response));
            var focusedTabId = response.tabId;
            workspaceAPI.refreshTab({
                tabId: focusedTabId,
                includeAllSubtabs: true
            });
            
                
        }).catch(function (error) {
            console.log(error);
        });         
        console.log('End Refresh Tab Helper');
    },                         
    openTabWithSubtab: function (component, event, helper, id) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            if (!response.isSubtab) {
                workspaceAPI.openTab({
                    url: '/lightning/r/Case/' + id + '/view',
                    focus: true
                });
            } else {
                workspaceAPI.openSubtab({
                    parentTabId: response.parentTabId,
                    url: '/lightning/r/Case/' + id + '/view',
                    focus: true
                });
            }
        })
            .catch(function (error) {
                //console.log(error);
            });
    },
    closeFocusedTab: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            var focusedTabId = response.tabId;
            $A.get('e.force:refreshView').fire();
            workspaceAPI.closeTab({ tabId: focusedTabId });
        })
            .catch(function (error) {
                //console.log(error);
            });
    },
    getCurrentUserLanguage: function (component, event, helper) {
        var action = component.get('c.getCurrentUserLanguage');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValues = response.getReturnValue();
                if (returnValues.Language_Skill__c == 'Thai') {
                    component.set('v.THTemplate', true);
                }
                //console.log('THTemplate', component.get('v.THTemplate'));

                component.set('v.UserObj', returnValues);
                //console.log('UserObj', returnValues);

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log(errors);

                        // //console.log("Error message: " +
                        //     errors[0].message);
                        helper.displayToast(component, "Error", errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                }
            }

        });
        $A.enqueueAction(action);
    },
    getCampaginList: function (component, event, helper) {
        component.set('v.isCampaignLoading',true);
        //console.log(' hnhnhnhnhn >>>>  ',component.get('v.caseObj').Hospital_Number_HN__c);
        
        var action = component.get('c.getCampaignList');
        action.setParams({
            "hnnumber": component.get('v.caseObj').Hospital_Number_HN__c,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('====== getCampaginInfo ======');
                var returnValues = response.getReturnValue();
                //console.log('returnValues : ',returnValues);
                
                component.set('v.OfferCampaginPickList',returnValues.campaignPickList.OfferPicklist);
                component.set('v.NonOfferCampaginPickList',returnValues.campaignPickList.PublicPicklist);
                component.set('v.interestPickList',returnValues.interestPickList.Campaign_Interest_Type__c);
                //console.log('====== getCampaginInfo ======');
                component.set('v.isCampaignLoading',false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log(errors);

                        // //console.log("Error message: " +
                        //     errors[0].message);
                        helper.displayToast(component, "Error", errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                }
                component.set('v.isCampaignLoading',false);
            }
            

        });
        $A.enqueueAction(action);
    },
    getCampaginDetail: function (component, event, helper) {
        component.set('v.isCampaignLoading',true);
        //console.log(' hnhnhnhnhn >>>>  ',component.get('v.caseObj').Campaign_Master__c);
        
        var action = component.get('c.getCampaignDetail');
        action.setParams({
            "campaign_master_id": component.get('v.caseObj').Campaign_Master__c,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('====== getCampaginDetail ======');
                var returnValues = response.getReturnValue();
                //console.log('returnValues : ',returnValues);
                
                component.set('v.campaignMasterObj',returnValues.CampaignObj);
                component.set('v.remainCampaign',returnValues.remainCampaign);
               
                
                //console.log('====== getCampaginDetail ======');
                component.set('v.isCampaignLoading',false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log(errors);

                        // //console.log("Error message: " +
                        //     errors[0].message);
                        helper.displayToast(component, "Error", errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                }
                component.set('v.isCampaignLoading',false);
            }
            

        });
        $A.enqueueAction(action);
    },
    getvaccinenamelist: function (component, event, helper) {
        var action = component.get('c.getVaccineDetail');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValues = response.getReturnValue();
                component.set('v.vaccineList', returnValues);
                //console.log('vaccineList = ', returnValues);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log(errors);
                        helper.displayToast(component, "Error", errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getHealthArealist: function (component, event, helper) {
        var action = component.get('c.getHealthAreaDetail');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValues = response.getReturnValue();
                component.set('v.HealthAreaList', returnValues);
                //console.log('vaccineList = ', returnValues);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log(errors);
                        helper.displayToast(component, "Error", errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
   getTopiclist: function (component, event, helper) {
        var action = component.get('c.getTopicDetail');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValues = response.getReturnValue();
                component.set('v.TopicList', returnValues);
                //console.log('vaccineList = ', returnValues);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log(errors);
                        helper.displayToast(component, "Error", errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },                            
})