import { LightningElement, api, track, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import getPBERecords from "@salesforce/apex/productScreenController.getPBERecords";
import getOppName from "@salesforce/apex/productScreenController.getOppName";
const columns = [
    { label: 'Produt Name', fieldName: 'Name' },
    { label: 'Product Code', fieldName: 'ProductCode__c'},
    { label: 'List Price', fieldName: 'UnitPrice__c', type: 'currency' },
    { label: 'Product Description', fieldName: 'Description__c'},
    { label: 'Product Family', fieldName: 'Family__c'},
    
];
export default class ProductScreen extends LightningElement {
@api isProductPricebook;
@api recordId;
@track isProdModalOpen = true;
@track isShowSelectedProducts = false;
@track opportunityName;

    page = 1; //initialize 1st page
    items = []; //contains all the records.
    data = []; //data  displayed in the table
    newdata = [];
    columns; //holds column info.
    startingRecord = 1; //start record position per page
    endingRecord = 0; //end record position per page
    pageSize = 10; //default value we are assigning
    totalRecountCount = 0; //total record count received from all retrieved records
    totalPage = 0; //total number of page is needed to display all records
    selectedRows = [];
@track searchTerm='';
@track selectedProdtlist = [];
@track completeProductList = [];


    connectedCallback() {
        debugger;
        setTimeout(() => {
       this.handleOpportunityname();
   }, 100);
    }
    
    handleOpportunityname(){
        getOppName({recId:this.recordId}).then((result) => {
            if(result){
                 this.opportunityName = result;
             this.error = undefined;
            }
    }).catch((err) => {
         this.error=err;
            this.opportunityName=undefined;
    });
    }


    @wire(getPBERecords,{priceName : "$isProductPricebook",oppId : "$recordId"})
    wiredData({error, data}){
        if(data){

            let tempList = [];
            for(var i=0;i<data.length;i++){
              let tempObj = {
            Id:data[i].Id,
            Product1Id__c: data[i].Product1Id__c,
            Name:data[i].Product1Id__r.Name,
            ProductCode__c:data[i].Product1Id__r.ProductCode__c,
            List_Price__c : data[i].List_Price__c,
            UnitPrice__c: data[i].UnitPrice__c,
            Description__c: data[i].Product1Id__r.Description__c,
            Family__c: data[i].Product1Id__r.Family__c
              };
              tempList.push(tempObj);
            }

            console.log('New List == >'+tempList);
            this.completeProductList = tempList;
            this.newdata = tempList;
            

        this.items = this.newdata;
            this.totalRecountCount = this.newdata.length;
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
            //here we slice the data according page size
            this.newdata = this.items.slice(0, this.pageSize);
            this.endingRecord = this.pageSize;
            this.columns = columns;
            this.error = undefined;
        } else if(error){
            this.error=error;
            this.Products=undefined;
        }
    }

    handleSearch(event){
        debugger;
        this.searchTerm = event.target.value;
        this.page = 1; // Reset to the first page when performing a new search
        this.displayRecordPerPage(this.page);
    } 

   //press on previous button this method will be called
    previousHandler() {
          debugger;
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }
    //press on next button this method will be called
    nextHandler() {
          debugger;
        if ((this.page < this.totalPage) && this.page !== this.totalPage) {
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);
        }
    }
    //this method displays records page by page
    displayRecordPerPage(page) {
          debugger;
        this.startingRecord = ((page - 1) * this.pageSize);
        this.endingRecord = (this.pageSize * page);
        this.endingRecord = (this.endingRecord > this.totalRecountCount)
            ? this.totalRecountCount : this.endingRecord;

        // Filter the items based on the search term
    // let filteredData = this.items.filter(item => 
    //     item.Name.toLowerCase().includes(this.searchTerm.toLowerCase()) || 
    //     item.ProductCode__c.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
    //     item.Family__c.toLowerCase().includes(this.searchTerm.toLowerCase())
    // );

    // Filter the items based on the search term
    let filteredData = this.items.filter(item => 
        item.Family__c.toLowerCase().includes(this.searchTerm.toLowerCase())
    );

        this.newdata = filteredData.slice(this.startingRecord, this.endingRecord);
        //increment by 1 to display the startingRecord count, 
        //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
        this.startingRecord = this.startingRecord + 1;
        this.template.querySelector('[data-id="datatable"]').selectedRows = this.selectedRows;
    }
    handleRowSelection(event) {
          debugger;
        let updatedItemsSet = new Set();
        // List of selected items we maintain.
        let selectedItemsSet = new Set(this.selectedRows);
        // List of items currently loaded for the current view.
        let loadedItemsSet = new Set();
       this.newdata.map((ele) => {
            loadedItemsSet.add(ele.Id);
        });
        if (event.detail.selectedRows) {
            event.detail.selectedRows.map((ele) => {
                updatedItemsSet.add(ele.Id);
            });
            // Add any new items to the selectedRows list
            updatedItemsSet.forEach((id) => {
                if (!selectedItemsSet.has(id)) {
                    selectedItemsSet.add(id);
                }
            });
        }
        loadedItemsSet.forEach((id) => {
            if (selectedItemsSet.has(id) && !updatedItemsSet.has(id)) {
                // Remove any items that were unselected.
                selectedItemsSet.delete(id);
            }
        });
        this.selectedRows = [...selectedItemsSet];
        console.log('selectedRows==> ' + JSON.stringify(this.selectedRows));
    }

     handleNext(){
         debugger;
         var selectedrowIdList = this.selectedRows;
         var allproducts = this.completeProductList;
         var selectedProductlist = [];
         for(var i=0; i<allproducts.length; i++){
             if(selectedrowIdList.includes(allproducts[i].Id)){
                 selectedProductlist.push(allproducts[i]);
             }
         }
            this.selectedProdtlist = selectedProductlist;
         this.isProdModalOpen = false;
         this.isShowSelectedProducts = true;
     }
    
    handleCancel(){
        debugger;
        this.isProdModalOpen = false;
       this.dispatchEvent(new CustomEvent('close'));
        this.closeAction();
        
    }

    modalCloseHandler(){
        this.dispatchEvent(new CustomEvent('closedover'));
        this.closeAction();
    }

    closeAction(){
        debugger;
  this.dispatchEvent(new CloseActionScreenEvent());
}

}