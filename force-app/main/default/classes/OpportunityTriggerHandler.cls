public class OpportunityTriggerHandler {
    
    public static void UpdateMonthlyIncentiveAchievement(list<Opportunity1__c> opplist ,map<id,Opportunity1__c> oldmap){
        
        Set<Id> fiscalIDSet = new Set<Id>();
        Map<Id,Quarterly_Goal__c> mapofMontlyidMonthlyRec = new Map<Id,Quarterly_Goal__c>();
        for(Opportunity1__c oppRec : opplist){
            if(oppRec.Quarterly_Goal__c !=null && oppRec.Fiscal_Year__c != null && (oldmap == null || oppRec.Quarterly_Goal__c != oldmap.get(oppRec.id).Quarterly_Goal__c ) ){
                fiscalIDSet.add(oppRec.Fiscal_Year__c);
            }
        }
        if(!fiscalIDSet.isEmpty()){
            
            List<Quarterly_Goal__c> monthlyGoallist = new List<Quarterly_Goal__c>();
            List<Quarterly_Goal__c> monthlyGoallistTobeUpdate = new List<Quarterly_Goal__c>();
            
            monthlyGoallist = [Select id,Total_Target_Achieved__c from Quarterly_Goal__c  where Fiscal_Year__c IN:fiscalIDSet ];
            
            if(!monthlyGoallist.IsEmpty()){
                for(Quarterly_Goal__c motnhIncentiveRec : monthlyGoallist){
                    mapofMontlyidMonthlyRec.put(motnhIncentiveRec.id,motnhIncentiveRec);
                }
            }
            
            Map<Id,Quarterly_Goal__c> mapOfMonthlyGoal = new Map<Id,Quarterly_Goal__c>();
            
            for(Opportunity1__c Opp : opplist){
                if(Opp.Quarterly_Goal__c != null && (oldmap == null || Opp.Quarterly_Goal__c != oldmap.get(Opp.id).Quarterly_Goal__c)){
                    Quarterly_Goal__c monthIncentiveRec = new Quarterly_Goal__c();
                    monthIncentiveRec.id = Opp.Quarterly_Goal__c;
                    
                    if(mapofMontlyidMonthlyRec.containsKey(Opp.Quarterly_Goal__c) && mapofMontlyidMonthlyRec.get(Opp.Quarterly_Goal__c).Total_Target_Achieved__c == null){
                        mapofMontlyidMonthlyRec.get(Opp.Quarterly_Goal__c).Total_Target_Achieved__c = 0;
                    }
                    if(Opp.Amount__c != null && mapofMontlyidMonthlyRec.get(Opp.Quarterly_Goal__c).Total_Target_Achieved__c != null){
                        
                        monthIncentiveRec.Total_Target_Achieved__c = mapofMontlyidMonthlyRec.get(Opp.Quarterly_Goal__c).Total_Target_Achieved__c + Opp.Amount__c;
                    }
                    
                    
                    mapofMontlyidMonthlyRec.put(opp.Quarterly_Goal__c,monthIncentiveRec);
                    if(mapOfMonthlyGoal.containsKey(Opp.Quarterly_Goal__c)){
                        mapOfMonthlyGoal.put(Opp.Quarterly_Goal__c,monthIncentiveRec);
                    }else{
                        mapOfMonthlyGoal.put(Opp.Quarterly_Goal__c,monthIncentiveRec);
                    }
                    
                    
                    if(oldmap != null && oldmap.get(Opp.id).Quarterly_Goal__c != null){
                        Quarterly_Goal__c monthIncentiveRecOld = new Quarterly_Goal__c();
                        monthIncentiveRecOld.id = oldmap.get(Opp.id).Quarterly_Goal__c;
                        
                        if(mapofMontlyidMonthlyRec.containsKey(Opp.Quarterly_Goal__c) && mapofMontlyidMonthlyRec.get(Opp.Quarterly_Goal__c).Total_Target_Achieved__c == null){
                            mapofMontlyidMonthlyRec.get(Opp.Quarterly_Goal__c).Total_Target_Achieved__c = 0;
                        }
                        
                        
                        monthIncentiveRecOld.Total_Target_Achieved__c = mapofMontlyidMonthlyRec.get(oldmap.get(Opp.Id).Quarterly_Goal__c).Total_Target_Achieved__c - Opp.Amount__c;
                        mapofMontlyidMonthlyRec.put(opp.Quarterly_Goal__c,monthIncentiveRecOld);
                        if(mapOfMonthlyGoal.containsKey(Opp.Quarterly_Goal__c)){
                            mapOfMonthlyGoal.put(Opp.Quarterly_Goal__c,monthIncentiveRecOld);
                        }else{
                            mapOfMonthlyGoal.put(Opp.Quarterly_Goal__c,monthIncentiveRecOld);
                        }
                        
                    }
                    
                }
                
            }
            if(!mapOfMonthlyGoal.isEmpty()){
                
                update mapOfMonthlyGoal.values();
            }
        }
        
    }
    /* public static void UpdateMonthlyAchievementAmountByAmountincrease(List<Opportunity> oppList,Map<Id,Opportunity> oldMap){

Map<Id,Decimal> mapOfquaeterIdByAmount = new Map<Id,Decimal>();
Map<Id,Integer> mapOfquaeterIdByCount  = new Map<Id,Integer>();
for(Opportunity opp : oppList){
if(opp.Amount != null && opp.Amount != oldMap.get(opp.Id).Amount && opp.Amount > oldMap.get(opp.Id).Amount && opp.Monthly_Incentive_Goal__c != null && oldMap.get(opp.Id).StageName != 'Closed Lost'){

if(mapOfquaeterIdByAmount.containsKey(opp.Monthly_Incentive_Goal__c)){
mapOfquaeterIdByAmount.put(opp.Monthly_Incentive_Goal__c,mapOfquaeterIdByAmount.get(opp.Monthly_Incentive_Goal__c) + (opp.Amount - oldMap.get(opp.Id).Amount));
}else{

mapOfquaeterIdByAmount.put(opp.Monthly_Incentive_Goal__c,opp.Amount - oldMap.get(opp.Id).Amount);

//mapOfquaeterIdByCount.put(opp.Financial_Projection__c,1);
}
}
}
if(!mapOfquaeterIdByAmount.isEmpty()){
List<Monthly_Incentive_Goal__c> qdListTobeUpdate = new List<Monthly_Incentive_Goal__c>();
qdListTobeUpdate = [select id,Total_Target_Achieved__c from Monthly_Incentive_Goal__c where id in: mapOfquaeterIdByAmount.keySet()];
if(!qdListTobeUpdate.isEmpty()){
for(Monthly_Incentive_Goal__c qd : qdListTobeUpdate){
if(  qd.Total_Target_Achieved__c != null){
qd.Total_Target_Achieved__c = qd.Total_Target_Achieved__c + mapOfquaeterIdByAmount.get(qd.id);
}

//qd.No_of_Opportunity__c = qd.No_of_Opportunity__c - mapOfquaeterIdByCount.get(qd.id);
}

update qdListTobeUpdate;
}

}

}

public static void UpdateMonthlyAchievementAmountByAmountdecrease(List<Opportunity> oppList,Map<Id,Opportunity> oldMap){

Map<Id,Decimal> mapOfquaeterIdByAmount = new Map<Id,Decimal>();
Map<Id,Integer> mapOfquaeterIdByCount  = new Map<Id,Integer>();
for(Opportunity opp : oppList){
if(opp.Amount != null && opp.Amount != oldMap.get(opp.Id).Amount && opp.Amount < oldMap.get(opp.Id).Amount && opp.Monthly_Incentive_Goal__c != null && oldMap.get(opp.Id).StageName != 'Closed Lost'){

if(mapOfquaeterIdByAmount.containsKey(opp.Monthly_Incentive_Goal__c)){
mapOfquaeterIdByAmount.put(opp.Monthly_Incentive_Goal__c,mapOfquaeterIdByAmount.get(opp.Monthly_Incentive_Goal__c) + (  oldMap.get(opp.Id).Amount - opp.Amount ));
}else{

mapOfquaeterIdByAmount.put(opp.Monthly_Incentive_Goal__c,oldMap.get(opp.Id).Amount - opp.Amount );

//mapOfquaeterIdByCount.put(opp.Financial_Projection__c,1);
}
}] 11
}
if(!mapOfquaeterIdByAmount.isEmpty()){
List<Monthly_Incentive_Goal__c> qdListTobeUpdate = new List<Monthly_Incentive_Goal__c>();
qdListTobeUpdate = [select id,Total_Target_Achieved__c from Monthly_Incentive_Goal__c where id in: mapOfquaeterIdByAmount.keySet()];
if(!qdListTobeUpdate.isEmpty()){
for(Monthly_Incentive_Goal__c qd : qdListTobeUpdate){
if(  qd.Total_Target_Achieved__c != null){
qd.Total_Target_Achieved__c = qd.Total_Target_Achieved__c - mapOfquaeterIdByAmount.get(qd.id);
}

//qd.No_of_Opportunity__c = qd.No_of_Opportunity__c - mapOfquaeterIdByCount.get(qd.id);
}

update qdListTobeUpdate;
}

}


}*/
    
    public static void updateQuarterlyGoaltoClosedWon(List<Opportunity1__c> oppList,Map<Id,Opportunity1__c> oldMap){
        Map<Id,Decimal> mapOfquaeterIdByAmount = new Map<Id,Decimal>();
        Map<Id,Integer> mapOfquaeterIdByCount  = new Map<Id,Integer>();
        list<Opportunity1__c> updateOppList = new list<Opportunity1__c>();
        // Map<Id,Decimal> mapOfquaeterIdByTotalAmount = new Map<Id,Decimal>();
        for(Opportunity1__c opp : oppList){
            if(opp.StageName__c != null && opp.StageName__c != oldMap.get(opp.Id).StageName__c && opp.StageName__c == 'Closed Won' ){
                if(mapOfquaeterIdByAmount.containsKey(opp.Quarterly_Goal__c)){
                    mapOfquaeterIdByAmount.put(opp.Quarterly_Goal__c,mapOfquaeterIdByAmount.get(opp.Quarterly_Goal__c) + opp.Amount__c);
                    //  mapOfquaeterIdByCount.put(opp.Quarterly_Goal__c,mapOfquaeterIdByCount.get(opp.Quarterly_Goal__c) + 1);
                    // mapOfquaeterIdByTotalAmount.put(opp.Quarterly_Goal__c,mapOfquaeterIdByTotalAmount.get(opp.Quarterly_Goal__c) + 0);
                }else{
                    mapOfquaeterIdByAmount.put(opp.Quarterly_Goal__c,opp.Amount__c);
                    // mapOfquaeterIdByCount.put(opp.Quarterly_Goal__c,1);
                    // mapOfquaeterIdByTotalAmount.put(opp.Quarterly_Goal__c,0);
                }
            }
        }
        
        if(!mapOfquaeterIdByAmount.isEmpty()){
            List<Quarterly_Goal__c> qdListTobeUpdate = new List<Quarterly_Goal__c>();
            qdListTobeUpdate = [select id,Total_Target_Achieved__c from Quarterly_Goal__c where id in: mapOfquaeterIdByAmount.keySet()];
            system.debug('qdListTobeUpdate==='+qdListTobeUpdate);
            if(!qdListTobeUpdate.isEmpty()){
                for(Quarterly_Goal__c qd : qdListTobeUpdate){
                    if(qd.Total_Target_Achieved__c !=null){
                        qd.Total_Target_Achieved__c = qd.Total_Target_Achieved__c - mapOfquaeterIdByAmount.get(qd.id);
                        
                    }
                    /*if( qd.No_of_Opportunity__c != null){
qd.No_of_Opportunity__c = qd.No_of_Opportunity__c - mapOfquaeterIdByCount.get(qd.id);
system.debug(' qd.No_of_Opportunity__c==='+qd.No_of_Opportunity__c);
}*/
                    
                }
                update qdListTobeUpdate;
            }
        }
        if(!oppList.IsEmpty()){
            for(Opportunity1__c opp : oppList){
                if(opp.StageName__c != null && opp.StageName__c != oldMap.get(opp.Id).StageName__c && opp.StageName__c == 'Closed Won' && opp.Quarterly_Goal__c != null){
                    Opportunity1__c oopRec = new Opportunity1__c();
                    oopRec.id = opp.id;
                    oopRec.Quarterly_Goal__c = null;
                    updateOppList.add(oopRec);
                }
            }
        }
        if(!updateOppList.IsEmpty()){
            update updateOppList;
        }
        
    }
    
    //Added by shubhi : used for inserting Product Fixed Price record under Account after Opp is marked Closed Won.
    
    public static void insertNewProductFixedPriceRecord(Map<Id,Opportunity1__c> mapOfOpportunity){
        
        Map<Id,List<Opportunity1__c>> mapofAccIdByListOfOpp = new Map<Id,List<Opportunity1__c>>();
        
        for(Opportunity1__c opp : mapOfOpportunity.values()){
            if(opp.StageName__c == 'Closed Won'){
                if(mapofAccIdByListOfOpp.containsKey(opp.AccountId__c)){
                    mapofAccIdByListOfOpp.get(opp.AccountId__c).add(opp);
                }else{
                    mapofAccIdByListOfOpp.put(opp.AccountId__c,New List<Opportunity1__c>{opp});
                }
            }
        }
        
        system.debug('mapofAccIdByListOfOpp' + mapofAccIdByListOfOpp);
        
        List<OpportunityLineItem1__c> oliList = new List<OpportunityLineItem1__c>();
        
        oliList = [Select id,Product1Id__c,Opportunity1Id__c,UnitPrice__c 
                   from OpportunityLineItem1__c 
                   where Opportunity1Id__c in: mapOfOpportunity.keyset()];
        
        if(!mapofAccIdByListOfOpp.isEmpty()){
            List<Product_Fixed_Price__c> pfpList                     = new List<Product_Fixed_Price__c>();
            Map<Id,List<Product_Fixed_Price__c>> mapOfAccIdByPFPList = new Map<Id,List<Product_Fixed_Price__c>>();
            
            pfpList = [Select Id,Product__c,Account__c 
                       FROM Product_Fixed_Price__c 
                       where Account__c in: mapofAccIdByListOfOpp.keySet()];
            
            system.debug('pfpList' + pfpList);
            List<Product_Fixed_Price__c> pfpListTobeInsert = new List<Product_Fixed_Price__c>();
            
            if(!pfpList.isEmpty()){
                
                for(Product_Fixed_Price__c pfp : pfpList){
                    if(mapOfAccIdByPFPList.containsKey(pfp.Account__c)){
                        mapOfAccIdByPFPList.get(pfp.Account__c).add(pfp);
                    }else{
                        mapOfAccIdByPFPList.put(pfp.Account__c,new List<Product_Fixed_Price__c>{pfp});
                    }
                }
                
                for(OpportunityLineItem1__c oli:oliList){
                    
                    boolean flowContinue = false;
                    for(Product_Fixed_Price__c pfp : mapOfAccIdByPFPList.get(mapOfOpportunity.get(oli.Opportunity1Id__c).AccountId__c)){
                        
                        if(oli.Product1Id__c == pfp.Product__c){
                            break;
                            flowContinue = false;
                        }
                        flowContinue = true;
                    }
                    if(flowContinue){
                        Product_Fixed_Price__c pfp = new Product_Fixed_Price__c();
                        pfp.Product__c             = oli.Product1Id__c;
                        pfp.Account__c             = mapOfOpportunity.get(oli.Opportunity1Id__c).AccountId__c;
                        pfp.Selling_Price__c       = oli.UnitPrice__c;
                        pfpListTobeInsert.add(pfp);
                    }
                    
                }
                insert pfpListTobeInsert;
            }
            else if(pfpList.isEmpty()){
                for(OpportunityLineItem1__c oli:oliList){
                    Product_Fixed_Price__c pfp = new Product_Fixed_Price__c();
                    pfp.Product__c             = oli.Product1Id__c;
                    pfp.Account__c             = mapOfOpportunity.get(oli.Opportunity1Id__c).AccountId__c;
                    pfp.Selling_Price__c       = oli.UnitPrice__c;
                    pfpListTobeInsert.add(pfp);
                }
                insert pfpListTobeInsert;
            }
        }
    }
      
    //Added by shubhi : used for updating Total Target Achieved on Quarterly Goal from Opportunity's Amount Field.
    
    public static void rollUpAmountOnQuarterlyGoal(List<Opportunity1__c> newOppList, Map<Id, Opportunity1__c> oldOpportunitiesMap){
        
        List<Quarterly_Goal__c> quarterlyGoalsToUpdate = new List<Quarterly_Goal__c>();
        
        for (Opportunity1__c newOpportunity : newOppList) {
            Opportunity1__c oldOpportunity = oldOpportunitiesMap.get(newOpportunity.Id);
            
            if (newOpportunity.StageName__c == 'Closed Won' && oldOpportunity.StageName__c != 'Closed Won') {
                
                Quarterly_Goal__c quarterlyGoal = [SELECT Id, Total_Target_Achieved__c FROM Quarterly_Goal__c WHERE Id = :newOpportunity.Quarterly_Goal__c LIMIT 1];
                quarterlyGoal.Total_Target_Achieved__c = newOpportunity.Amount__c;
                quarterlyGoalsToUpdate.add(quarterlyGoal);
            }
        }
        
        if (!quarterlyGoalsToUpdate.isEmpty()) {
            update quarterlyGoalsToUpdate;
        }
        
    }
    
    //Added by shubhi : used to tag Quarterly Goal when new opportunity is inserted.
    
    public static  void tagQuarterlyGoal(List<Opportunity1__c> opplist){
        
        set<Id> fiscalid = new set<id>();
        
        map<id,list<Quarterly_Goal__c>> mapFiscalIdMonthlygoal = new  map<id,list<Quarterly_Goal__c>>();
        if(opplist.size()>0){
            for(Opportunity1__c OppRec : opplist){
                fiscalid.add(OppRec.Fiscal_Year__c	);
            }
            
            list<Quarterly_Goal__c> quatrterGoalList = [select id,Quarter_End_Date__c,Quarter_Start_Date__c,Fiscal_Year__c	
                                                        From Quarterly_Goal__c where Fiscal_Year__c IN: fiscalid];
            if(quatrterGoalList.size()>0){
                for(Quarterly_Goal__c quarterGoalRec : quatrterGoalList){
                    mapFiscalIdMonthlygoal.put(quarterGoalRec.Fiscal_Year__c,quatrterGoalList);
                }
            }
            
            for(Opportunity1__c oppRec : opplist){
                if(mapFiscalIdMonthlygoal.containsKey(oppRec.Fiscal_Year__c	)){
                    for(Quarterly_Goal__c quarterlyRec : mapFiscalIdMonthlygoal.get(oppRec.Fiscal_Year__c	)){
                        if(oppRec.CloseDate__c	 >= quarterlyRec.Quarter_Start_Date__c && oppRec.CloseDate__c <=quarterlyRec.Quarter_End_Date__c ){ 
                            oppRec.Quarterly_Goal__c = quarterlyRec.id;
                        }
                    }
                }   
            }
            
        }
        
    }
    
    //Added by shubhi : used to tag Quarterly Goal when after insert of Opportunity, Fiscal Year is updated.
    
    public static void tagQuarterlyGoalAfterFYIsUpdated(List<Opportunity1__c> newList, Map<Id, Opportunity1__c> oldOppMap) {
        
        Set<Id> fiscalIds                                       = new Set<Id>();
        Map<Id, List<Quarterly_Goal__c>> mapFiscalIdMonthlyGoal = new Map<Id, List<Quarterly_Goal__c>>();

        List<Opportunity1__c> opportunitiesToUpdate = new List<Opportunity1__c>();
        for (Opportunity1__c newOpportunity : newList) {
            Opportunity1__c oldOpportunity = oldOppMap.get(newOpportunity.Id);
            if (oldOpportunity.Fiscal_Year__c != newOpportunity.Fiscal_Year__c) {
                opportunitiesToUpdate.add(newOpportunity);
            }
            fiscalIds.add(newOpportunity.Fiscal_Year__c);
        }

        if (!fiscalIds.isEmpty()) {
            
            List<Quarterly_Goal__c> quarterlyGoalList = [SELECT Id, Quarter_End_Date__c, Quarter_Start_Date__c, Fiscal_Year__c 
                                                         FROM Quarterly_Goal__c WHERE Fiscal_Year__c IN :fiscalIds];

            for (Quarterly_Goal__c quarterlyGoalRec : quarterlyGoalList) {
                mapFiscalIdMonthlyGoal.put(quarterlyGoalRec.Fiscal_Year__c, quarterlyGoalList);
            }

            for (Opportunity1__c oppRec : opportunitiesToUpdate) {
                if (mapFiscalIdMonthlyGoal.containsKey(oppRec.Fiscal_Year__c)) {
                    for (Quarterly_Goal__c quarterlyRec : mapFiscalIdMonthlyGoal.get(oppRec.Fiscal_Year__c)) {
                        if (oppRec.CloseDate__c >= quarterlyRec.Quarter_Start_Date__c && oppRec.CloseDate__c <= quarterlyRec.Quarter_End_Date__c) {
                            oppRec.Quarterly_Goal__c = quarterlyRec.Id;
                        }
                    }
                }
            }
        }
    }
    
    //Added by shubhi : used to tag Quarterly Goal when after insert of Opportunity, Close date is updated.
    
    public static void updateQuarterlyGoalByClosedate(List<Opportunity1__c> opplist, Map<Id,Opportunity1__c> oldOppRec){
        
        Set<Id> fiscalIds                                            = new Set<Id>();
        Map<Id, List<Quarterly_Goal__c>> mapOfFiscalIdQuarterlyGoals = new Map<Id, List<Quarterly_Goal__c>>();
        
        if (opplist.size() > 0) {
            for (Opportunity1__c opp : opplist) {
                fiscalIds.add(opp.Fiscal_Year__c);
            }
            
            List<Quarterly_Goal__c> quarterlyGoalList = [SELECT Id, Quarter_Start_Date__c, Quarter_End_Date__c, Fiscal_Year__c 
                                                         FROM Quarterly_Goal__c WHERE Fiscal_Year__c IN :fiscalIds];
            
            for (Quarterly_Goal__c quarterlyGoalRec : quarterlyGoalList) {
                mapOfFiscalIdQuarterlyGoals.put(quarterlyGoalRec.Fiscal_Year__c, quarterlyGoalList);
            }
            
            for (Opportunity1__c oppRec : opplist) {
                Opportunity1__c oldOpp = oldOppRec.get(oppRec.Id);
                if (oldOpp.CloseDate__c != oppRec.CloseDate__c) {
                    if (mapOfFiscalIdQuarterlyGoals.containsKey(oppRec.Fiscal_Year__c)) {
                        for (Quarterly_Goal__c quarterlyRec : mapOfFiscalIdQuarterlyGoals.get(oppRec.Fiscal_Year__c)) {
                            if (oppRec.CloseDate__c >= quarterlyRec.Quarter_Start_Date__c && oppRec.CloseDate__c <= quarterlyRec.Quarter_End_Date__c) {
                                oppRec.Quarterly_Goal__c = quarterlyRec.Id;
                            }
                        }
                    }
                }
            }
        }
    }
    
    //Added by shubhi : used to tag Fiscal Year based on Opp Created Date.
    
    public static void updateFiscalYearByCreatedDate(List<Opportunity1__c> newOpplist) {
        
        List<Id> opportunityIdsToUpdate = new List<Id>();
        
        try {
            for (Opportunity1__c opp : newOpplist) {
                Datetime createdDatetime = opp.CreatedDate;
                if (createdDatetime != null) {
                    Date createdDate = createdDatetime.date();
                    
                    Fiscal_Year__c fiscalYear = getFiscalYearByDate(createdDate);
                    if (fiscalYear != null) {
                        opportunityIdsToUpdate.add(opp.Id);
                    }
                }
            }
            
            if (!opportunityIdsToUpdate.isEmpty()) {
                List<Opportunity1__c> opportunitiesToUpdate = [SELECT Id, Fiscal_Year__c,CreatedDate FROM Opportunity1__c WHERE Id IN :opportunityIdsToUpdate];
                
                for (Opportunity1__c oppToUpdate : opportunitiesToUpdate) {
                    Fiscal_Year__c fiscalYear = getFiscalYearByDate(oppToUpdate.CreatedDate.date());
                    if (fiscalYear != null) {
                        oppToUpdate.Fiscal_Year__c = fiscalYear.Id;
                    }
                }
                
                if (!opportunitiesToUpdate.isEmpty()) {
                    update opportunitiesToUpdate;
                }
            }
        } catch (Exception e) {
            System.debug('Exception caught: ' + e.getMessage());
        }
    }
    
    @TestVisible 
    private static Fiscal_Year__c getFiscalYearByDate(Date createdDate) {
        List<Fiscal_Year__c> fiscalYears = [SELECT Id FROM Fiscal_Year__c WHERE Fiscal_Year_Start_Period__c <= :createdDate AND Fiscal_Year_End_Period__c >= :createdDate LIMIT 1];
        return fiscalYears.isEmpty() ? null : fiscalYears[0];
    }
    
    //Added by shubhi : used to tag Opportunity Owner based on Account Owner.
    
    public static void updateOppOwner(List<Opportunity1__c> oppList){
        
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity1__c opp : oppList) {
            if (opp.AccountId__c != null) {
                accountIds.add(opp.AccountId__c);
            }
        }
        
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, OwnerId FROM Account WHERE Id IN :accountIds]);
        
        for (Opportunity1__c opp : oppList) {
            if (opp.AccountId__c != null && accountMap.containsKey(opp.AccountId__c)) {
                opp.OwnerId__c = accountMap.get(opp.AccountId__c).OwnerId;
            }
        }
    }
    
    //Added by shubhi : used to Change Primary Quote stage based on Opportunity Stage.
    
    public static void updateQuoteStage(List<Opportunity1__c> newOppList, Map<Id,Opportunity1__c> oldOppRec){
        
        List<Opportunity1__c> opportunitiesToUpdate = new List<Opportunity1__c>();
        
        for (Opportunity1__c opp : newOppList) {
            if (opp.StageName__c == 'Quote Initiated' && oldOppRec.get(opp.Id).StageName__c != 'Quote Initiated') {
                opportunitiesToUpdate.add(opp);
            }
        }
        
        if (!opportunitiesToUpdate.isEmpty()) {

            List<Quote_C__c> primaryQuotesToUpdate = [SELECT Id, Status__c, OpportunityId__c FROM Quote_C__c WHERE OpportunityId__c IN :opportunitiesToUpdate];
          
            for (Quote_C__c q : primaryQuotesToUpdate) {
                q.Status__c = 'Presented';
            }
            
            if (!primaryQuotesToUpdate.isEmpty()) {
                update primaryQuotesToUpdate;
            }
        }
    }
    
}