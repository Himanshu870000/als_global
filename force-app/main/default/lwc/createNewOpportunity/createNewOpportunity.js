import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class createNewOpportunity extends LightningElement {

    @api recordId ;
    @api accountId ;
    isAddressVisible = false;
    handleSubmit(event) {
    debugger;
    //event.preventDefault();
    }

    handleSuccess(event) {
    debugger;
    //const fields = event.detail.fields;
    //this.accountId =  fields.AccountId__c;
    this.recordId = event.detail.id;
    this.isAddressVisible = true;
    const evt = new ShowToastEvent({
        title: "Success!",
        message: "The record has been successfully saved.",
        variant: "success",
    });
    this.dispatchEvent(evt);
    this.editMode = false;
    }

    handleError(event) {
    const evt = new ShowToastEvent({
        title: "Error!",
        message: "An error occurred while attempting to save the record.",
        variant: "error",
    });
    this.dispatchEvent(evt);
    this.editMode = false;
    }

    handleCancel(event) {
    event.preventDefault();
    var baseURL = window.location.origin;
    var url = baseURL + '/lightning/o/Opportunity1__c/list?filterName=Recent';
    window.location.href = url;
    }

}