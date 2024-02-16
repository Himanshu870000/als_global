public class UpdateMonthlyIncentive {
 /*   public static void UpdateMonthlyIncentive(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunitiesMap){
        set<Date> closeDT = new  set<Date>();
        map<id,Map<id,Integer>> mapOfIncetiveOpportunity = new map<id,Map<id,Integer>>();
        Map<id,Integer> mapofMonthIdMonth = new Map<id,Integer>();
        map<string,Integer> mapofUserAndMonth = new map<string,Integer>();
        list<Opportunity> opplist = new list<Opportunity>();
        for(Opportunity Opp : newOpportunities){
            integer   closemonth = Opp.CloseDate.month();
            Opportunity oldOpp = oldOpportunitiesMap.get(opp.Id);
            if(Opp.StageName != oldOpp.StageName){
                mapofUserAndMonth.put(Opp.OwnerId ,closemonth);
            }
        }
        system.debug('mapofUserAndMonth==='+mapofUserAndMonth);
        List<Monthly_Incentive_Goal__c> monthIncentiveRecList = [Select id,Total_Target_Achieved__c,Start_Date__c,End_Date__c,User__c
                                                                 From Monthly_Incentive_Goal__c 
                                                                 where  Fiscal_Year__c ='a1d5i000000mnuVAAQ'];
        
        for(Monthly_Incentive_Goal__c monthInRec :monthIncentiveRecList){
            if(monthInRec.User__c != null){
                integer startMonth = monthInRec.Start_Date__c.month();
                if( mapOfIncetiveOpportunity.containsKey(monthInRec.User__c)){
                    mapofMonthIdMonth.put(monthInRec.id,startMonth);
                    mapOfIncetiveOpportunity.put(monthInRec.Id,mapofMonthIdMonth);
                }else{
                    mapofMonthIdMonth.put(monthInRec.id,startMonth);
                    mapOfIncetiveOpportunity.put(monthInRec.User__c,mapofMonthIdMonth);
                }
                system.debug('mapOfIncetiveOpportunity==='+mapOfIncetiveOpportunity);
            }
        }
        
        
        
      }*/   
        
        
        
        
        
        
        
        
        
/*if(closeDT.Size()>0){
Monthly_Incentive_Goal__c monthIncentiveRec = [Select id,Total_Target_Achieved__c,Start_Date__c,End_Date__c
From Monthly_Incentive_Goal__c 
Where Start_Date__c >=: closeDT AND End_Date__c <=: closeDT AND Fiscal_Year__c ='a1d5i000000mnuVAAQ' Limit 1];
System.debug(' monthIncentiveRec==='+monthIncentiveRec);    
if(monthIncentiveRec != null){
for(Opportunity Opp1 : newOpportunities){
Opp1.Monthly_Incentive_Goal__c = monthIncentiveRec.id;
opplist.add(Opp1);
}
update opplist;
}   
}*/
        
   
    
    public static void UpdateMonthlyIncentiveOnStageClosedWon(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunitiesMap){
        try{
            list<Opportunity> opplist = new list<Opportunity>();
            list<Monthly_Incentive_Goal__c> mIGlist  = new list<Monthly_Incentive_Goal__c>();
            Map<String,Integer> mapOfIdMonthlyIncentiveGoalId = new Map<String,Integer>();
            Map<String,String> mapOfMonthNoMIGId = new Map<String,String>();
            map<string,Decimal> mapofOppIdOppAmount = new  map<string,Decimal>();
            set<id> ownerId = new set<id>();
            
            System.debug('mapOfMonthNoMIGId == >'+mapOfMonthNoMIGId);
            for(Opportunity opp : newOpportunities){
                ownerId.add(opp.OwnerId);
                if(opp.StageName == 'Closed Won' && opp.StageName !=oldOpportunitiesMap.get(opp.Id).StageName){
                    Integer currentMonth = Opp.CloseDate.month();
                    mapOfIdMonthlyIncentiveGoalId.put(opp.id,currentMonth);
                    // mapofOppIdOppAmount.put(opp.id,opp.Amount);
                }
            }
            
            for(Monthly_Incentive_Goal__c mig : [SELECT Id,Name,Fiscal_Year__c,User__c,Month_No__c FROM Monthly_Incentive_Goal__c WHERE User__c IN :ownerId]){
                mapOfMonthNoMIGId.put(String.valueOf(mig.Month_No__c),mig.id);
            }
            System.debug('mapOfIdMonthlyIncentiveGoalId == >'+mapOfIdMonthlyIncentiveGoalId);
            if(mapOfIdMonthlyIncentiveGoalId.keyset().size()>0){
                for(Opportunity opp : [SELECT Id,Name,Monthly_Incentive_Goal__c,Amount FROM Opportunity WHERE Id IN:mapOfIdMonthlyIncentiveGoalId.keyset()]){
                    Opportunity oppToupdate = new Opportunity();
                    oppToupdate.id = opp.id;
                    oppToupdate.Monthly_Incentive_Goal__c = mapOfMonthNoMIGId.get(String.valueOf(mapOfIdMonthlyIncentiveGoalId.get(opp.id)));
                    oppToupdate.Amount = opp.Amount;
                    opplist.add(oppToupdate);
                    
                }
                
                if(opplist.size()>0){
                    update opplist;
                    System.debug('opplist == >'+opplist);
                    if(opplist.size()>0){
                        for(Opportunity oppRec : opplist){
                            mapofOppIdOppAmount.put(oppRec.Monthly_Incentive_Goal__c,oppRec.Amount);
                        }
                        if(mapofOppIdOppAmount.keySet().Size()>0){
                            for(Monthly_Incentive_Goal__c miRec1 :[SELECT Id,Name,Fiscal_Year__c,Month_No__c,Total_Target_Achieved__c FROM Monthly_Incentive_Goal__c where ID IN: mapofOppIdOppAmount.KeySet()]){
                                Monthly_Incentive_Goal__c MigRec = new Monthly_Incentive_Goal__c();
                                MigRec.id = miRec1.id;
                                System.debug('mapofOppIdOppAmount == >'+mapofOppIdOppAmount);
                                System.debug('miRec1.Total_Target_Achieved__c == >'+miRec1.Total_Target_Achieved__c);
                                System.debug('mapofOppIdOppAmount.get(miRec1.id) == >'+mapofOppIdOppAmount.get(miRec1.id));
                                if(miRec1.Total_Target_Achieved__c == null){
                                    MigRec.Total_Target_Achieved__c = miRec1.Total_Target_Achieved__c + mapofOppIdOppAmount.get(miRec1.id);
                                }else if(miRec1.Total_Target_Achieved__c !=  null ){
                                    MigRec.Total_Target_Achieved__c = miRec1.Total_Target_Achieved__c + mapofOppIdOppAmount.get(miRec1.id);
                                    
                                }
                                mIGlist.add(MigRec);
                            }
                            if(mIGlist.size()>0){
                                update mIGlist; 
                                System.debug('mIGlist == >'+mIGlist);
                            }
                        }
                    }
                }
            }
          }catch(Exception e){
            System.debug('Error ==>'+e.getMessage()+' && Error Line ===>'+e.getlineNumber());
        }
    }
}