import { LightningElement, api} from 'lwc';
import updateStageToJunk from '@salesforce/apex/LeadStageUpdateController.updateStageToJunk';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CloseActionScreenEvent } from 'lightning/actions';
export default class RecordEditFormEditExampleLWC extends LightningElement {
    isLoaded = false;
    @api recordId;
    handleSubmit(event) {
        this.isLoaded = true;
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
    }
    handleSuccess(event) {
        debugger;
        console.log('onsuccess event recordEditForm', event.detail.id);
         // Call Apex method to get the fields from FieldSet
        updateStageToJunk({ recordId: event.detail.id})
            .then((result) => {
                this.dispatchEvent(
                new ShowToastEvent({
                title: "Success",
                message: "Lead updated",
                variant: "success"
                })
                );
                this.isLoaded = false;
                this.dispatchEvent(new CloseActionScreenEvent());
                this.navigateToRecord(event.detail.id);
            })
            .catch((error) => {
                console.error(error);
            });
    }

    navigateToRecord(recordId) {
    //const recordId = event.currentTarget.dataset.id;
    
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: recordId,
            actionName: 'view'
        }
    });
}
}