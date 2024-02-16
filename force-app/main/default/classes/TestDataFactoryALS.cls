@isTest
public class TestDataFactoryALS {

     @isTest
    Public Static Account CreateAccount(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        return acc;
    }  
    
    @isTest
    Public Static User CreateUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='TestEmail@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          IsActive=true,Division='Rainmakers',
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='sossfdce@cirrologix.com');
        insert u;
        return u;
    }
    
    @isTest
    Public Static Product1__c CreateProduct(){
        Product1__c pdt = new Product1__c();
        pdt.Name = 'Test Product';
        pdt.Region__c = 'North';
        pdt.ProductCode__c ='7876869';
        pdt.Family__c = 'Food';
        pdt.Vertical__c = 'Pharma';
        pdt.IsActive__c = true;
        insert pdt;
        return pdt;
    }
    
    @isTest
    Public Static PriceBook1__c CreatePriceBook(){
        string pdId = [select Id from Product1__c].Id;
        PriceBook1__c pb = new PriceBook1__c();
        pb.Name = 'Standard';
        pb.IsActive__c = true;
        pb.Product1Id__c = pdId;
        Insert pb;
        return pb;
    }
    
    @isTest
    Public Static PriceBookEntry1__c CreatePriceBookEntry(){
        string pdId = [select Id from Product1__c].Id;
        string pbeId = [select Id from PriceBook1__c].Id;
         PriceBookEntry1__c pbe = new PriceBookEntry1__c();
        pbe.Name ='Test price book Entry';
        pbe.Pricebook1Id__c = pbeId;
        pbe.Product1Id__c = pdId;
        pbe.ProductCode__c = '7876869';
        pbe.UnitPrice__c = 1000;
        Insert pbe;
        return pbe;
    }
    
    @isTest
    Public Static Product_Fixed_Price__c CreateFixedPrice(){
        string accId = [select Id from Account].Id;
        string pdId = [select Id from Product1__c].Id;
         Product_Fixed_Price__c pfp = new Product_Fixed_Price__c();
        pfp.Account__c = accId;
        pfp.Product__c = pdId;
        pfp.Selling_Price__c = 2000;
        Insert pfp;
        return pfp;
    }
    
    @isTest
    Public Static Opportunity1__c CreateOpportunity(){
        string accId = [select Id from Account].Id;
        string userId = [select Id from User].Id;
        Opportunity1__c opp = new Opportunity1__c();
        opp.Name = 'Test Opportunity';
        opp.AccountId__c = accId;
        opp.CloseDate__c = system.today()+1;
        opp.Customer_Success__c = userId;
        opp.RSM__c = userId;
        opp.StageName__c = 'New';
        Insert opp;
        return opp;
    }
    
    @isTest
    Public Static Quote_C__c CreateQuote(){
        string oppId = [select Id from Opportunity1__c].Id;
          Quote_C__c Qt = new Quote_C__c();
        qt.Name = 'Test Quote';
        qt.OpportunityId__c = oppId;
        Insert qt;
        return qt;
    }
    
    @isTest
    Public Static QuoteLineItems_c__c CreateQuoteLineItem(){
        string pdId = [select Id from Product1__c].Id;
        string qtId = [select Id from Quote_C__c].Id;
        QuoteLineItems_c__c qli = new QuoteLineItems_c__c();
        qli.ProductId__c = pdId;
        qli.QuoteId__c = qtId;
        qli.Quantity__c = 1;
        qli.List_Price__c = 1000;
        qli.Sales_Price__c = 2000;
        qli.Discount__c = 5;
        qli.Subtotal__c = 1000;
        qli.Total_Price__c = 950;
        Insert qli;
        return qli;
    }
}