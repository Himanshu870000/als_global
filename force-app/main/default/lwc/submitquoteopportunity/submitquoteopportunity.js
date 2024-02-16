import { LightningElement, api } from 'lwc';
import shareRecordToCustomerSuccessOnSubmitQuote from '@salesforce/apex/OpportunityHelper.shareRecordToCustomerSuccessOnSubmitQuote';
import getOppDetails from '@salesforce/apex/OpportunityHelper.getOppDetails';
import updateTaskStatus from "@salesforce/apex/updateTaskStatusController.updateTaskStatusAfterQuoteSubmission";
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { CloseActionScreenEvent } from 'lightning/actions';
import BaseURLOpportunity from '@salesforce/label/c.BaseURLOpportunity';
export default class Submitquoteopportunity extends LightningElement {
     @api recordId;
    error;
    showErrorCustomerSuccess = false;
    showErrorContactPerson = false;
    showErrorContactPersonORCustomerSUCCESS = false;
     connectedCallback() {
          setTimeout(() => {
              debugger;
              this.getOppRecordDetails();
          }, 300);
       } 
    
    getOppRecordDetails() {
        getOppDetails({ recordId: this.recordId })
            .then(result => {
                if (result.Customer_Success__c ==null && result.Contact_Person__c !=null) {
                    this.showErrorCustomerSuccess = true;
                }else{
                    this.showErrorCustomerSuccess = false;
                }
                 if(result.Contact_Person__c == null && result.Customer_Success__c !=null) {
                   this.showErrorContactPerson = true;
             }else{
                this.showErrorContactPerson = false;
             }
            if(result.Customer_Success__c == null && result.Contact_Person__c == null){
             this.showErrorContactPersonORCustomerSUCCESS = true;
            }else{
                this.showErrorContactPersonORCustomerSUCCESS = false;
            }

             if(result.Customer_Success__c !=null && result.Contact_Person__c !=null){
                this.sendRecordWithCS();
             }
            })
            .catch(error => {
                this.error = error;
        })
    }
    
       sendRecordWithCS(){
               debugger;
               shareRecordToCustomerSuccessOnSubmitQuote({recordId:this.recordId}).then((result) => {
                    if (result  =='SUCCESS') {
                         this.showToast();
                         this.closeModal();
                         this.updateTask();
                         window.location.href = BaseURLOpportunity+this.recordId+'/view';
                    }
                    else {
                        this.showErrorToast(result);
                        this.closeModal();
                        //window.location.href = BaseURLOpportunity+this.recordId+'/view';
                   }
               }).catch((error) => {
                    console.log(error);
                   this.showErrorToast();
                    this.closeModal();
                    window.location.href = BaseURLOpportunity+this.recordId+'/view';
                    
               });
           }
       
           showToast(message) {
               debugger;
               const event = new ShowToastEvent({
                   title: 'SUCCESS',
                   message:'Record submitted for feasability check.',
                   variant:'Success',
                   mode:'dismissable'    
               });
               this.dispatchEvent(event);
           }
       
           closeModal() {
               debugger;
               this.dispatchEvent(new CloseActionScreenEvent());
           }

           showErrorToast(message) {
            debugger;
            const event = new ShowToastEvent({
                title: 'ERROR',
                message:message,
                variant:'error',
                mode:'dismissable'    
            });
            this.dispatchEvent(event);
           }

        updateTask(){
           debugger;
        updateTaskStatus({recId:this.recordId}).then((result) => {
        console.log(result);
        }).catch((err) => {
        console.log(err);
        });
    }
    
}