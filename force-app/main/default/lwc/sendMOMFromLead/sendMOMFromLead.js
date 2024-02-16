import { LightningElement, api, track, wire } from 'lwc';
import getContacts from '@salesforce/apex/SendMOMfromLeadController.getContacts';
import getRelatedTaskMOM from '@salesforce/apex/SendMOMfromLeadController.getRelatedTaskMOM';
import sendEmailToSelectedContacts from '@salesforce/apex/SendMOMfromLeadController.sendEmailToSelectedContacts';
import updateTaskStatus from '@salesforce/apex/SendMOMfromLeadController.updateTaskStatus';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CloseActionScreenEvent } from 'lightning/actions';
import BaseURLOpportunity from '@salesforce/label/c.BaseURLOpportunity';
 
export default class SendMOMFromLead extends LightningElement {
    @api recordId; // Lead Id
    @track formattedMOM;
    @api isLoaded = false;
    @track contactOptions = [];
    @track selectedContacts = [];
    @track error;
 
     @wire(getContacts, { leadId: '$recordId' })
     wiredContacts({ error, data }) {
        if (data) {
            this.isLoaded = true;
            const items = [];
            for (let i = 0; i < data.length; i++) {
                items.push({
                    label: data[i].FirstName + ' ' + data[i].LastName,
                    value: data[i].Id
                });
            }
            this.contactOptions.push(...items);
            this.isLoaded = false;
        } else if (error) {
            this.error = error.message;
            this.isLoaded = false;
        }
    }
 
    @wire(getRelatedTaskMOM, { leadId: '$recordId' })
    wiredMOM({ error, data }) {
        if (data) {
            this.formattedMOM = data.MOM__c;
            this.taskId = data.Id;
        } else if (error) {
            this.error = error.message;
        }
    }
 
    handleChange(event) {  
        this.selectedContacts = event.detail.value;
    }

    handleChangeMOM(event) {  
        this.formattedMOM = event.detail.value;
    }

    sendEmail() {
        this.isLoaded = true;
        
        if (this.selectedContacts.length > 0) {    
        }else{
            this.showToast('Error', 'Please select the contact to proceed!!', 'error');
            return;
        }

        sendEmailToSelectedContacts({ selectedContactIds: this.selectedContacts, meetingNotes: this.formattedMOM })
            .then(result => {
                this.showToast('Success', 'Email sent successfully.', 'success');
                updateTaskStatus({ taskId: this.taskId, status: 'Completed' })
                    .then(() => {
                        console.log('Task status updated to Completed.');
                    })
                    .catch(error => {
                       this.showToast('Error', 'Some Error Occured!!', 'error');
                    });
                    
                this.closeModal();
                this.isLoaded = false;
                setTimeout(() => {
                    eval("$A.get('e.force:refreshView').fire();");
                }, 1000); 
                //window.location.href = BaseURLOpportunity+this.recordId+'/view';
            })
            .catch(error => {
                this.isLoaded = false;
                this.error = error.message;
                this.showToast('Error', 'Error sending email.', 'error');
            });
    }
 
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
 
    closeModal() {
        debugger;
        this.dispatchEvent(new CloseActionScreenEvent());
    }
 
 
}