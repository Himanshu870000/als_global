public class OpportunityLineItemSyncHandler {

    private static Set<Id> processedRecords = new Set<Id>();

    public static void handleOpportunityLineItemChanges(List<OpportunityLineItem1__c> newItems, List<OpportunityLineItem1__c> oldItems, Boolean isDelete) {
        // Check if already processed in this transaction
        if (!processedRecords.isEmpty()) {
            return;
        }

        Set<Id> opportunityIds = new Set<Id>();

        // Collect Opportunity Ids related to OpportunityLineItem1__c
        if (newItems != null) {
            for (OpportunityLineItem1__c oli : newItems) {
                if (oli != null && oli.Opportunity1Id__c != null) {
                    opportunityIds.add(oli.Opportunity1Id__c);
                }
            }
        }

        // Check if oldItems is not null
        if (oldItems != null) {
            for (OpportunityLineItem1__c oli : oldItems) {
                if (oli != null && oli.Opportunity1Id__c != null) {
                    opportunityIds.add(oli.Opportunity1Id__c);
                }
            }
        }

        // Fetch Quote_C__c records related to Opportunities
        List<Quote_C__c> quotesToUpdate = [
            SELECT Id, IsSyncing__c, OpportunityId__c
            FROM Quote_C__c
            WHERE OpportunityId__c IN :opportunityIds
            AND IsSyncing__c = true
        ];

        if (quotesToUpdate.isEmpty()) {
            return;
        }
        
        List<QuoteLineItems_c__c> QuoteLineItemsTodelete = new List<QuoteLineItems_c__c>();

        if (isDelete) {
            // Handle deletion scenario
            for (OpportunityLineItem1__c deletedItem : oldItems) {
                for (Quote_C__c Quote : quotesToUpdate) {
                    // Query existing QuoteLineItems_c__c records for the given product
                    List<QuoteLineItems_c__c> existingQuoteLineItems = [
                        SELECT Id
                        FROM QuoteLineItems_c__c
                        WHERE QuoteId__r.OpportunityId__c = :Quote.OpportunityId__c
                        AND ProductId__c = :deletedItem.Product1Id__c
                    ];
                    system.debug('existingQuoteLineItems ===>'+existingQuoteLineItems);

                    QuoteLineItemsTodelete.addAll(existingQuoteLineItems);
                }
            }
        }
        else{
            
            List<QuoteLineItems_c__c> quoteLineItemsToUpsert = new List<QuoteLineItems_c__c>();
            
            for (Quote_C__c quote : quotesToUpdate) {
                for (OpportunityLineItem1__c oli : newItems) {
                    if (oli.Opportunity1Id__c == quote.OpportunityId__c) {
                        List<QuoteLineItems_c__c> existingQuoteLineItems = [
                            SELECT Id
                            FROM QuoteLineItems_c__c
                            WHERE QuoteId__c = :quote.Id
                            AND ProductId__c = :oli.Product1Id__c
                        ];
                        
                        if (existingQuoteLineItems.isEmpty()) {
                            quoteLineItemsToUpsert.add(
                                new QuoteLineItems_c__c(
                                    QuoteId__c = quote.Id,
                                    Quantity__c = oli.Quantity__c,
                                    ProductId__c = oli.Product1Id__c,
                                    List_Price__c = oli.ListPrice__c,
                                    Subtotal__c = oli.Subtotal__c,
                                    Sales_Price__c = oli.UnitPrice__c,
                                    Product_Code__c = oli.ProductCode__c,
                                    Total_Price__c = oli.TotalPrice__c
                                )
                            );
                        } else {
                            for (QuoteLineItems_c__c existingQuoteLineItem : existingQuoteLineItems) {
                                existingQuoteLineItem.Quantity__c = oli.Quantity__c;
                                existingQuoteLineItem.List_Price__c = oli.ListPrice__c;
                                existingQuoteLineItem.Subtotal__c = oli.Subtotal__c;
                                existingQuoteLineItem.Sales_Price__c = oli.UnitPrice__c;
                                existingQuoteLineItem.Product_Code__c = oli.ProductCode__c;
                                existingQuoteLineItem.Total_Price__c = oli.TotalPrice__c;
                                
                                quoteLineItemsToUpsert.add(existingQuoteLineItem);
                            }
                        }
                    }
                }
            }
            
            // Mark records as processed to prevent recursion
            for (QuoteLineItems_c__c qli : quoteLineItemsToUpsert) {
                processedRecords.add(qli.Id);
            }
            
            if (!quoteLineItemsToUpsert.isEmpty()) {
                upsert quoteLineItemsToUpsert;
            }
        }
        
        if (!QuoteLineItemsTodelete.isEmpty()) {
            system.debug('Deleting quote line items record==>'+QuoteLineItemsTodelete);
            delete QuoteLineItemsTodelete;
        }
        
        // Mark records as processed to prevent recursion
        for (QuoteLineItems_c__c QliLineItem : QuoteLineItemsTodelete) {
            processedRecords.add(QliLineItem.Id);
        }

        // Clear processed records at the end of the transaction
        processedRecords.clear();
    }
}