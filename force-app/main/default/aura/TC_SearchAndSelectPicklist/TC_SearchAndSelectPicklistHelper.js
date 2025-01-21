({
    /**
     * @description This method use to open list of available multiselect values
     * for by default selection and count for selected values.
     */
    doInitHelper: function(component) {
        $A.util.toggleClass(component.find('resultsDiv'), 'slds-is-open');
        var value = component.get('v.value');
        var values = component.get('v.values');
        if (!$A.util.isEmpty(value) || !$A.util.isEmpty(values)) {
            var searchString;
            var count = 0;
            var multiSelect = component.get('v.multiSelect');
            var options = component.get('v.options');
            options.forEach(function(element, index) {
                if (multiSelect) {
                    if (values.includes(element.value)) {
                        element.selected = true;
                        count++;
                    }
                } else {
                    if (element.value == value) {
                        searchString = element.label;
                    }
                }
            });
            if (multiSelect) {
                component.set('v.searchString', count + ' options selected');
            } else {
                component.set('v.searchString', searchString);
            }
            component.set('v.options', options);
        }
    },

    /**
     * @description This method use filter values as per search text
     */
    filterOptionsHelper: function(component) {
		try{
			component.set("v.message", '');
			var searchText = component.get('v.searchString').toLowerCase().trim();
			console.log('searchText: ' + searchText);
			var options = component.get("v.options");
			var minChar = 2;
			if (searchText.length >= minChar) {
				var flag = true;
				for (let i = 0; i < options.length; i++) {
					let label = options[i].label.toLowerCase().trim();
					if (label.includes(searchText)) {
						options[i].isVisible = true;
						flag = false;
					} else {
						options[i].isVisible = false;
					}
				}

				component.set("v.options", options);

				if (flag) {
					component.set("v.message", `No results found for '${searchText}'`);
				}
			}
			$A.util.addClass(component.find('resultsDiv'), 'slds-is-open');
		} catch (err) {
			console.log('error:' + err)
		}

    },
    /**
     * @description This method helps to add selected value, pill and send to event.
     */
    selectItemHelper: function(component, event, selectedItem) {
        // console.error('Sel Item: '+selectedItem);
        var labelVar = component.get('v.fieldId');
        var options = component.get('v.options');
        var multiSelect = component.get('v.multiSelect');
        var searchString = component.get('v.searchString');
        var values = component.get('v.values') || [];
        var value;
        var count = 0;

        options.forEach(function(element, index) {
            if (element.value === selectedItem) {
                if (multiSelect) {
                    if (values.includes(element.value)) {
                        values.splice(values.indexOf(element.value), 1);
                    } else {
                        values.push(element.value);
                    }
                    element.selected = element.selected ? false : true;
                } else {
                    value = element.value;
                    searchString = element.label;
                }
            }
            if (element.selected) {
                count++;
            }
        });
        component.set('v.value', value);
        component.set('v.values', values);
        component.set('v.options', options);

        if (multiSelect) {
            component.set('v.searchString', count + ' options selected');
        } else {
            component.set('v.searchString', searchString);
        }

        if (multiSelect) {
            event.preventDefault();
        } else {
            $A.util.removeClass(component.find('resultsDiv'), 'slds-is-open');
        }
		//console.log('---- '+value);
        //console.log('>>>> '+values);
        //if (multiSelect) {
        var cmpEvent = component.getEvent("cmpEvent");
        cmpEvent.setParams({"fieldLabel": labelVar, "selectedValue": value, "selectedValues": values});
        cmpEvent.fire();
        //}
    },

    /**
     * @description This method helps to remove selected value and pill.
     */
    /*removePillHelper: function(component, event) {
        var labelVar = component.get('v.fieldId');
        var value = event.getSource().get('v.name');
        var multiSelect = component.get('v.multiSelect');
        var count = 0;
        var options = component.get("v.options");
        var values = component.get('v.values') || [];
        options.forEach(function(element, index) {
            if (element.value === value) {
                element.selected = false;
                values.splice(values.indexOf(element.value), 1);
            }
            if (element.selected) {
                count++;
            }
        });

        if (multiSelect) {
            component.set('v.searchString', count + ' options selected');
        }
        component.set('v.values', values)
        component.set("v.options", options);

        //if (multiSelect) {
        var cmpEvent = component.getEvent("cmpEvent");
        cmpEvent.setParams({"fieldLabel": labelVar, "selectedValue": value, "selectedValues": values});
        cmpEvent.fire();
        //}
    },*/

    /**
     * @description This method help to close the dropdown if clicked outside the dropdown.
     */
    blurEventHelper: function(component, event) {
        $A.util.removeClass(component.find('resultsDiv'), 'slds-is-open');
    }
})