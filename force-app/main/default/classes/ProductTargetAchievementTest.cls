@isTest
private class ProductTargetAchievementTest {

    @isTest
    static void testSetTargetAchievement() {
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar', accRec.Id, System.today(), userRec.Id, 'New', 'South');
        OpportunityLineItem1__c testOpportunityLineItem = new OpportunityLineItem1__c(
            Opportunity1Id__c = oppRec.Id, 
            TotalPrice__c = 1000.0
        );
        insert testOpportunityLineItem;
        Set<Id> oppIdSet = new Set<Id>();
        oppIdSet.add(oppRec.Id);
        ProductTargetAchievement.setTargetAchievement(oppIdSet);
        OpportunityLineItem1__c updatedOpportunityLineItem = [SELECT Id, TotalPrice__c FROM OpportunityLineItem1__c WHERE Id = :testOpportunityLineItem.Id];
    }
}