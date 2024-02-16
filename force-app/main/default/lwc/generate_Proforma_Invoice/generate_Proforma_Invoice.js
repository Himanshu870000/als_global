/**
 * @author [Navneet Shukla]
 * @create date 2024-01-21 17:58:55
 * @modify date 2024-01-21 18:18:30
 * @desc [Method for Generating and Downloading Proforma Invoice PDF]
 */

import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import generateSelectedProformaInvoice from '@salesforce/apex/PerformaInvoiceController.generateSelectedProformaInvoice';
import Banglore_Proforma_Invoice_Label from '@salesforce/label/c.Banglore_Proforma_Invoice_Label';
import Mumbai_Proforma_invoice_Label from '@salesforce/label/c.Mumbai_Proforma_invoice_Label';
export default class GenerateCertification extends LightningElement {
     @api recordId;
     isShowButtonHide = true;
     isShowButton = false;
     value;
     error;
     get options() {
          debugger;
          return [
              { label: 'Bangalore Proforma Invoice', value: 'Bangalore Proforma Invoice' },
              { label: 'Mumbai Proforma Invoice', value: 'Mumbai Proforma Invoice' },
          ];
      }
     
     HandleChangeCertificate(event) {
          debugger;
          this.value = event.detail.value;
          if (this.value != null && this.value != undefined) {
                    this.getPDFViewData();
               this.isShowButton = true;
          } else {
               this.isShowButton = false;
          }
     }

     getPDFViewData() {
          debugger;
          if (this.value == 'Bangalore Proforma Invoice') {
              this.PDFNameToDownload = this.value;
              this.pdfLink = Banglore_Proforma_Invoice_Label+this.recordId;
          }
          if (this.value == 'Mumbai Proforma Invoice') {
              this.PDFNameToDownload = this.value;
              this.pdfLink = Mumbai_Proforma_invoice_Label+this.recordId;
          }
     }
     
     HandleSumbit() {
          debugger;
          generateSelectedProformaInvoice({ InvoiceName: this.value, recordId: this.recordId })
               .then(result => {
                    if (result == 'SUCCESS') {
                         const event = new ShowToastEvent({
                              title: 'SUCCESS',
                              message: 'Proforma Invoice generated Successfully !',
                              variant: 'success',
                              mode: 'dismissable'
                          });
                          this.dispatchEvent(event);
                          this.closeQuickAction();
                    } else {
                         const event = new ShowToastEvent({
                              title: 'ERROR',
                              message: 'Something went Wrong !',
                              variant: 'error',
                              mode: 'dismissable'
                          });
                          this.dispatchEvent(event);
                          this.closeQuickAction();
                    }
               })
               .catch(error => {
                    this.error = error;
              })
     }

     closeQuickAction() {
          debugger;
          this.dispatchEvent(new CloseActionScreenEvent());
     }
     HandleNextButton() {
          debugger;
          this.isShowPDFPreview = true;
          this.isShowButtonHide = false;
      }
}