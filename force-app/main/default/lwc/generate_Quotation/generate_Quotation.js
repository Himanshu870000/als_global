import { LightningElement,api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import generateSelectedQuatationPDF from '@salesforce/apex/QuoteHelper.generateSelectedQuatationPDF'; 
import validatePharmaQuote from '@salesforce/apex/QuoteScreenController.validatePharmaQuote'; 
import BanglorePharma from '@salesforce/label/c.ALS_Banglore_Pharma';
import MumbaiPharmaBatchPDFLabel from '@salesforce/label/c.MumbaiPharmaBatchPDFLabel';
import MumbaiPharmaEnlPDFLabel from '@salesforce/label/c.MumbaiPharmaEnlPDFLabel';
import MumbaiPharmaGeneralPDFLabel from '@salesforce/label/c.MumbaiPharmaGeneralPDFLabel';
import MumbaiPharmaInVitroPDFLabel from '@salesforce/label/c.MumbaiPharmaInVitroPDFLabel';
export default class generate_Quotation extends LightningElement {
    @api recordId;
    @track isValidatePharma = false;
    @track isValidateENL = false;
    isShowPDFPreview = false;
    isShowButton = false;
    isShowSaveCancelButton = false;
    isShowButtonHide = true;
    isShowMumbaiPharmaPDF = false;
    isShowBanglorePharmaPDF = false;
    isShowBanglorePharmaPDF1 = false;
    value = '--None--';
    valuem;
    selectedBanValue = 'Banglore Pharma Template';
    PDFNameToDownload;
    get options() {
        debugger;
        return [
            { label: 'For Banglore', value: 'Banglore Pharma Template' },
            { label: 'Mumbai Pharma Template', value: 'Mumbai Pharma Template' },
            
        ];
    }

    get mumbaiOptions() {
        debugger;
        return [
            { label: 'Mumbai Pharma Batch Quote', value: 'Mumbai Pharma Batch Quote' },
            { label: 'Mumbai Pharma EnL Quote', value: 'Mumbai Pharma EnL Quote' },
            { label: 'Mumbai Pharma General Quote', value: 'Mumbai Pharma General Quote' },
            { label: 'Mumbai Pharma In-Vitro Quote', value: 'Mumbai Pharma In-Vitro Quote' }
        ];
    }

    get bangloreOptions() {
        debugger;
        return[
            {label:'For Banglore', value: 'Banglore Pharma Template'}
        ]
    }

    connectedCallback(){
        setTimeout(() => {
            // this.getPDFViewData();
           // alert(this.recordId);
           this.getLabLocation();
        }, 600);
    }

    getLabLocation(){
        debugger;
        validatePharmaQuote({recId:this.recordId}).then((result) => {
            if(result.Lab_Location__c != undefined && result.Lab_Location__c == 'Banglore Lab'){
                this.isShowBanglorePharmaPDF = false;
                this.isShowMumbaiPharmaPDF = false;
                this.isShowBanglorePharmaPDF1 = true;
                this.isShowButton = true;
                this.value == 'Banglore Pharma Template';
            }else if(result.Lab_Location__c != undefined && result.Lab_Location__c == 'Mumbai Lab'){
                this.isShowMumbaiPharmaPDF = true;
                this.isShowBanglorePharmaPDF = false;
                this.isShowBanglorePharmaPDF1 = false;
                this.isShowButton = true;
                this.value == 'Mumbai Pharma Template';
            }else{
                this.isShowBanglorePharmaPDF = true;
                this.isShowButton = true;
            }
        }).catch((err) => {
            console.log(err);
        });
    }

    getPDFViewData() {
        debugger;
        if (this.value == 'Banglore Pharma Template') {
            this.PDFNameToDownload = this.value;
            this.pdfLink = BanglorePharma+this.recordId;
        }
        if (this.selectedBanValue == 'Banglore Pharma Template') {
            this.PDFNameToDownload = this.selectedBanValue;
            this.pdfLink = BanglorePharma+this.recordId;
        }
        if (this.valuem == 'Mumbai Pharma Batch Quote') {
            this.PDFNameToDownload = this.valuem;
            this.pdfLink = MumbaiPharmaBatchPDFLabel+this.recordId;
        }
        if (this.valuem == 'Mumbai Pharma EnL Quote') {
            this.PDFNameToDownload = this.valuem;
            this.pdfLink = MumbaiPharmaEnlPDFLabel+this.recordId;
        }
        if (this.valuem == 'Mumbai Pharma General Quote') {
            this.PDFNameToDownload = this.valuem;
            this.pdfLink = MumbaiPharmaGeneralPDFLabel+this.recordId;
        }
        if (this.valuem == 'Mumbai Pharma In-Vitro Quote') {
            this.PDFNameToDownload = this.valuem;
            this.pdfLink = MumbaiPharmaInVitroPDFLabel+this.recordId;
        }
    }

    HandleChange(event) {
        debugger;
        this.value = event.detail.value;
        if (event.detail.value == 'Mumbai Pharma Template') {
            this.isShowMumbaiPharmaPDF = true;
            this.isShowBanglorePharmaPDF = false;
        } else {
            this.getPDFViewData();
        }
      
        if (this.value != '--None--') {
            this.isShowButton = true;
        } else {
            this.isShowButton = false;
        }
    }

    HandleChangebanglorePharma(event){
        debugger;
        this.selectedBanValue = event.detail.value;
        if (this.selectedBanValue == 'Banglore Pharma Template') {
            this.getPDFViewData();
        }
    }

    HandleChangeMumbaiPharma(event) {
        debugger;
        this.valuem = event.detail.value;
        if (this.valuem == 'Mumbai Pharma Batch Quote') {
            this.getPDFViewData();
        }
        if (this.valuem == 'Mumbai Pharma EnL Quote') {
            this.getPDFViewData();
        }
        if (this.valuem == 'Mumbai Pharma General Quote') {
            this.getPDFViewData();
        }
        if (this.valuem == 'Mumbai Pharma In-Vitro Quote') {
            this.getPDFViewData();
        }


    }

    HandleNextButton() {
        debugger;
        if (this.value == 'Banglore Pharma Template'){
            validatePharmaQuote({recId:this.recordId}).then((result) => {
            if(result.Subject__c == undefined || result.Sample_Quantity__c == undefined || result.TAT__c == undefined|| result.ContactId__c == undefined){
                this.isValidatePharma = true;
                this.isShowButtonHide = false;
            }
            else{
                this.isValidatePharma = false;
                this.isShowPDFPreview = true;
               
                this.isShowButtonHide = false;
            }
        }).catch((err) => {
            console.log(err);
        });
        }
        else if (this.selectedBanValue == 'Banglore Pharma Template'){
            validatePharmaQuote({recId:this.recordId}).then((result) => {
            if(result.Subject__c == undefined || result.Sample_Quantity__c == undefined || result.TAT__c == undefined|| result.ContactId__c == undefined){
                this.isValidatePharma = true;
                this.isShowButtonHide = false;
            }
            else{
                this.isValidatePharma = false;
                this.isShowPDFPreview = true;
                this.selectedBanValue == 'Banglore Pharma Template';
                this.getPDFViewData();
                this.isShowButtonHide = false;
            }
        }).catch((err) => {
            console.log(err);
        });
        }else if (this.valuem == 'Mumbai Pharma Batch Quote'){
        validatePharmaQuote({recId:this.recordId}).then((result) => {
            if(result.Subject__c == undefined || result.Sample_Quantity__c == undefined || result.TAT__c == undefined|| result.ContactId__c == undefined){
                this.isValidatePharma = true;
                this.isShowButtonHide = false;
            }
            else{
                this.isValidatePharma = false;
                this.isShowPDFPreview = true;
                this.isShowButtonHide = false;
            }
        }).catch((err) => {
            console.log(err);
        });
        }else if (this.valuem == 'Mumbai Pharma EnL Quote'){
            validatePharmaQuote({recId:this.recordId}).then((result) => {
            if(result.Subject__c == undefined || result.Sample_Quantity__c == undefined|| result.ContactId__c == undefined){
                this.isValidateENL = true;
                this.isShowButtonHide = false;
            }
            else{
                this.isValidateENL = false;
                this.isShowPDFPreview = true;
                this.isShowButtonHide = false;
            }
        }).catch((err) => {
            console.log(err);
        });
        }else if (this.valuem == 'Mumbai Pharma General Quote'){
            validatePharmaQuote({recId:this.recordId}).then((result) => {
            if(result.Subject__c == undefined || result.Sample_Quantity__c == undefined|| result.ContactId__c == undefined){
                this.isValidateENL = true;
                this.isShowButtonHide = false;
            }
            else{
                this.isValidateENL = false;
                this.isShowPDFPreview = true;
                this.isShowButtonHide = false;
            }
        }).catch((err) => {
            console.log(err);
        });

        }else if(this.valuem == 'Mumbai Pharma In-Vitro Quote'){
            validatePharmaQuote({recId:this.recordId}).then((result) => {
            if(result.Subject__c == undefined || result.Sample_Quantity__c == undefined|| result.ContactId__c == undefined){
                this.isValidateENL = true;
                this.isShowButtonHide = false;
            }
            else{
                this.isValidateENL = false;
                this.isShowPDFPreview = true;
                this.isShowButtonHide = false;
            }
        }).catch((err) => {
            console.log(err);
        });
        }
        
    }

    HandleSumbit() {
        debugger;
        generateSelectedQuatationPDF({ QuotationName: this.PDFNameToDownload, recordId: this.recordId })
            .then((result) => {
                if (result =='SUCCESS') {
                    const event = new ShowToastEvent({
                        title: 'SUCCESS',
                        message: 'Quotation generated Successfully !',
                        variant: 'success',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(event);
                    this.closeQuickAction();
                } else {
                    this.showErrorToast();
                    this.closeQuickAction();
                }
            })
            .catch((error) => {
                this.error = error;
           })
    }

    closeQuickAction() {
        debugger;
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    showToast() {
        const event = new ShowToastEvent({
            title: 'SUCCESS',
            message: 'Quotation generated Successfully !',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
        this.closeQuickAction();
    }

    showErrorToast() {
        const evt = new ShowToastEvent({
            title: 'ERROR',
            message: 'Something went wrong !',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
        
    }

}