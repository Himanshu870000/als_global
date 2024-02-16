public without sharing class SyncToOpportunityHelper {
    
    @AuraEnabled
    public static String getOtherQuoteName(String quoteId) {
        String otherQuoteName;
        try {
            if (!String.isBlank(quoteId)) {
                Quote_C__c currentQuote = [SELECT Id, OpportunityId__c
                                           FROM Quote_C__c 
                                           WHERE Id = :quoteId];
                if (currentQuote != null) {
                    List<Quote_C__c> otherQuotes = [
                        SELECT Id, Quote_Name__c, OpportunityId__c
                        FROM Quote_C__c 
                        WHERE OpportunityId__c = :currentQuote.OpportunityId__c AND Id != :quoteId AND IsSyncing__c = true
                    ];
                    if (!otherQuotes.isEmpty()) {
                        otherQuoteName = otherQuotes[0].Quote_Name__c;
                    }
                }
            }
        } catch (Exception ex) {
            system.debug('Error getting Other Quote Name: ' + ex.getMessage());
        }
        System.debug('otherQuoteName====>' + otherQuoteName);
        return otherQuoteName;
    }
    
    @AuraEnabled
    public static void updateIsSyncing(String quoteId, Boolean markAsSyncing) {
        try {
            System.debug('Entering SetAsyncToFalse method');
            if (!String.isBlank(quoteId)) {
                system.debug('Quote Id:: ' + quoteId);
                List<Quote_C__c> qtList = [SELECT Id, OpportunityId__c, IsSyncing__c FROM Quote_C__c WHERE Id = :quoteId];
                
                List<Quote_C__c> otherQuotes = [
                    SELECT Id, IsSyncing__c
                    FROM Quote_C__c 
                    WHERE OpportunityId__c = :qtList[0].OpportunityId__c AND Id != :quoteId AND IsSyncing__c = true
                ];
                
                // Update IsSyncing__c field on Quote_C__c
                if (!otherQuotes.isEmpty()) {
                    otherQuotes[0].IsSyncing__c = false;
                    update otherQuotes[0];
                }
            }
        } catch (Exception ex) {
            system.debug('Error updating IsSyncing: ' + ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static void SetAsyncToFalse(String quoteId, Boolean markAsSyncing) {
        try {
            System.debug('Entering SetAsyncToFalse method');
            if (!String.isBlank(quoteId)) {
                system.debug('Quote Id:: ' + quoteId);
                List<Quote_C__c> qtList = [SELECT Id, OpportunityId__c, IsSyncing__c FROM Quote_C__c WHERE Id = :quoteId];
                
                // Update IsSyncing__c field on Quote_C__c
                if (!qtList.isEmpty()) {
                    qtList[0].IsSyncing__c = false;
                    update qtList[0];
                }
            }
            
        } catch (exception ex) {
            System.debug('Error in SetAsyncToFalse: ' + ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static void createQuoteLineItem(String quoteId, Boolean markAsSyncing){
        try{
            if(!String.isBlank(quoteId)) {
                system.debug('Quote Id:: '+ quoteId);
                List<Quote_C__c> qtList = [SELECT Id, OpportunityId__c FROM Quote_C__c WHERE Id =: quoteId];
                
                // Update IsSyncing__c field on Quote_C__c if markAsSyncing is true
                if (markAsSyncing && !qtList.isEmpty()) {
                    Quote_C__c quoteToUpdate = new Quote_C__c(Id = qtList[0].Id, IsSyncing__c = true);
                    update quoteToUpdate;
                }
                
                list<QuoteLineItems_c__c> productListToBeSynced = new list<QuoteLineItems_c__c>([SELECT Id,Opportunity_Line_Item1__c, 
                                                                                                 Opportunity_Line_Item1__r.Quantity__c, 
                                                                                                 Opportunity_Line_Item1__r.UnitPrice__c, Opportunity_Line_Item1__r.Id, 
                                                                                                 Opportunity_Line_Item1__r.Subtotal__c, 
                                                                                                 Opportunity_Line_Item1__r.TotalPrice__c, 
                                                                                                 Opportunity_Line_Item1__r.ListPrice__c, 
                                                                                                 Opportunity_Line_Item1__r.ProductCode__c
                                                                                                 FROM QuoteLineItems_c__c WHERE QuoteId__c =:quoteId]);
                
                List<Id> oppLineItemIdList = new List<Id>();
                List<QuoteLineItems_c__c> qliListToBeInserted = new List<QuoteLineItems_c__c>();
                
                if(!productListToBeSynced.isEmpty()) {
                    for(QuoteLineItems_c__c productRec : productListToBeSynced){
                        
                        /* newQuoteLineRec.UnitPrice = productRec.UnitPrice;
newQuoteLineRec.ServiceDate = productRec.ServiceDate;
newQuoteLineRec.Discount = productRec.Discount;*/
                        
                        productRec.Quantity__c = productRec.Opportunity_Line_Item1__r.Quantity__c;
                        productRec.List_Price__c = productRec.Opportunity_Line_Item1__r.ListPrice__c;
                        productRec.Subtotal__c = productRec.Opportunity_Line_Item1__r.Subtotal__c;
                        productRec.Sales_Price__c = productRec.Opportunity_Line_Item1__r.UnitPrice__c;
                        productRec.Product_Code__c = productRec.Opportunity_Line_Item1__r.ProductCode__c;
                        productRec.Total_Price__c = productRec.Opportunity_Line_Item1__r.TotalPrice__c;
                        
                        oppLineItemIdList.add(productRec.Opportunity_Line_Item1__r.Id);
                    }
                    system.debug('---'+productListToBeSynced);
                    update productListToBeSynced;                            
                }
                
                List<OpportunityLineItem1__c> oppLineItemsList = [SELECT Id, Quantity__c, ListPrice__c, Product1Id__c, Subtotal__c, UnitPrice__c, ProductCode__c, TotalPrice__c
                                                                  
                                                                  FROM OpportunityLineItem1__c WHERE Opportunity1Id__c =: qtList[0].OpportunityId__c AND Id NOT IN: oppLineItemIdList];
                
                if(oppLineItemsList.size() >0 ){
                    for(OpportunityLineItem1__c lineItem : oppLineItemsList){
                        
                        QuoteLineItems_c__c qli = new QuoteLineItems_c__c();
                        qli.QuoteId__c = qtList[0].Id;
                        qli.Opportunity_Line_Item1__c = lineItem.Id;
                        
                        qli.ProductId__c = lineItem.Product1Id__c;
                        
                        qli.Quantity__c = lineItem.Quantity__c;
                        qli.Sales_Price__c = lineItem.UnitPrice__c;
                        
                        qli.List_Price__c = lineItem.ListPrice__c;
                        qli.Subtotal__c = lineItem.Subtotal__c;
                        qli.Product_Code__c  = lineItem.ProductCode__c ; 
                        qli.Total_Price__c = lineItem.TotalPrice__c;
                        
                        
                        qliListToBeInserted.add(qli);
                    }
                }
                
                if(!qliListToBeInserted.isEmpty())
                    insert qliListToBeInserted;
                
                
                
            }
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage());
            system.debug('Error@@==>'+ex.getLineNumber());
        }
    }
    
}