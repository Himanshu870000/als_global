@isTest
public class CustomTaskTriggerHelperTest {
	 @isTest
    static void testUpdateAuditedField() {
        Lead__c ldRec = UtilityTest.createLeadRec('Test', 'Nano', 'Maruti Suzuki', 'North', 'testnano@gmail.com', 'Food Service');
        
        Task__c testTask = new Task__c(
            Subject__c = 'Mark Audited',
            Status__c = 'Completed',
            Lead__c = ldRec.Id
        );
        insert testTask;
        
        Map<Id, Task__c> oldTaskMap = new Map<Id, Task__c>();
        oldTaskMap.put(testTask.Id, testTask);
        
        Test.startTest();
        CustomTaskTriggerHelper.updateAuditedField(new List<Task__c>{testTask}, oldTaskMap);
        Test.stopTest();
    }
}