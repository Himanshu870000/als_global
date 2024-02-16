@isTest
public class QuoteLineItemSyncHandlerTest {
    @isTest
    static void testHandleQuoteLineItemChanges() {
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
        
         Product1__c pdt = new Product1__c();
        pdt.Name = 'Test Product';
        pdt.Region__c = 'North';
        pdt.ProductCode__c ='7876869';
        pdt.Family__c = 'Certification';
        pdt.Vertical__c = 'Pharma';
        pdt.IsActive__c = true;
        insert pdt;
        
        
        Quote_C__c quoRec = new Quote_C__c();
        quoRec.Name = 'Test';
         quoRec.OpportunityId__c = opp1.Id;
        quoRec.IsSyncing__c = true;
        insert quoRec;
        
        List<QuoteLineItems_c__c> qliList = new List<QuoteLineItems_c__c>();
        List<QuoteLineItems_c__c> qliList1 = new List<QuoteLineItems_c__c>();
        List<OpportunityLineItem1__c> oliList = new List<OpportunityLineItem1__c>();
        set<Id> setOfQuoteId = new set<Id>(); 
        QuoteLineItems_c__c qli = new QuoteLineItems_c__c();
        qli.ProductId__c = pdt.id;
        qli.QuoteId__c = quoRec.Id;
        qli.Quantity__c = 1;
        qli.List_Price__c = 1000;
        qli.Sales_Price__c = 2000;
        qli.Discount__c = 5;
        qli.Subtotal__c = 1000;
        qli.Total_Price__c = 950;
        Insert qli;
        qliList.add(qli);
        qli.List_Price__c = 3000;
        qli.Sales_Price__c = 6000;
        qli.Discount__c =85;
        qli.Subtotal__c = 1080;
        qli.Total_Price__c = 990;
        Update qli;
        qliList1.add(qli);
        /*setOfQuoteId.add(qli.QuoteId__c);
        QuoteLineItems_c__c qliQuote = [SELECT Id,Name,ProductId__c,QuoteId__c,QuoteId__r.OpportunityId__c From QuoteLineItems_c__c Where QuoteId__c IN: setOfQuoteId];
        qli.QuoteId__r.OpportunityId__c = opp.Id; */
        
        
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
        
        
        Test.startTest();
        
        QuoteLineItemSyncHandler.handleQuoteLineItemChanges(qliList,qliList1,true);
         QuoteLineItemSyncHandler.handleQuoteLineItemChanges(qliList,qliList1,false);
        
        Test.stopTest();
        
    }
}