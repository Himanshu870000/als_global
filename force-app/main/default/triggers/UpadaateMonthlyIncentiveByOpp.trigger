trigger UpadaateMonthlyIncentiveByOpp on Opportunity (after update) {
    if(Trigger.IsAfter && Trigger.IsUpdate){
        UpdateMonthlyIncentive.UpdateMonthlyIncentiveOnStageClosedWon(Trigger.New,Trigger.OldMap);
         
    }
}