public class updateTaskStatusController {

    @AuraEnabled
    Public Static String updateTaskStatusAfterAddress(String recId, String billAddress, String shipAddress){
        List<Task__c> updatetaskList = new List<Task__c>();
        List<Task__c> taskList = [select Id, Status__c, CompletedDateTime__c, Subject__c  from Task__c where Opportunity1Id__c =: recId 
                                  and Subject__c = 'Update Billing and Shiping address'];
        for(Task__c ts: taskList){
            if(billAddress!=null && shipAddress!=null){
                Task__c t = new Task__c();
                t.Id = ts.Id;
                t.Status__c = 'Completed';
                t.CompletedDateTime__c = system.now();
                updatetaskList.add(t);
            }
        }
        if(!updatetaskList.isEmpty()){
            update updatetaskList;
        }
        return 'Success';
    }
    
    @AuraEnabled
    Public Static String updateTaskStatusAfterQuoteSubmission(String recId){
        List<Task__c> updatetaskList = new List<Task__c>();
        List<Task__c> taskList = [select Id, Status__c, CompletedDateTime__c, Subject__c  from Task__c where Opportunity1Id__c =: recId 
                                  and Subject__c = 'Check Quote Feasibility'];
        for(Task__c ts: taskList){
                Task__c t = new Task__c();
                t.Id = ts.Id;
                t.Status__c = 'Completed';
                t.CompletedDateTime__c = system.now();
                updatetaskList.add(t);
        }
        if(!updatetaskList.isEmpty()){
            update updatetaskList;
        }
        return 'Success';
    }
}