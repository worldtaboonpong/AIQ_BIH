import { LightningElement , wire} from 'lwc';
import { subscribe, MessageContext } from "lightning/messageService";
import DOCTOR_SCHEDULE_MESSAGE from "@salesforce/messageChannel/DoctorSchedule__c";

export default class DoctorList extends LightningElement {
	doctorList = [];

	@wire(MessageContext)
    messageContext;
    subscription = null;

	connectedCallback() {
        this.subscription = subscribe(this.messageContext, DataChannel, (message) => {
			if (message.type === 'doctorList'){
				this.doctorList = message.doctorList;
			}
        });
    }

	handleSelectDate(event){

	}
}