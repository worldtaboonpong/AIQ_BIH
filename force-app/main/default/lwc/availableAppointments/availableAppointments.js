import { LightningElement, track, wire } from 'lwc';
import getAvailableAppointments from '@salesforce/apex/AppointmentController.getAvailableAppointments';

const columns = [
    { label: 'Start Time', fieldName: 'StartTime', type: 'text', typeAttributes: { hour24: true } },
    { label: 'End Time', fieldName: 'EndTime', type: 'text', typeAttributes: { hour24: true } },
    { label: 'Status', fieldName: 'Status', type: 'text' },
];

export default class AvailableAppointments extends LightningElement {
    @track appointments;
    columns = columns;

    @wire(getAvailableAppointments)
    wiredAppointments({ error, data }) {
        if (data) {
            this.appointments = data.map(appointment => ({
                id: appointment.Id,
                StartTime: appointment.Start_Time__c,
                EndTime: appointment.End_Time__c,
                Status: appointment.Appointment_Status__c
            }));
        } else if (error) {
            console.error(error);
        }
    }
}