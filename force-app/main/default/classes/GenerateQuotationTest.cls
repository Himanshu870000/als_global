@isTest
public class GenerateQuotationTest {
    @isTest
    static void testGenerateSelectedQuotation() {
        
        
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Opportunity1__c opp1 = new Opportunity1__c();
        opp1.Name = 'Test';
        opp1.StageName__c = 'New';
        opp1.CloseDate__c = system.today();
        opp1.Region__c = 'West';
        opp1.AccountId__c = acc.Id;
        Insert opp1;
        
        
        Quote_C__c quoRec = new Quote_C__c();
        quoRec.Name = 'Test';
        quoRec.OpportunityId__c = opp1.Id; 
        insert quoRec;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(quoRec);
        PageReference pageRef = Page.BanglorePharmaPDF; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(quoRec.Id));
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        
        GenerateQuotation.generateSelectedQuatation('Banglore Pharma Template' , quoRec.Id);
        GenerateQuotation.generateSelectedQuatation('Mumbai Pharma Batch Quote',quoRec.Id);
        GenerateQuotation.generateSelectedQuatation('Mumbai Pharma EnL Quote',quoRec.Id);
        GenerateQuotation.generateSelectedQuatation('Mumbai Pharma General Quote',quoRec.Id);
        GenerateQuotation.generateSelectedQuatation('Mumbai Pharma In-Vitro Quote',quoRec.Id);
        
        Test.stopTest();
    }
}