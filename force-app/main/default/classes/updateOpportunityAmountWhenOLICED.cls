public class updateOpportunityAmountWhenOLICED {
    
    //Method to handle the insert opp line items with Quantity or Salesprice
    public static void updateOpportunityRollupONInsert(List<OpportunityLineItem1__c> oppLineItems){
        try{
            Set<Id> opportunityIds = new Set<Id>();
            for (OpportunityLineItem1__c oli : oppLineItems) {
                if(oli.Opportunity1Id__c != null){
                    opportunityIds.add(oli.Opportunity1Id__c);
                }
            }
            List<Opportunity1__c> opportunitiesToUpdate = [SELECT Id,Name, (SELECT Id,TotalPrice__c FROM OpportunityLineItems1__r) FROM Opportunity1__c WHERE Id IN :opportunityIds];
            List<Opportunity1__c> opportunitiesToUpdateList = new List<Opportunity1__c>();
            if(!opportunitiesToUpdate.isEmpty()){
                for (Opportunity1__c opp : opportunitiesToUpdate) {
                    Decimal totalAmount = 0;
                    
                    for (OpportunityLineItem1__c oliItem : opp.OpportunityLineItems1__r) {
                        if(oliItem.TotalPrice__c != null){
                            totalAmount += oliItem.TotalPrice__c;
                        }               
                    }
                    
                    opp.Amount__c = totalAmount;
                    opportunitiesToUpdateList.add(opp);
                }
            }
            
            if (!opportunitiesToUpdateList.isEmpty()) {
                update opportunitiesToUpdateList;
            }
        }
        catch(Exception e){
            System.debug('Exception occured ==>'+e.getMessage());
        }
    }
    
    //Method to handle the update Quantity or Salesprice
    public static void updateOpportunityRollupOnUpdate(List<OpportunityLineItem1__c> oppLineItems, Map<Id,OpportunityLineItem1__c> oldItems){
        try{
            Set<Id> opportunityIds = new Set<Id>();
            for (OpportunityLineItem1__c oli : oppLineItems) {
                if(oli.Opportunity1Id__c != null){
                    if(oli.Opportunity1Id__c !=oldItems.get(oli.id).Opportunity1Id__c || oli.Quantity__c!=oldItems.get(oli.id).Quantity__c || oli.UnitPrice__c!=oldItems.get(oli.id).UnitPrice__c){
                        opportunityIds.add(oli.Opportunity1Id__c);
                    }
                }
            }
            List<Opportunity1__c> opportunitiesToUpdate = [SELECT Id,Name, (SELECT Id,TotalPrice__c FROM OpportunityLineItems1__r) FROM Opportunity1__c WHERE Id IN :opportunityIds];
            List<Opportunity1__c> opportunitiesToUpdateList = new List<Opportunity1__c>();
            if(!opportunitiesToUpdate.isEmpty()){
                for (Opportunity1__c opp : opportunitiesToUpdate) {
                    Decimal totalAmount = 0;
                    
                    for (OpportunityLineItem1__c oliItem : opp.OpportunityLineItems1__r) {
                        if(oliItem.TotalPrice__c != null){
                            totalAmount += oliItem.TotalPrice__c;
                        }               
                    }
                    
                    opp.Amount__c = totalAmount;
                    opportunitiesToUpdateList.add(opp);
                }
            }
            
            if (!opportunitiesToUpdateList.isEmpty()) {
                update opportunitiesToUpdateList;
            }
        }
        catch(Exception e){
            System.debug('Exception occured ==>'+e.getMessage());
        }
    } 
    
    //Method to handle the Delete Oppline items
    
     public static void updateOpportunityRollupOnDelete(List<OpportunityLineItem1__c> oppLineItems){
        try{
            Set<Id> opportunityIds = new Set<Id>();
            for (OpportunityLineItem1__c oli : oppLineItems) {
                if(oli.Opportunity1Id__c != null){ 
                        opportunityIds.add(oli.Opportunity1Id__c); 
                }
            }
            List<Opportunity1__c> opportunitiesToUpdate = [SELECT Id,Name, (SELECT Id,TotalPrice__c FROM OpportunityLineItems1__r) FROM Opportunity1__c WHERE Id IN :opportunityIds];
            List<Opportunity1__c> opportunitiesToUpdateList = new List<Opportunity1__c>();
            if(!opportunitiesToUpdate.isEmpty()){
                for (Opportunity1__c opp : opportunitiesToUpdate) {
                    Decimal totalAmount = 0;
                    
                    for (OpportunityLineItem1__c oliItem : opp.OpportunityLineItems1__r) {
                        if(oliItem.TotalPrice__c != null){
                            totalAmount += oliItem.TotalPrice__c;
                        }               
                    }
                    
                    opp.Amount__c = totalAmount;
                    opportunitiesToUpdateList.add(opp);
                }
            }
            
            if (!opportunitiesToUpdateList.isEmpty()) {
                update opportunitiesToUpdateList;
            }
        }
        catch(Exception e){
            System.debug('Exception occured ==>'+e.getMessage());
        }
    }
}