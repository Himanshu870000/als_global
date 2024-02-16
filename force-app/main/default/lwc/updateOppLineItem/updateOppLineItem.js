import { LightningElement, api, track,  } from 'lwc';
import updateOppLineItem  from '@salesforce/apex/productScreenController.updateOppLineItem';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from "lightning/actions";
import BaseURLOpportunity from '@salesforce/label/c.BaseURLOpportunity';
export default class UpdateOppLineItem extends LightningElement {

@api selectedRows = [];
@track oppLineItems = [];
@api recordId;
@track isEditOliOpen= true;

    connectedCallback() {
    debugger;
    console.log('selectedRows...',JSON.stringify(this.selectedRows));
    for(let i =0;i<this.selectedRows.length;i++){
                 var temp = {
                     "Id":this.selectedRows[i].Id,
                     "Name" : this.selectedRows[i].Name,
                     "opportunityId": this.recordId,
                     "quantity" : this.selectedRows[i].Quantity__c,
                     "discount" : this.selectedRows[i].Discount__c,
                     "salesPrice": this.selectedRows[i].UnitPrice__c,
                     "listPrice" : this.selectedRows[i].ListPrice__c, // Assuming this field is available in your result
                     "totalValue" : this.selectedRows[i].Subtotal__c,
                     "discountedPrice" : this.selectedRows[i].TotalPrice__c
                 }
               // this.oppLineItems.push(this.calculateFields(temp));
               console.log('data === >'+temp);
            this.oppLineItems.push(this.calculateFields(temp));
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
    
        const actualSalesPrice = item.unitPrice || item.listPrice;
        // Calculate Total Value
        item.totalValue = item.quantity * actualSalesPrice || 0;

        // Calculate Discounted Price
        const discountPercentage = item.discount || 0;
        item.discountedPrice = item.totalValue - (item.totalValue * discountPercentage / 100);

        return item;
        }


handleSave() {
    debugger;
    // console.log('this.oppLineItems::'+this.oppLineItems);
    updateOppLineItem({ OLILIST: JSON.stringify(this.oppLineItems), oppId : this.recordId})
    .then(result => {
        if(result){   
            this.showToast();
            this.dispatchEvent(new CustomEvent('close'));
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