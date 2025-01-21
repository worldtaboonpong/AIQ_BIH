import { LightningElement, api, track } from 'lwc';
import getAvailableSessions from '@salesforce/apex/DoctorAvailabilityController.getAvailableSessions';

export default class DoctorAvailabilityComponent extends LightningElement {
    @api doctorIds = [];
    @api startDateTime;
    @api endDateTime;
    @track availableSessions = [];

    connectedCallback() {
        this.loadAvailableSessions();
    }

    loadAvailableSessions() {
        getAvailableSessions({ 
            doctorIds: this.doctorIds, 
            startDateTime: this.startDateTime, 
            endDateTime: this.endDateTime 
        })
        .then(result => {
            this.availableSessions = result;
        })
        .catch(error => {
            console.error('Error fetching available sessions', error);
        });
    }
}