import { LightningElement, track } from 'lwc';
import getAccountDetailsByTime from '@salesforce/apex/TC_BookAppointmentCtrl.getAccountDetailsByTime';

export default class PopupDialog extends LightningElement {
    @track hovered = false;
    @track accountName;
    @track accountHN;
    @track popoverPosition = { top: 0, left: 0 }; // Track the position of the popover
    @track timeslots = [
        '08:00', '08:15', '08:30', '08:45', '09:00', '09:15', '09:30', '09:45', '10:00',
        '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00', '12:15', '12:30',
        '12:45', '13:00', '13:15', '13:30', '13:45', '14:00', '14:15', '14:30', '14:45',
        '15:00', '15:15', '15:30', '15:45', '16:00', '16:15', '16:30', '16:45'
    ];

    handleMouseOver(event) {
        const selectedTime = event.target.textContent.trim();
        const boundingRect = event.target.getBoundingClientRect();

        // Set popover position dynamically based on the time slot's bounding rectangle
        this.popoverPosition = {
            top: boundingRect.top - 120,  // Adjust to control the height (display the popover above the slot)
            left: boundingRect.left + boundingRect.width / 2  // Center horizontally over the time slot
        };

        getAccountDetailsByTime({ selectedTime })
            .then(result => {
                if (result) {
                    this.accountName = result.Name;
                    this.accountHN = result.Hospital_Number_HN__c;
                    this.hovered = true; // Show the popover
                } else {
                    console.log('No account found for the selected time.');
                    this.hovered = false; // Hide the popover if no data
                }
            })
            .catch(error => {
                console.error('Error fetching account details', error);
            });
    }

    handleMouseOut() {
        this.hovered = false; // Hide the popover when the mouse leaves
    }
}