trigger TriggerOnQuoteLineItem on QuoteLineItems_c__c (after insert, after update) {
    
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        TriggerOnQuoteLineItemHelper.handleDiscountOnListedPrice(Trigger.new);
        //TriggerOnQuoteLineItemHelper.updateQuoteDiscount(Trigger.new);
    }

}