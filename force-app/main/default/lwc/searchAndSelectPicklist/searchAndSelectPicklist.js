import { LightningElement, api } from "lwc";

export default class SearchAndSelectPicklist extends LightningElement {
    @api multiSelect = false;
    @api label = "";
    @api fieldId = "";
    @api options = [];
    @api values = [];
    @api value = "";
    @api minChar = 1;
    @api disabled = false;
    isDropdownOpen = false;
    searchString = "";
    message = "";
    isSearching = false;
    isLoading = false;

    handleBlur() {
        this.isDropdownOpen = false;
    }

    showOptions() {
        if (!this.disabled) {
            this.message = ""; // Clear any existing messages
            this.searchString = ""; // Reset the search string
            // Set all options to visible
            this.options = this.options.map((option) => ({
                ...option,
                isVisible: true
            }));
            // Open the dropdown if options are not empty
            if (this.options && this.options.length > 0) {
                this.isDropdownOpen = true; // Set flag to open dropdown
            }
        }
    }

    filterOptions(event) {
        const searchString = event.target.value.toLowerCase().trim();
        this.searchString = searchString;
        if (searchString) {
            const minChar = 2;
            if (searchString.length >= minChar) {
                if (this.fieldId === "resourceId") {
                    // Debounced search with a timeout
                    if (!this.isSearching) {
                        this.isSearching = true;
                        this.isLoading = true;
                        setTimeout(() => {
                            this.filterOptionsHelper(searchString);
                            this.isSearching = false;
                            this.isLoading = false;
                        }, 2000);
                    }
                } else {
                    this.filterOptionsHelper(searchString);
                }
            } else {
                this.message = ""; // Clear any existing message
                this.isDropdownOpen = false;
            }
        } else {
            this.isDropdownOpen = false;
            this.message = "";
        }
    }

    filterOptionsHelper(searchText) {
        try {
            const filteredOptions = this.options.map((option) => {
                const label = option.label.toLowerCase().trim();
                if (label.includes(searchText)) {
                    return { ...option, isVisible: true };
                }
                return { ...option, isVisible: false };
            });
            this.options = filteredOptions;
            // Check if any options are visible
            const hasVisibleOptions = filteredOptions.some((option) => option.isVisible);
            if (!hasVisibleOptions) {
                this.message = `No results found for '${searchText}'`;
            } else {
                this.message = "";
            }
            this.isDropdownOpen = hasVisibleOptions;
        } catch (err) {
            console.error("Error in filterOptionsHelper:", err);
        }
    }

    selectItem(event) {
        const selectedItem = event.currentTarget.dataset.id; // Using `data-id` for the value
        if (selectedItem) {
            this.selectItemHelper(selectedItem);
        }
    }

    selectItemHelper(selectedItem) {
        let count = 0;
        let searchString = this.searchString;
        const values = [...this.values]; // Clone the array to ensure reactivity
        const options = this.options.map((option) => {
            if (option.value === selectedItem) {
                if (this.multiSelect) {
                    if (values.includes(option.value)) {
                        values.splice(values.indexOf(option.value), 1);
                    } else {
                        values.push(option.value);
                    }
                    option.selected = !option.selected;
                } else {
                    this.value = option.value;
                    searchString = option.label;
                }
            }
            if (option.selected) {
                count++;
            }
            return option; // Return updated option object
        });

        this.options = options;
        this.values = values;

        if (this.multiSelect) {
            this.searchString = `${count} options selected`;
        } else {
            this.searchString = searchString;
            this.isDropdownOpen = false; // Close the dropdown for single select
        }

        // Fire a custom event to pass the selected values to the parent
        const cmpEvent = new CustomEvent("selectitem", {
            detail: {
                fieldLabel: this.fieldId,
                selectedValue: this.value,
                selectedValues: this.values
            }
        });
        this.dispatchEvent(cmpEvent);
    }
}
