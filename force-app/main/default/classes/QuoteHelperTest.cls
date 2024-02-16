@isTest
public class QuoteHelperTest {
    
    @istest
    static void testQuoteHelper(){
        User useRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar',accRec.id,System.today(),useRec.id,'New','South');
        Quote_C__c quotRec = new Quote_C__c(Name = 'Testing',OpportunityId__c =oppRec.id);
        insert quotRec;
        QuoteHelper.generateSelectedQuatationPDF('Banglore Pharma Template',quotRec.id);
        QuoteHelper.generateSelectedQuatationPDF('Mumbai Pharma Batch Quote',quotRec.id);
        QuoteHelper.generateSelectedQuatationPDF('Mumbai Pharma EnL Quote',quotRec.id);
        QuoteHelper.generateSelectedQuatationPDF('Mumbai Pharma General Quote',quotRec.id);
        QuoteHelper.generateSelectedQuatationPDF('Mumbai Pharma In-Vitro Quote',quotRec.id);
    }
    @istest
    static void testupdateQuoteAddressFromOpportunity(){
        User useRec = UtilityTest.createUserCustomService();
        List<Quote_C__c> quotList = new List<Quote_C__c>();
        Account accRec = UtilityTest.createAccRec('Banoj');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar',accRec.id,System.today(),useRec.id,'New','South');
        Quote_C__c quotRec = new Quote_C__c(Name = 'Testing',OpportunityId__c =oppRec.id);
        insert quotRec;
        quotList.add(quotRec);
        
        Opportunity1__c testOpp = new Opportunity1__c(Id=quotRec.OpportunityId__c,Name = 'Anwar',Billing_Address__Street__s = '22, Bannerghatta Rd, Sarakki Industrial Layout, 3rd Phase, J. P. Nagar',
                                                      Billing_Address__City__s = 'Bengaluru',Billing_Address__PostalCode__s='560076',Billing_Address__StateCode__s='KA',Billing_Address__CountryCode__s='IN',
                                                      Shipping_Address__Street__s='22, Bannerghatta Rd, Sarakki Industrial Layout, 3rd Phase, J. P. Naga',
                                                      Shipping_Address__City__s='Bengaluru',Shipping_Address__PostalCode__s='560076',Shipping_Address__StateCode__s='KA',Shipping_Address__CountryCode__s='IN');
        update testOpp;
        
        QuoteHelper.updateQuoteAddressFromOpportunity(quotList);
    }
    @istest
    static void testupdateQuoteAddressFromOpportunity1(){
        User useRec = UtilityTest.createUserCustomService();
        List<Quote_C__c> quotList = new List<Quote_C__c>();
        Account accRec = UtilityTest.createAccRec('Banoj');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar',accRec.id,System.today(),useRec.id,'New','South');
        Quote_C__c quotRec = new Quote_C__c(Name = 'Testing',OpportunityId__c =oppRec.id);
        insert quotRec;
        quotList.add(quotRec);
        
        Opportunity1__c testOpp = new Opportunity1__c(Id=quotRec.OpportunityId__c,Name = 'Anwar',Billing_Address__Street__s = '22, Bannerghatta Rd, Sarakki Industrial Layout, 3rd Phase, J. P. Nagar',
                                                      Billing_Address__City__s = 'Bengaluru',Billing_Address__PostalCode__s='560076',Billing_Address__StateCode__s='KA',Billing_Address__CountryCode__s='IN',
                                                      Shipping_Address__Street__s='22, Bannerghatta Rd, Sarakki Industrial Layout, 3rd Phase, J. P. Naga',
                                                      Shipping_Address__City__s='Bengaluru',Shipping_Address__PostalCode__s='560076',Shipping_Address__StateCode__s='KA',Shipping_Address__CountryCode__s='IN');
        update testOpp;
        
        QuoteHelper.updateQuoteAddressFromOpportunity(quotList);
        QuoteHelper.mapFieldsFromOpportunity(quotList);
    }
    
    @isTest
    static void testUpdatePrimaryQuote() {
        
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        set<Id> setOfquotId = new set<Id>();
        Set<Id> oppIdSet = new Set<Id>();
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar', accRec.Id, System.today(), userRec.Id, 'New', 'South');
        Opportunity1__c oppRec1 = UtilityTest.CreateOppRecCustomerService('Rehman', accRec.Id, System.today(), userRec.Id, 'Closed Lost', 'North');
        Quote_C__c quoteRec = new Quote_C__c(Name = 'Testing', OpportunityId__c = oppRec1.Id);
        insert quoteRec;
        setOfquotId.add(quoteRec.id);
        oppIdSet.add(oppRec.Id);
        QuoteHelper.updatePrimaryQuote(oppIdSet,setOfquotId);       
        
        
    }
    
    @isTest
    static void testuncheckDuplicatePrimary() {
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        List<Quote_C__c> quotList = new List<Quote_C__c>();
        set<Id> setOfquotId = new set<Id>();
        Set<Id> oppIdSet = new Set<Id>();
        Map<Id,Quote_C__c> oldMap = new Map<Id,Quote_C__c>();
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar', accRec.Id, System.today(), userRec.Id, 'New', 'South');
        Opportunity1__c oppRec1 = UtilityTest.CreateOppRecCustomerService('Rehman', accRec.Id, System.today(), userRec.Id, 'Closed Lost', 'North');
        Quote_C__c quoteRec = new Quote_C__c(Name = 'Testing', OpportunityId__c = oppRec1.Id);
        quoteRec.Primary__c = true;
        insert quoteRec;
        quotList.add(quoteRec);
        oldMap.put(quoteRec.Id,quoteRec);
        setOfquotId.add(quoteRec.id);
        oppIdSet.add(oppRec.Id);
        QuoteHelper.updatePrimaryQuote(oppIdSet,setOfquotId);   
        QuoteHelper.uncheckDuplicatePrimary(quotList,oldMap);
        QuoteHelper.updateAmountOnOpportunityOnPrimaryMark(quotList,oldMap);
        
        
    }
    
}