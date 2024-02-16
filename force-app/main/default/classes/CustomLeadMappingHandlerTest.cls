@isTest
public class CustomLeadMappingHandlerTest {

    @isTest
    Static Void CustomLeadMappingHandlerTestMethod(){
     	User userRec = UtilityTest.createUserCustomService();
        Lead__c ldRec = UtilityTest.createLeadRec('test', 'lead', 'util', 'West', 'util@gmail.com', 'Pharma');
        Account accRec = UtilityTest.createAccRec('TestAcc');
        Contact conRec = UtilityTest.createConRec('Test','Contact');
        Opportunity1__c oppRec = UtilityTest.CreateOppRec('Testoppty',accRec.Id, Date.newInstance(2024, 12, 12),userRec.Id,'New','West');
        Product1__c prodRec = UtilityTest.createProdRec('Test Product','TP','Food','Food','TESTMETHOD','Chemistry',true);
        Enquiry_Contact_Details__c ecd = new Enquiry_Contact_Details__c();
        ecd.First_Name__c = 'Test';
        ecd.Last_Name__c = 'Enquiry';
        ecd.Email__c = 'Utilenquiry@gmail.com';
        ecd.Lead__c = ldRec.Id;
        Insert ecd;
        
        Initial_Requirement__c inRec = new Initial_Requirement__c();
        inRec.LeadId__c = ldRec.Id;
        inRec.Product1Id__c = prodRec.Id;
        inRec.Opportunity1Id__c = oppRec.Id;
        inRec.ServiceDate__c = Date.newInstance(2024, 12, 12);
        inRec.Time_line__c =Date.newInstance(2024, 12, 30) ;
        Insert inRec;
        
        Lead__c ld = new Lead__c();
        ld.Id =ldRec.Id;
        ld.Lead_Status__c = 'New';
        Update ld;
        CustomLeadMappingHandler.getLeadDetails(ldRec.Id);
        CustomLeadMappingHandler.createRecords('Test Account', 'Mr.', 'test', 'Contact', 'test opp', 'test owner', ldRec.Id);
        CustomLeadMappingHandler.updateContactOpportunityAccountid(conRec.Id, oppRec.Id, accRec.Id);
        CustomLeadMappingHandler.UpdateleadStatus(ld.Id);
        CustomLeadMappingHandler.getopportunityData(accRec.Id);
        CustomLeadMappingHandler.createExistingAccount_Contact_Opportunity(accRec.Id, 'util', 'first', 'last',oppRec.Id , 'ExistingAccountNewContactExistingOpportunity', conRec.Id);
        CustomLeadMappingHandler.createExistingAccount_Contact_Opportunity(accRec.Id, 'util', 'first', 'last',oppRec.Id , 'NewAccountExistingContactNewOpportunity', conRec.Id);
        CustomLeadMappingHandler.createDefaultAccountContactOpportunityRecords('test acc', 'Mr.', 'test con', 'testing', 'test opp', ldRec.Id);
        CustomLeadMappingHandler.checkDuplicateAccountContactOpportunity(ldRec.Id);
        CustomLeadMappingHandler.mappingLeadFieldToAccountOpportunityContactObj(ldRec.Id, conRec.Id, oppRec.Id, accRec.Id);
        CustomLeadMappingHandler.moveInitialRequirementsFromLeadToOpportunity(ldRec.Id, oppRec.Id);
    }
}