@isTest
private class UpdateTaskStatusControllerTest {
    
    @isTest
    static void testUpdateTaskStatusAfterAddress() {
        User useRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar', accRec.id, System.today(), useRec.id, 'New', 'South');
        Quote_C__c quotRec = new Quote_C__c(Name = 'Testing', OpportunityId__c = oppRec.id);
        insert quotRec;
        
        Task__c testTask = new Task__c(
            Opportunity1Id__c = oppRec.Id,
            Subject__c = 'Update Billing and Shiping address'
        );
        insert testTask;
        
        updateTaskStatusController.updateTaskStatusAfterAddress(oppRec.Id, 'Billing Address', 'Shipping Address');
        Task__c updatedTask = [SELECT Id, Status__c FROM Task__c WHERE Id = :testTask.Id];
    }
    
    @isTest
    static void testUpdateTaskStatusAfterQuoteSubmission() {
        
        User useRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar', accRec.id, System.today(), useRec.id, 'New', 'South');
        Quote_C__c quotRec = new Quote_C__c(Name = 'Testing', OpportunityId__c = oppRec.id);
        insert quotRec;
        
        Task__c testTask = new Task__c(
            Opportunity1Id__c = oppRec.Id,
            Subject__c = 'Check Quote Feasibility'
        );
        insert testTask;
        
        updateTaskStatusController.updateTaskStatusAfterQuoteSubmission(oppRec.Id);
        Task__c updatedTask = [SELECT Id, Status__c FROM Task__c WHERE Id = :testTask.Id];
    }
}