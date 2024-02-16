@isTest
public class TriggerOnQuoteLineItemHelperTest {

    @isTest
    Static void TriggerOnQuoteLineItemHelperTestMethod(){
        List<QuoteLineItems_c__c> qliList = new List<QuoteLineItems_c__c>();
        Set<Id> QuoteIds = new Set<Id>();
        User useRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        Contact conRec = UtilityTest.createConRec('test', 'contact');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar', accRec.id, System.today(), useRec.id, 'New', 'South');
        Quote_C__c quoteRec = UtilityTest.createQuoteRec(accRec.Id,'Test QLI','Test Description','Draft', conRec.Id,oppRec.Id);
        QuoteIds.add(quoteRec.Id);
        Product1__c prodRec = UtilityTest.createProdRec('Test Product','TP','Food','Food','TESTMETHOD','Chemistry',true);
        QuoteLineItems_c__c qliRec = UtilityTest.createQLIRec(quoteRec.Id,prodRec.Id,5,100,90,10,450,450,'TP');
        qliList.add(qliRec);
        
        TriggerOnQuoteLineItemHelper.handleDiscountOnListedPrice(qliList);
        
        TriggerOnQuoteLineItemHelper.updateQuoteDiscount(qliList);
        
        TriggerOnQuoteLineItemHelper.updateRelatedQuotes(QuoteIds);
    }
}