({
    handleSlotClick: function (component, event, helper) {
        var selectedTime = event.currentTarget.dataset.time;
        var timeSlots = component.get("v.timeSlots");

        // Mark the selected slot and unselect others
        timeSlots.forEach(function (slot) {
            slot.selected = (slot.time === selectedTime);
        });

        component.set("v.timeSlots", timeSlots);
        component.set("v.selectedTime", selectedTime);
    },

    handleReviewClick: function (component, event, helper) {
        var selectedTime = component.get("v.selectedTime");
        if (selectedTime) {
            // Send selected time to Apex for review handling
            var action = component.get("c.reviewTimeSlot");
            action.setParams({ selectedTime: selectedTime });
            $A.enqueueAction(action);
        } else {
            alert("Please select a time slot.");
        }
    },

    // Fetch data when the component is initialized
    doInit: function (component, event, helper) {
        var action = component.get("c.getSessionDetails");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var sessionData = response.getReturnValue();
                component.set("v.timeSlots", sessionData.timeSlots);
                component.set("v.patientInfo", sessionData.patientInfo);
                component.set("v.sessionDetails", sessionData.sessionDetails);
            }
        });
        $A.enqueueAction(action);
    }
})