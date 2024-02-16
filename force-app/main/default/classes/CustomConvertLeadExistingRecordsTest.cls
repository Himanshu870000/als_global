@isTest
public class CustomConvertLeadExistingRecordsTest {

    @isTest
    Static Void CustomConvertLeadExistingTestMethod(){
        Lead__c ldRec = UtilityTest.createLeadRec('Test','Lead','util','North','util@gmail.com','Pharma');
        
        CustomConvertLeadExistingRecords.getLookupValues('Pharma', 'Lead__c', 'Vertical_Segment__c=Pharma', 'Id,Name', 1);
        CustomConvertLeadExistingRecords.getLookupValues('Pharma', 'Lead__c', '', 'Id,Name', 1);
        
        CustomConvertLeadExistingRecords.getinitRecord(ldRec.Id, 'Lead__c', 'Company__c');
        
        CustomConvertLeadExistingRecords.gerRecentlyCreatedRecords('Lead__c', 'Company__c', 'Vertical_Segment__c=Pharma', 1);
        CustomConvertLeadExistingRecords.gerRecentlyCreatedRecords('Lead__c', 'Company__c', '', 1);
    }
}