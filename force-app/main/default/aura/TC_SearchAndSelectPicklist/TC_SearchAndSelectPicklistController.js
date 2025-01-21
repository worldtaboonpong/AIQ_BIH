({
    /**
     * @description This method helps to prepopulate the seleted value pill if value attribute is filled.
     */
    doInit: function(component, event, helper) {
        helper.doInitHelper(component);
    },

    /**
     * @description This method helps When a keyword is entered in search box.
     */
    filterOptions: function(component, event, helper) {
        if (!$A.util.isEmpty(component.get('v.searchString'))) {
			let fieldId = component.get('v.fieldId')
			if (fieldId === 'resourceId'){
				let isSearching = component.get('v.isSearching');
				console.log('isSearching: ' + isSearching)
				if (!isSearching){
					component.set('v.isSearching' , true)
					component.set('v.isLoading' , true)
					window.setTimeout(
						$A.getCallback(function() {
							helper.filterOptionsHelper(component);
							component.set('v.isSearching' , false)
							component.set('v.isLoading' , false)
						}), 2000
					)
				}
			} else {
				helper.filterOptionsHelper(component);
			}

        } else {
            $A.util.removeClass(component.find('resultsDiv'), 'slds-is-open');
        }
    },

    /**
     * @description This method helps When an item is selected.
     */
    selectItem: function(component, event, helper) {
        var selectedItem = event.currentTarget.id
        //if (!$A.util.isEmpty(selectedItem)) {
            helper.selectItemHelper(component, event, selectedItem);
        //}
    },

    /**
     * @description This method helps to add picklist value when new text entered.
     */
    /*doOnCommit: function(component, event, helper) {
        var searchText = component.get("v.searchString");
        var options = component.get('v.options');
        options.push({label: searchText, value: searchText});
        component.set('v.options', options);
        helper.selectItemHelper(component, event, searchText);
    },*/

    /**
     * @description This method helps to show available options for picklist.
     */
    showOptions: function(component, event, helper) {
        var disabled = component.get("v.disabled");
        if (!disabled) {
            component.set("v.message", '');
            component.set('v.searchString', '');
            var options = component.get("v.options");
            options.forEach(function(element, index) {
                element.isVisible = true;
            });
            component.set("v.options", options);
            if (!$A.util.isEmpty(component.get('v.options'))) {
                $A.util.addClass(component.find('resultsDiv'), 'slds-is-open');
            }
        }
    },

    /**
     * @description This method helps to remove the selected item.
     */
    /*removePill: function(component, event, helper) {
        helper.removePillHelper(component, event);
    },*/

    /**
     * @description This method to close the dropdown if clicked outside the dropdown.
     */
    blurEvent: function(component, event, helper) {
        helper.blurEventHelper(component, event);
    },
})