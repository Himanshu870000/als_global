public class CustomTaskTriggerHelper {
    public class CustomTriggerException extends Exception {}
    
    public static void updateAuditedField(List<Task__c> taskList, Map<Id,Task__c> oldTaskMap ){
        
        List<Lead__c> leadsToUpdate = new List<Lead__c>();
        
        for (Task__c task : taskList) {
            Task__c oldTask = oldTaskMap.get(task.Id);
            
            if (task.Subject__c == 'Mark Audited' && task.Status__c == 'Completed' && task.Status__c != oldTask.Status__c) {
                leadsToUpdate.add(new Lead__c(Id = task.Lead__c, Audited__c = true, Sub_Stage__c = 'Audited'));
            }
        }
        
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }
    
    public static void updateCompletedDateTime(List<Task__c> newTasks) {
        for (Task__c newTask : newTasks) {
            if (newTask.Status__c == 'Completed') {
                newTask.CompletedDateTime__c = System.now();
            }
        }
    }
    
    
    // Method for Updating Lead Stage to SQL After completing the Task
    public static void updateLeadStageOnTaskCompleted(List<Task__c> newTasKList,Map<id,Task__c> oldTasKMap){
        List<Task__c> taskRecList = new List<Task__c>();
        Set<Id> TaskIdSet = new Set<Id>();
        String taskSubject = Constant.LEAD_STAGE_SQL;
        Set<Id> LeadIdSet = new Set<Id>();
        System.debug('newTasKList == >'+newTasKList);
        System.debug('oldTasKMap == >'+oldTasKMap);
        try{
            for(Task__c tkRec : newTasKList){
                if(tkRec.Status__c !=null && tkRec.Status__c == 'Completed' && oldTasKMap.get(tkRec.id).Status__c =='Open'){
                    TaskIdSet.add(tkRec.Id);
                }
            }
            System.debug('TaskIdSet == >'+TaskIdSet);
            if(TaskIdSet.size()>0){
                taskRecList =   [SELECT Id,Subject__c,Lead__C,Status__c FROM Task__c WHERE Id IN:TaskIdSet AND Subject__c=:taskSubject LIMIT 1];
                if(taskRecList.size()>0){
                    Lead__C ledRecToUpdate = new Lead__C();
                    ledRecToUpdate.Id = taskRecList.get(0).Lead__c;
                    ledRecToUpdate.Lead_Status__c ='SQL';
                    update ledRecToUpdate;
                    System.debug('ledRecToUpdate == >'+ledRecToUpdate);
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
    
}