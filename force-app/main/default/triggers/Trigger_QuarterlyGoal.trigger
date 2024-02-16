trigger Trigger_QuarterlyGoal on Quarterly_Goal__c (after insert) {
    
     if(Trigger.isInsert && Trigger.IsAfter){
        Trigger_Handler.updateOpportunityWithQuarterlyGoal(Trigger.New);
    }

}