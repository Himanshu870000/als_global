import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import createQuoteLineItems  from '@salesforce/apex/QuoteScreenController.createQuoteLineItems';
import BaseURLQuote from '@salesforce/label/c.BaseURLQuote';
export default class SaveProductsScreen extends LightningElement {
@track oliList = [];
@track isEditProdOpen = true;
@track qunty; 
@api selectedRows = [];
@api recordId;
@api oppName;
@track isLoading = false;

connectedCallback() { 
    debugger;
    console.log('selectedRows...',JSON.stringify(this.selectedRows));
    for(let i =0;i<this.selectedRows.length;i++){
                 var temp = {
                     "productId" : this.selectedRows[i].Product1Id__c,
                     "Name" : this.selectedRows[i].Name,
                     "quoteId": this.recordId,
                     "productCode":this.selectedRows[i].ProductCode__c,
                     "Method":this.selectedRows[i].Method,
                     "quantity" : this.qunty,
                     //"discount" : 0,
                     "ListPrice": this.selectedRows[i].UnitPrice__c|| 0,
                     "SalesPrice" : this.selectedRows[i].UnitPrice__c || 0, // Assuming this field is available in your result
                     "totalValue" : 0,
                     //"discountedPrice" : 0
                 } 
               // this.oliList.push(this.calculateFields(temp));
            this.oliList.push(this.calculateFields(temp));
            console.log('oliList..',JSON.stringify(this.oliList));
}
}

handleInputChange(event){
    debugger;
// Update the oliList when the input value changes
var productId = event.target.dataset.id;
const field = event.target.dataset.field;
const value = event.target.value;
this.oliList = this.oliList.map(item => {
    if (item.productId === productId) {
        return this.calculateFields({ ...item, [field]: value });
    }
    return item;
});
}

modalCloseHandler(){
    debugger;
    this.dispatchEvent(new CloseActionScreenEvent());
}

calculateFields(item) {
    
const actualSalesPrice = item.SalesPrice;
// Calculate Total Value
item.totalValue = item.quantity * actualSalesPrice || 0;

// Calculate Discounted Price
//const discountPercentage = item.discount || 0;
//item.discountedPrice = item.totalValue - (item.totalValue * discountPercentage / 100);

return item;
}

handleSave() {
    debugger;
    console.log('this.oliList::'+this.oliList);
    this.isLoading = true;
    for(var i=0;i<this.oliList.length;i++){
        if(this.oliList[i].quantity == undefined || this.oliList[i].quantity == '' || this.oliList[i].quantity == 0){
            this.isLoading = false;
            this.showNotification('error','Please add the Quantity','error');
            this.closeAction();
            return;
        }
    }
    createQuoteLineItems({ jsonData: JSON.stringify(this.oliList), QuoteId:this.recordId})
    .then(result => {
        if(result){   
            const event = new ShowToastEvent({
            title: 'SUCCESS',
            message: 'Record created Successfully !',
            variant: 'success',
            mode: 'dismissable'
        });
         this.dispatchEvent(event);
         this.dispatchEvent(new CustomEvent('close'));
         this.closeAction();
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
    this.isEditProdOpen= false;
    this.closeAction();
}

handleCancel() {
    // Implement any logic you need for canceling, e.g., refreshing the page
   this.isEditProdOpen= false;
    this.dispatchEvent(new CustomEvent('close'));
   this.closeAction();
}

showNotification(title,message,variant){
    const evt = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
    });
    this.dispatchEvent(evt);
}

    closeAction(){
  this.dispatchEvent(new CloseActionScreenEvent());
}
}