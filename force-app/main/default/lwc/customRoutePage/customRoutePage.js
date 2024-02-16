import { LightningElement, wire, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import fetchDependentPicklistValues from '@salesforce/apex/OpportunityHelper.fetchDependentPicklistValues';
import createRouteRecord from '@salesforce/apex/OpportunityHelper.createRouteRecord';
	
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CustomRoutePage extends LightningElement {
    @track typeDependentPicklistWrapperArray;
    @track typeOptions;
    @track ratingOptions;
    @track industryOptions;
    selectedTypeValue;
    selectedRatingValue;
    selectedIndustryValue;
    selectedSalesUserId;
    @track isModalOpen = true;
    data;
    error;

    @wire(fetchDependentPicklistValues, {})
    wiredFetchDependentPicklistValues({ error, data }) {
        if (data) {
            debugger;
            try {
                this.typeDependentPicklistWrapperArray = JSON.parse(data);
                let options = [];
                for (var key in JSON.parse(data)) {
                    options.push({ label: key, value: key });
                }
                this.typeOptions = options;
                this.ratingOptions = undefined;
                this.industryOptions = undefined;
            } catch (error) {
                console.error('check error here', error);
            }
        } else if (error) {
            console.error('check error here', error);
        }
    }

    handleTypeChange(event) {
          debugger;
        try {
            this.selectedRatingValue = undefined;
            this.selectedIndustryValue = undefined;
            this.ratingOptions = undefined;
            this.industryOptions = undefined;
            let options = [];
            this.selectedTypeValue = event.detail.value;
            if (this.typeDependentPicklistWrapperArray) {
                for (var key in this.typeDependentPicklistWrapperArray) {
                    if (this.selectedTypeValue === key) {
                        for (var subkey in this.typeDependentPicklistWrapperArray[key]) {
                            for (var childkey in this.typeDependentPicklistWrapperArray[key][subkey]) {
                                options.push({ label: childkey, value: childkey });
                            }
                        }
                        break;
                    }
                }
                options = options.filter((thing, index) => {
                    const _thing = JSON.stringify(thing);
                    return index === options.findIndex(obj => {
                        return JSON.stringify(obj) === _thing;
                    });
                });
                this.ratingOptions = options;
            }
        } catch (error) {
            console.error('check error here', error);
        }

    }

    handleRatingChange(event) {
          debugger;
        try {
            this.selectedIndustryValue = undefined;
            this.industryOptions = undefined;
            let options = [];
            this.selectedRatingValue = event.detail.value;
            if (this.typeDependentPicklistWrapperArray) {
                for (var key in this.typeDependentPicklistWrapperArray) {
                    if (this.selectedTypeValue === key) {
                        for (var subkey in this.typeDependentPicklistWrapperArray[key]) {
                            for (var childkey in this.typeDependentPicklistWrapperArray[key][subkey]) {
                                if (this.selectedRatingValue === childkey) {
                                    for (var grandchildkey in this.typeDependentPicklistWrapperArray[key][subkey][childkey]) {
                                        options.push({ label: this.typeDependentPicklistWrapperArray[key][subkey][childkey][grandchildkey], value: this.typeDependentPicklistWrapperArray[key][subkey][childkey][grandchildkey] });
                                    }
                                    break;
                                }
                            }
                        }
                    }
                }
                options = options.filter((thing, index) => {
                    const _thing = JSON.stringify(thing);
                    return index === options.findIndex(obj => {
                        return JSON.stringify(obj) === _thing;
                    });
                });
                this.industryOptions = options;
            }
        } catch (error) {
            console.error('check error here', error);
        }

    }

    handleIndustryChange(event) {
          debugger;
        this.selectedIndustryValue = event.detail.value;
    }

    closeAction() {
        debugger;
        this.dispatchEvent(new CloseActionScreenEvent());
     }

    closeModal() {
        debugger;
        this.isModalOpen = false;
    }

    handleChange( event ) {
        debugger;
        this.selectedSalesUserId = event.detail.recordId;
        console.log(event.detail.recordId);
    }

    submitDetails() {
        debugger;
        createRouteRecord({
            State: this.selectedTypeValue,
            city: this.selectedRatingValue,
            routename: this.selectedIndustryValue,
            salesUserId :  this.selectedSalesUserId
        })
            .then(result => {
                if (result) {
                    this.data = result;
                    this.showToast();
                    this.isModalOpen = false;
                    let OrgBaseURL = 'https://page-velocity-4089--alsdev.sandbox.lightning.force.com/lightning/r/Route__c/';
                    window.location.href = OrgBaseURL+this.data.Id+'/view';     
              }
            })
            .catch(error => {
            this.error = error;
              console.log('error == >'+error);
          });

    }

    showToast() {
        const event = new ShowToastEvent({
            title: 'Toast message',
            message: 'Toast Message',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}