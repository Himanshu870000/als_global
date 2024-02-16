trigger QuoteLineItemSyncTrigger on QuoteLineItems_c__c (before insert,after insert, after update, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            QuoteLineItemSyncHandler.handleQuoteLineItemChanges(Trigger.new, Trigger.old, false);
        } else if (Trigger.isDelete) {
            try {
                QuoteLineItemSyncHandler.handleQuoteLineItemChanges(null, Trigger.old, true);
            } catch (Exception e) {
                // Log the exception message or custom error handling
                System.debug('Exception Message: ' + e.getMessage());
            }
        }
    }
    if(trigger.isAfter && trigger.isInsert){
           QuoteScreenController.checkCertification(trigger.new);
    }
    if(trigger.isAfter && trigger.isDelete){
           QuoteScreenController.deleteOppoLineItem(trigger.old);
    }
}