@isTest
public class OpportunityHelperTest {
    
    @isTest
    Static Void OpportunityHelperTestMethod(){
        
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'rsmuser@gmail.com',
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Test Account');
        Lead__c leadRec = UtilityTest.createLeadRec('Test','Lead','Util Labs','North','util@gmail.com');
        Opportunity1__c oppRec = UtilityTest.CreateOppRec('Test Opportunity',accRec.Id, Date.newInstance(2024, 01, 31), userRec.Id, 'New','North');
        Task__c taskRec = UtilityTest.createTask('Quote Submitted By Sales User','High','Open',leadRec.Id, oppRec.Id,userRec.Id,Date.newInstance(2024, 01, 31));
        Opportunity1__c opp = new Opportunity1__c();
        opp.Id = oppRec.Id;
        opp.RSM__c = testUser.Id;
        opp.OwnerId__c = testUser.Id;
        opp.Billing_Address__Street__s = 'BTM';
        opp.Billing_Address__City__s = 'Test';
        opp.Billing_Address__PostalCode__s = '560076';
        update opp;
        
        OpportunityHelper.sendReleaseQuoteToOpportunityOwner(oppRec.Id);
        OpportunityHelper.shareRecordToCustomerSuccessOnSubmitQuote(oppRec.Id);
        OpportunityHelper.UpdateNegotiationnotes('Test Negotiation', oppRec.Id);
        OpportunityHelper.getOppDetails(oppRec.Id);
        OpportunityHelper.fetchDependentPicklistValues();
        OpportunityHelper.createRouteRecord('Karnataka', 'Banglore', 'marathhalli', userRec.Id);
    }
}