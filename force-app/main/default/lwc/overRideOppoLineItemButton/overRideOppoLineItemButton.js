import { LightningElement, track, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class OverRideOppoLineItemButton extends LightningElement {
 //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = true;
    @track isPriceBook;
    value = 'None';
    @track isProduct = false;
    @api recordId;
    closeModal() {
        // to close modal set isModalOpen track value as false
        this.isModalOpen = false;
    }

    
    get options() {
        return [
            { label: 'None', value: 'None' },
            { label: 'Standard', value: 'Standard' },
            
        ];
    }

    handleChange(event){
        this.isPriceBook = event.target.value;
    }
    handleClick() {
        this.isModalOpen = false;
        this.isProduct = true;
    }

    modalCloseHandler(){
        debugger;
        this.closeAction();
    }

    closeGrandChild(){
        this.closeAction();
    }

    closeAction(){
        debugger;
  this.dispatchEvent(new CloseActionScreenEvent());
}
}