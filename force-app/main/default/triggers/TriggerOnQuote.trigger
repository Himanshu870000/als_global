// Trigger to create QuoteLineItems_c__c records based on OpportunityLineItem1__c records
// Author: Navneet Shukla

trigger TriggerOnQuote on Quote_C__c (after insert,before insert,After Update,before update) {

   
    
    if(Trigger.isBefore && Trigger.isUpdate){
        if(QuoteHelper.handleReccursive){
            QuoteHelper.uncheckDuplicatePrimary(trigger.new,trigger.oldMap);
        }
        
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        QuoteHelper.updateAmountOnOpportunityOnPrimaryMark(trigger.new, trigger.oldMap);
        QuoteScreenController.CreateOppLineItemOnPrimaryQuote(trigger.new, trigger.oldMap);
    }
    
    if(trigger.isBefore && trigger.isInsert){
        QuoteHelper.updateQuoteName(trigger.new);
        QuoteHelper.updateQuoteAddressFromOpportunity(trigger.new);
        QuoteHelper.mapFieldsFromOpportunity(trigger.new);
        for(Quote_C__c qute : trigger.new){
            qute.Quote_Created__c = true;
        }
    }
    if(trigger.isAfter && trigger.isInsert){
       // QuoteHelper.ApprovalProcessForQuoteDiscount(trigger.new);
    }
    
    
}