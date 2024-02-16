trigger TriggerOnLeadCustom on Lead__c (before insert,after insert,after update, before update) {

    if(trigger.isInsert && trigger.isBefore){
        LeadTriggerHandler.leadRSMAssignment(trigger.new);
    }
    if(trigger.isAfter && trigger.isInsert){
       LeadTriggerHandler.onAfterInsertLead(trigger.newMap);
    }
    if(trigger.isAfter && trigger.isUpdate){
        //LeadTriggerHandler.tagEnquiryContactDetails(trigger.new, trigger.oldMap);
        LeadTriggerHandler.updateTaskStatus(trigger.new, trigger.oldMap);
        LeadTriggerHandler.updateRelatedTaskOwnersOnLeadOwnerChange(trigger.new, trigger.oldMap);
        LeadTriggerHandler.sendEmailtoStakeHolders(trigger.new, trigger.oldMap);
        
    }
    if(trigger.isBefore && trigger.isUpdate){
       //LeadTriggerHandler.validateLeadStatusChange(trigger.new, trigger.oldMap);
       LeadTriggerHandler.validateLeadConversion(trigger.new, trigger.oldMap);
       LeadTriggerHandler.leadRSMAssignment(trigger.new);
    }
}