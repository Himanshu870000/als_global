import { LightningElement, api, wire ,track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import createOpportunityLineItems  from '@salesforce/apex/productScreenController.createOpportunityLineItems';
import BaseURLOpportunity from '@salesforce/label/c.BaseURLOpportunity';

export default class EditProducts extends LightningElement {
//@api selectedProducts;
@track oliList = [];
@track isEditProdOpen = true;
@api selectedRows = [];
@api recordId;
@api oppName;

connectedCallback() {
    debugger;
    console.log('selectedRows...',JSON.stringify(this.selectedRows));
    for(let i =0;i<this.selectedRows.length;i++){
                 var temp = {
                     "productId" : this.selectedRows[i].Product1Id__c,
                     "Name" : this.selectedRows[i].Name,
                     "opportunityId": this.recordId,
                     "opportunityName": this.oppName,
                     "quantity" : 0,
                     "discount" : 0,
                     "salesPrice": this.selectedRows[i].UnitPrice__c|| 0,
                     "listPrice" : this.selectedRows[i].UnitPrice__c || 0, // Assuming this field is available in your result
                     "totalValue" : 0,
                     "discountedPrice" : 0
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
    
const actualSalesPrice = item.salesPrice || item.listPrice;
// Calculate Total Value
item.totalValue = item.quantity * actualSalesPrice || 0;

// Calculate Discounted Price
const discountPercentage = item.discount || 0;
item.discountedPrice = item.totalValue - (item.totalValue * discountPercentage / 100);

return item;
}

handleSave() {
    debugger;
    // console.log('this.oliList::'+this.oliList);
    createOpportunityLineItems({ jsonData: JSON.stringify(this.oliList), oppId:this.recordId})
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
         window.location.href = BaseURLOpportunity+this.recordId+'/view';
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



    closeAction(){
  this.dispatchEvent(new CloseActionScreenEvent());
}

}