trigger TriggerOpportunity on Opportunity1__c (before insert, before update,After insert,After Update) {
    if(trigger.isBefore && trigger.isInsert){
        TriggerOpportunityHandler.provideOppnameWithAcc(trigger.new);
        TriggerOpportunityHandler.updateProbabilityonCreation(trigger.new);
        TriggerOpportunityHandler.oncreationHandleCreateFlag(trigger.new);
        TriggerOpportunityHandler.OppRSMAssignment(trigger.new);
        TriggerOpportunityHandler.updateClosedDateOnOpp(trigger.new);
    }
    
    if(trigger.isBefore && trigger.isupdate){
        TriggerOpportunityHandler.updateProbability(Trigger.new, Trigger.oldMap);
    }
    if(trigger.isAfter && trigger.isInsert){
        
       // TriggerOpportunityHandler.ApprovalProcessForOpportunityAmountGreaterthen50Lakh(trigger.new); 
    }
    if(trigger.isAfter && trigger.isUpdate){ 
       TriggerOpportunityHandler.get_closedown_opportunity(trigger.new);
    }
}