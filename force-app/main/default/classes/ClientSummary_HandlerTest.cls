@IsTest(SeeAllData=true)
public class ClientSummary_HandlerTest {
	@isTest
    static void testGetAllAccountCount(){
        Lead__c newLead = new Lead__c();
        newLead.Lead_Status__c = 'New';
        newLead.First_Name__c = 'Test';
        newLead.Name ='Testing';
        newLead.Company__c = 'Testing Pvt Ltd';
        newLead.Email__c = 'test@gmail.com';
        newLead.Vertical_Segment__c = 'Pharma';
        insert newLead;
        
        Account activeAcc = new Account();
        activeAcc.Name = 'Qwerty';
        activeAcc.Account_Stage__c = 'Active';
        insert activeAcc;
        
        Account newAcc = new Account();
        newAcc.Account_Stage__c = 'New';
        newAcc.Name = 'Qwerty201';
        insert newAcc;
        
        Account inActiveAcc = new Account();
        inActiveAcc.Name = 'Qwerty301';
        inActiveAcc.Account_Stage__c = 'Inactive';
        insert inActiveAcc;
        
        Test.startTest();
        //ClientSummary_Handler.ClientSummaryWrapper wrp = ClientSummary_Handler.ClientSummaryWrapper();
        ClientSummary_Handler.ClientSummaryWrapper result = ClientSummary_Handler.getAllAccountCount();
        Test.stopTest();
    }
}