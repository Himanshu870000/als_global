public class QuoteHelper {
    
    public static boolean handleReccursive = true;
    
    @AuraEnabled
    public static string generateSelectedQuatationPDF(String QuotationName,string recordId){
        try{
            List<Attachment> attachList = new List<Attachment>();
            if(recordId !=null){
                blob pdfBody;
                string filename;
                Quote_C__c qarec = [SELECT Id,Name FROM Quote_C__c WHERE Id=:recordId];
                if(!String.isBlank(qarec.id) &&  QuotationName != null){
                    
                    if(QuotationName == 'Banglore Pharma Template'){
                        PageReference pdfPage = Page.ALS_Banglore_Pharma;   
                        pdfPage.getParameters().put('id',recordId);
                        pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                        filename = 'Banglore Pharma';
                    }
                    if(QuotationName == 'Mumbai Pharma Batch Quote'){
                        PageReference pdfPage = Page.ALS_Mumbai_BatchTesting;   
                        pdfPage.getParameters().put('id',recordId);
                        pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                        filename = 'Mumbai Pharma Batch';
                    }
                    if(QuotationName == 'Mumbai Pharma EnL Quote'){
                        PageReference pdfPage = Page.ALS_Mumbai_ENL;   
                        pdfPage.getParameters().put('id',recordId);
                        pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                        filename = 'Mumbai Pharma EnL';
                    }
                    if(QuotationName == 'Mumbai Pharma General Quote'){
                        PageReference pdfPage = Page.ALS_Mumbai_General;   
                        pdfPage.getParameters().put('id',recordId);
                        pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                        filename = 'Mumbai Pharma General';
                    }
                    if(QuotationName == 'Mumbai Pharma In-Vitro Quote'){
                        PageReference pdfPage = Page.ALS_Mumbai_In_Vitro;   
                        pdfPage.getParameters().put('id',recordId);
                        pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                        filename = 'Mumbai Pharma In-Vitro';
                    }
                    Attachment attach = new Attachment(); 
                    attach.Body = pdfBody;
                    attach.Name =  filename+'_'+System.now()+'_.Pdf';
                    attach.IsPrivate = false;
                    attach.ParentId = qarec.Id;
                    attach.ContentType = 'application/pdf';
                    attachList.add(attach);
                }
                if(!attachList.isEmpty()){
                    insert attachList;
                    System.debug('attachList Size == >'+attachList.size());
                    if(attachList.size()>0){
                        return 'SUCCESS';   
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }    

    // ================================================================================================================================================================
    // Method for Updating Address Shipping and Billing from Opportunity - Dinesh
    public static void updateQuoteAddressFromOpportunity(List<Quote_C__c> quoteList){
        List<Quote_C__c> quoteListToUpdate = new List<Quote_C__c>();
        Opportunity1__c oppRec = new Opportunity1__c();
        Set<Id> oppIdSet = new Set<Id>();
        try{
            for(Quote_C__c quoeRec : quoteList){
                if(quoeRec.OpportunityId__c !=null){
                    oppIdSet.add(quoeRec.OpportunityId__c);
                }
            }
            system.debug('oppIdSet == >'+oppIdSet);
            if(oppIdSet.size()>0){
                oppRec = [SELECT Id,Name,Billing_Address__Street__s,Billing_Address__City__s,Billing_Address__PostalCode__s,Billing_Address__StateCode__s,Billing_Address__CountryCode__s,Shipping_Address__Street__s,Shipping_Address__City__s,Shipping_Address__PostalCode__s,Shipping_Address__StateCode__s,Shipping_Address__CountryCode__s FROM Opportunity1__c WHERE ID IN:oppIdSet LIMIT 1];
                system.debug('oppRec == >'+oppRec);
                for(Quote_C__c queRec : quoteList){
                    Quote_C__c queRecToUpdate = new Quote_C__c();
                    queRecToUpdate.Id = queRec.Id;  
                    system.debug('oppRec.Billing_Address__Street__s----->'+oppRec.Billing_Address__Street__s);
                    if (oppRec.Billing_Address__Street__s != null) {
                        queRec.BillingAddress__Street__s = oppRec.Billing_Address__Street__s;
                    }
                    if (oppRec.Billing_Address__City__s != null) {
                        queRec.BillingAddress__City__s = oppRec.Billing_Address__City__s;
                    }
                    if (oppRec.Billing_Address__StateCode__s != null) {
                        queRec.BillingAddress__StateCode__s = oppRec.Billing_Address__StateCode__s;
                    }
                    if (oppRec.Billing_Address__PostalCode__s != null) {
                        queRec.BillingAddress__PostalCode__s = oppRec.Billing_Address__PostalCode__s;
                    }
                    if (oppRec.Billing_Address__CountryCode__s != null) {
                        queRec.BillingAddress__CountryCode__s = oppRec.Billing_Address__CountryCode__s;
                    }
                    if (oppRec.Shipping_Address__Street__s != null) {
                        queRec.ShippingAddress__Street__s = oppRec.Shipping_Address__Street__s;
                    }
                    if (oppRec.Shipping_Address__City__s != null) {
                        queRec.ShippingAddress__City__s = oppRec.Shipping_Address__City__s;
                    }
                    if (oppRec.Shipping_Address__StateCode__s != null) {
                        queRec.ShippingAddress__StateCode__s = oppRec.Shipping_Address__StateCode__s;
                    }
                    if (oppRec.Shipping_Address__PostalCode__s != null) {
                        queRec.ShippingAddress__PostalCode__s = oppRec.Shipping_Address__PostalCode__s;
                    }
                    if (oppRec.Shipping_Address__CountryCode__s != null) {
                        queRec.ShippingAddress__CountryCode__s = oppRec.Shipping_Address__CountryCode__s;
                    }
                    System.debug('Updated Quote Rec === >'+queRec);
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        
    }
    
    //  ================================================================================================================================================================
    // Method for Updating Quote Name - Dinesh
    Public static void updateQuoteName(List<Quote_C__c> newQuoteList){
        try{
            Map<Id, Integer> opportunityQuoteCountMap = new Map<Id, Integer>();
            Set<Id> opportunityIds = new Set<Id>();
            for (Quote_C__c newQuote : newQuoteList) {
                if (newQuote.OpportunityId__c != null) {
                    opportunityIds.add(newQuote.OpportunityId__c); 
                }
            }
            for (AggregateResult result : [SELECT OpportunityId__c, COUNT(Id) quoteCount FROM Quote_C__c WHERE OpportunityId__c IN :opportunityIds GROUP BY OpportunityId__c]) {
                opportunityQuoteCountMap.put((Id) result.get('OpportunityId__c'), (Integer) result.get('quoteCount'));
            }
            for (Quote_C__c newQuote : newQuoteList) {
                if (newQuote.OpportunityId__c != null) {
                    Integer quoteCount = opportunityQuoteCountMap.containsKey(newQuote.OpportunityId__c) ? opportunityQuoteCountMap.get(newQuote.OpportunityId__c) : 0;
                    String quoteNamePrefix = '/' + String.valueOf(quoteCount + 1);
                    newQuote.Name =newQuote.Name+quoteNamePrefix; 
                    opportunityQuoteCountMap.put(newQuote.OpportunityId__c, quoteCount + 1);
                }
            }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
    }
    
    
    public static void uncheckDuplicatePrimary(List<Quote_C__c> quoteList,Map<Id,Quote_C__c> oldMap){
        Set<Id> oppIdSet = new Set<Id>();
        Set<Id> quoteIdSet = new Set<Id>(); 
        for(Quote_C__c qu : quoteList){
            if(qu.Primary__c && qu.Primary__c != oldMap.get(qu.Id).Primary__c){
                oppIdSet.add(qu.OpportunityId__c);
                quoteIdSet.add(qu.Id);
            }
        }
        
        if(!oppIdSet.isEmpty()){
            updatePrimaryQuote(oppIdSet,quoteIdSet);
        }
        
        
    }
    
    @future
    public static void updatePrimaryQuote(Set<Id> oppIdSet,Set<Id> quoteIdSet){
        if(!oppIdSet.isEmpty()){
            List<Quote_C__c> quoteListTobeInactive = new List<Quote_C__c>();
            system.debug('oppIdSet:::::::::>'+oppIdSet);
            system.debug('quoteIdSet:::::::::>'+quoteIdSet);
            quoteListTobeInactive = [select id,Primary__c from Quote_C__c where OpportunityId__c in: oppIdSet and Id not in:quoteIdSet];
           
            if(!quoteListTobeInactive.isEmpty()){
                for(Quote_C__c qu : quoteListTobeInactive){
                qu.Primary__c = false;
            }
            handleReccursive = false;
            update quoteListTobeInactive;
            }
            
        }
    }
    
    
    Public static void updateAmountOnOpportunityOnPrimaryMark(List<Quote_C__c> quoteList,Map<Id,Quote_C__c> oldMap){
        Map<Id,Decimal> mapofOppIdByAmount = new Map<Id,Decimal>();
        Map<Id,Id> mapoppIdByQuoteId = new Map<Id,Id>();
        Set<Id> quoteIdSet = new Set<Id>();
        for(Quote_C__c qu : quoteList){
            if(qu.Primary__c && qu.Primary__c != oldMap.Get(qu.Id).Primary__c){
                mapofOppIdByAmount.put(qu.OpportunityId__c,qu.Total_Price1__c);
                mapoppIdByQuoteId.put(qu.OpportunityId__c,qu.Id);
                quoteIdSet.add(qu.Id);
            }
        }
        
        if(!quoteIdSet.isEmpty()){
            List<QuoteLineItems_c__c> qliList = new List<QuoteLineItems_c__c>();
            qliList = [select Id from QuoteLineItems_c__c];
        }
        
        if(!mapofOppIdByAmount.isEmpty()){
            List<Opportunity1__c> oppListTobeUpdate = new List<Opportunity1__c>();
            for(Id mapKey : mapofOppIdByAmount.keySet()){
                Opportunity1__c opp = new Opportunity1__c();
                opp.Id =mapKey;
                opp.Amount__c = mapofOppIdByAmount.get(mapKey);
                opp.Primary_Quote__c = mapoppIdByQuoteId.get(mapKey);
                oppListTobeUpdate.add(opp);
            }
            
            if(!oppListTobeUpdate.isEmpty()){
                update oppListTobeUpdate;
            }
        }
    }
    

    public static void mapFieldsFromOpportunity(List<Quote_C__c> newQuotes) {
       
        Set<Id> opportunityIds = new Set<Id>();
        Map<Id, Opportunity1__c> opportunityMap = new Map<Id, Opportunity1__c>();

        for (Quote_C__c newQuote : newQuotes) {
            if (newQuote.OpportunityId__c != null) {
                opportunityIds.add(newQuote.OpportunityId__c);
            }
        }

        if (!opportunityIds.isEmpty()) {
            opportunityMap = new Map<Id, Opportunity1__c>([SELECT Id, AccountId__c, Contact_Person__c, RSM__c FROM Opportunity1__c WHERE Id IN :opportunityIds]);
        }

        for (Quote_C__c newQuote : newQuotes) {
            Opportunity1__c relatedOpportunity = opportunityMap.get(newQuote.OpportunityId__c);
            if (relatedOpportunity != null) {
                newQuote.AccountId__c = relatedOpportunity.AccountId__c;
                newQuote.ContactId__c = relatedOpportunity.Contact_Person__c;
                newQuote.RSM__c       = relatedOpportunity.RSM__c;
            }
        }
    }
    
   

}