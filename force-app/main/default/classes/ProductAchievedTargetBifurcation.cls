public class ProductAchievedTargetBifurcation {

    public static void CreateProductTargetBifurcation(List<Opportunity1__c> opplist, Map<Id, Opportunity1__c> oppRecMap) {
        
        Set<Id> ownerIdSet = new Set<Id>();
        Map<Id, Id> mapofOwnerIdByYearltGoalId = new Map<Id, Id>();
        Map<Id, Map<Id, Decimal>> mapofOwnerIdByMapOfProdIdByAmount = new Map<Id, Map<Id, Decimal>>();
        Map<String, Product_Target_Detail__c> existingProdTargetsMap = new Map<String, Product_Target_Detail__c>(); 
        
        List<OpportunityLineItem1__c> oliList = [SELECT Id, CreatedById, Product1Id__c, TotalPrice__c, Opportunity1Id__c FROM OpportunityLineItem1__c WHERE Opportunity1Id__c IN :oppRecMap.keySet() AND Opportunity1Id__r.StageName__c = 'Closed Won'];
        
        System.debug('Queried Opportunity Line Items: ' + oliList);
        
        Map<Id, Decimal> temprMap;
        
        for (OpportunityLineItem1__c oli : oliList) {
            System.debug('oli.CreatedById ::'+oli.CreatedById);
            ownerIdSet.add(oli.CreatedById);
            
            if (mapofOwnerIdByMapOfProdIdByAmount.containsKey(oli.CreatedById)) {
                temprMap = mapofOwnerIdByMapOfProdIdByAmount.get(oli.CreatedById);
                if (temprMap.containsKey(oli.Product1Id__c)) {
                    temprMap.put(oli.Product1Id__c, temprMap.get(oli.Product1Id__c) + oli.TotalPrice__c);
                } else {
                    temprMap.put(oli.Product1Id__c, oli.TotalPrice__c);
                }
                
                mapofOwnerIdByMapOfProdIdByAmount.put(oli.CreatedById,temprMap);
            } else {
                temprMap = new Map<Id, Decimal>();
                temprMap.put(oli.Product1Id__c, oli.TotalPrice__c);
                mapofOwnerIdByMapOfProdIdByAmount.put(oli.CreatedById, temprMap);
            }
        }
        
        System.debug('OwnerId Set: ' + ownerIdSet);
        System.debug('Map of OwnerId by Map of ProdId by Amount: ' + mapofOwnerIdByMapOfProdIdByAmount);
        
        if (!ownerIdSet.isEmpty()) {
            List<Yearly_Goal__c> yearlyGoalList = [SELECT Id, User__c FROM Yearly_Goal__c WHERE User__c IN :ownerIdSet];
            
            System.debug('Queried Yearly Goals: ' + yearlyGoalList);
            
            if (!yearlyGoalList.isEmpty()) {
                for (Yearly_Goal__c yg : yearlyGoalList) {
                    System.debug('Processing Yearly Goal: ' + yg);
                    mapofOwnerIdByYearltGoalId.put(yg.User__c, yg.Id);
                    System.debug('Added mapping of OwnerId to Yearly Goal Id: ' + yg.User__c + ' => ' + yg.Id);
                }
            }
            
            System.debug('Map of OwnerId by Yearly Goal Id: ' + mapofOwnerIdByYearltGoalId);
            
            List<Product_Target_Detail__c> existingProdTargets = [SELECT Id, Product__c, Yearly_Goal__c,Achieved_Target__c FROM Product_Target_Detail__c
                                                                  WHERE Yearly_Goal__c IN :mapofOwnerIdByYearltGoalId.values() 
                                                                  AND Product__c IN :temprMap.keySet()];
            
            System.debug('Queried Existing Product Targets: ' + existingProdTargets);
            
            if (existingProdTargets.isEmpty()) {
                System.debug('No existing product targets found.');
            } else {
                for(Product_Target_Detail__c existingProdTarget : existingProdTargets){
                    String existingKey = existingProdTarget.Product__c + '_' + existingProdTarget.Yearly_Goal__c;
                    existingProdTargetsMap.put(existingKey, existingProdTarget);
                    System.debug('Existing Product Target: ' + existingKey + ' => ' + existingProdTarget);
                }
                System.debug('Existing Product Targets Map: ' + existingProdTargetsMap);
            }
            
            List<Product_Target_Detail__c> prodTargetListTobeInsert = new List<Product_Target_Detail__c>();
            
            if (!mapofOwnerIdByMapOfProdIdByAmount.isEmpty()) {
                for (Id ownerId : mapofOwnerIdByMapOfProdIdByAmount.keySet()) {
                    System.debug('Processing OwnerId: ' + ownerId);
                    Map<Id, Decimal> tempMap = mapofOwnerIdByMapOfProdIdByAmount.get(ownerId);
                    
                    for (Id mapKey : tempMap.keySet()) {
                        String key = mapKey + '_' + mapofOwnerIdByYearltGoalId.get(ownerId);
                        System.debug('Processing Map Key: ' + key);
                        
                        Product_Target_Detail__c prodTarget;
                        
                        if(existingProdTargetsMap.containsKey(key)){
                            prodTarget = existingProdTargetsMap.get(key);
                            prodTarget.Achieved_Target__c += tempMap.get(mapKey);
                            System.debug('Updating existing Product Target: ' + key + ' => ' + prodTarget);
                        } else {
                            prodTarget                    = new Product_Target_Detail__c();
                            prodTarget.Product__c         = mapKey;
                            prodTarget.Achieved_Target__c = tempMap.get(mapKey);
                            System.debug(' mapofOwnerIdByYearltGoalId.get(ownerId)'+ mapofOwnerIdByYearltGoalId.get(ownerId));
                            prodTarget.Yearly_Goal__c     = mapofOwnerIdByYearltGoalId.get(ownerId);
                            System.debug(' mapofOwnerIdByYearltGoalId.get(ownerId)'+ mapofOwnerIdByYearltGoalId.get(ownerId));
                            prodTargetListTobeInsert.add(prodTarget);
                            System.debug('Creating new Product Target: ' + key + ' => ' + prodTarget);
                        }
                    }
                }
            }
            
            System.debug('prodTargetListTobeInsert: ' + prodTargetListTobeInsert);
            
            insert prodTargetListTobeInsert;
        }
    }
}