import { LightningElement, api ,track} from 'lwc';
import updateFeasibleStatus from '@salesforce/apex/TriggerOpportunityHandler.updateFeasibleStatus';
import { CloseActionScreenEvent } from 'lightning/actions';   
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RefreshEvent } from 'lightning/refresh';
import BaseURLOpportunity from '@salesforce/label/c.BaseURLOpportunity';
export default class UpdateOpportunityFeasibility extends LightningElement {
    @api recordId;
    @track substatusfeasibleMessage;
    error;
    data;
   

    handleChange(event) {
        debugger;
        this.substatusfeasibleMessage = event.target.value;
    }
    submitAction() {
        debugger;
        updateFeasibleStatus({ recordId: this.recordId, statusReason: this.substatusfeasibleMessage })
            .then(result => {
                if (result) {
                    if (result == 'SUCCESS') {
                        this.showToast();
                        this.closeQuickAction();
                        this.handleUploadFinished();
                }
            }
            })
            .catch(error => {
                this.error = error;
        })
    }

    showToast() {
        const event = new ShowToastEvent({
            title: 'SUCCESS',
            message: 'The Fesibility Approval is Fired Successfully',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    closeQuickAction() {
        debugger;
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleUploadFinished(event) {
        debugger;
         window.location.href = BaseURLOpportunity+this.recordId+'/view'; 
    }
}