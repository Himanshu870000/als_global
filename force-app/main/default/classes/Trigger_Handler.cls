public class Trigger_Handler {
    public Static void CreateQuarterPeriodsRec(List<Fiscal_Year__c> fiscalList){
        system.debug('fiscalList:::::::::::>'+fiscalList);
        List<Quarter_Period__c> quarteList = new  List<Quarter_Period__c>();
        // List<Yearly_Goal__c> yearlyGoalList = new  List<Yearly_Goal__c>();
        if(fiscalList.size()>0){
            for(Fiscal_Year__c fiscalRec : fiscalList){
                Date quarterStartDate = fiscalRec.Fiscal_Year_Start_Period__c;
                Date quarterEndDate;
                
                for (Integer i = 1; i <= 4; i++) {
                    if (i == 1) {
                        quarterEndDate = quarterStartDate.addMonths(3).addDays(-1); // End of first quarter
                    } else {
                        quarterStartDate = quarterEndDate.addDays(1); // Start of the next quarter
                        quarterEndDate = quarterStartDate.addMonths(3).addDays(-1); // End of the next quarter
                    }
                    // Create a Quarter record for each quarter
                    Quarter_Period__c	quaerteRec = new Quarter_Period__c();
                    quaerteRec.Name ='Quarter' + i;
                    quaerteRec.Fiscal_Year__c = fiscalRec.id;
                    quaerteRec.Quarter_Start_Period__c = quarterStartDate;
                    
                    quaerteRec.Quarter_End_Period__c = quarterEndDate;
                    quarteList.add(quaerteRec);
                    quarterStartDate = quarterEndDate.addDays(1);
                }
            }
        }
        if(quarteList.Size()>0){
            insert quarteList;
        }
        /* if(yearlyGoalList.Size()>0){
insert yearlyGoalList;
}*/
    }
    /*public Static void CreateQuarterlyGoalRec(List<Yearly_Goal__c> yearlyGoalList){
List<Quarterly_Goal__c> quarteList = new  List<Quarterly_Goal__c>();
set<id> fiscalyearId = new set<id>();
for(Yearly_Goal__c yearRec :yearlyGoalList ){

fiscalyearId.add(yearRec.Fiscal_Year__c);

}
list<Quarter_Period__c> quarterPeriodList =[Select id From Quarter_Period__c where Fiscal_Year__c IN:fiscalyearId  ORDER BY Quarter_Start_Period__c ASC];

for(Yearly_Goal__c yearRec :yearlyGoalList ){
for(Quarter_Period__c quaterPeriodRec :quarterPeriodList){
Quarterly_Goal__c quarterlyGoalRec = new Quarterly_Goal__c(); 
quarterlyGoalRec.Yearly_Goal__c = yearRec.id ;
quarterlyGoalRec.Quarter_Period__c = quaterPeriodRec.id;
quarterlyGoalRec.Role__c = 'Sales Person' ;
quarterlyGoalRec.Quarterly_Target__c = yearRec.Yearly_Target__c  / 4;
quarteList.add(quarterlyGoalRec);

}
} 
if(quarteList.size()>0){
insert quarteList;
} 
}*/
    
    public Static void CreateQuarterlyGoalRec(List<Yearly_Goal__c> yearlyGoalList){
        system.debug('yearlyGoalList::::::>'+yearlyGoalList);
        List<Quarterly_Goal__c> quarteList = new  List<Quarterly_Goal__c>();
        // List<Yearly_Goal__c> yearlyGoalList = new  List<Yearly_Goal__c>();
        if(yearlyGoalList.size()>0){
            for(Yearly_Goal__c yearlylRec : yearlyGoalList){
                Date quarterStartDate = yearlylRec.Yearly_Goal_Start_Period__c;
                Date quarterEndDate;
                
                for (Integer i = 1; i <= 4; i++) {
                    if (i == 1) {
                        quarterEndDate = quarterStartDate.addMonths(3).addDays(-1); // End of first quarter
                    } else {
                        quarterStartDate = quarterEndDate.addDays(1); // Start of the next quarter
                        quarterEndDate = quarterStartDate.addMonths(3).addDays(-1); // End of the next quarter
                    }
                    // Create a Quarter record for each quarter
                    Quarterly_Goal__c	quaerteRec = new Quarterly_Goal__c();
                    quaerteRec.Name ='Quarter' + i;
                    quaerteRec.Yearly_Goal__c = yearlylRec.id;
                    quaerteRec.Quarter_Start_Date__c = quarterStartDate; 
                    quaerteRec.Quarterly_Target__c = yearlylRec.Yearly_Target__c / 4; 
                    quaerteRec.Quarter_End_Date__c = quarterEndDate;
                    quaerteRec.User__c = yearlylRec.User__c;
                    quaerteRec.Fiscal_Year__c = yearlylRec.Fiscal_Year__c;
                    quarteList.add(quaerteRec);
                    quarterStartDate = quarterEndDate.addDays(1);
                }
            }
        }
        if(quarteList.Size()>0){
            insert quarteList;
        }
        /* if(yearlyGoalList.Size()>0){
insert yearlyGoalList;
}*/
    }
    
    
    //Added by shubhi : used to tag Quarterly Goal on existing Opportunities.
    
    public static void updateOpportunityWithQuarterlyGoal(List<Quarterly_Goal__c> newGoals) {
        
        Set<Id> opportunityIdsToUpdate = new Set<Id>();
        
        for (Quarterly_Goal__c goal : newGoals) {
            opportunityIdsToUpdate.add(goal.Fiscal_Year__c);
        }
        
        List<Opportunity1__c> opportunitiesToUpdate = [SELECT Id, CloseDate__c, Fiscal_Year__c, Quarterly_Goal__c
                                                       FROM Opportunity1__c WHERE Fiscal_Year__c IN :opportunityIdsToUpdate];
        
        for (Opportunity1__c opportunity : opportunitiesToUpdate) {
            for (Quarterly_Goal__c goal : newGoals) {
                if (opportunity.Fiscal_Year__c == goal.Fiscal_Year__c && opportunity.CloseDate__c != null) {
                    Date closeDate = opportunity.CloseDate__c;
                    
                    if (closeDate >= goal.Quarter_Start_Date__c && closeDate <= goal.Quarter_End_Date__c 
                        && opportunity.Quarterly_Goal__c == null) {
                            opportunity.Quarterly_Goal__c = goal.Id;
                        }
                }
            }
        }
        update opportunitiesToUpdate;
    }       
}