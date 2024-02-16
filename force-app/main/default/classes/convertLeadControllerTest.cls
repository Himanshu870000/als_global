@isTest
public class convertLeadControllerTest {
    @isTest
    static void testGetLeads() {
        Lead__c ldRec = UtilityTest.createLeadRec('Test', 'Nano', 'Maruti Suzuki', 'North', 'testnano@gmail.com', 'Food Service');
        
        Lead ldtest = new Lead();
        ldtest.LastName = 'test Lead';
        ldtest.Company = 'Test Technology Pvt Ltd';
        ldtest.Status = 'Close Converted';
        insert ldtest;
        
        List<Lead> resultLeads = convertLeadController.getLeads(ldRec.Id);
        convertLeadController.UpdateleadStatus(ldtest.id);
    }
    
    
    @isTest
    static void testcreateAccount(){
        Account accRec = UtilityTest.createAccRec('Test Account');
        
        convertLeadController.createAccount('Test Account');
    }
    
    @isTest
    static void testcreateContact(){
        Contact conRec = new Contact();
        conRec.FirstName = 'TestName';
        conRec.LastName = 'TQwerty';
        conRec.Salutation = 'Mr';
        insert conRec;
        
        convertLeadController.createContact(conRec.Salutation,conRec.FirstName,conRec.LastName);
        
       
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Service'].Id,
            FirstName = 'Test 1',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuseqwertr345@example.com',
            Alias = 'tufser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        Account accRec = UtilityTest.createAccRec('Banoj');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar',accRec.id,System.today(),testUser.id,'New','South');
        
        convertLeadController.createRecords(accRec.Name,conRec.Salutation,conRec.FirstName,conRec.LastName,oppRec.Name,testUser.Id);
        convertLeadController.createopportunity(oppRec.Name);
      //  convertLeadController.getopportunityData(oppRec.Id);
    }
}