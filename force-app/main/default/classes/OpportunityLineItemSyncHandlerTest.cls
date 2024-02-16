@isTest
private class OpportunityLineItemSyncHandlerTest {

    @isTest
    static void testHandleOpportunityLineItemChanges() {
        List<OpportunityLineItem1__c> newoliList = new List<OpportunityLineItem1__c>();
        List<OpportunityLineItem1__c> oldoliList = new List<OpportunityLineItem1__c>();
        
        User useRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        Contact conRec = UtilityTest.createConRec('test', 'contact');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar', accRec.id, System.today(), useRec.id, 'New', 'South');
        Quote_C__c quoteRec = UtilityTest.createQuoteRec(accRec.Id,'Test QLI','Test Description','Draft', conRec.Id,oppRec.Id);
        Product1__c prodRec = UtilityTest.createProdRec('Test Product','TP','Food','Food','TESTMETHOD','Chemistry',true);
        QuoteLineItems_c__c qliRec = UtilityTest.createQLIRec(quoteRec.Id,prodRec.Id,5,100,90,450,450,'TP');
        OpportunityLineItem1__c oliRec = UtilityTest.createOliRec(oppRec.Id,prodRec.Id,10,100,90,900,900,'TP');
        oldoliList.add(oliRec);
        
        Quote_C__c qt = new Quote_C__c();
        qt.Id = quoteRec.Id;
        qt.IsSyncing__c=true;
        update qt;
        
        OpportunityLineItem1__c oli = new OpportunityLineItem1__c();
        oli.Id = oliRec.Id;
        oli.ListPrice__c = 100;
        update oli;
        newoliList.add(oli);


        OpportunityLineItemSyncHandler.handleOpportunityLineItemChanges(newoliList,oldoliList,false);
        OpportunityLineItemSyncHandler.handleOpportunityLineItemChanges(newoliList,oldoliList,true);
        
    }
}