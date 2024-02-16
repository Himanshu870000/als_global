import { LightningElement,api } from 'lwc';
import UpdateNegotiationnotes from '@salesforce/apex/OpportunityHelper.UpdateNegotiationnotes';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { CloseActionScreenEvent } from 'lightning/actions';
import BaseURLOpportunity from '@salesforce/label/c.BaseURLOpportunity';
export default class InitiateNegotiontoCS extends LightningElement {
 fieldValue = " ";
    fieldLabel;
    required;
    fieldLength = 32000;
    visibleLines = 3;
    @api recordId;
    validity;
    errorMessage;
    error;
    allowedFormats = [
        'font',
        'size',
        'bold',
        'italic',
        'underline',
        'strike',
        'list',
        'indent',
        'align',
        'link',
        'image',
        'clean',
        'table',
        'header',
        'color',
        'background',
        'code',
        'code-block',
        'script',
        'blockquote',
        'direction',
    ];
    connectedCallback() {
        debugger;
        this.validity = true;
        document.documentElement.style.setProperty('--rta-visiblelines', (this.visibleLines * 2) + 'em');
    }
    handleChange(event) {
        debugger;
        if ((event.target.value).length > this.fieldLength) {
            this.validity = false;
            this.errorMessage = "You have exceeded the max length";
        }
        else {
            this.validity = true;
            this.fieldValue = event.target.value;
        }
    }

    submitAction() {
        debugger;
        UpdateNegotiationnotes({ negotiationvalue : this.fieldValue, recordId: this.recordId })
            .then(result => {
                if (result == 'SUCCESS') {
                    this.showToast();
                    this.closeQuickAction();
                    this.handleUploadFinished();
               }
            })
            .catch(error => {
                this.error = error;
           })
    }

    closeQuickAction() {
        debugger;
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleUploadFinished(event) {
        debugger;
         window.location.href = BaseURLOpportunity+this.recordId+'/view'; 
    }
    showToast() {
        const event = new ShowToastEvent({
            title: 'SUCCESS',
            message: 'Record Updated Successfully !',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}