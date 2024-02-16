@isTest
public class updateOpportunityAmountWhenOLICEDTest {

    @isTest
    Static Void updateOpportunityAmountTestMethod(){
        List<OpportunityLineItem1__c> newoliList = new List<OpportunityLineItem1__c>();
        
        
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('TestAcc');
        Opportunity1__c oppRec = UtilityTest.CreateOppRec('Testopp',accRec.Id, Date.newInstance(2024, 12, 12),userRec.Id,'New','North');
        Product1__c prodRec = UtilityTest.createProdRec('Test Product','TP','Food','Food','TESTMETHOD','Chemistry',true);
        OpportunityLineItem1__c oliRec = UtilityTest.createOliRec(oppRec.Id,prodRec.Id,10,100,90,900,900,'TP');
        newoliList.add(oliRec);
        OpportunityLineItem1__c oli = new OpportunityLineItem1__c();
        oli.Id = oliRec.Id;
        oli.Quantity__c = 5;
        oli.UnitPrice__c = 500;
        update oli;
        
        updateOpportunityAmountWhenOLICED.updateOpportunityRollupOnDelete(newoliList);
        updateOpportunityAmountWhenOLICED.updateOpportunityRollupONInsert(newoliList);
    }
}