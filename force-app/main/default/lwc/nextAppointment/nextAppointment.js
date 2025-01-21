import { LightningElement, wire, track } from 'lwc';
import getNextUpcomingAppointment from '@salesforce/apex/AppointmentController.getNextUpcomingAppointment';

export default class NextAppointment extends LightningElement {
    @track appointment;
    @track error;
    accountName = 'Freddy Flintoff'; // This should be dynamically set

    @wire(getNextUpcomingAppointment, { accountName: '$accountName' })
    wiredAppointment({ data, error }) {
        if (data) {
            this.appointment = data;
        } else if (error) {
            this.error = error;
        }
    }
}