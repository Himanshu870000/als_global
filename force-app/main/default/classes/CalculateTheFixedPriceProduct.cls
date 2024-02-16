public class CalculateTheFixedPriceProduct {
    
  /* Public Static void CalculateTheFixedPrice(Map<Id,Opportunity> mapOfOpportunity){
        Map<Id,List<Opportunity>> mapofAccIdByListOfOpp = new Map<Id,List<Opportunity>>();
        
        for(Opportunity opp : mapOfOpportunity.values()){
            if(mapofAccIdByListOfOpp.containsKey(opp.AccountId)){
                mapofAccIdByListOfOpp.get(opp.AccountId).add(opp);
            }else{
                mapofAccIdByListOfOpp.put(opp.AccountId,New List<Opportunity>{opp});
            }
        }
        
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        oliList = [Select id,Product2Id,OpportunityId from OpportunityLineItem where OpportunityId in: mapOfOpportunity.keyset()];
        
        if(!mapofAccIdByListOfOpp.isEmpty()){
           List<Product_Fixed_Price__c> pfpList = new List<Product_Fixed_Price__c>();
            Map<Id,List<Product_Fixed_Price__c>> mapOfAccIdByPFPList = new Map<Id,List<Product_Fixed_Price__c>>();
            pfpList = [Select Id,Product__c,Account__c 
                       FROM Product_Fixed_Price__c 
                       where Account__c in: mapofAccIdByListOfOpp.keySet()];
            
            if(!pfpList.isEmpty()){
                List<Product_Fixed_Price__c> pfpListTobeInsert = new List<Product_Fixed_Price__c>();
                for(Product_Fixed_Price__c pfp : pfpList){
                    if(mapOfAccIdByPFPList.containsKey(pfp.Account__c)){
                        mapOfAccIdByPFPList.get(pfp.Account__c).add(pfp);
                    }else{
                        mapOfAccIdByPFPList.put(pfp.Account__c,new List<Product_Fixed_Price__c>{pfp});
                    }
                }
                
                for(OpportunityLineItem oli:oliList){
                    boolean flowContinue = false;
                    for(Product_Fixed_Price__c pfp : mapOfAccIdByPFPList.get(mapOfOpportunity.get(oli.OpportunityId).AccountId)){
                        if(oli.Product2Id == pfp.Product__c){
                            break;
                            flowContinue = false;
                        }
                        flowContinue = true;
                    }
                    if(flowContinue){
                        Product_Fixed_Price__c pfp = new Product_Fixed_Price__c();
                        pfp.Product__c = oli.Product2Id;
                        pfp.Account__c = mapOfOpportunity.get(oli.OpportunityId).AccountId;
                        pfpListTobeInsert.add(pfp);
                    }
                    
                }
            }
        }
    }*/

}