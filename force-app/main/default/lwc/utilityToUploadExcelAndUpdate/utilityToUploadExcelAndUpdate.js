import { LightningElement, api, wire, track } from 'lwc';
import CreateSampleUpdateRecords from '@salesforce/apex/UtilityToUploadExcelAndUpdateController.CreateSampleUpdateRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class UtilityToUploadExcelAndUpdate extends LightningElement {
    file;
    quotNames;
    // @track ExcelFormat=[{'Quote_Name__c':'','Label_Site__c':'','Department__c':'','Company__c':'','Customer_Site_ID__c':'','Sample_ID__c':'','Sample_Type__c':'','Date_Created__c':'','Testing_Started__c':'','Project_CreatedBy__c':'','Sample_Description__c':'','Test_Id__c':'','Test_Name__c':'','Sample_Status__c':'','Test_Status__c':'','Date_Approved__c':'','Test_ID_Discipline__c':'','Test_ID_Technique__c':'','Test_ID_Price__c':'','CurrencyIsoCode':'','Test_Due_Date__c':'','Sample_Due_Date__c':'','Final_Supplementary_Certificate_Created__c':'','First_Certificate_Approved__c':'','Final_Supplementary_Certificate_Approved__c':'','Final_Supplementary_Certificate_Sent__c':'','TAT_in_ALIMS__c':'','Invoice_Issued__c':'','BusinessManager__c':''}];
    @track ExcelFormat = [{ 'Quote_Name__c': '', 'Label_Site__c': '', 'Department__c': '', 'Company__c': '', 'Customer_Site_ID__c': '', 'Sample_ID__c': '', 'Sample_Type__c': '', 'Project_CreatedBy__c': '', 'Sample_Description__c': '', 'Test_Id__c': '', 'Test_Name__c': '', 'Sample_Status__c': '', 'Test_Status__c': '', 'Date_Approved__c': '', 'Test_ID_Discipline__c': '', 'Test_ID_Technique__c': '', 'Test_ID_Price__c': '', 'CurrencyIsoCode': '', 'Final_Supplementary_Certificate_Created__c': '', 'First_Certificate_Approved__c': '', 'Final_Supplementary_Certificate_Approved__c': '', 'Final_Supplementary_Certificate_Sent__c': '', 'TAT_in_ALIMS__c': '', 'Invoice_Issued__c': '', 'BusinessManager__c': '' }];
    handleInputChange(event) {
        debugger;
        if (event.target.files.length > 0 && event.target.files[0].size > 0) {

            //this.ligtningAlertOnUpload();
            this.file = event.target.files[0];
            this.read(this.file);

        };

    }

    async read(file) {
        debugger;
        try {
            const result = await this.load(file);
            this.parse(result);
        } catch (e) {
            this.error = e;
            console.error('error=>', e);
        }
    }

    async load(file) {
        debugger;
        return new Promise((resolve, reject) => {
            const reader = new FileReader();

            reader.onload = () => {
                resolve(reader.result);
            };
            reader.onerror = () => {
                reject(reader.error);
            };
            reader.readAsText(file);
        });
    }

    @track Csvdata = [];

    parse(csv) {
    const lines = csv.split(/\r\n|\n/);
    const headers = lines[0].split(',');
    const data = [];

    // Define datetime fields
    const datetimeFields = ['Date_Created__c', 'Schedule_Date__c', 'Date_Approved__c', 'Test_Due_Date__c', 'Sample_Due_Date__c', 'Testing_Started__c', 'Invoice_Issued__c'];

    lines.forEach((line, i) => {
        if (i === 0) return;
        if (line == '' || line.includes(',,,') || line.trim() === '') return;
        
        const obj = {};
        const currentline = line.split(',');

        for (let j = 0; j < headers.length; j++) {
            const fieldName = headers[j];

            // Check if the current field is a datetime field
            if (datetimeFields.includes(fieldName)) {
                let dateTimeString = currentline[j];
                // Assuming DateTimeField is the name of your datetime field
                if (dateTimeString) {
                    let parsedDate = new Date(dateTimeString);
                    if (!isNaN(parsedDate.getTime())) {
                        obj[fieldName] = parsedDate.toISOString();
                    } else {
                        console.error('Invalid date string:', dateTimeString);
                        obj[fieldName] = null; // or handle the error appropriately
                    }
                } else {
                    obj[fieldName] = null; // Handle empty date strings if needed
                }
            } else {
                obj[fieldName] = currentline[j];
            }
        }
        data.push(obj);
    });

    console.log('dataUpdated=', JSON.stringify(data));

    this.Csvdata = data;
    if (this.Csvdata.length > 0) {
        this.handleSubmit(this.Csvdata);
    }
}




    handleSubmit(ArrayList) {
        console.log('data in Csvdata after onclick=', JSON.stringify(this.Csvdata));

        debugger;
        CreateSampleUpdateRecords({ sampleUpdateList: ArrayList })
            .then(result => {
                if (result == 'SUCCESS') {

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Sample Update Records Created successfully..',
                            variant: 'success',
                        }),
                    );
                }
                else {

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'error',
                            message: 'error',
                            variant: 'error',
                        }),
                    );
                }
            })
            .catch(error => {
                window.alert(error);
                console.log('error in Comp=', error);

            })
    }

    ligtningAlertOnUpload() {
        LightningAlert.open({
            message: 'This is the alert message.',
            theme: 'Success', // a red theme intended for error states
            label: 'Uploading!', // this is the header text
        });
    }

    //DownLoad Data IN CSV Foramt

    HandleDownLoad() {
        debugger;
        let rowEnd = '\n';
        let csvString = '';
        // this set elminates the duplicates if have any duplicate keys
        let rowData = new Set();

        // getting keys from data
        this.ExcelFormat.forEach(function (record) {
            Object.keys(record).forEach(function (key) {
                rowData.add(key);
                console.log('rowData=' + rowData);
            });
        });

        // Array.from() method returns an Array object from any object with a length property or an iterable object.
        rowData = Array.from(rowData);
        console.log('rowData in array Form=' + rowData);

        // splitting using ','
        csvString += rowData.join(',');
        console.log('csvString with JoinMethod=' + csvString);

        csvString += rowEnd;
        console.log('csvString with rowEndVariable=' + csvString);

        // main for loop to get the data based on key value
        for (let i = 0; i < this.ExcelFormat.length; i++) {
            let colValue = 0;

            // validating keys in data
            for (let key in rowData) {
                if (rowData.hasOwnProperty(key)) {
                    // Key value 
                    // Ex: Id, Name
                    let rowKey = rowData[key];
                    console.log('rowKey Values=' + rowKey);
                    // add , after every value except the first.
                    if (colValue > 0) {
                        csvString += ',';
                        console.log('csvString with ,=' + csvString);
                    }
                    // If the column is undefined, it as blank in the CSV file.
                    let value = this.ExcelFormat[i][rowKey] === undefined ? '' : this.ExcelFormat[i][rowKey];
                    csvString += '"' + value + '"';
                    console.log('csvString After adding Value=' + csvString);
                    colValue++;
                }
            }
            csvString += rowEnd;
        }

        // Creating anchor element to download
        let downloadElement = document.createElement('a');

        // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
        downloadElement.target = '_self';
        // CSV File Name
        downloadElement.download = 'Sample Update.csv';
        // below statement is required if you are using firefox browser
        // document.body.appendChild(downloadElement);
        // click() Javascript function to download CSV file
        downloadElement.click();
    }
}