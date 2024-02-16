@isTest
private class SyncToOpportunityHelperTest {
    @isTest
    static void testGetOtherQuoteName() {
        // Create test data
        User testUser = UtilityTest.createUserCustomService();
        Account testAccount = UtilityTest.createAccRec('Banoj');
        Opportunity1__c testOpportunity = UtilityTest.CreateOppRecCustomerService('Anwar', testAccount.Id, System.today(), testUser.Id, 'New', 'South');
        Quote_C__c testQuote = new Quote_C__c(Name = 'Testing', OpportunityId__c = testOpportunity.Id);
        insert testQuote;
        
        // Call the method
        String otherQuoteName = SyncToOpportunityHelper.getOtherQuoteName(testQuote.Id);
    }
    
    @isTest
    static void testUpdateIsSyncing() {
        
        User testUser = UtilityTest.createUserCustomService();
        Account testAccount = UtilityTest.createAccRec('Banoj');
        Opportunity1__c testOpportunity = UtilityTest.CreateOppRecCustomerService('Anwar', testAccount.Id, System.today(), testUser.Id, 'New', 'South');
        Quote_C__c testQuote = new Quote_C__c(Name = 'Testing', OpportunityId__c = testOpportunity.Id);
        insert testQuote;
        
        SyncToOpportunityHelper.updateIsSyncing(testQuote.Id, true);
        testQuote = [SELECT Id, IsSyncing__c FROM Quote_C__c WHERE Id = :testQuote.Id];
        
        
    }
    
    @isTest
    static void testSetAsyncToFalse() {
        User testUser = UtilityTest.createUserCustomService();
        Account testAccount = UtilityTest.createAccRec('Banoj');
        Opportunity1__c testOpportunity = UtilityTest.CreateOppRecCustomerService('Anwar', testAccount.Id, System.today(), testUser.Id, 'New', 'South');
        Quote_C__c testQuote = new Quote_C__c(Name = 'Testing', OpportunityId__c = testOpportunity.Id,IsSyncing__c = true);
        insert testQuote;
        
        
        SyncToOpportunityHelper.SetAsyncToFalse(testQuote.Id, false);
        
        testQuote = [SELECT Id, IsSyncing__c FROM Quote_C__c WHERE Id = :testQuote.Id];
        
    }
    
    @isTest
    static void testCreateQuoteLineItem() {
        User testUser = UtilityTest.createUserCustomService();
        Account testAccount = UtilityTest.createAccRec('Banoj');
        Opportunity1__c testOpportunity = UtilityTest.CreateOppRecCustomerService('Anwar', testAccount.Id, System.today(), testUser.Id, 'New', 'South');
        Quote_C__c testQuote = new Quote_C__c(Name = 'Testing', OpportunityId__c = testOpportunity.Id);
        insert testQuote;
        
        
        Product1__c pdt = new Product1__c();
        pdt.Name = 'Test Product';
        pdt.Region__c = 'North';
        pdt.ProductCode__c ='7876869';
        pdt.Family__c = 'Certification';
        pdt.Vertical__c = 'Pharma';
        pdt.IsActive__c = true;
        insert pdt;
        
        List<QuoteLineItems_c__c> qliList = new List<QuoteLineItems_c__c>();
        List<OpportunityLineItem1__c> oliList = new List<OpportunityLineItem1__c>();
        set<Id> setOfQuoteId = new set<Id>(); 
        QuoteLineItems_c__c qli = new QuoteLineItems_c__c();
        qli.ProductId__c = pdt.id;
        qli.QuoteId__c = testQuote.Id;
        qli.Quantity__c = 1;
        qli.List_Price__c = 1000;
        qli.Sales_Price__c = 2000;
        qli.Discount__c = 5;
        qli.Subtotal__c = 1000;
        qli.Total_Price__c = 950;
        qli.QuoteId__c = testQuote.id;
        Insert qli;
       
        qliList.add(qli);
        
        OpportunityLineItem1__c oli = new OpportunityLineItem1__c();
        oli.Opportunity1Id__c = qli.QuoteId__r.OpportunityId__c;
        oli.QuoteLineitemId__c = qli.Id;
        oli.Name = qli.ProductId__r.Name;
        oli.Product1Id__c = qli.ProductId__c;
        oli.ProductCode__c = qli.Product_Code__c;
        oli.Quantity__c = qli.Quantity__c;
        oli.ListPrice__c = qli.Sales_Price__c;
        oli.UnitPrice__c = qli.List_Price__c;
        oli.Discount__c = qli.Discount__c;
        oli.Subtotal__c = qli.Subtotal__c;
        oli.TotalPrice__c = qli.Total_Price__c;
        insert oli;
        oliList.add(oli);        
        
        SyncToOpportunityHelper.createQuoteLineItem(testQuote.Id, true);
        
        List<QuoteLineItems_c__c> quoteLineItems = [SELECT Id FROM QuoteLineItems_c__c WHERE QuoteId__c = :testQuote.Id];
    }
}