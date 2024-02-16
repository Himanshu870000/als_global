import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';   
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fireApprovalProcessForRSM from '@salesforce/apex/TriggerOpportunityHandler.fireApprovalProcessForRSM';
export default class CreateFeasibilityapprovalButton extends LightningElement {

@api recordId;
ShowRmsnullMessage=false;
data;
error;

connectedCallback(){
    setTimeout(() =>{
     this.getmymethod();
    },300);
}
getmymethod(){
debugger;
fireApprovalProcessForRSM({recordId : this.recordId})
   .then(result =>{
    if(result){
        if(result == 'Please Provide RSM Value !'){
            this.ShowRmsnullMessage = true;
        }
            if(result == 'SUCCESS'){
                this.showToast();
                this.closeQuickAction();
            }
    }
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
    
}