import { LightningElement,api,track } from 'lwc';
import getCaseList from '@salesforce/apex/TodayTaskAuraController.getCaseList';

const columns = [
    { label: 'Case Number', fieldName:'caseLink', type:'url',typeAttributes: { label: { fieldName: 'CaseNumber' }, target: '_blank'}  },
    { label: 'Subject', fieldName: 'Subject' },
    { label: 'Origin', fieldName: 'Origin' },
    { label: 'Priority', fieldName: 'Priority'},
    { label: 'Status', fieldName: 'Status' },
];

export default class ShowCaselistonVisit extends LightningElement {
    @api recordId;
    @track caseList=[];
    @track columns =columns;

    connectedCallback(){
        setTimeout(() => {
            this.getCaseRecords();
        }, 300);
    }

    getCaseRecords(){
        getCaseList({recId : this.recordId}).then((result) => {
            if(result){
                result = JSON.parse(JSON.stringify(result));
                result.forEach(res => {
                    res.caseLink = '/' + res.Id;
                });

                this.caseList = result;
                this.error=undefined;
            }
        }).catch((err) => {
            console.log('error foun ==>',err);
        });
    }
}