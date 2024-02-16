import { LightningElement, api, track, wire } from 'lwc';
import getOppLineItems from "@salesforce/apex/productScreenController.getOppLineItems";
import { CloseActionScreenEvent } from "lightning/actions";
const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Quantity', fieldName: 'Quantity__c', type: 'number' },
    { label: 'List Price', fieldName: '	ListPrice__c', type: 'currency' },
    { label: 'Unit Price', fieldName: 'UnitPrice__c', type: 'currency' },
    { label: 'Discount', fieldName: 'Discount__c', type: 'number' },
    { label: 'Sub Total', fieldName: 'Subtotal__c', type: 'currency' },
    { label: 'Total Price', fieldName: 'TotalPrice__c', type: 'currency' },
];
export default class EditOppLineItem extends LightningElement {
 @api recordId;
 @track columns=columns;
 @track oppLineItems;
 @track error;
 @track selectedRows = [];
 @track isLineItemModalOpen =true;
 @track isShowSelectedItems=false;
 @track initialRecords;

    @wire(getOppLineItems,{OppId : "$recordId"})
    wiredOppLineItems({error, data}){
        debugger;
        if(data){
            this.oppLineItems = data;
            this.initialRecords =  this.oppLineItems;
            this.error=undefined;
        }else if(error){
            this.oppLineItems = undefined;
            this.error=error;
        }
        
    }

    handleRowSelection(event) {
        debugger;
        this.selectedRows = event.detail.selectedRows;
            console.log('Selected Rows:', this.selectedRows);
    }

    handleSearch(event){
        debugger;
        const searchKey = event.target.value.toLowerCase(); 
        if (searchKey) {
            this.oppLineItems = this.initialRecords;
            if (this.oppLineItems) {
                let searchRecords = [];
                for (let record of this.oppLineItems) {
                    let valuesArray = Object.values(record); 
                    for (let val of valuesArray) {
                        console.log('val is ' + val);
                        let strVal = String(val);
                        if (strVal) {
                            if (strVal.toLowerCase().includes(searchKey)) {
                                searchRecords.push(record);
                                break;
                            }
                        }
                    }
                }
 
                console.log('Matched Accounts are ' + JSON.stringify(searchRecords));
                this.oppLineItems = searchRecords;
            }
        } else {
            this.oppLineItems = this.initialRecords;
        }
    }

    handleNext(){
         debugger;
         this.isLineItemModalOpen = false;
         this.isShowSelectedItems = true;
     }
    
    handleCancel(){
        debugger;
        this.closeModal();
    }

    modalCloseHandler(){
        this.closeModal();
    }

    closeModal() {
        debugger;
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}