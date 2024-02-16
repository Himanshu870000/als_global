import { LightningElement, api } from 'lwc';
import shareToCsrUser from '@salesforce/apex/TriggerOpportunityHandler.shareToCsrUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { CloseActionScreenEvent } from 'lightning/actions';
export default class SubmitForCSR extends LightningElement {

    @api recordId;

    connectedCallback() {
   setTimeout(() => {
      debugger;
        this.submitToCsr();
        this.showToast();
        this.closeModal();
   }, 300);
} 

    submitToCsr(){
        debugger;
        shareToCsrUser({recordId:this.recordId}).then((result) => {
            console.log('Record Is Shared Successfully...!',result);
        }).catch((err) => {
            console.log(err);
        });
    }

    showToast() {
        debugger;
        const event = new ShowToastEvent({
            title: 'Success',
            message:
                'Record Shared Successfully..!',
            variant:'Success',
            mode:'dismissable'    
        });
        this.dispatchEvent(event);
    }

    closeModal() {
        debugger;
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}