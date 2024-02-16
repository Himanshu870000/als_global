import { LightningElement,api,wire,track} from 'lwc';
import getAllAddresses from "@salesforce/apex/CreateOpportunityOnAccount.getAllCustomerAddress";
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import getUpdateOpportunityAccountAddresss from "@salesforce/apex/CreateOpportunityOnAccount.UpdateOpportunityAccountAddresss";
import updateTaskStatusAfterAddress from "@salesforce/apex/updateTaskStatusController.updateTaskStatusAfterAddress";
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import BaseURLOpportunity from '@salesforce/label/c.BaseURLOpportunity';
export default class CreateOpportunityOnAccount extends NavigationMixin(LightningElement) {
    @api recordId;
    selectedAddressIndex = -1;
    selectedBilAddressIndex = -1;
    @track ship_addresses = [];
    @track bill_addresses = [];
    @track ShippingAddressId;
    @track BillingAddressId;
    error;
    @track checkedShipAdd;
    @track checkedBillAdd
    @track accRecord;
    //@track oppRecord;
    @track nextBtn = true;
    llcUser = false;
    
    connectedCallback(){
        setTimeout(() => {
            this.getRecordDetails();
        }, 300);
    }

    getRecordDetails(){
        debugger;
        getAllAddresses({custId : this.recordId}).then(data => {
            if(data){
                debugger;
                let clonedData = JSON.parse(JSON.stringify(data));
                this.accRecord = clonedData.account;
                //this.oppRecord = clonedData.opp;
                this.ship_addresses = clonedData.customer_ship_addresses;
                this.bill_addresses = clonedData.customer_bill_addresses;
                this.selectedAddressIndex = clonedData.ship_selected_index != undefined ? clonedData.ship_selected_index : -1;
                this.selectedBilAddressIndex = clonedData.bill_selected_index != undefined ? clonedData.bill_selected_index : -1;
                if (this.ship_addresses && this.ship_addresses.length === 1) {
                    this.ship_addresses[0].checked = true;
                    this.checkedShipAdd = true;
                }
                if (this.bill_addresses && this.bill_addresses.length === 1) {
                    this.bill_addresses[0].checked = true;
                    this.checkedBillAdd = true;
                }
                console.log('RecordId', this.recordId);
                console.log('Data',clonedData);
                if(this.ship_addresses && this.bill_addresses ){
                    this.nextBtn = false;
                }else{
                    this.nextBtn = true;
                }
            }
       })
    }

    onAddressSelect(event) {
        debugger;
        let addressId = event.currentTarget.dataset.id;
      //   let Value = event.target.value;
        let selectedIndex = event.currentTarget.dataset.index;
         this.checkedShipAdd = event.target.checked;
         if(this.checkedBillAdd==undefined){
              this.checkedBillAdd=true;
          }   
        if(addressId && selectedIndex ) {
            if(this.selectedAddressIndex !== -1)
                this.ship_addresses[this.selectedAddressIndex].checked = false;
            this.ship_addresses[selectedIndex].checked = true;
            this.selectedAddressIndex = selectedIndex;
          //  this.nextBtn = false; // added
        }
         if(this.checkedShipAdd &&  this.checkedBillAdd ){
                this.nextBtn = false;
        }else{
              this.nextBtn = true;
        }
        
        
    }

    onBillAddressSelect(event) {
        debugger;
        let addressId = event.currentTarget.dataset.id;
        let selectedIndex = event.currentTarget.dataset.index;
         this.checkedBillAdd = event.target.checked;   
          if(this.checkedShipAdd==undefined){
              this.checkedShipAdd=true;
          }
        if(addressId && selectedIndex ) {
            if(this.selectedBilAddressIndex !== -1)
                this.bill_addresses[this.selectedBilAddressIndex].checked = false;
            this.bill_addresses[selectedIndex].checked = true;
            this.selectedBilAddressIndex = selectedIndex;
          //   this.nextBtn = false; 
        }
         if(this.checkedShipAdd &&  this.checkedBillAdd ){
                this.nextBtn = false;
        }else{
              this.nextBtn = true;
        }
    }



    handleNavigate() {
        debugger;
        let index = this.ship_addresses.findIndex((item) => {
            return item.checked === true;
        });

        let billingIndex = this.bill_addresses.findIndex((item) => {
            return item.checked === true;
        });
        if(index === -1 || billingIndex === -1) {
            const evt = new ShowToastEvent({
                title: "No Selection",
                message: "Please select Shipping and Billing address in-order to proceed.",
                variant: "Warning",
            });
            this.dispatchEvent(evt);
            return;
        }

        let selectedAddress = this.ship_addresses[index];
        
        let shippaddressId = selectedAddress.id;

        if(shippaddressId !=undefined){
            this.ShippingAddressId = shippaddressId;
        }
        let accShipAddress = false;

        let selectedBillingAddress = this.bill_addresses[billingIndex];
        let billAddressId = selectedBillingAddress.id;

        if(billAddressId !=undefined){
            this.BillingAddressId = billAddressId;
        }

        let accountBillAddress = false;
        
        if(selectedAddress.id === 'Shipping') {
           // addressId = undefined;
            accShipAddress = true;
        }
        
        if(selectedBillingAddress.id === 'Billing') {
          //  billAddressId = undefined;
            accountBillAddress = true;
        }
        
        // if(selectedAddress.state != null && selectedAddress.city != null && selectedAddress.country != null && selectedAddress.street != null && selectedAddress.postalCode != null &&
        //           selectedBillingAddress.state != null && selectedBillingAddress.city != null && selectedBillingAddress.country && selectedBillingAddress.postalCode != null && selectedBillingAddress.street != null){
        //      //Console.log('Success');
        //       this.openCreateRecordForm(addressId, accShipAddress, billAddressId, accountBillAddress);
        // }else{
        //     alert('Selected Address should save the all data');
            
        // }

     this.updateOpportunityAccAddress();
     this.updateTask();
        
    
      //  this.openCreateRecordForm(addressId, accShipAddress, billAddressId, accountBillAddress);
    }    

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
   
     updateOpportunityAccAddress(){
         debugger;
    getUpdateOpportunityAccountAddresss({oppId : this.recordId,shippindId:this.ShippingAddressId,billingId:this.BillingAddressId})
       .then(result =>{
            const event = new ShowToastEvent({
            title: 'SUCCESS',
            message: 'Address Updated Successfully !',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
        //    var BaseURL = BaseURLOpportunity;
        //    location.replace(BaseURL + this.recordId);
           window.location.href = BaseURLOpportunity+this.recordId+'/view';
       // window.location.reload();
       })
       .catch(error =>{
        this.error = error;
        const evt = new ShowToastEvent({
            title: 'ERROR',
            message: this.error,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
       })
     }

    updateTask(){
        debugger;
         updateTaskStatusAfterAddress({recId:this.recordId, billAddress:this.BillingAddressId, shipAddress:this.ShippingAddressId}).then((result) => {
         console.log(result);
     }).catch((err) => {
         console.log(err);
     });
    }
    
  
}