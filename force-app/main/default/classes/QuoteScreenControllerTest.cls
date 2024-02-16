@isTest
public class QuoteScreenControllerTest {
    
    @isTest
    Public Static Void CreateRecords(){
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Service']; 
        User u = new User(Alias = 'standt', Email='TestEmail@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          IsActive=true,Division='Rainmakers',
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='sossfdce@cirrologix.com');
        insert u;
        user usrId=[select id,name,Profile.Name from User where Profile.Name ='Customer Service' limit 1];
        
        Product1__c pdt = new Product1__c();
        pdt.Name = 'Test Product';
        pdt.Region__c = 'North';
        pdt.ProductCode__c ='7876869';
        pdt.Family__c = 'Certification';
        pdt.Vertical__c = 'Pharma';
        pdt.IsActive__c = true;
        insert pdt;
        
        PriceBook1__c pb = new PriceBook1__c();
        pb.Name = 'Standard';
        pb.IsActive__c = true;
        pb.Product1Id__c = pdt.Id;
        Insert pb;
        
        PriceBookEntry1__c pbe = new PriceBookEntry1__c();
        pbe.Name ='Test price book Entry';
        pbe.Pricebook1Id__c = pb.Id;
        pbe.Product1Id__c = pdt.Id;
        pbe.ProductCode__c = '7876869';
        pbe.UnitPrice__c = 1000;
        Insert pbe;
        
        Product_Fixed_Price__c pfp = new Product_Fixed_Price__c();
        pfp.Account__c = acc.Id;
        pfp.Product__c = pdt.Id;
        pfp.Selling_Price__c = 2000;
        Insert pfp;
        
        User useRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar',accRec.id,System.today(),useRec.id,'New','South');
        
        List<Quote_C__c> quotList = new List<Quote_C__c>();
        Quote_C__c Qt1 = new Quote_C__c();
        Qt1.Name = 'Test  11 Quote';
        Qt1.OpportunityId__c = oppRec.Id;
        Qt1.Primary__c = false;
        Insert Qt1;
        
        
        
        Opportunity1__c opp = new Opportunity1__c();
        opp.Name = 'Test Opportunity';
        opp.AccountId__c = acc.Id;
        opp.CloseDate__c = system.today()+1;
        opp.Customer_Success__c = usrId.id;
        opp.RSM__c = UserInfo.getUserId();
        opp.StageName__c = 'New';
        opp.Primary_Quote__c = Qt1.id;
        Insert opp;
        
        List<Quote_C__c> quoteList = new List<Quote_C__c>();
        Map<Id,Quote_C__c> quoteOldMap = new Map<Id,Quote_C__c>(); 
        
        Quote_C__c Qt = new Quote_C__c();
        qt.Name = 'Test Quote';
        qt.OpportunityId__c = opp.Id;
       // qt.Primary__c = true;
        Insert qt;
        quoteOldMap.put(qt.Id,qt);
        
        
        qt.Primary__c = true;
        update qt;
        quoteList.add(qt);
        
        
        
        String jsonData = '[{"productId":"pdt.id", "quoteId":"qt.id","listPrice":100,"quantity":2,"unitPrice":90,"discount":5,"discountedPrice":85,"totalValue":170}]';
        Boolean isApprovalToFire = false;
        
        List<QuoteLineItems_c__c> qliList = new List<QuoteLineItems_c__c>();
        List<OpportunityLineItem1__c> oliList = new List<OpportunityLineItem1__c>();
        set<Id> setOfQuoteId = new set<Id>(); 
        QuoteLineItems_c__c qli = new QuoteLineItems_c__c();
        qli.ProductId__c = pdt.id;
        qli.QuoteId__c = qt.Id;
        qli.Quantity__c = 1;
        qli.List_Price__c = 1000;
        qli.Sales_Price__c = 2000;
        qli.Discount__c = 5;
        qli.Subtotal__c = 1000;
        qli.Total_Price__c = 950;
        qli.QuoteId__c = qt.id;
        Insert qli;
        /*setOfQuoteId.add(qli.QuoteId__c);
        QuoteLineItems_c__c qliQuote = [SELECT Id,Name,ProductId__c,QuoteId__c,QuoteId__r.OpportunityId__c From QuoteLineItems_c__c Where QuoteId__c IN: setOfQuoteId];
        qli.QuoteId__r.OpportunityId__c = opp.Id; */
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
        

        Test.startTest();        
        QuoteScreenController.getPBERecords('Standard', qt.Id); 
        QuoteScreenController.getOppName(qt.Id);
        // QuoteScreenController.createQuoteLineItems(jsonData, Qt1.Id);
        QuoteScreenController.createQuoteLineItems(jsonData, Qt.Id); 
        QuoteScreenController.getQuoteLineItems(qt.Id);
        QuoteScreenController.validateCertification(qt.Id);
        //QuoteScreenController.checkCertification(qli);
        QuoteScreenController.checkOpportunityUpdated(opp.Id);
        QuoteScreenController.deleteOppoLineItem(qliList);
        QuoteScreenController.validatePharmaQuote(qt.Id);
        //  QuoteScreenController.validatePharmaQuote(qt.Id);
        QuoteScreenController.checkPrimaryQuoteFromRelatedQuoteList(opp.Id);
        QuoteScreenController.checkPrimaryQuoteFromRelatedQuoteList(oppRec.Id);
        QuoteScreenController.updateQuoteLineItems(jsonData,Qt.Id); 
        Test.stopTest();
    }
    
     @isTest
    Public Static Void CreateRecordsTest1(){
         Map<Id,Quote_C__c> quoteOldMap = new Map<Id,Quote_C__c>();
        List<Quote_C__c> quoteList = new List<Quote_C__c>();
        Contact conRec = UtilityTest.createConRec('Test 1','Rest 1');
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Mukesh Test');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('tushar',accRec.id,System.today(),userRec.id,'New','South');
        Quote_C__c quoteRecOld = UtilityTest.createQuoteRec(accRec.id,'Qute-12','Description','Draft',conRec.id,oppRec.id);
        quoteOldMap.put(quoteRecOld.id,quoteRecOld);
        
        Quote_C__c newQuote = new Quote_C__c();
        newQuote.id = quoteRecOld.id;
        newQuote.Primary__c = true;
        update newQuote;
        quoteList.add(newQuote);
        
        QuoteScreenController.CreateOppLineItemOnPrimaryQuote(quoteList,quoteOldMap);

        
         Product1__c pdt = new Product1__c();
        pdt.Name = 'Test Product';
        pdt.Region__c = 'North';
        pdt.ProductCode__c ='7876869';
        pdt.Family__c = 'Certification';
        pdt.Vertical__c = 'Pharma';
        pdt.IsActive__c = true;
        insert pdt;
        
       
         QuoteLineItems_c__c qli = new QuoteLineItems_c__c();
        qli.ProductId__c = pdt.id;
        qli.QuoteId__c = newQuote.Id;
        qli.Quantity__c = 1;
        qli.List_Price__c = 1000;
        qli.Sales_Price__c = 2000;
        qli.Discount__c = 5;
        qli.Subtotal__c = 1000;
        qli.Total_Price__c = 950;
        Insert qli;
        
        
    }
   
}