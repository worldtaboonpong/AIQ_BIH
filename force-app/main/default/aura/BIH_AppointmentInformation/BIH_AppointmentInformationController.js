({
	init: function (component, event, helper) {
		component.set('v.columns', [
			{
				label: 'Date/Time', fieldName: 'appointmentDateTime', type: 'date',
					typeAttributes: {
						// year: 'numeric',
						// month: 'numeric',
						// day: 'numeric',
						hour: '2-digit',
						minute: '2-digit'
					} 
			},
			{ label: 'Visit Type', fieldName: 'visitTypeString', type: 'text' },
			{ label: 'Appointment Status', fieldName: 'appointmentStatusString', type: 'Text' },
			{ label: 'Doctor', fieldName: 'doctorName', type: 'text'},
			{ label: 'Location', fieldName: 'locationName', type: 'text' },
			{ label: 'Service ', fieldName: '', type: 'text' },
			{ label: 'Remark', fieldName: 'note', type: 'Text' },
			{ label: 'Update User', fieldName: '', type: 'Text' }
		]);
		helper.startSpinner(component);
		var recordId = component.get('v.recordId');

		var actionPromise = new Promise(function (resolve, reject) {
			var act = component.get("c.getAccount");
			act.setParams({
				"accountId": recordId,
			});
			act.setCallback(this, function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var res = response.getReturnValue();
					// console.log(JSON.stringify(response.getReturnValue()));
					component.set("v.accObj", response.getReturnValue());

					resolve(res);
				}
			});
			$A.enqueueAction(act);
		});
		actionPromise.then(
			function (res) {
				var action = component.get("c.getAppointmentInformation");
				action.setParams({
					"hnNumber": res.Hospital_Number_HN__c,
				});
				action.setCallback(this, function (response) {
					var state = response.getState();
					if (state === "SUCCESS") {
						// console.log(JSON.stringify(response.getReturnValue()));

						component.set("v.data", response.getReturnValue());
						// response.getReturnValue().forEach(function (item, index) {
						// 	console.dir(item.doctorName);

						// });
						helper.sortData(component, 'visitDateTime','desc');
						var maptmp = JSON.parse(JSON.stringify(component.get("v.data")));
						var tmp = {};
						var tmpArray = [];
						// console.log(maptmp);
						var activeSections = component.get('v.activeSections');
						maptmp.forEach(element => {
							// console.log(element.appointmentDateTime.slice(0, 10), ' : ', tmp[element.appointmentDateTime.slice(0, 10)]);
							if (tmp[element.appointmentDateTime.slice(0, 10)] == undefined){
								tmp[element.appointmentDateTime.slice(0, 10)] = [];
								activeSections.push(element.appointmentDateTime.slice(0, 10));
							}
							tmp[element.appointmentDateTime.slice(0, 10)].push(element);

						});
						// console.log('activeSections',activeSections);
						
						for (var t in tmp) {
							var tmpdate = new Date(t);
							var tmpApp = helper.sortDataDateTImeMap(tmp[t], 'appointmentDateTime', 'desc');
							tmpArray.push({
								'date' : t,
								'appointment': tmpApp,
								'dateString': tmpdate.toLocaleDateString('en-GB', {
									day: 'numeric', month: 'short', year: 'numeric'
								}).replace(/ /g, '-'),
							});
						}
						// tmpArray.push({
						// 	'date': '2019-04-10',
						// 	'appointment': null,
						// });
						// tmpArray.push({
						// 	'date': '2018-01-10',
						// 	'appointment': null,
						// });
						// tmpArray.push({
						// 	'date': '2019-05-12',
						// 	'appointment': null,
						// });
						// console.log(tmpArray);
						component.set("v.dataMapDate", tmpArray);
						// console.log(component.get("v.dataMapDate"));
						helper.sortDataMap(component, 'date','desc');
						// console.log('---after sort---');
						// console.log(component.get("v.dataMapDate"));
						setTimeout(() => {
							component.set('v.activeSections', activeSections);
						}, 100);

						// console.log(tmp);
						
						// helper.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
					}
					helper.stopSpinner(component);
				});
				$A.enqueueAction(action);
			});

	},

	updateColumnSorting: function (cmp, event, helper) {
		var fieldName = event.getParam('fieldName');
		var sortDirection = event.getParam('sortDirection');
		cmp.set("v.sortedBy", fieldName);
		cmp.set("v.sortedDirection", sortDirection);
		helper.sortData(cmp, fieldName, sortDirection);
	},
	changeState: function changeState(component) {
		component.set('v.isexpanded', !component.get('v.isexpanded'));
	}, 
	handleSectionToggle: function (cmp, event) {
		var openSections = event.getParam('openSections');

		if (openSections.length === 0) {
			cmp.set('v.activeSectionsMessage', "All sections are closed");
		} else {
			cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
		}
	}
})