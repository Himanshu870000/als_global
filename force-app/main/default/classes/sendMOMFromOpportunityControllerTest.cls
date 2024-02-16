@isTest
public class sendMOMFromOpportunityControllerTest {

    @isTest
    Static Void sendMOMFromOpportunityTestMethod(){
        List<String> SelectedConId = new List<String>();
        List<String> SelectedConId2 = new List<String>();
        
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('TestAcc');
        
        Contact conRec = new Contact();
        conRec.FirstName = 'Test';
        conRec.LastName = 'Contact';
        conRec.Email = 'utilrec@gmail.com';
        Insert conRec;
        
        Opportunity1__c oppRec = UtilityTest.CreateOppRec('Testopp',accRec.Id, Date.newInstance(2024, 12, 12),userRec.Id,'New','North');
        SelectedConId.add(oppRec.Id);
        
        Opportunity1__c oppRec1 = UtilityTest.CreateOppRec('Testopp1',accRec.Id, Date.newInstance(2024, 12, 12),userRec.Id,'New','North');
        Opportunity1__c opp1 = new Opportunity1__c();
        opp1.Id=oppRec1.Id;
        opp1.Contact_Person__c = conRec.Id;
        Update opp1;
        
        Opportunity_Contact_Role1__c oppConRec = new Opportunity_Contact_Role1__c();
        oppConRec.Contact__c = conRec.Id;
        oppConRec.Opportunity1__c = oppRec.Id;
        oppConRec.IsPrimary__c = true;
        oppConRec.Role__c = 'Business User';
        Insert oppConRec;
        SelectedConId2.add(oppConRec.Id);
        
        sendMOMFromOpportunityController.getContacts(oppRec.Id);
        sendMOMFromOpportunityController.getContacts(oppRec1.Id);
        sendMOMFromOpportunityController.SendEmailToSelectedContactNew(SelectedConId, 'Test Mom Notes');
        sendMOMFromOpportunityController.SendEmailToSelectedContactNew(SelectedConId2, 'Test Mom Notes');
        
    }
}