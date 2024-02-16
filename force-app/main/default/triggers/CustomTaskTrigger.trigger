trigger CustomTaskTrigger on Task__c (before update, after update) {
    
    if(Trigger.isUpdate && Trigger.isAfter){
        CustomTaskTriggerHelper.updateAuditedField(Trigger.new, Trigger.oldMap);
         CustomTaskTriggerHelper.updateLeadStageOnTaskCompleted(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
        CustomTaskTriggerHelper.updateCompletedDateTime(Trigger.new);        
    }
}