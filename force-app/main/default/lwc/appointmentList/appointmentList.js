import { LightningElement, track } from 'lwc';
import getAvailableAppointments from '@salesforce/apex/AppointmentController.getAvailableAppointments';
import generateAppointmentPdf from '@salesforce/apex/AppointmentController.generateAppointmentPdf';
import jsPDFResource from '@salesforce/resourceUrl/jsPDF';
import { loadScript } from 'lightning/platformResourceLoader';

export default class AppointmentList extends LightningElement {
    @track appointments = [];
    @track error;
    doctorId = ''; // Set this value based on your needs
    startTime = '2024-09-01 00:00:00';
    endTime = '2024-09-01 23:59:59';
    jsPdfInitialized = false;
    jsPDF; // This will hold the jsPDF constructor

    renderedCallback() {
        if (this.jsPdfInitialized) {
            return;
        }
        this.jsPdfInitialized = true;

        loadScript(this, jsPDFResource)
            .then(() => {
                console.log('jsPDF loaded successfully.');
                console.log('window.jspdf:', window.jspdf); // Debugging line
                console.log('window.jspdf.jsPDF:', window.jspdf.jsPDF); // Debugging line
                console.log('window.jsPDF:', window.jsPDF); // Debugging line
                this.jsPDF = window.jspdf?.jsPDF || window.jspdf?.default || window.jsPDF;
                console.log('this.jsPDF:', this.jsPDF); // Verify what is actually assigned
            })
            .catch(error => {
                this.error = error;
                console.log('Error loading jsPDF: ' + error);
            });
    }

    connectedCallback() {
        this.loadAppointments();
    }

    loadAppointments() {
        console.log('Loading appointments...');
        getAvailableAppointments({ doctorId: this.doctorId, startTime: this.startTime, endTime: this.endTime })
            .then(result => {
                console.log('Appointments retrieved:', result); // Log the result
                this.appointments = result;
                this.error = undefined;
            })
            .catch(error => {
                console.error('Error retrieving appointments:', error); // Log any errors
                this.error = error;
                this.appointments = undefined;
            });
    }
    
    

    handleGeneratePdf() {
        console.log('Generate PDF button clicked.');
        
        if (!this.jsPDF) {
            console.log('jsPDF is not loaded or initialized.');
            return;
        }
    
        const selectedAppointments = this.appointments.map(app => app.Id);
    
        console.log('Selected Appointments:', selectedAppointments); // Check if appointments are selected
    
        generateAppointmentPdf({ appointmentIds: selectedAppointments })
            .then(pdfContent => {
                console.log('PDF Content:', pdfContent); // Ensure the PDF content is being received
    
                if (!pdfContent) {
                    console.log('PDF content is empty or undefined.');
                    return;
                }
    
                const doc = new this.jsPDF();  // Use the jsPDF constructor
                doc.text(pdfContent, 10, 10);
                doc.save('appointments.pdf');
            })
            .catch(error => {
                this.error = error;
                console.log('Error generating PDF: ' + error);
            });
    }
}