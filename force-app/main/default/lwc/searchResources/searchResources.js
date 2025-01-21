import { LightningElement, api, wire } from "lwc";
import { publish, MessageContext } from "lightning/messageService";
import DOCTOR_SCHEDULE_MESSAGE from "@salesforce/messageChannel/DoctorSchedule__c";
import getBookingDetails from "@salesforce/apex.TC_BookAppointmentCtrl.getBookingDetails";
import findDoctorAndSchedules from "@salesforce/apex.TC_BookAppointmentCtrl.findDoctorAndSchedules";

export default class SearchResources extends LightningElement {
    @wire(MessageContext)
    messageContext;

    selHospital = "BH";
    selLocation = "";
    selSpecialty = "";
    selSubSpecialty = "";
    selResource = "";
    hospitals = [];
    locations = [];
    specialties = [];
    subSpecialties = [];
    resources = [];

    connectedCallback() {
        this.fetchBookingDetails();
    }

    fetchBookingDetails() {
        getBookingDetails({
            selHospital: this.selHospital,
            selLocation: this.selLocation,
            selSpecialty: this.selSpecialty,
            selSubSpecialty: this.selSubSpecialty,
            selResource: this.selResource,
            selDate: null,
            selStartTime: null,
            selEndTime: null
        })
            .then((result) => {
                // Map the returned values to the component's properties
                this.hospitals = result.Hospitals || [];
                this.locations = result.Locations || [];
                this.specialties = result.Specialties || [];
                this.subSpecialties = result.SubSpecialties || [];
                this.resources = result.Resources || [];
            })
            .catch((error) => {
                console.error("Error fetching booking details:", error);
            });
    }

    handleHospitalChange(event) {
        this.selHospital = event.detail.value;
        this.resetDependentFields(["selLocation", "selSpecialty", "selSubSpecialty", "selResource"]);
        this.fetchBookingDetails();
    }

    handleLocationChange(event) {
        this.selLocation = event.detail.value;
        this.resetDependentFields(["selSpecialty", "selSubSpecialty", "selResource"]);
        this.fetchBookingDetails();
    }

    handleSpecialtyChange(event) {
        if (event.detail.fieldLabel === "selSpecialtyId") {
            this.selSpecialty = event.detail.selectedValue;
            this.resetDependentFields(["selSubSpecialty", "selResource"]);
            this.fetchBookingDetails();
        }
    }

    handleSubSpecialtyChange(event) {
        if (event.detail.fieldLabel === "selSubSpecialtyId") {
            this.selSubSpecialty = event.detail.selectedValue;
            this.resetDependentFields(["selResource"]);
            this.fetchBookingDetails();
        }
    }

    handleResourceChange(event) {
        if (event.detail.fieldLabel === "resourceId") {
            this.selResource = event.detail.selectedValue;
        }
    }

    resetDependentFields(fields) {
        fields.forEach((field) => {
            this[field] = "";
        });
    }

    handleReset() {
        this.selHospital = "BH";
        this.selLocation = "";
        this.selSpecialty = "";
        this.selSubSpecialty = "";
        this.selResource = "";
        this.fetchBookingDetails();
    }

    handleFind() {
        findDoctorAndSchedules({
            selHospital: this.selHospital,
            selLocation: this.selLocation,
            selSpecialty: this.selSpecialty,
            selSubSpecialty: this.selSubSpecialty,
            selResource: this.selResource,
            selDate: null,
            selStartTime: null,
            selEndTime: null
        })
            .then((result) => {
                const message = {
                    type: "doctorList",
                    doctorList: result
                };
                publish(this.messageContext, DOCTOR_SCHEDULE_MESSAGE, message);
            })
            .catch((error) => {
                console.error("Error finding doctors:", error);
            });
    }
}
