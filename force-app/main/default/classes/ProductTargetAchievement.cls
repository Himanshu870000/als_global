public class ProductTargetAchievement {
    
    public static void setTargetAchievement(Set<Id> oppIdSet){
        List<OpportunityLineItem1__c> oliList = new List<OpportunityLineItem1__c>();
        oliList  =[SELECT Id,TotalPrice__c FROM OpportunityLineItem1__c 
                   where Opportunity1Id__c in: oppIdSet];
    }

}