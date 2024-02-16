import { LightningElement } from 'lwc';
export default class Fiscalyearlookup extends LightningElement {
    id;
    //on type we do search record according below marching where clouse
    matchingInfo = {
        primaryField: { fieldPath: "Name" }
    };
    displayInfo = {
        additionalFields: ["Name"],
    };
   
    handleChange(event) {
        debugger;
        console.log(`Selected record: ${event.detail.recordId}`);
      //  this.id = event.detail.recordId;
       const value = event.detail.recordId;

        // const auraEvent = new CustomEvent('sendidtoaura', {
        //         detail: this.id 
        //     });
        //     this.dispatchEvent(auraEvent);
        const auraEvent = new CustomEvent('sendidtoaura', {
            detail: {value}
        });
        this.dispatchEvent(auraEvent);
    }
}