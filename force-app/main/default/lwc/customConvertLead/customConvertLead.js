import { LightningElement,api,track, wire } from 'lwc';
import getLeadDetails from '@salesforce/apex/CustomLeadMappingHandler.getLeadDetails';
import createRecords from '@salesforce/apex/CustomLeadMappingHandler.createRecords';
import getopportunityData from '@salesforce/apex/CustomLeadMappingHandler.getopportunityData';
import UpdateleadStatus from '@salesforce/apex/CustomLeadMappingHandler.UpdateleadStatus';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createExistingAccount_Contact_Opportunity from '@salesforce/apex/CustomLeadMappingHandler.createExistingAccount_Contact_Opportunity';
import checkDuplicateAccountContactOpportunity from '@salesforce/apex/CustomLeadMappingHandler.checkDuplicateAccountContactOpportunity';
import OrgBaseURL from '@salesforce/label/c.OrgBaseURL'; 

export default class CustomConvertLead extends LightningElement {
OrgBaseURL = OrgBaseURL;
value = '';
activeSectionMessage = '';
@track selectedValue1 = 'New';
@track selectedValue2 = 'New'
@track selectedValue3 = 'New'
@track selectedValue4 = ''
@track selectedValue5 = ''
@track selectedValue6 = ''
comValues = 'Mr.';
OppValues = 'Installation';
convertValues = 'Closed-Converted';
showDuplicateErrorPanel = false;
errorMessageDuplicate;
doNotCreateOpp;
leadRecordOwnerName;
@track salutation;
@track leads = [];
@track updateLeadsData = [];
@api recordId;
@track acckey='';
@track conkey='';
@track oppResults = [];
@track contactId;
@track accountId;
@track searchTerm = '';
@track searchResults = [];
@api iconName2 = 'standard:contact';
@track oppRecords = false;
@track oppSize;
@track error;
@track results;
@track selectedOpportunityId;
checkDuplicateMessage;
    isLeadDetailsChanged = false;     
    successdata;

handleToggleSection(event) {
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
    }

    get options1() {
        return [
            { label: 'Create New', value: 'New' },
        ];
    }
    get options2() {
        return [
            { label: 'Create New', value: 'New' },
        ];
    }
    get options3() {
        return [
            { label: 'Create New', value: 'New' },
        ];
    }
    get options4() {
        return [
            { label: 'Choose Existing', value: 'Exist' },
        ];
    }
    get options5() {
        return [
            { label: 'Choose Existing', value: 'Exist' },
        ];
    }
    get options6() {
        return [
            { label: 'Choose Existing', value: 'Exist' },
        ];
    }

    get comOptions() {
        return [
            { label: 'Mr.', value: 'Mr.' },
            { label: 'Ms.', value: 'Ms' },
            { label: 'Mrs.', value: 'Mrs' },
            { label: 'Dr.', value: 'Dr' },
            { label: 'Prof.', value: 'prof' },
        ];
    }

    get OppOptions(){
        return [
            { label: 'Installation', value: 'Installation' },
            { label: 'Utility Opportunity', value: 'Utility Opportunity' },
            { label: 'New Sale', value: 'New Sale' },
        ]
    }
     
    get ConvertOptions(){
        return [
            {label:'Closed-Converted', value:'Closed-Converted'},
        ]
    }
     
     connectedCallback() {
          debugger;
          setTimeout(() => {
               console.log("record Id == >" + this.recordId);  
               this.CallMethodgetLeadDetails();
          }, 300);
     }

     CallMethodgetLeadDetails() {
          debugger;
          getLeadDetails({ recordId: this.recordId })
               .then(result => {
                    if (result) {
                         this.leads = result;
                        this.leadRecordOwnerName = result[0].Owner.Name
               }
               })
               .catch(error => {
                    this.error = error;
          })
     }

     handleTodoChange(event) {
          debugger;
          var checkValue = event.target.checked;
          this.doNotCreateOpp = checkValue;
     }

    handleChange(event){
        debugger;
        this.salutation = event.target.value;
    }

    hanldeProgressValueChange(event) {
        debugger;
         this.accountId = event.detail;
        // Implement logic to handle the selected account in the parent component
        console.log('Selected Account Id:', this.accountId);
        this.handleOppoRecords();
        this.oppRecords = true;
    }

    handleOppoRecords(){
        debugger;
    getopportunityData({accountId:this.accountId})
        .then((result) => {
            //this.oppResults = result;
             this.oppSize = result.length;
             var tempoppObj = [];
             for (var i = 0; i<result.length; i++){
                  var tempobj = {
                       oppname : result[i].Name,
                       accname: result[i].AccountId__r.Name,
                       closedate: result[i].CloseDate__c,
                       amount: result[i].Amount__c,
                       ownername: result[i].AccountId__r.Owner.Name,
                       Id : result[i].Id,
                       cheked : false
                  };
                  tempoppObj.push(tempobj);
             }
             this.oppResults = tempoppObj;

            this.error = undefined;
        }).catch((err) => {
            this.oppResults = undefined;
            this.error = err;
        });
    }

    hanldeContactValueChange(){
        debugger;
        this.contactId = event.detail;
    }

    handleKeyDown(event) {
        debugger;
    if (event.key === 'Backspace') {
        this.handleBackspace();
    }
}

    handleBackspace(){
        debugger;
        if(this.searchResults && this.searchTerm && this.searchTerm.length>0){
            this.searchResults = this.searchResults.filter(
                account => account.Name.toLowerCase().includes(this.searchTerm.toLowerCase())
            );
        }
    }


    handleRadio1ChangeAccountNew(){
        debugger;
       this.selectedValue4='';
       this.selectedValue1='New';
    }

    handleRadio4ChangeExistingAccount() {
         // Existing Account
        debugger;
       this.selectedValue1='';
       this.selectedValue4='Exist';
    }

    handleRadio2ChangeContactNew(){
        debugger;
       this.selectedValue5='';
       this.selectedValue2='New';
    }

    handleRadio5ChangeExistingContact() {
          // Existing Contact
        debugger;
       this.selectedValue2='';
       this.selectedValue5='Exist';
    }
    handleRadio3ChangeOpportunityNew(){
        debugger;
       this.selectedValue6='';
       this.selectedValue3='New';
    }

     handleRadio6ChangeExistingOpportunity() {
           // Existing Opportunity Custom
        debugger;
       this.selectedValue3='';
       this.selectedValue6='Exist';
    } 

    handleInputChange(event){
         debugger;
         // selected Opportunity Record custom

         const selectedOppId = event.currentTarget.dataset.id;
        // this.selectedOpportunityId = selectedOppId;
         for (var i = 0; i < this.oppResults.length; i++){
              if (this.oppResults[i].Id === selectedOppId) {
               this.oppResults[i].cheked = true;
              } else {
               this.oppResults[i].cheked = false;
              }
         }
    }

     
     onChangeValue(event) {
          debugger;
          var tempArray = [];
          var tempLeaDdata = this.leads;
          for (var i = 0; i < tempLeaDdata.length; i++) {
               if (event.target.name == 'company') {
                    if (tempLeaDdata[i].Company__c != event.target.value) {
                         var companame = event.target.value;
                         this.isLeadDetailsChanged = true;
                    } else {
                         companame = tempLeaDdata[i].Company__c;
                    }   
               } else {
                    companame = tempLeaDdata[i].Company__c;
               }
               
               if (event.target.name == 'firstname') {
                    if (tempLeaDdata[i].First_Name__c != event.target.value) {
                         var firstname = event.target.value;
                         this.isLeadDetailsChanged = true;
                    } else {
                         firstname = tempLeaDdata[i].First_Name__c;
                    }   
               } else {
                    firstname = tempLeaDdata[i].First_Name__c;
               } 

               if (event.target.name == 'lastname') {
                    if (tempLeaDdata[i].Name != event.target.value) {
                         var lastname = event.target.value;
                         this.isLeadDetailsChanged = true;
                    } else {
                         lastname = tempLeaDdata[i].Name;
                    }   
               } else {
                    lastname = tempLeaDdata[i].Name;
               }
               var ownerName = tempLeaDdata[i].Owner.Name;
               var tempObj = {
                    Company__c: companame,
                    First_Name__c: firstname,
                    Name: lastname,
                    OwnerName : ownerName
               };
               tempArray.push(tempObj);
          }
          console.log("Record data ==== >" + tempArray);
        //  this.leads = tempArray;
          this.updateLeadsData = tempArray;
     }
     
    handleConvert() {
         debugger;
         
         // for Duplicate Record
         checkDuplicateAccountContactOpportunity({ recordId: this.recordId })
              .then(result => {
               if (result) {
                    this.errorMessageDuplicate = result;
                    this.showDuplicateErrorPanel = true;
                    return;
               } else {
                    this.showDuplicateErrorPanel = false;
                    if (this.selectedValue1 == 'New' && this.selectedValue2 == 'New' && this.selectedValue3 == 'New') { 
                         this.createDefaultNewLeadConvert();
                    }
                        // Existing Account,New Contact & Existing Opportunity
         if (this.selectedValue4 == 'Exist' && this.selectedValue2 == 'New' && this.selectedValue6 == 'Exist') {
          var combination1 ='ExistingAccountNewContactExistingOpportunity'
          createExistingAccount_Contact_Opportunity({ accountId: this.accountId, companame: '', firstname: this.leads[0].First_Name__c, lastname: this.leads[0].Name,combinationName : combination1,contactId : '' })
               .then(result => {
                    if (result) {
                     this.updateLd();   
                     this.showToast();
                    this.dispatchEvent(new CloseActionScreenEvent());
                    window.location.href = this.OrgBaseURL+this.recordId+'/view'; 
                }
               })
               .catch(error => {
                this.error = error;
          })
     }

      // New Account,Existing Contact & New Opportunity
     if (this.selectedValue1 == 'New' && this.selectedValue5 == 'Exist' && this.selectedValue3 == 'New') {
          var combination2 = 'NewAccountExistingContactNewOpportunity';
          createExistingAccount_Contact_Opportunity({ accountId: '', companame: this.leads[0].Company__c, firstname: '', lastname: '', opportunityId: '', combinationName: combination2, contactId: this.contactId })
               .then(result => {
                    if (result) {
                     this.updateLd();   
                     this.showToast();
                    this.dispatchEvent(new CloseActionScreenEvent());
                    window.location.href = this.OrgBaseURL+this.recordId+'/view';     
                    }
               })
               .catch(error => {
                    this.error = error;
               })
           }
               }
              })
              .catch(error => {
                   this.error = error;
              })   
        }

    updateLead(){
        debugger;
        UpdateleadStatus({LeadId:this.recordId})
        .then((result) => {
           this.showToast(); 
        }).catch((err) => {
            
        });
    }

    // Method for Creating Default New Account,Contact and Opportunity Record
    createDefaultNewLeadConvert(){
        debugger;
         if (this.selectedValue1 == 'New') {
              if (this.isLeadDetailsChanged == true) {
               createRecords({
                    accName:this.updateLeadsData[0].Company__c,
                    Salutation:this.salutation, 
                    conFirst_Name__c:this.updateLeadsData[0].First_Name__c, 
                    conLastName:this.updateLeadsData[0].Name,
                    oppname:this.updateLeadsData[0].Company__c, 
                     ownerName: this.leadRecordOwnerName,
                     leadId : this.recordId
               }).then((result) => {
                   debugger;
                         this.successdata = result;
                         this.updateLd();   
                         this.showToast();
                         this.dispatchEvent(new CloseActionScreenEvent());
                         window.location.href = this.OrgBaseURL+this.recordId+'/view'; 
                    }).catch((err) => {
                        console.log(err);
                    });
              } else {
               createRecords({
                    accName:this.leads[0].Company__c,
                    Salutation:this.salutation, 
                    conFirst_Name__c:this.leads[0].First_Name__c, 
                    conLastName:this.leads[0].Name,
                    oppname:this.leads[0].Company__c, 
                     ownerName: this.leadRecordOwnerName,
                     leadId : this.recordId
               }).then((result) => {
                this.successdata = result;
                         this.updateLd();   
                         this.showToast();
                         this.dispatchEvent(new CloseActionScreenEvent());
                         window.location.href = this.OrgBaseURL+this.successdata+'/view'; 
                    }).catch((err) => {
                        console.log(err);
                    });
              }
      
        }
    }
     
     updateLd() {
          UpdateleadStatus({ recordId: this.recordId })
          .then((result) => {
               console.log(result);
          }).catch((err) => {
               console.log(err);
           });
     }

    showToast() {
        const event = new ShowToastEvent({
            title: 'Success',
            message: 'Record has been Created Successfully',
            variant: 'success',
        });
        this.dispatchEvent(event);
    }

     handleCancel() {
        debugger;
          this.dispatchEvent(new CloseActionScreenEvent());
    }
    closeQuickAction() {
     debugger;
     this.dispatchEvent(new CloseActionScreenEvent());
 }
}