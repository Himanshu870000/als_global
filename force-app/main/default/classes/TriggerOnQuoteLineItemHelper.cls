public class TriggerOnQuoteLineItemHelper {
    
    public static void handleDiscountOnListedPrice(List<QuoteLineItems_c__c> newQuoteLineItems) {
        Set<Id> quoteIdsToUpdate = new Set<Id>();
        for (QuoteLineItems_c__c newQuoteLineItem : newQuoteLineItems) {
            if (newQuoteLineItem.Sales_Price__c < newQuoteLineItem.List_Price__c) {
                quoteIdsToUpdate.add(newQuoteLineItem.QuoteId__c);
            }
        }
        updateRelatedQuotes(quoteIdsToUpdate);
    }
    
    @TestVisible private static void updateRelatedQuotes(Set<Id> quoteIds) {
        List<Quote_C__c> quotesToUpdate = new List<Quote_C__c>();
        
        for (Id quoteId : quoteIds) {
            Quote_C__c relatedQuote = [SELECT Id, Discount_on_Listed_Price__c FROM Quote_C__c WHERE Id = :quoteId LIMIT 1];
            if (relatedQuote != null) {
                relatedQuote.Discount_on_Listed_Price__c = true;
                quotesToUpdate.add(relatedQuote);
            }
        }
        if (!quotesToUpdate.isEmpty()) {
            update quotesToUpdate;
        }
    }
    
    public static void updateQuoteDiscount(List<QuoteLineItems_c__c> newQuoteLineItems) {
        
        Map<Id, Decimal> quoteIdToTotalDiscount = new Map<Id, Decimal>();
        Map<Id, Integer> quoteIdToLineItemCount = new Map<Id, Integer>();
        Set<Id> quoteIds = new Set<Id>();
        for (QuoteLineItems_c__c lineItem : newQuoteLineItems) {
            quoteIds.add(lineItem.QuoteId__c);
        }
        List<QuoteLineItems_c__c> quoteLineItems = [SELECT QuoteId__c, Discount__c FROM QuoteLineItems_c__c WHERE QuoteId__c IN :quoteIds];
        System.debug('quoteLineItems == 111 > ' +quoteLineItems);
        
        for (QuoteLineItems_c__c lineItem : quoteLineItems) {
            if (lineItem.Discount__c != null) {
                if (!quoteIdToTotalDiscount.containsKey(lineItem.QuoteId__c)) {
                    quoteIdToTotalDiscount.put(lineItem.QuoteId__c, 0);
                    quoteIdToLineItemCount.put(lineItem.QuoteId__c, 0);
                }
                quoteIdToTotalDiscount.put(lineItem.QuoteId__c, quoteIdToTotalDiscount.get(lineItem.QuoteId__c) + lineItem.Discount__c);
                quoteIdToLineItemCount.put(lineItem.QuoteId__c, quoteIdToLineItemCount.get(lineItem.QuoteId__c) + 1);
            }
        }
        List<Quote_C__c> quotesToUpdate = new List<Quote_C__c>();
        for (Id quoteId : quoteIds) {
            if (quoteIdToTotalDiscount.containsKey(quoteId) && quoteIdToLineItemCount.get(quoteId) > 0) {
                Decimal averageDiscount = quoteIdToTotalDiscount.get(quoteId) / quoteIdToLineItemCount.get(quoteId);
                quotesToUpdate.add(new Quote_C__c(Id = quoteId, Discount__c = averageDiscount));
            }
        }
        if (!quotesToUpdate.isEmpty()) {
            try {
                update quotesToUpdate;
            } catch (Exception e) {
                System.debug('Error updating Quotes Discount: ' + e.getMessage());
            }
        }
    }
    
}