import { LightningElement, api } from 'lwc';
import createConfigureTaskOnOpportunity from '@salesforce/apex/TriggerOpportunityHandler.createConfigureTaskOnOpportunity';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CreateFinalProductaskOnOpportunity extends LightningElement {
     data;
     error;
     @api recordId;
     connectedCallback() {
          debugger;
          setTimeout(() => {
               this.getMethod();
          }, 300);
     }
     tr
     getMethod() {
          debugger;
          createConfigureTaskOnOpportunity({ recordId: this.recordId })
               .then(result => {
                    if (result) {
                         try {
                              this.data = result;
                              this.showToast();
                              this.dispatchEvent(new CloseActionScreenEvent());
                          } catch(error){
                              alert('Error == >' + this.error);
                          }
                 }
               })
               .catch(error => {
                    this.error = error;
                    alert('Error === >' + this.error);
               })
     }

     showToast() {
          const event = new ShowToastEvent({
               title: 'SUCCESS',
               message: 'Task has been Created Successfully',
               variant: 'success',
           });
           this.dispatchEvent(event);
     }
}