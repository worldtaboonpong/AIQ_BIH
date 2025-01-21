({
    // Handle search and filter the options
    handleSearch: function(component, event, helper) {
        var searchTerm = component.get("v.searchTerm").toLowerCase();
        var allOptions = component.get("v.picklistOptions");
        var filteredOptions = allOptions.filter(function(option) {
            return option.label.toLowerCase().includes(searchTerm);
        });

        component.set("v.filteredOptions", filteredOptions);
        
        // Show the dropdown if there are matching options
        if (filteredOptions.length > 0) {
            component.set("v.showDropdown", true);
        } else {
            component.set("v.showDropdown", false);
        }
    },

    // Handle selection of a dropdown option
    handleSelect: function(component, event, helper) {
        var labelVar = component.get('v.fieldId');
        var selectedValue = event.target.getAttribute("data-value");
        var allOptions = component.get("v.picklistOptions");
        var selectedLabel = allOptions.find(option => option.value === selectedValue).label;
		console.log(selectedLabel + ' >> ' + selectedValue);
        component.set("v.selectedValue", selectedValue);
        component.set("v.searchTerm", selectedLabel);  // Set the selected label in the input field
        
        var cmpEvent = component.getEvent("searchableCmpEvent");
        cmpEvent.setParams({"fieldLabel": labelVar, "selectedValue": selectedValue});
        cmpEvent.fire();
        
        component.set("v.showDropdown", false);  // Hide the dropdown
    },

    // Hide the dropdown when the input loses focus
    handleBlur: function(component, event, helper) {
        setTimeout(function() {
            component.set("v.showDropdown", false);
        }, 300);  // Delay hiding to allow selecting an option
    }
})