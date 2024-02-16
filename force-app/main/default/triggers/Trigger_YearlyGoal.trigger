trigger Trigger_YearlyGoal on Yearly_Goal__c (after insert) {
       if(Trigger.isInsert && Trigger.IsAfter){
        Trigger_Handler.CreateQuarterlyGoalRec(Trigger.New);
    }
}