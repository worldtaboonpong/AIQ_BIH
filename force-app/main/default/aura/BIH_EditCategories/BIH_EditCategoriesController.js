({	
    init: function (component, event, helper) {
        
        helper.getWrapper(component, event, helper);
        
        var caseObj = component.get('v.caseObj');
        //caseObj.RecordTypeId = getRecordTypeId;
        component.set('v.caseObj', caseObj);
       // console.log('caseObj' + caseObj.RecordTypeId);
           
        //helper.stopSpinner(component);
        var catLvL1 = component.get('v.caseObj.Case_Category_Level1__c');
        var catLvL2 = component.get('v.caseObj.Case_Category_Level2__c');
        var catLvL3 = component.get('v.caseObj.Case_Category_Level3__c');

        if(catLvL1 != 'Undefined' && catLvL2 != '' ){
            component.set('v.validSaveBtn',false);
        }else{
            component.set('v.validSaveBtn',true);
        }
        
        
        
        var action = component.get("c.getUserTeam");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var userTeam = response.getReturnValue();
                component.set("v.userTeam", userTeam);
                if (userTeam === 'Individual Team' || userTeam === 'Referral Team') {
                    console.log('Individual Team+++++' + caseObj.RecordTypeId);
                    $A.util.removeClass(component.find("individualTeamSection"), "slds-hide");
                    $A.util.addClass(component.find("individualTeamSection"), "slds-show");
                } else {
                    $A.util.removeClass(component.find("individualTeamSection"), "slds-show");
                    $A.util.addClass(component.find("individualTeamSection"), "slds-hide");
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    onChangeCatelvl1: function (component, event, helper) {
        // console.log(component.find('case_category_lvl_1').get("v.validity"));
        var main = event.getSource().get("v.value");
        console.log('main: ', main);
        
        var getCate1 = component.get('v.caseObj.Case_Category_Level1__c');
        console.log('getCate1: ', getCate1);
        var sub = component.get('v.MapCaseCateLVL_2');
        console.log('sub: ', sub);
        // component.set('v.CaseCateLVL_1', sub[getCate1]);
        component.set('v.CaseCateLVL_2', sub[main]);
        //component.set('v.CaseCateLVL_3', '');
        if (main != '') {
            component.set('v.CaseCateLVL_2_disableField', false);
        } else {
            component.set('v.CaseCateLVL_2_disableField', true);
        }
        component.set('v.caseObj.Case_Category_Level2__c', '');
        component.set('v.caseObj.Case_Category_Level3__c', '');
        component.set('v.caseObj.SLA__c', '');
        component.set("v.numberDynamicGroup", undefined);
        component.set('v.caseObj.Quick_Case__c', '');
        if(component.get('v.caseObj.Is_Quick_Case_Create__c')){
            component.set('v.caseObj.Subject', getCate1);
        }
        var catLvL1 = component.get('v.caseObj.Case_Category_Level1__c');
        var catLvL2 = component.get('v.caseObj.Case_Category_Level2__c');
        var catLvL3 = component.get('v.caseObj.Case_Category_Level3__c');
        
        console.log('catLvL1', catLvL1);
        console.log('catLvL2', catLvL2);
        console.log('catLvL3', catLvL3);
        if(catLvL1 == 'Undefined' ||  catLvL1 == '' || catLvL2 == '' ){
            component.set('v.validSaveBtn',true);
        }else{
            component.set('v.validSaveBtn',false);
        }
        // console.log(SubTaskMap[Main_Task__c]);
    },
    onChangeCatelvl2: function (component, event, helper) {
        var main = event.getSource().get("v.value");
        var sub = component.get('v.MapCaseCateLVL_3');
        var getCate1 = component.get('v.caseObj.Case_Category_Level1__c');
        component.set('v.CaseCateLVL_3', sub[main + ':' + getCate1]);
        // console.log('Cate3: ' + sub[main + ':' + getCate1]);
        
        if (main != '') {
            component.set('v.CaseCateLVL_3_disableField', false);
        } else {
            component.set('v.CaseCateLVL_3_disableField', true);
        }
        component.set('v.caseObj.Case_Category_Level3__c', '');
        component.set('v.caseObj.SLA__c', '');
        component.set("v.numberDynamicGroup",undefined);
        component.set('v.caseObj.Quick_Case__c', '');
        if(component.get('v.caseObj.Is_Quick_Case_Create__c')){
            component.set('v.caseObj.Subject', getCate1 +' , '+ main);
        }
        var catLvL1 = component.get('v.caseObj.Case_Category_Level1__c');
        var catLvL2 = component.get('v.caseObj.Case_Category_Level2__c');
        var catLvL3 = component.get('v.caseObj.Case_Category_Level3__c');
        
        console.log('catLvL1', catLvL1);
        console.log('catLvL2', catLvL2);
        console.log('catLvL3', catLvL3);
        if(catLvL1 == 'Undefined' ||     catLvL1 == '' || catLvL2 == ''  ){
            component.set('v.validSaveBtn',true);
        }else{
            component.set('v.validSaveBtn',false);
        }
        // console.log(SubTaskMap[Main_Task__c]);
    },
    onChangeCatelvl3: function (component, event, helper) {
        var mapsla = component.get('v.MapSLA');
        var mapDynmicGrp = component.get('v.MapDynamicGroup');
        // var mapslacc = component.get('v.MapSLACC');
       // console.log('mapsla', JSON.parse(JSON.stringify(mapDynmicGrp)));
        // console.log('mapslacc', mapslacc);
        
        var THTemplate = component.get('v.THTemplate');
        // // alert(str.split(/[()]/));
        var mapServiceDetailTH = component.get('v.MapServiceDetailTH');
        var mapServiceDetailEN = component.get('v.MapServiceDetailEN');
        var mapScriptTH = component.get('v.MapScriptTH');
        var mapScriptEN = component.get('v.MapScriptEN');
        var catLvL1 = component.get('v.caseObj.Case_Category_Level1__c');
        var catLvL2 = component.get('v.caseObj.Case_Category_Level2__c');
        var catLvL3 = component.get('v.caseObj.Case_Category_Level3__c');
        
        console.log('catLvL1', catLvL1);
        console.log('catLvL2', catLvL2);
        console.log('catLvL3', catLvL3);
        if(catLvL1 == 'Undefined' || catLvL1 == '' || catLvL2 == ''  ){
            component.set('v.validSaveBtn',true);
        }else{
            component.set('v.validSaveBtn',false);
        }
        
        var tmp = catLvL3 + ':' + catLvL2 + ':' + catLvL1;
        var PayorType = component.get('v.caseObj.Payor_Type__c');
        console.log('PayorType: ',PayorType);
        component.set('v.caseObj.Payor_Type__c',PayorType);
        
        component.set('v.numberDynamicGroup', mapDynmicGrp[tmp]);
        component.set('v.caseObj.SLA__c', mapsla[tmp]);
        
        var scriptInfo ;
        var serviceDetailInfo;
        if (THTemplate == true) {
            scriptInfo = mapScriptTH[tmp];
            serviceDetailInfo = mapServiceDetailTH[tmp];
        }else{
            scriptInfo = mapScriptEN[tmp];
            serviceDetailInfo = mapServiceDetailEN[tmp];
        }
        component.set('v.caseObj.Script__c', scriptInfo);
        component.set('v.caseObj.Service_Detail__c', serviceDetailInfo);
        component.set('v.caseObj.Quick_Case__c', '');
        if(component.get('v.caseObj.Is_Quick_Case_Create__c')){
            component.set('v.caseObj.Subject', catLvL1 +' , '+ catLvL2 + ' , '+ catLvL3);
        }
    },
    onChangeQuickCase: function (component, event, helper) {
        component.set('v.isResetCate', false);
        component.set('v.isResetCate', true);
        
        
        console.log('--- on change quick case ---');
        var mapsla = component.get('v.MapSLA');
        var map_quick_case = component.get('v.MapQuickCase');
        var val = event.getSource().get("v.value");
        console.log('map_quick_case : ', JSON.parse(JSON.stringify(map_quick_case)));
        console.log('val : ', val);
        
        var cate1 = map_quick_case[val].split(":")[2];
        var cate2 = map_quick_case[val].split(":")[1];
        var cate3 = map_quick_case[val].split(":")[0];
        var THTemplate = component.get('v.THTemplate');
        // console.log('map_quick_case[val].split(":") : ', map_quick_case[val].split(":"));
        var mapDynmicGrp = component.get('v.MapDynamicGroup');
        var mapCateLvl2 = component.get('v.MapCaseCateLVL_2');
        var mapCateLvl3 = component.get('v.MapCaseCateLVL_3');
        var mapServiceDetailTH = component.get('v.MapServiceDetailTH');
        var mapServiceDetailEN = component.get('v.MapServiceDetailEN');
        var mapScriptTH = component.get('v.MapScriptTH');
        var mapScriptEN = component.get('v.MapScriptEN');
        component.set('v.CaseCateLVL_2', mapCateLvl2[cate1]);
        component.set('v.CaseCateLVL_3', mapCateLvl3[cate2 + ':' + cate1]);
        // console.log('mapCateLvl2[] : ' , JSON.parse(JSON.stringify(mapCateLvl2[cate1])));
        // console.log('mapCateLvl3[] : ', JSON.parse(JSON.stringify(mapCateLvl3[cate2 + ':' + cate1])));
        var scriptInfo;
        var serviceDetailInfo;
        // console.log('mapScriptTH : ', JSON.parse(JSON.stringify(mapScriptTH)));
        // console.log('mapScriptEN : ', JSON.parse(JSON.stringify(mapScriptEN)));
        // console.log('mapServiceDetailTH : ', JSON.parse(JSON.stringify(mapServiceDetailTH)));
        // console.log('mapServiceDetailEN : ', JSON.parse(JSON.stringify(mapServiceDetailEN)));
        
        if (THTemplate == true) {
            scriptInfo = mapScriptTH[map_quick_case[val]];
            serviceDetailInfo = mapServiceDetailTH[map_quick_case[val]];
        } else {
            scriptInfo = mapScriptEN[map_quick_case[val]];
            serviceDetailInfo = mapServiceDetailEN[map_quick_case[val]];
        }
        console.log('scriptInfo : ', scriptInfo);
        console.log('serviceDetailInfo : ', serviceDetailInfo);
        setTimeout(() => {
            var caseObj = component.get('v.caseObj');
            
            caseObj.Case_Category_Level1__c = cate1;
            caseObj.Case_Category_Level2__c = cate2;
            caseObj.Case_Category_Level3__c = cate3;
            caseObj.Quick_Case__c = val;
            caseObj.Script__c = scriptInfo;
            caseObj.Service_Detail__c = serviceDetailInfo;
            
            component.set('v.caseObj', caseObj);
            component.set('v.numberDynamicGroup', mapDynmicGrp[map_quick_case[val]]);
            component.set('v.caseObj.SLA__c', mapsla[map_quick_case[val]]);
            
            // console.log(component.find('case_category_lvl_1').get("v.validity"));
            
            // var valid1 = component.find('case_category_lvl_1').get("v.validity");
            
            // component.find('case_category_lvl_1').setCustomValidity('');
            // console.log(component.find('case_category_lvl_1').get("v.validity"));
        }, 50);
        
        
    },
    onChangeQuickCase1: function (component, event, helper) {
        component.set('v.isResetCate', false);
        component.set('v.isResetCate', true);
        
        
        console.log('--- on change quick case ---');
        var mapsla = component.get('v.MapSLA');
        var map_quick_case = component.get('v.MapQuickCase1');
        var val = event.getSource().get("v.value");
        console.log('map_quick_case : ', JSON.parse(JSON.stringify(map_quick_case)));
        console.log('val : ', val);
        
        var cate1 = map_quick_case[val].split(":")[2];
        var cate2 = map_quick_case[val].split(":")[1];
        var cate3 = map_quick_case[val].split(":")[0];
        var THTemplate = component.get('v.THTemplate');
        // console.log('map_quick_case[val].split(":") : ', map_quick_case[val].split(":"));
        var mapDynmicGrp = component.get('v.MapDynamicGroup');
        var mapCateLvl2 = component.get('v.MapCaseCateLVL_2');
        var mapCateLvl3 = component.get('v.MapCaseCateLVL_3');
        var mapServiceDetailTH = component.get('v.MapServiceDetailTH');
        var mapServiceDetailEN = component.get('v.MapServiceDetailEN');
        var mapScriptTH = component.get('v.MapScriptTH');
        var mapScriptEN = component.get('v.MapScriptEN');
        component.set('v.CaseCateLVL_2', mapCateLvl2[cate1]);
        component.set('v.CaseCateLVL_3', mapCateLvl3[cate2 + ':' + cate1]);
        // console.log('mapCateLvl2[] : ' , JSON.parse(JSON.stringify(mapCateLvl2[cate1])));
        // console.log('mapCateLvl3[] : ', JSON.parse(JSON.stringify(mapCateLvl3[cate2 + ':' + cate1])));
        var scriptInfo;
        var serviceDetailInfo;
        // console.log('mapScriptTH : ', JSON.parse(JSON.stringify(mapScriptTH)));
        // console.log('mapScriptEN : ', JSON.parse(JSON.stringify(mapScriptEN)));
        // console.log('mapServiceDetailTH : ', JSON.parse(JSON.stringify(mapServiceDetailTH)));
        // console.log('mapServiceDetailEN : ', JSON.parse(JSON.stringify(mapServiceDetailEN)));
        
        if (THTemplate == true) {
            scriptInfo = mapScriptTH[map_quick_case[val]];
            serviceDetailInfo = mapServiceDetailTH[map_quick_case[val]];
        } else {
            scriptInfo = mapScriptEN[map_quick_case[val]];
            serviceDetailInfo = mapServiceDetailEN[map_quick_case[val]];
        }
        console.log('scriptInfo : ', scriptInfo);
        console.log('serviceDetailInfo : ', serviceDetailInfo);
        setTimeout(() => {
            var caseObj = component.get('v.caseObj');
            
            caseObj.Case_Category_Level1__c = cate1;
            caseObj.Case_Category_Level2__c = cate2;
            caseObj.Case_Category_Level3__c = cate3;
            caseObj.Quick_Case__c = val;
            caseObj.Script__c = scriptInfo;
            caseObj.Service_Detail__c = serviceDetailInfo;
            
            component.set('v.caseObj', caseObj);
            component.set('v.numberDynamicGroup', mapDynmicGrp[map_quick_case[val]]);
            component.set('v.caseObj.SLA__c', mapsla[map_quick_case[val]]);
            
            // console.log(component.find('case_category_lvl_1').get("v.validity"));
            
            // var valid1 = component.find('case_category_lvl_1').get("v.validity");
            
            // component.find('case_category_lvl_1').setCustomValidity('');
            // console.log(component.find('case_category_lvl_1').get("v.validity"));
        }, 50);
        
        
    },
    onChangeQuickCase2: function (component, event, helper) {
        component.set('v.isResetCate', false);
        component.set('v.isResetCate', true);
        
        
        console.log('--- on change quick case ---');
        var mapsla = component.get('v.MapSLA');
        var map_quick_case = component.get('v.MapQuickCase2');
        var val = event.getSource().get("v.value");
        console.log('map_quick_case : ', JSON.parse(JSON.stringify(map_quick_case)));
        console.log('val : ', val);
        
        var cate1 = map_quick_case[val].split(":")[2];
        var cate2 = map_quick_case[val].split(":")[1];
        var cate3 = map_quick_case[val].split(":")[0];
        var THTemplate = component.get('v.THTemplate');
        var mapDynmicGrp = component.get('v.MapDynamicGroup');
        var mapCateLvl2 = component.get('v.MapCaseCateLVL_2');
        var mapCateLvl3 = component.get('v.MapCaseCateLVL_3');
        var mapServiceDetailTH = component.get('v.MapServiceDetailTH');
        var mapServiceDetailEN = component.get('v.MapServiceDetailEN');
        var mapScriptTH = component.get('v.MapScriptTH');
        var mapScriptEN = component.get('v.MapScriptEN');
        component.set('v.CaseCateLVL_2', mapCateLvl2[cate1]);
        component.set('v.CaseCateLVL_3', mapCateLvl3[cate2 + ':' + cate1]);
        // console.log('mapCateLvl2[] : ' , JSON.parse(JSON.stringify(mapCateLvl2[cate1])));
        // console.log('mapCateLvl3[] : ', JSON.parse(JSON.stringify(mapCateLvl3[cate2 + ':' + cate1])));
        var scriptInfo;
        var serviceDetailInfo;
        
        if (THTemplate == true) {
            scriptInfo = mapScriptTH[map_quick_case[val]];
            serviceDetailInfo = mapServiceDetailTH[map_quick_case[val]];
        } else {
            scriptInfo = mapScriptEN[map_quick_case[val]];
            serviceDetailInfo = mapServiceDetailEN[map_quick_case[val]];
        }
        console.log('scriptInfo : ', scriptInfo);
        console.log('serviceDetailInfo : ', serviceDetailInfo);
        setTimeout(() => {
            var caseObj = component.get('v.caseObj');
            
            caseObj.Case_Category_Level1__c = cate1;
            caseObj.Case_Category_Level2__c = cate2;
            caseObj.Case_Category_Level3__c = cate3;
            caseObj.Quick_Case__c = val;
            caseObj.Script__c = scriptInfo;
            caseObj.Service_Detail__c = serviceDetailInfo;
            
            component.set('v.caseObj', caseObj);
            component.set('v.numberDynamicGroup', mapDynmicGrp[map_quick_case[val]]);
            component.set('v.caseObj.SLA__c', mapsla[map_quick_case[val]]);
            
        }, 50);
        
        
    },
    onSave: function (component, event, helper) {
        helper.startSpinner(component);
        console.log('===onSave===');
        var validate = true;//helper.validateField(component, event, helper);
        console.log( 'Case_Category_Level1__c : ' ,component.get('v.caseObj.Case_Category_Level1__c'));
        console.log( 'Case_Category_Level2__c : ' ,component.get('v.caseObj.Case_Category_Level2__c'));
        console.log( 'Case_Category_Level3__c : ' ,component.get('v.caseObj.Case_Category_Level3__c'));

        if(component.get('v.caseObj.Case_Category_Level1__c') == '' || component.get('v.caseObj.Case_Category_Level1__c') == undefined  || component.get('v.caseObj.Case_Category_Level2__c')  == ''  )
            validate = false;
        
        
        if (validate) {
            console.log('====Validation Passed====');
            
            
            
            
            // console.log('Checking 1');
            if (component.get('v.caseObj.Channel__c') == "Contact Center" && component.get('v.caseObj.Origin') != 'Email' ){
                component.set('v.caseObj.Subject', component.get('v.caseObj.Case_Category_Level1__c') + ' , ' + component.get('v.caseObj.Case_Category_Level2__c') + ' , ' + component.get('v.caseObj.Case_Category_Level3__c' ) );
            }
            
            
            console.log('CASE SAVE :::: ',JSON.parse(JSON.stringify(component.get('v.caseObj'))));
            var caseObj = component.get('v.caseObj');
            
            component.set('v.patientObj.sobjectType','Account'); 
            component.set('v.senderObj.sobjectType','Account');
            
            var patientObj;
            var senderObj;
            // console.log('arrive time '+component.get('v.caseObj.Arrival_Time__c'));
            // patientObj = component.get('v.patientObj');
            //senderObj = component.get('v.senderObj');
            
            
            console.log( 'caseObj : ' ,JSON.parse(JSON.stringify(caseObj)));
            //console.log( 'patientObj : ' ,JSON.parse(JSON.stringify(patientObj)));
            //console.log( 'senderObj : ' ,JSON.parse(JSON.stringify(senderObj)));
            
            
            var action = component.get("c.UpdateCaseRecord");
            action.setParams({
                "caseObj": caseObj,
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state on save :', state);
                
                if (state === "SUCCESS") {
                    var getReturnValue = response.getReturnValue();
                    var isNew = component.get("v.recordId");
                    
                    console.log(getReturnValue);
                    var toastEventSuccess = $A.get('e.force:showToast');
                    toastEventSuccess.setParams({
                        type: 'Success',
                        message: 'This case is saved'
                    });
                    toastEventSuccess.fire();
                    $A.get('e.force:refreshView').fire();
                    $A.get('e.force:closeQuickAction').fire();
                    helper.stopSpinner(component); 
                    //helper.displayToast(component, "Success", "This case is saved");
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        type: 'Error',
                        message: errors[0].message
                    });
                    toastEvent.fire();
                    helper.stopSpinner(component);                    
                    console.log(errors[0].message);  
                    //helper.displayToast(component, "Error", errors[0].message);
                }
                helper.stopSpinner(component);
            });
            $A.enqueueAction(action);
        } else {
            console.log('====Validation failed====');
        }
    },
    doCancel: function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})