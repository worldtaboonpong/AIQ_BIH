import { LightningElement, track, api } from 'lwc';
import searchDoctors from '@salesforce/apex/DoctorSearchController.searchDoctors';
import getSpecialtyOptions from '@salesforce/apex/DoctorSearchController.getSpecialtyOptions';

export default class DoctorSearch extends LightningElement {
  @track startDateTime;
  @track endDateTime;
  @track selectedSpecialty;
  @track specialtyOptions = [];
  @track doctorOptions = [];
  @track selectedDoctors = [];
  @track doctors = [];

  connectedCallback() {
    this.loadSpecialtyOptions();
  }

  loadSpecialtyOptions() {
    getSpecialtyOptions().then(result => {
      this.specialtyOptions = result.map(option => ({ label: option, value: option }));
    });
  }

  handleStartDateChange(event) {
    this.startDateTime = event.target.value;
  }

  handleEndDateChange(event) {
    this.endDateTime = event.target.value;
  }

  handleSpecialtyChange(event) {
    this.selectedSpecialty = event.target.value;
  }

  handleSearch() {
    searchDoctors({ 
      startDateTime: this.startDateTime, 
      endDateTime: this.endDateTime, 
      specialty: this.selectedSpecialty 
    }).then(result => {
      this.doctors = result;
      this.doctorOptions = result.map(doctor => ({ label: doctor.Name, value: doctor.Id }));
    });
  }

  handleDoctorSelect(event) {
    this.selectedDoctors = event.detail.value;
    // Dispatch an event to notify other components or flows
    const selectedDoctorsEvent = new CustomEvent('doctorsselected', { detail: this.selectedDoctors });
    this.dispatchEvent(selectedDoctorsEvent);
  }
}