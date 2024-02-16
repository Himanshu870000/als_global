trigger TriggerOnCustomOpp on Opportunity1__c (before insert,after insert,after update,before update) {
   
    if(trigger.isBefore && trigger.isInsert){
        OpportunityTriggerHandler.tagQuarterlyGoal(Trigger.new);
        OpportunityTriggerHandler.updateOppOwner(Trigger.new);
     }
    
    if(trigger.isAfter && trigger.isInsert){
        OpportunityTriggerHandler.UpdateMonthlyIncentiveAchievement(trigger.new,trigger.oldmap);
        OpportunityTriggerHandler.updateFiscalYearByCreatedDate(trigger.new);
    }
    
    if(trigger.isAfter && trigger.IsUpdate){
     // ProductAchievedTargetBifurcation.CreateProductTargetBifurcation(trigger.new,trigger.newmap);
      //OpportunityTriggerHandler.insertNewProductFixedPriceRecord(trigger.newMap);
      OpportunityTriggerHandler.rollUpAmountOnQuarterlyGoal(trigger.new,trigger.oldmap);
      OpportunityTriggerHandler.updateQuoteStage(trigger.new,trigger.oldmap);
     }
    
     if(trigger.isBefore && trigger.isUpdate){
       OpportunityTriggerHandler.tagQuarterlyGoalAfterFYIsUpdated(Trigger.new, Trigger.oldmap);
       OpportunityTriggerHandler.updateQuarterlyGoalByClosedate(Trigger.new, Trigger.oldmap);
    }

}