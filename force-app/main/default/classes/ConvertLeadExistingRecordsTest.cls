@isTest
public class ConvertLeadExistingRecordsTest {

    @isTest
    Static Void ConvertLeadExistingRecordsTestMethod(){
        Lead__c ldRec = UtilityTest.createLeadRec('Test','Lead','util','North','util@gmail.com','Pharma');
        ConvertLeadExistingRecords.getinitRecord(ldRec.Id, 'Lead__c', 'Company__c');
        ConvertLeadExistingRecords.gerRecentlyCreatedRecords('Lead__c', 'Company__c', 'Vertical_Segment__c=Pharma', 1);
        ConvertLeadExistingRecords.gerRecentlyCreatedRecords('Lead__c', 'Company__c', '', 1);
        
        ConvertLeadExistingRecords.getLookupValues('Pharma', 'Lead__c', 'Vertical_Segment__c=Pharma', 'Id,Name', 1);
        ConvertLeadExistingRecords.getLookupValues('Pharma', 'Lead__c', '', 'Id,Name', 1);
    }
}