public class TimeSlotController {
    @AuraEnabled
    public static Map<String, Object> getSessionDetails() {
        // Simulated session details
        Map<String, Object> sessionInfo = new Map<String, Object>();
        sessionInfo.put('start', '08:00');
        sessionInfo.put('end', '19:00');
        sessionInfo.put('description', 'For standby queue and same-day appointments.');

        // Patient information
        Map<String, Object> patientInfo = new Map<String, Object>();
        patientInfo.put('name', 'Mr. Freddy Flintoff');
        patientInfo.put('hn', '800329482');

        // Time slots logic (available and selected simulation)
        List<Map<String, Object>> timeSlots = new List<Map<String, Object>>();
        for (Integer i = 8; i <= 19; i++) {
            for (Integer j = 0; j <= 45; j += 15) {
                Map<String, Object> slot = new Map<String, Object>();
                String slotTime = String.valueOf(i) + ':' + (j == 0 ? '00' : String.valueOf(j));
                slot.put('time', slotTime);
                slot.put('available', true);  // Simulate that all slots are available
                slot.put('selected', false);
                timeSlots.add(slot);
            }
        }

        // Add data to the sessionInfo map
        sessionInfo.put('timeSlots', timeSlots);
        sessionInfo.put('patientInfo', patientInfo);

        return sessionInfo;
    }

    @AuraEnabled
    public static void reviewTimeSlot(String selectedTime) {
        // Logic to handle the review of the selected time slot (e.g., booking)
        System.debug('Selected Time: ' + selectedTime);
    }
}