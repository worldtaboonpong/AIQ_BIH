({
	doInit : function(component, event, helper) {
		// component.set("v.selectedCase", '500N000000DAkKGIA1');
		var pageReference = component.get("v.pageReference");
		var c__selectedCase = pageReference.state.c__selectedCase;
		component.set("v.selectedCase", c__selectedCase);
		var caseId = component.get("v.selectedCase");
		var action = component.get("c.getInvitationLetterWrapper");
		console.log('caseId : ', caseId);
		helper.startSpinner(component);
		action.setParams({ "caseId": caseId });
		action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var returnValues = response.getReturnValue();
					component.set('v.countryPicklist', returnValues.InvitationLetterObjectPickListValue.LetterCountry__c);
					component.set('v.embassyPicklist', returnValues.InvitationLetterObjectPickListValue.LetterEmbassyType__c);
					component.set('v.specialtyPicklist', returnValues.CaseObjectPickListValue.Specialty_Doctor__c);
					setTimeout(() => {
						console.log('returnValues : ', returnValues);
						component.set('v.caseObj',returnValues.caseObj);
						component.set('v.letterObj', returnValues.letterObj);
						if (returnValues.letterPersonTypeAttendantObj.length > 0){
							component.set('v.letterPersonTypeAttendantObj', returnValues.letterPersonTypeAttendantObj);
						}
						if (returnValues.letterPersonTypePatientObj.length > 0) {
							component.set('v.letterPersonTypePatientObj', returnValues.letterPersonTypePatientObj);
						}
						if (returnValues.letterObj.LetterTo__c == 'Other Country'){
							component.set('v.isOtherCountry', true);
						}
					
						
					}, 100);
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log(errors);

							// console.log("Error message: " +
							//     errors[0].message);
							// helper.displayToast(component, "Error", errors[0].message);
						}
					} else {
						console.log("Unknown error");
					}
					reject(Error('Invalid value: Task Object'))
				}
			helper.stopSpinner(component);
			});
		$A.enqueueAction(action);
	},
	onSaveAndGenerate: function (component, event, helper) {
		console.log('save generate');
		
		helper.startSpinner(component);
		var actionPromise = new Promise(function (resolve, reject) {
			var action = component.get("c.saveInvitationLetterWrapper");
			console.log('ketter : ',component.get('v.letterObj'));
			
			var wrapper = {
				'letterObj': component.get('v.letterObj'),
				'letterPersonTypePatientObj': component.get('v.letterPersonTypePatientObj'),
				'letterPersonTypeAttendantObj': component.get('v.letterPersonTypeAttendantObj'),
				'caseObj': component.get('v.caseObj'),
				'personListForDelete': component.get('v.personListForDelete'),
			}
			action.setParams({
				"wrapper": wrapper
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					console.log('SUCCESS');
					var returnValues = response.getReturnValue();
					console.log(returnValues);
					
					var workspaceAPI = component.find("workspace");
					
					workspaceAPI.getFocusedTabInfo().then(function (response) {
						var focusedTabId = response.tabId;
						var focusedParentTabId = response.parentTabId;
						console.log('focusedParentTabId :', focusedParentTabId);
						workspaceAPI.openSubtab({
							parentTabId: focusedParentTabId,
							url: '/apex/GeneratePDFInvitation?Id=' + returnValues.Id + '&isCopy=false',
							focus: true
						}).then(function (res2) {
							console.log('subtab id : ',res2);
							workspaceAPI.setTabLabel({
								tabId: res2,
								label: "Invitation Letter"
							});
							workspaceAPI.setTabIcon({
								tabId: res2,
								icon: "standard:file",
								iconAlt: "PDF"
							});
							workspaceAPI.closeTab({ tabId: focusedTabId });
						});
					});
					resolve(returnValues);
					
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log(errors);

							console.log("Error message: " +
							    errors[0].message);
							// helper.displayToast(component, "Error", errors[0].message);
						}
					} else {
						console.log("Unknown error");
					}
					reject(Error('Invalid value: Task Object'))
				}
				// helper.stopSpinner(component);
			});
			$A.enqueueAction(action);
		});
		
		
		actionPromise.then(
			function (returnValues) {
				console.log(component.get('v.caseObj').Id);
				var act = component.get("c.createInvitaionLetterToPDF");
				act.setParams({
					"caseId": component.get('v.caseObj').Id,
				});
				act.setCallback(this, function (response) {
					var state = response.getState();
					if (state === "SUCCESS") {
						console.log('--- after open pdf ---');
						console.log(response.getReturnValue());
						component.getEvent("oSaveAndGenerate").setParams({ "isSuccess": true }).fire();

					} else if (state === "ERROR") {
						var errors = response.getError();
						if (errors) {
							if (errors[0] && errors[0].message) {
								console.log(errors);

								console.log("Error message: " +
								    errors[0].message);
								// helper.displayToast(component, "Error", errors[0].message);
							}
						} else {
							console.log("Unknown error");
						}
						reject(Error('Invalid value: Task Object'))
					}
					helper.stopSpinner(component);
				});
				$A.enqueueAction(act);
			}
		);





		
	},
	onChangeLetterTo: function (component, event, helper) {
		var letObj = component.get('v.letterObj');
		if (letObj.LetterTo__c == 'Other Country'){
			component.set('v.isOtherCountry', true);
			letObj.LetterCountryText__c = '';
		}else{
			component.set('v.isOtherCountry', false);
			component.set('v.letterObj', letObj);
		}
		console.log(letObj.LetterCountryText__c);
		
	}
})