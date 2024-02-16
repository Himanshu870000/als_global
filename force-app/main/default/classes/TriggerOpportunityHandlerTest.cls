@isTest 
public class TriggerOpportunityHandlerTest {
    
    @isTest
    static void testQuoteHelper() {
        // Test data setup
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        
        List<Opportunity1__c> oppList = new List<Opportunity1__c>(); 
        Opportunity1__c  oppRec1 = new Opportunity1__c();
        oppRec1.Name = 'Anwar';
        oppRec1.AccountId__c = accRec.Id;
        oppRec1.CloseDate__c = system.today();
        oppRec1.Customer_Success__c = userRec.Id;
        oppRec1.Sub_Status__c = 'Not Feasible';
        oppRec1.StageName__c ='New';
        oppRec1.Region__c = 'South';
        Insert oppRec1;
        oppList.add(oppRec1);
        
        
        Map<Id,Opportunity1__c> mapOfOpp = new Map<Id,Opportunity1__c>();
        Opportunity1__c  oppRec2= new Opportunity1__c();
        oppRec2.Name = 'Anwar';
        oppRec2.AccountId__c = accRec.Id;
        oppRec2.CloseDate__c = system.today();
        oppRec2.Customer_Success__c = userRec.Id;
        oppRec2.Sub_Status__c = 'Feasible';
        oppRec2.StageName__c ='New';
        oppRec2.Region__c = 'South';
        Insert oppRec2;
        mapOfOpp.put(oppRec2.Id,oppRec2);
        
        TriggerOpportunityHandler.shareToCsrUser(oppRec1.Id);
        TriggerOpportunityHandler.updateFeasibleStatus(oppRec1.Id, 'MoA');
        TriggerOpportunityHandler.updateFeasibleStatus(oppRec2.Id, 'MoA');
        //TriggerOpportunityHandler.updateProbability(oppList,mapOfOpp);
        
    }
}