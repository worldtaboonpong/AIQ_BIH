/**
 * CHANGE LOG:
 * - (16 Jan 2025): init AppointmentTrigger instead of using Flow: Appointment: Send update to TrakCare
 */
trigger AppointmentTrigger on Appointment__c (after update) {
	AppointmentTriggerHandler handler = AppointmentTriggerHandler.getInstance();
    if (!handler.isTriggerActivated()) return;
    handler.setParams(Trigger.new, Trigger.oldMap);
    switch on Trigger.operationType {
        when AFTER_UPDATE {
            handler.executeAfterUpdate();
        }
    }
}