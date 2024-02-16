@isTest
public class PerformaInvoiceControllerTest {
    @isTest static void testNameDetails(){
        
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Opportunity1__c opp1 = new Opportunity1__c();
        opp1.Name = 'Test';
        opp1.StageName__c = 'New';
        opp1.CloseDate__c = system.today();
        opp1.Region__c = 'West';
        Opp1.AccountId__c = acc.Id;
        Insert opp1;
        
        OpportunityLineItem1__c opl1 = new OpportunityLineItem1__c();
        opl1.Name = 'Rohit';        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp1);
        PageReference pageRef = Page.BangloerePerfomaInvoice; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(opp1.Id));
        Test.setCurrentPage(pageRef);
            
        Test.startTest();
        
        PerformaInvoiceController pdf1 = new PerformaInvoiceController(sc);
        PerformaInvoiceController.generateSelectedProformaInvoice('Bangalore Proforma Invoice',opp1.Id);
        PerformaInvoiceController.generateSelectedProformaInvoice('Mumbai Proforma Invoice',opp1.Id);
        Test.stopTest();
        
    }
}