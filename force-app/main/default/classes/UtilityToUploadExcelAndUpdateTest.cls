@isTest
public class UtilityToUploadExcelAndUpdateTest {

    @isTest
    Static Void UtilityToUploadExcelAndUpdateTestMethod(){
        List<Sample_Update__c> sampleUpdateList = new List<Sample_Update__c>();
        
        User useRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        Contact conRec = UtilityTest.createConRec('test', 'contact');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Test Quote', accRec.id, System.today(), useRec.id, 'New', 'South');
        Quote_C__c quoteRec = UtilityTest.createQuoteRec(accRec.Id,'Test','Test Description','Draft', conRec.Id,oppRec.Id);
        Sample_Update__c suRec = UtilityTest.createSuRec(oppRec.Id,'Test/1','Test Description',useRec.id);
        sampleUpdateList.add(suRec);
        
        UtilityToUploadExcelAndUpdateController.CreateSampleUpdateRecords(sampleUpdateList);
    }
}