@isTest
public class TaskCompleteButtonControllerTest {
    @isTest
    static void testProcessTaskRecord() {
         Task__c taskRecord = new Task__c();
         taskRecord.MOM__c = 'Test';  
         insert taskRecord;
        
        
         Task__c taskRecord1 = new Task__c();
         taskRecord1.Subject__c = 'Test';  
         insert taskRecord1;
        
        Test.startTest();
        
         TaskCompleteButtonController.processTaskRecord(taskRecord.Id);
         TaskCompleteButtonController.processTaskRecord(taskRecord1.Id);
         TaskCompleteButtonController.processReopenTaskRecord(taskRecord.Id);
        
        Test.stopTest();
    }
}