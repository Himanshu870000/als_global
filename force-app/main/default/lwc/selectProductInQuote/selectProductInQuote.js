import { LightningElement, track, api, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class SelectProductInQuote extends LightningElement {
    @track isModalOpen = true;
    @track isPriceBook;
    value = 'Standard';
    @track isProduct = false;
    @api recordId;
    get options() {
        return [
            { label: 'None', value: 'None' },
            { label: 'Standard', value: 'Standard' },
            
        ];
    }

    handleChange(event){
        this.value = event.target.value;
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