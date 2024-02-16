import { LightningElement } from 'lwc';
import getFieldSet from "@salesforce/apex/CreateOpportunityOnAccount.getFieldSet";
export default class CustomOpportunityRecordForm extends LightningElement {
error;
data;

    connectedCallback(){
        this.callApexMethod();
   }    

callApexMethod(){
    debugger;
    getFieldSet()
    .then(result => {
        if (result){
            this.data = result;
        }
    })

    .catch(error => {
        this.error = error;
    })
}
}