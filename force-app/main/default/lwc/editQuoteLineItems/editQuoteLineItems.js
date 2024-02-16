import { LightningElement, api, track, wire } from 'lwc';
import getQuoteLineItems from "@salesforce/apex/QuoteScreenController.getQuoteLineItems";
import { CloseActionScreenEvent } from "lightning/actions";
const columns = [
    { label: 'Product Name', fieldName: 'ProductName' },
    { label: 'Product Family', fieldName: 'Family__c' },
    { label: 'Method', fieldName: 'Test_Method__c' },
    { label: 'Quantity', fieldName: 'Quantity__c', type: 'number' },
    { label: 'List Price', fieldName: 'List_Price__c', type: 'number' },
    { label: 'Sales Price', fieldName: 'Sales_Price__c', type: 'currency' },
    //{ label: 'Discount', fieldName: 'Discount__c', type: 'number' },
    // { label: 'Sub Total', fieldName: 'Subtotal__c', type: 'currency' },
    // { label: 'Total Price', fieldName: 'Total_Price__c', type: 'currency' },
];
export default class EditQuoteLineItems extends LightningElement {
 @api recordId;
 @track columns=columns;
 @track oppLineItems;
 @track error;
 @track selectedRows = [];
 @track isLineItemModalOpen =true;
 @track isShowSelectedItems=false;
 @track searchTerm ='';
 @track items = [];
 //@track initialRecords; 

     @wire(getQuoteLineItems,{QuoteId : "$recordId"})
    wiredOppLineItems({error, data}){
        debugger;
        if(data){
            let tempList = [];
            for(var i=0;i<data.length;i++){
                let tempObj = {
                    Id:data[i].Id,
                    Name:data[i].Name,
                    ProductName:data[i].ProductId__r.Name,
                    Family__c:data[i].ProductId__r.Family__c,
                    Test_Method__c:data[i].Test_Method__c,
                    Quantity__c:data[i].Quantity__c,
                    List_Price__c:data[i].List_Price__c,
                    Sales_Price__c:data[i].Sales_Price__c,
                   // Discount__c:data[i].Discount__c,
                     Subtotal__c:data[i].Subtotal__c,
                    // Total_Price__c:data[i].Total_Price__c
                }
                tempList.push(tempObj);
            }
            this.oppLineItems = tempList;
            this.items = this.oppLineItems;
            //this.initialRecords =  this.oppLineItems;
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
        this.searchTerm = event.target.value;
        let filteredData = this.items.filter(item => 
        item.Family__c.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
        item.ProductName.toLowerCase().includes(this.searchTerm.toLowerCase())
    );
        this.oppLineItems = filteredData;
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