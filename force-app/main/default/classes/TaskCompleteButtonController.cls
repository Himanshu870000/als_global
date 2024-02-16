//@Author : Navneet Shukla

public with sharing class TaskCompleteButtonController {
    
    @AuraEnabled
    public static Map<String, String> processTaskRecord(String taskId) {
        Map<String, String> result = new Map<String, String>();
        
        try {
            Task__c taskRecord = [SELECT Id, MOM__c, Status__c FROM Task__c WHERE Id = :taskId LIMIT 1];
            
            if (String.isBlank(taskRecord.MOM__c)) {
                // MOM__c is empty, return error message
                result.put('errorMsg', 'MOM cannot be empty. Please enter MOM.');
            } else {
                // Update Status__c to Completed
                taskRecord.Status__c = 'Completed';
                update taskRecord;
            }
        } catch (Exception e) {
            // Handle any exceptions and return an error message
            result.put('errorMsg', 'An error occurred while processing the task.');
        }
        
        return result;
    }
    
    
    @AuraEnabled
    public static Map<String, String> processReopenTaskRecord(String taskId) {
        Map<String, String> result = new Map<String, String>();
        
        try {
            Task__c taskRecord = [SELECT Id, Status__c FROM Task__c WHERE Id = :taskId LIMIT 1];
            
            // Update Status__c to Open
            taskRecord.Status__c = 'Open';
            update taskRecord;
        } catch (Exception e) {
            // Handle any exceptions and return an error message
            result.put('errorMsg', 'An error occurred while reopening the task.');
        }
        
        return result;
    }
}