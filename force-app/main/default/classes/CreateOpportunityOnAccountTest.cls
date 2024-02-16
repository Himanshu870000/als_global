@isTest
public class CreateOpportunityOnAccountTest {

    @isTest
    Static Void CreateOpportunityOnAccountTestMethod(){
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('TestAcc');
        
        Account acc = new Account();
        acc.Id = accRec.Id;
        acc.BillingCity='Banglore';
        acc.BillingCountry = 'IN';
        acc.BillingPostalCode='560076';
        acc.BillingState = 'KA';
        acc.BillingStreet = 'BTM';
        acc.ShippingCity = 'Banglore';
        acc.ShippingCountry = 'IN';
        acc.ShippingPostalCode ='560076' ;
        acc.ShippingState = 'KA';
        acc.ShippingStreet = 'Marathalli';
        update acc;
        
        Opportunity1__c oppRec = UtilityTest.CreateOppRec('Testopp',accRec.Id, Date.newInstance(2024, 12, 12),userRec.Id,'New','North');
        
        Dispatch_Address__c disAdd = new Dispatch_Address__c();
        disAdd.Account__c= accRec.Id;
        disAdd.Type__c = 'Billing';
        disAdd.Address__City__s ='Banglore';
        disAdd.Address__CountryCode__s = 'IN';
        disAdd.Address__PostalCode__s = '560076';
        disAdd.Address__StateCode__s = 'KA';
        disAdd.Address__Street__s = 'Panduranga Nagar';
        Insert disAdd;
        
        Dispatch_Address__c disAdd1 = new Dispatch_Address__c();
        disAdd1.Account__c= accRec.Id;
        disAdd1.Type__c = 'Shipping';
        disAdd1.Address__City__s ='Banglore';
        disAdd1.Address__CountryCode__s = 'IN';
        disAdd1.Address__PostalCode__s = '560076';
        disAdd1.Address__StateCode__s = 'KA';
        disAdd1.Address__Street__s = 'Yashwanthpur';
        Insert disAdd1;
               
        CreateOpportunityOnAccount.getFieldSet();
        CreateOpportunityOnAccount.getAllCustomerAddress(oppRec.Id);
        CreateOpportunityOnAccount.UpdateOpportunityAccountAddresss(oppRec.Id, disAdd1.Id, disAdd.id);
        CreateOpportunityOnAccount.UpdateOpportunityAccountAddresss(oppRec.Id, 'Shipping', 'Billing');
    }
}