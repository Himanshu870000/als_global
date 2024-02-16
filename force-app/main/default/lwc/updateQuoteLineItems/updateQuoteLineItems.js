import { LightningElement, track, api, wire } from 'lwc';
import updateQuoteLineItems  from '@salesforce/apex/QuoteScreenController.updateQuoteLineItems';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from "lightning/actions";
import BaseURLQuote from '@salesforce/label/c.BaseURLQuote';
export default class UpdateQuoteLineItems extends LightningElement {
@api selectedRows = [];
@track oppLineItems = [];
@api recordId;
@track isEditOliOpen= true;
@track isLoading = false;

    connectedCallback() { 
    debugger;
    console.log('selectedRows...',JSON.stringify(this.selectedRows));
    for(let i =0;i<this.selectedRows.length;i++){
                 var temp = {
                     "Id":this.selectedRows[i].Id,
                     "Name" : this.selectedRows[i].Name,
                     "quoteId": this.recordId,
                     "ProductName":this.selectedRows[i].ProductName,
                     "Family":this.selectedRows[i].Family__c,
                    // "Method":this.selectedRows[i].Test_Method__c,
                     "quantity" : this.selectedRows[i].Quantity__c, 
                     "listPrice" : this.selectedRows[i].List_Price__c,
                     "salesPrice": this.selectedRows[i].Sales_Price__c,                                       
                    //  "discount" : this.selectedRows[i].Discount__c,
                     "totalValue" : this.selectedRows[i].Subtotal__c,
                    //  "discountedPrice" : this.selectedRows[i].Total_Price__c
                 }
               // this.oppLineItems.push(this.calculateFields(temp));
               console.log('data === >'+temp);
            this.oppLineItems.push(temp);
            console.log('oppLineItems..',JSON.stringify(this.oppLineItems));
}
}

handleInputChange(event){
    debugger;
    // Update the oppLineItems when the input value changes
    var oppId = event.target.dataset.id;
    const field = event.target.dataset.field;
    const value = event.target.value;
    this.oppLineItems = this.oppLineItems.map(item => {
    if (item.Id === oppId) {
        return this.calculateFields({ ...item, [field]: value });
    }
    return item;
});
}

    calculateFields(item) {
    
        const actualSalesPrice = item.salesPrice;
        // Calculate Total Value
        item.totalValue = item.quantity * actualSalesPrice || 0;

        // Calculate Discounted Price
        // const discountPercentage = item.discount || 0;
        // item.discountedPrice = item.totalValue - (item.totalValue * discountPercentage / 100);

        return item;
        }

        handleSave() {
    debugger;
    // console.log('this.oppLineItems::'+this.oppLineItems);
    this.isLoading = true;
    updateQuoteLineItems({ OLILIST: JSON.stringify(this.oppLineItems), QuoteId : this.recordId})
    .then(result => {
        if(result){   
            this.showToast();
            this.dispatchEvent(new CustomEvent('close'));
            window.location.href = BaseURLQuote+this.recordId+'/view';
        }else{
            console.log('Error Find')
        }
    })
    .catch(error => {
        //  console.error('Error in handleSave:', error);
        alert(error.body.message)
        const event = new ShowToastEvent({
            title: 'Error',
            message: 'Error saving selected products: ' + error.body.message,
            variant: 'error',
        });
        this.dispatchEvent(event);
    });
    this.isEditOliOpen= false;
}

    showToast() {
        const event = new ShowToastEvent({
            title: 'SUCCESS',
            message:
                'Record Updated Successfully !',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    handleCancel() {
        this.dispatchEvent(new CustomEvent('close'));
        this.closeModal();
    }


    closeModal() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}