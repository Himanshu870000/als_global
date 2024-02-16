/**
 * @author [Dinesh B]
 * @email dinesh.b@utilitarianLab.com
 * @create date 2024-01-17 17:58:55
 * @modify date 2024-01-17 18:18:30
 * @desc [Method for Generating and Downloading Certificate PDF]
 */

import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import generateSelectedCertificationPDF from '@salesforce/apex/CertificationPDFHelper.generateSelectedCertificationPDF';
import validateCertification from '@salesforce/apex/QuoteScreenController.validateCertification';
import CertificationTemplatePDFLabel from '@salesforce/label/c.CertificationTemplatePDFLabel';
import HygieneAuditCertificatePDFLabel from '@salesforce/label/c.HygieneAuditCertificatePDFLabel';
import TrainingTemplateCertificatePDFLabel from '@salesforce/label/c.TrainingTemplateCertificatePDFLabel';
export default class GenerateCertification extends LightningElement {
     @api recordId;
     isValidate = false;
     isShowButtonHide = true;
     isShowButton = false;
     value;
     error;
     get options() {
          debugger;
          return [
              { label: 'Certificate Template', value: 'Certificate Template' },
              { label: 'Training Template Certificate', value: 'Training Template Certificate' },
              { label: 'Hygiene Audit Certificate', value: 'Hygiene Audit Certificate' },
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
          if (this.value == 'Certificate Template') {
              this.PDFNameToDownload = this.value;
              this.pdfLink = CertificationTemplatePDFLabel+this.recordId;
          }
          if (this.value == 'Training Template Certificate') {
              this.PDFNameToDownload = this.value;
              this.pdfLink = TrainingTemplateCertificatePDFLabel+this.recordId;
          }
          if (this.value == 'Hygiene Audit Certificate') {
              this.PDFNameToDownload = this.value;
              this.pdfLink = HygieneAuditCertificatePDFLabel+this.recordId;
          }
     }
     
     HandleSumbit() {
          debugger;
          generateSelectedCertificationPDF({ CertificateName: this.value, recordId: this.recordId })
               .then(result => {
                    if (result == 'SUCCESS') {
                         const event = new ShowToastEvent({
                              title: 'SUCCESS',
                              message: 'Certificate generated Successfully !',
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
           validateCertification({recId:this.recordId}).then((result) => {
               console.log('result is ==>', result);
            if(result.Subject__c == undefined || result.Audit_Scheme__c == undefined || result.Total_sites_to_be_covered__c == undefined || result.Area_Of_The_Units_To_Be_Audited__c == undefined || result.Total_Effective_employees_as_stated_in_E__c == undefined || result.Type_of_Audit__c == undefined || result.Scope_of_Audit__c == undefined || result.ContactId__c == undefined || result.Category_of_FBO__c == undefined){
                this.isValidate = true;
                 this.isShowButtonHide = false;
            }
            else{
                this.isValidate = false;
                this.isShowPDFPreview = true;
                this.isShowButtonHide = false;
            }
        }).catch((err) => {
            console.log(err);
        });
          //this.isShowPDFPreview = true;
         // this.isShowButtonHide = false;
      }
}