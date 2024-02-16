trigger OpportunityLineItemSyncTrigger on OpportunityLineItem1__c (after insert, after update, after delete, after undelete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            OpportunityLineItemSyncHandler.handleOpportunityLineItemChanges(Trigger.new, Trigger.old, false);
          } 
        else if (Trigger.isDelete) {
            try{
                OpportunityLineItemSyncHandler.handleOpportunityLineItemChanges(null, Trigger.old, true);
            }catch (Exception e) {
                // Log the exception message or custom error handling
                System.debug('Exception Message: ' + e.getMessage());
            }
        }
    }
    
    //Methods for Updating the amount in opportunity
   if(Trigger.isAfter &&(Trigger.isInsert || Trigger.isUndelete)){
        updateOpportunityAmountWhenOLICED.updateOpportunityRollupONInsert(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        updateOpportunityAmountWhenOLICED.updateOpportunityRollupOnUpdate(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isDelete){
        updateOpportunityAmountWhenOLICED.updateOpportunityRollupOnDelete(Trigger.old);
    }
    
    
}