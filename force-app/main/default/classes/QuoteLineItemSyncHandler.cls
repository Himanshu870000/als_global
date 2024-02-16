public class QuoteLineItemSyncHandler {
    
           static Set<Id> processedRecords = new Set<Id>();
    
    public static void handleQuoteLineItemChanges(List<QuoteLineItems_c__c> newItems, List<QuoteLineItems_c__c> oldItems, Boolean isDelete) {
        // Check if already processed in this transaction
        if (!processedRecords.isEmpty()) {
            return;
        }
        
        Set<Id> quoteIds = new Set<Id>();
        
        // Check if newItems is not null
        if (newItems != null) {
            // Collect Quote Ids related to QuoteLineItems_c__c
            for (QuoteLineItems_c__c qli : newItems) {
                if (qli != null && qli.QuoteId__c != null) {
                    quoteIds.add(qli.QuoteId__c);
                }
            }
        }
        
        // Check if oldItems is not null
        if (oldItems != null) {
            // Collect Quote Ids related to QuoteLineItems_c__c from oldItems
            for (QuoteLineItems_c__c qli : oldItems) {
                if (qli != null && qli.QuoteId__c != null) {
                    quoteIds.add(qli.QuoteId__c);
                }
            }
        }
        
        // Fetch Opportunity1__c records related to Quotes
        List<Opportunity1__c> opportunitiesToUpdate = [SELECT Id FROM Opportunity1__c WHERE Id IN (SELECT OpportunityId__c FROM Quote_C__c
                                                                                                   WHERE Id IN :quoteIds AND IsSyncing__c = true )];
        
        if (opportunitiesToUpdate.isEmpty()) {
            return;
        }
        
        List<OpportunityLineItem1__c> opportunityLineItemsToDelete = new List<OpportunityLineItem1__c>();
        
        if (isDelete) {
            // Handle deletion scenario
            for (QuoteLineItems_c__c deletedItem : oldItems) {
                for (Opportunity1__c opportunity : opportunitiesToUpdate) {
                    // Query existing OpportunityLineItem1__c records for the given product
                    List<OpportunityLineItem1__c> existingOpportunityLineItems = [SELECT Id FROM OpportunityLineItem1__c WHERE Opportunity1Id__c = :opportunity.Id 
                                                                                  AND Product1Id__c = :deletedItem.ProductId__c];
                    
                    opportunityLineItemsToDelete.addAll(existingOpportunityLineItems);
                }
            }
        } else {
            // Handle insertion and update scenarios
            List<OpportunityLineItem1__c> opportunityLineItemsToUpsert = new List<OpportunityLineItem1__c>();
            
            for (QuoteLineItems_c__c qli : newItems) {
                for (Opportunity1__c opportunity : opportunitiesToUpdate) {
                    // Query existing OpportunityLineItem1__c records for the given product
                    List<OpportunityLineItem1__c> existingOpportunityLineItems = [
                        SELECT Id
                        FROM OpportunityLineItem1__c
                        WHERE Opportunity1Id__c = :opportunity.Id
                        AND Product1Id__c = :qli.ProductId__c
                    ];
                    
                    system.debug('existingOpportunityLineItems' + existingOpportunityLineItems);
                    
                    OpportunityLineItem1__c oppLineItem;
                    
                    if (existingOpportunityLineItems.isEmpty()) {
                        oppLineItem = new OpportunityLineItem1__c(
                            Opportunity1Id__c = opportunity.Id,
                            Quantity__c       = qli.Quantity__c,
                            Product1Id__c     = qli.ProductId__c,
                            ListPrice__c      = qli.List_Price__c,
                            Subtotal__c       = qli.Subtotal__c,
                            UnitPrice__c      = qli.Sales_Price__c,
                            ProductCode__c    = qli.Product_Code__c, 
                            TotalPrice__c     = qli.Total_Price__c,
                            Discount__c       = qli.Discount__c
                        );
                    } else {
                        oppLineItem                = existingOpportunityLineItems[0];
                        oppLineItem.Quantity__c    = qli.Quantity__c;
                        oppLineItem.ListPrice__c   = qli.List_Price__c;
                        oppLineItem.Subtotal__c    = qli.Subtotal__c;
                        oppLineItem.UnitPrice__c   = qli.Sales_Price__c;
                        oppLineItem.ProductCode__c = qli.Product_Code__c;
                        oppLineItem.TotalPrice__c  = qli.Total_Price__c;
                        oppLineItem.Discount__c    = qli.Discount__c;
                        
                    }
                    
                    opportunityLineItemsToUpsert.add(oppLineItem);
                }
            }
            system.debug('opportunityLineItemsToUpsert' + opportunityLineItemsToUpsert);
            
            if (!opportunityLineItemsToUpsert.isEmpty()) {
                map<Id , OpportunityLineItem1__c> oppLineItemMap = new map<Id,OpportunityLineItem1__c>();
                
                for(OpportunityLineItem1__c oppLineItem : opportunityLineItemsToUpsert){
                    oppLineItemMap.put(oppLineItem.Id,oppLineItem);
                }
                upsert oppLineItemMap.values();
            }
        }
        
        if (!opportunityLineItemsToDelete.isEmpty()) {
            delete opportunityLineItemsToDelete;
        }
        
        // Mark records as processed to prevent recursion
        for (OpportunityLineItem1__c oppLineItem : opportunityLineItemsToDelete) {
            processedRecords.add(oppLineItem.Id);
        }
        
        // Clear processed records at the end of the transaction
        processedRecords.clear();
    }
}