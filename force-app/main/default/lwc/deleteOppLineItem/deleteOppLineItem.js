import { LightningElement, api, track, wire } from 'lwc';
import getOppLineItems from "@salesforce/apex/productScreenController.getOppLineItems";
import DeleteOpportunityLineItem from "@salesforce/apex/productScreenController.DeleteOpportunityLineItem";
import { CloseActionScreenEvent } from "lightning/actions";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import BaseURLOpportunity from '@salesforce/label/c.BaseURLOpportunity';
const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Quantity', fieldName: 'Quantity__c', type: 'number' },
    { label: 'List Price', fieldName: '	ListPrice__c', type: 'currency' },
    { label: 'Unit Price', fieldName: 'UnitPrice__c', type: 'currency' },
    { label: 'Discount', fieldName: 'Discount__c', type: 'number' },
    { label: 'Sub Total', fieldName: 'Subtotal__c', type: 'currency' },
    { label: 'Total Price', fieldName: 'TotalPrice__c', type: 'currency' },
];
export default class DeleteOppLineItem extends LightningElement {
 @track columns=columns;
 @track oppLineItems;
 @track error;
 @track selectedRowsIds = [];
 @api recordId;
 @track error;

    @wire(getOppLineItems,{OppId : "$recordId"})
    wiredOppLineItems({error, data}){
        if(data){
            this.oppLineItems = data;
            this.error=undefined;
        }else if(error){
            this.oppLineItems = undefined;
            this.error=error;
        }
        
    }

    handleRowSelection(event) {
        debugger;
        const selectedRows = event.detail.selectedRows;
        for (let i = 0; i < selectedRows.length; i++) {
            //alert('You selected: ' + selectedRows[i].OpportunityName);
            this.selectedRowsIds = selectedRows[i].Id;
        }
            console.log('Selected Rows:', this.selectedRowsIds);
    }

    handleDelete(){
        debugger;
        DeleteOpportunityLineItem({OppLineItemId:this.selectedRowsIds}).then((result) => {
            if(result){  
                debugger; 
            const event = new ShowToastEvent({
            title: 'SUCCESS',
            message: 'Record Deleted Successfully',
            variant: 'Success',
            mode: 'dismissable'
        });
         this.dispatchEvent(event);
         this.closeModal()
         window.location.href = BaseURLOpportunity+this.recordId+'/view';
        }else{
            console.log('Error Find')
        }
        }).catch((err) => {
            this.error=err;
        });
    }

    handleCancel() {
   this.closeModal();
    }

    closeModal() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}