import { LightningElement, api } from 'lwc';
import updateStageToAudit from '@salesforce/apex/LeadStageUpdateController.updateStageToAudit';
import fetchStakeHolderDetails from '@salesforce/apex/LeadStageUpdateController.fetchStakeHolderDetails';
import sendAduitDetailsToStackHolderEmail from '@salesforce/apex/UtilityClassForEmailMethod.sendAduitDetailsToStackHolderEmail';

import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { RefreshEvent } from 'lightning/refresh';
import LeadBaseURL from '@salesforce/label/c.LeadBaseURL';

export default class RecordEditFormEditExampleLWC extends LightningElement {
    isLoaded = false;
    @api recordId;

    handleSubmit(event) {
        this.isLoaded = true;
        console.log('onsubmit event recordEditForm' + event.detail.fields);
    }

    handleSuccess(event) {
        debugger;
        console.log('onsuccess event recordEditForm', event.detail.id);
        sendAduitDetailsToStackHolderEmail({ recordId: event.detail.id })
            .then(result => {
                if (result == 'SUCCESS') {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'SUCCESS',
                            message: 'Lead Udated Successfully !',
                            variant: 'success',
                        })
                    );
                    this.dispatchEvent(new CloseActionScreenEvent());
                    window.location.href = LeadBaseURL+this.recordId+'/view'; 
                }
                if (result == 'Please add Stack Holder Details') {
                    this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'ERROR',
                        message: 'Add stakeholder details before adding audit details.',
                        variant: 'error',
                    })
                    );
                    this.dispatchEvent(new CloseActionScreenEvent());
                }
        })

        // // Validate before proceeding with the update
        // fetchStakeHolderDetails({ recordId: event.detail.id })
        //     .then((isStakeHolderPresent) => {
        //         if (isStakeHolderPresent) {
        //             // Call Apex method to get the fields from FieldSet
        //             updateStageToAudit({ recordId: event.detail.id })
        //                 .then((result) => {
        //                     this.dispatchEvent(
        //                         new ShowToastEvent({
        //                             title: 'Success',
        //                             message: 'Lead updated',
        //                             variant: 'success',
        //                         })
        //                     );
        //                   //  this.isLoaded = false;
        //                     this.dispatchEvent(new CloseActionScreenEvent());
        //                     window.location.href = LeadBaseURL+this.recordId+'/view'; 
        //                    // this.navigateToRecord(event.detail.id);
        //                    // this.dispatchEvent(new RefreshEvent());
        //                 })
        //                 .catch((error) => {
        //                     console.error(error);
        //                 });
        //         } else {
        //             this.isLoaded = false;
        //             this.dispatchEvent(
        //                 new ShowToastEvent({
        //                     title: 'Error',
        //                     message: 'Add stakeholder details before adding audit details.',
        //                     variant: 'error',
        //                 })
        //             );
        //         }
        //     })
        //     .catch((error) => {
        //         console.error(error);
        //     });
    }

    // navigateToRecord(recordId) {
    //     //const recordId = event.currentTarget.dataset.id;

    //     this[NavigationMixin.Navigate]({
    //         type: 'standard__recordPage',
    //         attributes: {
    //             recordId: recordId,
    //             actionName: 'view',
    //         },
    //     });
    // }
}