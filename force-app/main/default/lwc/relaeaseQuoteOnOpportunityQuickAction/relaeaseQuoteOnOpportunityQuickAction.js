import { LightningElement,api , track} from 'lwc';
import sendReleaseQuoteToOpportunityOwner from '@salesforce/apex/OpportunityHelper.sendReleaseQuoteToOpportunityOwner';
import checkOpportunityUpdated from '@salesforce/apex/QuoteScreenController.checkOpportunityUpdated';
import checkPrimaryQuoteFromRelatedQuoteList from '@salesforce/apex/QuoteScreenController.checkPrimaryQuoteFromRelatedQuoteList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { CloseActionScreenEvent } from 'lightning/actions';
import BaseURLOpportunity from '@salesforce/label/c.BaseURLOpportunity';
export default class RelaeaseQuoteOnOpportunityQuickAction extends LightningElement {
     @api recordId;
     @track toastMessage;
     connectedCallback() {
          setTimeout(() => {
             debugger;
              //  this.checkPrimaryQuote(); 
                 this.checkPrimaryQuoteUpdate();
             //  this.sendOpportunityOWnerEmail();
          }, 300);
       } 
       
        sendOpportunityOWnerEmail(){
               debugger;
               sendReleaseQuoteToOpportunityOwner({recordId:this.recordId}).then((result) => {
                    if (result == 'SUCCESS') {
                         this.showToast();
                         this.closeModal();
                         window.location.href = BaseURLOpportunity+this.recordId+'/view';
                    }
                    else {
                        this.showErrorToast();
                        this.closeModal();
                        window.location.href = BaseURLOpportunity+this.recordId+'/view';
                   }
               }).catch((err) => {
                   console.log(err);
               });
        }
        
        checkPrimaryQuoteUpdate() {
        debugger;
            checkPrimaryQuoteFromRelatedQuoteList({ recordId: this.recordId })
                .then(result => {
                    if (result) {
                        if (result != 'SUCCESS') {
                            this.showWarningToast();
                        }
                        if (result == 'SUCCESS') {
                            this.sendOpportunityOWnerEmail();
                        }
                    } 
                })
                .catch(error => {
                console.log('Error while checking primary');
            })
        }
    

           checkPrimaryQuote(){
            debugger;
            checkOpportunityUpdated({recId:this.recordId}).then((result) => {
                if(result){

                    if(result == 'Please add the Primary Quote'){
                        const event = new ShowToastEvent({
                            title: 'ERROR',
                            message:result,
                            variant:'error',
                            mode:'dismissable'    
                        });
                        this.dispatchEvent(event);
                        this.closeModal();
                    }else if(result == 'Please add the Products'){
                        const event = new ShowToastEvent({
                            title: 'ERROR',
                            message:result,
                            variant:'error',
                            mode:'dismissable'    
                        });
                        this.dispatchEvent(event);
                        this.closeModal();
                    }else if(result == 'Please generate the Quote Document !'){
                        const event = new ShowToastEvent({
                            title: 'ERROR',
                            message:result,
                            variant:'error', 
                            mode:'dismissable'    
                        });
                        this.dispatchEvent(event);
                        this.closeModal();
                    }else if(result == 'SUCCESS'){
                        this.sendOpportunityOWnerEmail();
                    }
                }
            }).catch((err) => {
                console.log(err);
            });
           }
       
           showToast() {
               debugger;
               const event = new ShowToastEvent({
                   title: 'SUCCESS',
                   message:'Quote Relesed Successfully !',
                   variant:'Success',
                   mode:'dismissable'    
               });
               this.dispatchEvent(event);
           }
       
           closeModal() {
               debugger;
               this.dispatchEvent(new CloseActionScreenEvent());
           }
    
           showErrorToast() {
            debugger;
            const event = new ShowToastEvent({
                title: 'ERROR',
                message:'Something went wrong !',
                variant:'error',
                mode:'dismissable'    
            });
            this.dispatchEvent(event);
           }
    
           showWarningToast() {
            const evt = new ShowToastEvent({
                title: 'WARNING',
                message: 'Please Add Primary Quote Before Release  Quote',
                variant: 'warning',
                mode: 'dismissable'
            });
               this.dispatchEvent(evt); 
               this.dispatchEvent(new CloseActionScreenEvent());
        }
}