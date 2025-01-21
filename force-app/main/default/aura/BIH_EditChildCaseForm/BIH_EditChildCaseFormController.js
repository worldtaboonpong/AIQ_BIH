({

	init: function (cmp, event, helper) {
		

//		helper.startSpinner(cmp);
		var action = cmp.get("c.getBtnConfig");
		helper.getPreferLanguagelist(cmp, event, helper);
		helper.serverSideCall(cmp, action).then(
			function (result) {
				
				if(result==='New' || result==='new' || result==='NEW'){
					cmp.set("v.isNew", true);
				}else{
					cmp.set("v.isNew", false);
				}


				var action2 = cmp.get("c.getPDVSEndpoint");
				return helper.serverSideCall(cmp, action2);
			}
		).then(
			function (result) {

				cmp.set("v.pdvsEndpoint", result);

				var action3 = cmp.get("c.getUserName");
				return helper.serverSideCall(cmp, action3);

			}
		).then(
			function (result) {

				cmp.set("v.userName", result);


				var action4 = cmp.get("c.getSessionId");
				return helper.serverSideCall(cmp, action4);
			}
		).then(
			function (result) {
				cmp.set("v.sessionId", result);

				var action5 = cmp.get("c.getClientId");
				action5.setParams({
					"caseId": cmp.get("v.recordId"),
				});

				return helper.serverSideCall(cmp, action5);
			}
		).then(
			function(result){
				
				if(result === null){
					cmp.set("v.clientId","");
				}else{
					cmp.set("v.clientId", result);
				}

				//helper.startSpinner(cmp);
				helper.onInIt(cmp, event, helper);
				// helper.getCurrentUserLanguage(cmp, event, helper);
				// //console.log(JSON.parse(JSON.stringify(cmp.get("v.pageReference").state)));
				var getRecordTypeId = cmp.get("v.recordTypeId");
				//console.log('getRecordTypeId: ', cmp.get("v.recordTypeId"));
		
				var caseObj = cmp.get('v.caseObj');
				caseObj.RecordTypeId = getRecordTypeId;
				cmp.set('v.caseObj', caseObj);
				// cmp.set('v.recordId',caseObj.Id);
				//console.log('caseObj' + caseObj.RecordTypeId);
				//console.log('caseObj' + caseObj.Id);
				helper.getCampaignList(cmp, event, helper);
			}
		).catch(
			function (error) {
				//helper.stopSpinner(cmp);
			}
		);		
	},

	onSearchPDVS: function(component, event, helper){
		var dt = new Date().getTime();
    	var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        	var r = (dt + Math.random()*16)%16 | 0;
        	dt = Math.floor(dt/16);
        	return (c=='x' ? r :(r&0x3|0x8)).toString(16);
    	});     

		var hnNumber = component.get("v.caseObj.Hospital_Number_HN__c");
		if (typeof(hnNumber) == "undefined"){
			hnNumber = "";
		}

		var dateOfBirth = component.get("v.caseObj.Date_of_Birth__c");
		if (typeof(dateOfBirth) == "undefined"){
			dateOfBirth = "";
		}
		
		var fullName = component.get("v.caseObj.Full_Name__c");
		var firstName;
		var lastName;
		if (typeof(fullName) == "undefined"){
			firstName = "";
			lastName = "";
		}else{
			firstName = fullName.split(' ')[0];
			lastName = fullName.split(' ')[1];
		}

		if(typeof(firstName)=="undefined"){
			firstName = "";
		}
		if(typeof(lastName)=="undefined"){
			lastName = "";
		}

		var gender = component.get("v.caseObj.Gender__c");
		if(typeof(gender)=="undefined"){
			gender = "";
		}

		if(gender === "Male"){
			gender = 'male';
		}else if(gender === "Female"){
			gender = 'female';
		}else{
			gender = '';
		}

		var dateOfBirthString = '';
		var date = new Date(dateOfBirth);
		if (!isNaN(date.getTime())) {
			var day = date.getDate().toString();
			var month = (date.getMonth() + 1).toString();
			// Months use 0 index.

			dateOfBirthString = (day[1] ? day : '0' + day[0]) + '/' +
			(month[1] ? month : '0' + month[0]) + '/' + 
			date.getFullYear();
		}
		// alert("v.sessionId >> "+component.get("v.sessionId"));
		// alert("v.userName >> "+component.get("v.userName"));

		//	helper.startSpinner(component);
		$.ajax({url: component.get("v.pdvsEndpoint"), method: "post",headers: {
			'Content-Type'		:'application/json',
			'X-Service-Name'	:'auth-search_varify',
			'X-Request-UUID'	: uuid,
			'X-ProxyUser-Ip'	:'203.0.113.19',
			'API_KEY'			:'3a7c7be3125d4ea0a0ae665ed92cdc99'
		},dataType:"json",data:JSON.stringify({
						"search_patient": { 
							"hn" 			: hnNumber,
							"first_name" 	: firstName,
							"last_name" 	: lastName,
							"sex" 			: gender,
							"date_of_birth" : dateOfBirthString,
							"case_id" : component.get("v.recordId"),
							"case_no" : component.get("v.caseObj.CaseNumber"),
							"client_id" : component.get("v.clientId")
						},
							"request_session"	: component.get("v.sessionId"),
							"username"			: component.get("v.userName")
						})
		,
		success: function(result){
			//helper.stopSpinner(component);

			if(result.status){
				console.log('success');
                                    console.log('uuid:'+uuid);
                                    console.log('hnNumber:'+hnNumber);
                                    console.log('firstName:'+firstName);
                                    console.log('lastName:'+lastName);
                                    console.log('gender:'+gender);
                                    console.log('dateOfBirthString:'+dateOfBirthString);
                                    console.log('case_id:'+component.get("v.recordId"));
                                    console.log('case_no:'+component.get("v.caseObj.CaseNumber"));
                                    console.log('client_id:'+component.get("v.clientId"));
                                    console.log('request_session:'+component.get("v.sessionId"));
                                    console.log('username:'+component.get("v.userName"));

				window.open(result.data.redirect_url,'_blank');
			}else{
                					console.log('Error');
                                    console.log('uuid:'+uuid);
                                    console.log('hnNumber:'+hnNumber);
                                    console.log('firstName:'+firstName);
                                    console.log('lastName:'+lastName);
                                    console.log('gender:'+gender);
                                    console.log('dateOfBirthString:'+dateOfBirthString);
                                    console.log('case_id:'+component.get("v.recordId"));
                                    console.log('case_no:'+component.get("v.caseObj.CaseNumber"));
                                    console.log('client_id:'+component.get("v.caseObj.clientId"));
                                    console.log('request_session:'+component.get("v.sessionId"));
                                    console.log('username:'+component.get("v.userName"));
				helper.displayToast(component, "Error", result.status_code + ' ' + result.status_message);
			}
		  },
		error: function( jqXhr, textStatus, errorThrown ){
									console.log('Error2');
                                    console.log('uuid:'+uuid);
                                    console.log('hnNumber:'+hnNumber);
                                    console.log('firstName:'+firstName);
                                    console.log('lastName:'+lastName);
                                    console.log('gender:'+gender);
                                    console.log('dateOfBirthString:'+dateOfBirthString);
                                    console.log('case_id:'+component.get("v.recordId"));
                                    console.log('case_no:'+component.get("v.caseObj.CaseNumber"));
                                    console.log('client_id:'+component.get("v.caseObj.clientId"));
                                    console.log('request_session:'+component.get("v.sessionId"));
                                    console.log('username:'+component.get("v.userName"));
                                    console.log('jqXhr :'+JSON.stringify(jqXhr));
                                    console.log('textStatus :'+textStatus);
                                    console.log('errorThrown :'+errorThrown);

			//alert('Cannot connect to PDVS!');
			//
			//helper.stopSpinner(component);

			//helper.displayToast(component, "Error", 'Cannot connect to PDVS!');

			
		}
		});
	},

	onChangeCatelvl1: function (component, event, helper) {
		var main = event.getSource().get("v.value");
		//console.log('main: ',main);
		
		var getCate1 = component.get('v.caseObj.Case_Category_Level1__c');
		//console.log('getCate1: ',getCate1);
		var sub = component.get('v.MapCaseCateLVL_2');
		//console.log('sub: ',sub);
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
		// //console.log(SubTaskMap[Main_Task__c]);
	},
	onChangeCatelvl2: function (component, event, helper) {
		var main = event.getSource().get("v.value");
		var sub = component.get('v.MapCaseCateLVL_3');
		var getCate1 = component.get('v.caseObj.Case_Category_Level1__c');
		component.set('v.CaseCateLVL_3', sub[main + ':' + getCate1]);
		// //console.log('Cate3: ' + sub[main + ':' + getCate1]);

		if (main != '') {
			component.set('v.CaseCateLVL_3_disableField', false);
		} else {
			component.set('v.CaseCateLVL_3_disableField', true);
		}
		component.set('v.caseObj.Case_Category_Level3__c', '');
		component.set('v.caseObj.SLA__c', '');
		// //console.log(SubTaskMap[Main_Task__c]);
	},
	onChangeCatelvl3: function (component, event, helper) {
		var mapsla = component.get('v.MapSLA');
		var mapslacc = component.get('v.MapSLACC');
		//console.log('mapsla',mapsla);
		//console.log('mapslacc',mapslacc);
		
		var THTemplate = component.get('v.THTemplate');
		// alert(str.split(/[()]/));
		var mapServiceDetailTH = component.get('v.MapServiceDetailTH');
		var mapServiceDetailEN = component.get('v.MapServiceDetailEN');
		var catLvL1 = component.get('v.caseObj.Case_Category_Level1__c');
		var catLvL2 = component.get('v.caseObj.Case_Category_Level2__c');
		var catLvL3 = component.get('v.caseObj.Case_Category_Level3__c');
		catLvL1 = catLvL1.split(":");
		catLvL2 = catLvL2.split(":");
		catLvL3 = catLvL3.split(":");
		catLvL1 = catLvL1[0].trimEnd();
		catLvL2 = catLvL2[0].trimEnd();
		catLvL3 = catLvL3[0].trimEnd();
		//console.log('catLvL1: ',catLvL1);
		//console.log('catLvL2: ',catLvL2);
		//console.log('catLvL3: ',catLvL3);
		var tmp = catLvL3 + ':' +catLvL2 + ':' +catLvL1;
		//console.log('tmp',tmp);
		
        var PayorType = component.get('v.caseObj.Payor_Type__c');
		//console.log('PayorType: ',PayorType);
        component.set('v.caseObj.Payor_Type__c',PayorType);
        
        var PatientType = component.get('v.caseObj.Patient_Type__c');
		//console.log('PatientType: ',PatientType);
        component.set('v.caseObj.Patient_Type__c',PatientType);
        
        var Typeofpayment = component.get('v.caseObj.Type_of_payment__c');
		//console.log('Typeofpayment: ',Typeofpayment);
        component.set('v.caseObj.Type_of_payment__c',Typeofpayment);
        
        var Methodofpaymenttelemed = component.get('v.caseObj.Method_of_payment_telemed__c');
	//console.log('Methodofpaymenttelemed: ',Methodofpaymenttelemed);
        component.set('v.caseObj.Method_of_payment_telemed__c',Methodofpaymenttelemed);
		
                var channel = component.get('v.caseObj.Channel__c');
		//console.log('channel: ',channel);
		if (channel == 'Contact Center'){
			//console.log('mapSLACC[tmp]',mapslacc[tmp]);
			component.set('v.caseObj.SLA__c',mapslacc[tmp]);
			if (THTemplate == true){
				component.set('v.ServiceDetail',mapServiceDetailTH[tmp]);
			}else{
				component.set('v.ServiceDetail',mapServiceDetailEN[tmp]);
			}
		}else {
		component.set('v.caseObj.SLA__c', mapsla[tmp]);
		}
	},
	onChangeDoctor: function (component, event, helper) {
		var mapDoctor = component.get('v.MapDoctorAll');
		var doctorSelected = component.get('v.doctorNameValue').Id;

		var doctorSpecialty1 = mapDoctor[doctorSelected].Specialty__c;
		var doctorSpecialty2 = mapDoctor[doctorSelected].Specialty2__c;
		component.set('v.caseObj.Specialty_Doctor__c',doctorSpecialty1);
		component.set('v.caseObj.Specialty_Doctor2__c',doctorSpecialty2);

	},
	onChangeFlightNumber: function (component, event, helper) {
		//console.log('---- onChangeFlightNumber ----');
		var mapflight = component.get('v.FlightMap');
		var tmp = component.get('v.caseObj.Flight_Number__c');
		component.set('v.ArriveTimeList', mapflight[tmp]);
		component.set('v.caseObj.Arrival_Time__c','');
		// if(mapflight[tmp].length == 1){
		// 	component.set('v.caseObj.Arrival_Time__c', mapflight[tmp][1].value);
		// }else{
		// 	component.set('v.caseObj.Arrival_Time__c', mapmethod[tmp][mapflight[tmp].length].value);
		// }
		
		
	},
	onChangePaymentMethod: function (component, event, helper) {
		//console.log('---- onChangePaymentMethod ----');
		var mapmethod = component.get('v.PaymentMap');
		var tmp = component.get('v.caseObj.Method_Of_Payment__c');
		component.set('v.SegmentList', mapmethod[tmp]);
		component.set('v.caseObj.Segment__c', mapmethod[tmp][0].value);
		
	},
	hideModal: function (component, event, helper) {
		helper.hideModal(component, event, helper);
	},
	showModal: function (component, event, helper) {
		helper.showModal(component, event, helper);
	},
	onChangePendingTeam: function (component, event, helper) {
		var value = event.getSource().get("v.value");
		if (value != '') {
			component.set('v.pending_team_reason_disableField', false);
		} else {
			component.set('v.pending_team_reason_disableField', true);
			component.set('v.caseObj.Pending_Reason__c', '');
		}
		// //console.log(SubTaskMap[Main_Task__c]);
	},
	onChangeStatus: function (component, event, helper) {
		var value = event.getSource().get("v.value");
		if (value == 'Closed') {
			if (component.get('v.isContactCenter')){
				//console.log('---Close Case CC---');
				
				component.set('v.caseObj.Close_Case_Reason__c','Completed by myself');
				//console.log('close case reason: ',component.get('v.caseObj.Close_Case_Reason__c'));
				
			}
			component.set('v.close_case_reason_disableField', false);
			
		} else {
			component.set('v.close_case_reason_disableField', true);
			component.set('v.caseObj.Close_Case_Reason__c', '');
		}
		// //console.log(SubTaskMap[Main_Task__c]);
	},
	onChangePendingReason: function (component, event, helper) {
		var value = event.getSource().get("v.value");
		if (value != 'N/A' && value != undefined) {
			component.set('v.caseObj.Status', 'Pending');
		}
	},
	onClickWalkIn: function (component, event, helper) {
		var value = event.getSource().get("v.value");
		var originSubject = component.get('v.caseObj.Subject');
		var defaultReqBy = $A.get("{!$Label.c.Walk_In_Subject_Default}");
		var defaultSubjAirportStr = '['+defaultReqBy+']';
		var defaultCat1Airport = $A.get("{!$Label.c.Walk_In_Cat1_Default}");
		var defaultCat2Airport = $A.get("{!$Label.c.Walk_In_Cat2_Default}");
		var defaultCat3Airport = $A.get("{!$Label.c.Walk_In_Cat3_Default}");

		var dateTimeNow = new Date().toISOString();

		//console.log('originSubject'+originSubject);
		//console.log('value'+value);

		//Default Category
		if (value == true){
			var sub = component.get('v.MapCaseCateLVL_2');
			component.set('v.CaseCateLVL_2_disableField', false);
			component.set('v.CaseCateLVL_2', sub[defaultCat1Airport]);

			component.set('v.caseObj.Request_By__c', defaultReqBy);
			component.set('v.caseObj.Case_Category_Level1__c', defaultCat1Airport);
			setTimeout(() => {
				component.set('v.caseObj.Case_Category_Level2__c', defaultCat2Airport);
				component.set('v.caseObj.Arrival_Date__c', dateTimeNow);
				component.set('v.caseObj.Check_In_Date__c', dateTimeNow);
			}, 100);

			var sub3 = component.get('v.MapCaseCateLVL_3');
			component.set('v.CaseCateLVL_3', sub3[defaultCat2Airport + ':' + defaultCat1Airport]);
			
			setTimeout(() => {
				component.set('v.caseObj.Case_Category_Level3__c', defaultCat3Airport);
			}, 100);

		}

		//Default Subject
		if (value == true && (originSubject==undefined || originSubject=='')) {
			component.set('v.caseObj.Subject', defaultSubjAirportStr);
		}else if(!originSubject.includes(defaultSubjAirportStr) && value== true){
			component.set('v.caseObj.Subject', defaultSubjAirportStr+originSubject);
		}else if(originSubject.includes(defaultSubjAirportStr) && value== false){
			originSubject = originSubject.replace(defaultSubjAirportStr, '');
			component.set('v.caseObj.Subject', originSubject);
		}else{
			component.set('v.caseObj.Subject', originSubject);
		}

	},
	onCancel: function (component, event, helper) {
		helper.closeFocusedTab(component, event, helper);
	},

	onSave: function (component, event, helper) {
		//console.log('===onSave===');
		var validate = helper.validateField(component, event, helper);
		//console.log('====Validation Passed====');
		
		// component.get('v.caseOwnerValue').Id;
		// component.get('v.patientNameValue').Id;
		// component.get('v.senderNameValue').Id;
		if (validate) {
			//helper.startSpinner(component);
			var catLvL1 = component.get('v.caseObj.Case_Category_Level1__c');
			var catLvL2 = component.get('v.caseObj.Case_Category_Level2__c');
			var catLvL3 = component.get('v.caseObj.Case_Category_Level3__c');
			if (catLvL1 != '' && catLvL1 != undefined){
				catLvL1 = catLvL1.split(":");
				catLvL1 = catLvL1[0].trimEnd();
			}
			if (catLvL2 != '' && catLvL2 != undefined){
				catLvL2 = catLvL2.split(":");
				catLvL2 = catLvL2[0].trimEnd();

			}
			if (catLvL3 != '' && catLvL3 != undefined){
				catLvL3 = catLvL3.split(":");
				catLvL3 = catLvL3[0].trimEnd();
			}
			
			//console.log('catLvL1: ',catLvL1);
			//console.log('catLvL2: ',catLvL2);
			//console.log('catLvL3: ',catLvL3);
			
			component.set('v.caseObj.Case_Category_Level1__c',catLvL1);
			component.set('v.caseObj.Case_Category_Level2__c',catLvL2);
			component.set('v.caseObj.Case_Category_Level3__c',catLvL3);
			// //console.log('validate : true');

			component.set('v.caseObj.OwnerId', component.get('v.caseOwnerValue').Id);
            component.set('v.caseObj.Staff_Name__c', component.get('v.caseStaffValue').Id);
			// //console.log(component.get('v.patientNameValue'));

			if (component.get('v.patientNameValue') !== undefined && component.get('v.patientNameValue') !== null) {
				component.set('v.caseObj.Patient__c', component.get('v.patientNameValue').Id);
			} else {
				component.set('v.caseObj.Patient__c', '');
			}
			// //console.log('senderNameValue ', component.get('v.senderNameValue'));
			if (component.get('v.senderNameValue') !== undefined && component.get('v.senderNameValue') !== null) {
				component.set('v.caseObj.AccountId', component.get('v.senderNameValue').Id);
			} else {
				component.set('v.caseObj.AccountId', '');
			}
			if (component.get('v.doctorNameValue') !== undefined && component.get('v.doctorNameValue') !== null) {
				component.set('v.caseObj.Doctor__c', component.get('v.doctorNameValue').Id);
			} else {
				component.set('v.caseObj.Doctor__c', '');
			}
			if (component.get('v.personReasonNameValue') !== undefined && component.get('v.personReasonNameValue') !== null) {
				component.set('v.caseObj.Pending_Person__c', component.get('v.personReasonNameValue').Id);
			} else {
				component.set('v.caseObj.Pending_Person__c', '');
			}
			//console.log('Checking 1');
			
			component.set('v.caseObj.Check_In_Time__c', component.get('v.checkInTime'));
			component.set('v.caseObj.Check_Out_Time__c', component.get('v.checkOutTime'));



			// //console.log(component.get('v.caseObj.AccountId'));

			// //console.log(component.get('v.caseObj'));
			var caseObj = component.get('v.caseObj');
			//console.log('Checking 2');
			//console.log(JSON.parse(JSON.stringify(component.get('v.caseObj'))));

			// //console.log('arrive time '+component.get('v.caseObj.Arrival_Time__c'));
			var patientObj = component.get('v.patientObj');
			var senderObj = component.get('v.senderObj');
			var action = component.get("c.UpdateCaseRecord");
			action.setParams({
				"caseObj": caseObj,
				"patientObj": patientObj,
				"senderObj": senderObj,
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				//console.log('state on save :' ,state);
				
				if (state === "SUCCESS") {
					var getReturnValue = response.getReturnValue();

					// //console.log('==== isNew ====');
					var isNew = component.get("v.recordId");
					// //console.log(isNew);
					//console.log(getReturnValue);

					// //console.log('==== isNew ====');
					component.set('v.isDisabledField', true);
					// //console.log('success'); 
					helper.displayToast(component, "Success", "This case is saved");
					helper.refreshFocusedTab(component, event, helper);
					if (isNew === undefined || isNew == undefined || isNew == null || isNew == '') {
						helper.openTabWithSubtab(component, event, helper, getReturnValue.Id);
					}
					helper.closeFocusedTab(component, event, helper);

					// callback(getReturnValue);
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						//console.log('error');

						if (errors[0] && errors[0].message) {
							// //console.log("Error message: " +
							// 	errors[0].message);
							//console.log(helper.parseObj(errors));

							//console.log("Error message: " +
//errors[0].message);
							var errorMsg = errors[0].message;
							var tmpIndex_1 = errorMsg.indexOf(",");
							var tmpIndex_2 = errorMsg.indexOf(":", tmpIndex_1);
							errorMsg = errorMsg.substring(tmpIndex_1 + 1, tmpIndex_2);
							helper.displayToast(component, "Error", errorMsg);
						}
					} else {
						//console.log("Unknown error");
					}
				}
				
				//helper.stopSpinner(component);
			});
			$A.enqueueAction(action);
		} else {

		}
	},
	accountEvt: function (component, event, helper) {
		// //console.log('accountEvt');
		helper.hideModal(component, event, helper);
		// var LastIndex = component.get("v.rowIndexLastPick");
		var accObj = event.getParam("account");
		//console.log(JSON.parse(JSON.stringify(accObj)));


		var caseObj = component.get("v.caseObj");
        caseObj.Hospital_Number_HN__c = accObj.Hospital_Number_HN__c;
		caseObj.Full_Name__c = accObj.Name;
		caseObj.Date_of_Birth__c = accObj.PersonBirthdate;
		caseObj.Patient__c = accObj.Id;
		caseObj.Patient_Email__c = accObj.PersonEmail;
		caseObj.Verified_Patient__c = true;
		caseObj.Gender__c = accObj.Gender__c;
		caseObj.Phone__c = accObj.Phone;
		caseObj.Nationality__c = accObj.Nationality__c;
		caseObj.Country_of_Residence__c = accObj.Country_of_Residence__c;
        component.set("v.caseObj", caseObj);
        component.set('v.patientNameValue', accObj);
        helper.getCampaignList(component, event, helper);
		// component.set('v.senderNameValue', accObj);
	},
	handleChangeAirportRep: function (component, event, helper) {
		// This will contain an array of the "value" attribute of the selected options
		var caseObj = component.get("v.caseObj");
		var selectedOptionValue = event.getParam("value");
		caseObj.Airport_Rep_Name__c = selectedOptionValue;
		component.set("v.caseObj", caseObj);
	},
	handleSelect: function (component, event, helper) {
		// This will contain the index (position) of the selected lightning:menuItem
		var selectedMenuItemValue = event.getParam("value");
		// //console.log('selectedMenuItemValue :', selectedMenuItemValue);

		helper.ohandleSelect(component, event, selectedMenuItemValue);
	},
	// onChangeDoctor: function (component, event, helper) {
	// 	var doctorNameValue = component.set('v.patientNameValue', doctorNameValue);
	// 	if (doctorNameValue != null && doctorNameValue != undefined){
	// 		component.set('v.hasDoctor', true);
	// 	}else{
	// 		component.set('v.hasDoctor', true);
	// 	}
	// }
	onChangeEscalate : function (component, event, helper) {
        var value = event.getSource().get("v.value");
        
        // //console.log(JSON.parse(JSON.stringify(component.get('v.caseObj.Escalate_Date__c'))));
        var datenow = new Date();
        //var dateFormat =  datenow.getUTCFullYear()+'-'+datenow.getUTCMonth().toString().padStart(2,'0')+'-'+datenow.getUTCDate().toString().padStart(2,'0')+'T'+datenow.getUTCHours().toString().padStart(2,'0')+':'+datenow.getUTCMinutes().toString().padStart(2,'0')+':'+datenow.getUTCSeconds().toString().padStart(2,'0')+'.'+datenow.getUTCMilliseconds().toString().padStart(2,'0')+'Z';
         var dateFormat =  (new Date()).toISOString();
        // //console.log('dateFormat : '+dateFormat);
        
        if (value != '' && value !=  undefined && value != null) {
            
            component.set('v.isRequiredEscalateDate',true);
            //console.log('dateFormat : '+dateFormat);
             component.set('v.caseObj.Escalate_Date__c',dateFormat);
        }else{
            component.set('v.isRequiredEscalateDate',false);
            component.set('v.caseObj.Escalate_Date__c','');
        }
    },
        onChangeAddCampaignCheckBox : function (component, event, helper) {
        // var value = event.getSource().get("v.value");
        var checkCmp = component.find("add_campaign");
        var value = checkCmp.get("v.checked");
        //console.log('value : ',value);
        component.set('v.isShowCampaignDetail',value);
        helper.getCampaignList(component, event, helper);
        if(!value){
            component.set('v.caseObj.Campaign_Master__c','');
            component.set('v.caseObj.Campaign_Interest_Type__c','');
            component.set('v.campaignMasterObj','');
        }
    },
    onChangeCampaignName : function (component, event, helper) {
        component.set('v.caseObj.Campaign_Interest_Type__c','');
        var camMaster = component.get('v.caseObj').Campaign_Master__c;
        if(camMaster != null && camMaster != undefined && camMaster != ''){
            helper.getCampaignDetail(component, event, helper);
        }else{
            component.set('v.campaignMasterObj','');
        }
    }
})