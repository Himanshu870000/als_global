public class QuoteScreenController {
    @AuraEnabled(cacheable=true)
    public static List<PriceBookEntry1__c> getPBERecords(string priceName,String QuoteId){
        system.debug('The Quote id is==>'+QuoteId);
        String oppId = [Select id , OpportunityId__c from Quote_C__c where id = :QuoteId].OpportunityId__c;
        String Accid = [Select id , AccountId__c from Opportunity1__c where id = :oppId].AccountId__c;
        map<id,Product_Fixed_Price__c> prodIdByPFP = new map<id,Product_Fixed_Price__c>();
        List<PriceBookEntry1__c> newPriceBookEntryList = new List<PriceBookEntry1__c>();
        for(Product_Fixed_Price__c pfp : [Select id , Product__c , Selling_Price__c from Product_Fixed_Price__c where Account__c = :accId]){
            prodIdByPFP.put(pfp.Product__c , pfp);
        }
        system.debug('prodIdByPFP==>'+prodIdByPFP);
        List<PriceBookEntry1__c> prodFixedPriceList = [SELECT id,Product1Id__c,List_Price__c,Product1Id__r.Name,Product1Id__r.ProductCode__c,Product1Id__r.Method__c,UnitPrice__c,Product1Id__r.Description__c,Product1Id__r.Family__c FROM PriceBookEntry1__c where Pricebook1Id__r.Name =: priceName];
        for(PriceBookEntry1__c priceBookRec : prodFixedPriceList) 
        {
            if(prodIdByPFP.containsKey(priceBookRec.Product1Id__c)){
                priceBookRec.List_Price__c = prodIdByPFP.get(priceBookRec.Product1Id__c).Selling_Price__c;
            }
            newPriceBookEntryList.add(priceBookRec);
        }
        system.debug('newPriceBookEntryList==>'+newPriceBookEntryList);
        return newPriceBookEntryList;
    }
    
    @AuraEnabled
    Public Static String getOppName(String recId){
        string oppName= [SELECT OpportunityId__r.Name FROM Quote_C__c where Id=:recId].OpportunityId__r.Name;
        return oppName;
    }
    
    @AuraEnabled
    public static String createQuoteLineItems(String jsonData, String QuoteId) {
        Boolean isApprovalToFire= false;
        try{
            System.debug('jsonData: ===>' + jsonData);
            List<QuoteLineItems_c__c> QLIToInsertList = new List<QuoteLineItems_c__c>();
            List<ProductInfo> productInfoList = (List<ProductInfo>)JSON.deserialize(jsonData, List<ProductInfo>.class);
            for (ProductInfo productInfo : productInfoList) {
                QuoteLineItems_c__c qlirec = new QuoteLineItems_c__c();
                qlirec.ProductId__c = productInfo.productId;
                qlirec.Product_Code__c = productInfo.productCode;
                qlirec.Test_Method__c = productInfo.Method;
                qlirec.QuoteId__c = QuoteId;
                qlirec.List_Price__c = productInfo.ListPrice;
                qlirec.Quantity__c = productInfo.quantity;
                qlirec.Sales_Price__c = productInfo.SalesPrice;
                //qlirec.Discount__c = productInfo.discount;
                //qlirec.Total_Price__c = productInfo.discountedPrice;
                qlirec.Subtotal__c = productInfo.totalValue;
                QLIToInsertList.add(qlirec);
            }
            insert QLIToInsertList;
            return 'SUCCESS';
        }catch(Exception e){
            System.debug('Error == >'+e.getMessage()+' & Erro line ===>'+e.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled(cacheable=true)
    Public Static List<QuoteLineItems_c__c> getQuoteLineItems(String QuoteId){
        return [Select Id, Name,ProductId__r.Name,ProductId__r.Family__c,Product_Code__c,Test_Method__c,Quantity__c, List_Price__c, Sales_Price__c,Discount__c, Subtotal__c, Total_Price__c from QuoteLineItems_c__c where QuoteId__c =:QuoteId];
    }
    
        @AuraEnabled
    public static String updateQuoteLineItems(String OLILIST, string QuoteId) {
        Boolean isApprovalToFire= false;
        try{
            System.debug('jsonData: ===>' + OLILIST);
            List<QuoteLineItems_c__c> QLIToInsertList = new List<QuoteLineItems_c__c>();
            List<UpdateLineitemInfo> productInfoList = (List<UpdateLineitemInfo>)JSON.deserialize(OLILIST, List<UpdateLineitemInfo>.class);
            for (UpdateLineitemInfo productInfo : productInfoList) {
                QuoteLineItems_c__c qlirec = new QuoteLineItems_c__c();
                qlirec.Id = productInfo.Id;
                //qlirec.Test_Method__c = productInfo.Method;
                qlirec.List_Price__c = productInfo.listPrice;
                qlirec.Quantity__c = productInfo.quantity;
                qlirec.Sales_Price__c = productInfo.salesPrice;
                //qlirec.Discount__c = productInfo.discount;
                //qlirec.Total_Price__c = productInfo.discountedPrice;
                qlirec.Subtotal__c = productInfo.totalValue;
                QLIToInsertList.add(qlirec);
            }
            Update QLIToInsertList;

            return 'SUCCESS';
        }catch(Exception e){
            System.debug('Error == >'+e.getMessage()+' & Erro line ===>'+e.getLineNumber());
        }
        return null;
    }
    
    //Method to create a opportunity lineitems when quote is marked as primary
    Public Static String CreateOppLineItemOnPrimaryQuote(List<Quote_C__c> quoteList, Map<Id,Quote_C__c> quoteOldMap){
        System.debug('quoteList ==> '+quoteList);
        System.debug('quoteOldMap ==> '+quoteOldMap);
        try{
			Set<Id> quoteId = new Set<Id>();
            Map<Id, Quote_C__c> quoteMap = new Map<Id, Quote_C__c>();
            Map<Id, OpportunityLineItem1__c> oliMap = new Map<Id, OpportunityLineItem1__c>();
            List<OpportunityLineItem1__c> oliList = new List<OpportunityLineItem1__c>();            
            if (!quoteList.isEmpty()) {
                for (Quote_C__c qt : quoteList) {
                    if (qt.Primary__c != quoteOldMap.get(qt.Id).Primary__c && qt.Primary__c == true) {
                        quoteId.add(qt.Id);
                        quoteMap.put(qt.Id, qt);
                    }
                }
            }
            System.debug('Quote quoteId  ==> '+quoteId);
           // List<QuoteLineItems_c__c> qliList = [select Id,QuoteId__r.OpportunityId__c, ProductId__c,ProductId__r.Name,Product_Code__c, Quantity__c, List_Price__c, Sales_Price__c,Discount__c, Subtotal__c, Total_Price__c from QuoteLineItems_c__c where QuoteId__c IN: quoteId];
            List<QuoteLineItems_c__c> qliList = [
                SELECT Id, QuoteId__r.OpportunityId__c, ProductId__c, ProductId__r.Name, Product_Code__c,
                       Quantity__c, List_Price__c, Sales_Price__c, Discount__c, Subtotal__c, Total_Price__c
                FROM QuoteLineItems_c__c
                WHERE QuoteId__c IN :quoteId
            ];
            System.debug('Quote Lineitems Size ==> '+qliList.Size());
            if(!qliList.isEmpty()){ 
            for(QuoteLineItems_c__c qli : qliList){
                System.debug('qli.ProductId__r.Name === > '+qli.ProductId__r.Name);
                    OpportunityLineItem1__c oli = new OpportunityLineItem1__c();
                    oli.Opportunity1Id__c = qli.QuoteId__r.OpportunityId__c;
                    oli.QuoteLineitemId__c = qli.Id;
                    oli.Name = qli.ProductId__r.Name;
                    oli.Product1Id__c = qli.ProductId__c;
                    oli.ProductCode__c = qli.Product_Code__c;
                    oli.Quantity__c = qli.Quantity__c;
                    oli.ListPrice__c = qli.Sales_Price__c;
                    oli.UnitPrice__c = qli.List_Price__c;
                   // oli.Discount__c = qli.Discount__c;
                    oli.Subtotal__c = qli.Subtotal__c;
                   // oli.TotalPrice__c = qli.Total_Price__c;
                    oliList.add(oli);

                    // Populate the map with QuoteLineitemId__c as the external ID field
                    oliMap.put(qli.Id, oli);
                }
            }
            if (!oliMap.isEmpty()) {
                // Upsert Opportunity Line Items based on the external ID field (QuoteLineitemId__c)
                Database.UpsertResult[] upsertResults = Database.upsert(oliMap.values(), OpportunityLineItem1__c.QuoteLineitemId__c, false);

                for (Database.UpsertResult result : upsertResults) {
                    if (result.isSuccess()) {
                        System.debug('Opportunity Line Item upserted successfully');
                    } else {
                        System.debug('Error upserting Opportunity Line Item: ' + result.getErrors());
                    }
                }
            }

            return 'success';
        }
        catch(Exception e){
            System.debug('Error == >'+e.getMessage()+' & Erro line ===>'+e.getLineNumber());
        }
        
        return null;
    }
    
    
    //Method to delete oppo lineitem after deleting quoteline item
    Public Static String deleteOppoLineItem(List<QuoteLineItems_c__c> qtList){
        try{
            Set<Id> qliId = new Set<Id>();
            if(!qtList.isEmpty()){
                for(QuoteLineItems_c__c qli : qtList){
                    qliId.add(qli.Id);
                }
            }
            List<OpportunityLineItem1__c> oli = [Select Id,QuoteLineitemId__c from OpportunityLineItem1__c where QuoteLineitemId__c IN:qliId];
            if(!oli.isEmpty()){
                Delete oli;
            }
        }
        catch(Exception e){
            System.debug('Error == >'+e.getMessage()+' & Erro line ===>'+e.getLineNumber());
        }
        return null;
    }
    
    //Method for Validating the Pharma Quote
     @AuraEnabled
    Public Static Quote_C__c validatePharmaQuote(String recId){
        try{
            if(recId != null){              
            Quote_C__c qtREc = [Select Id, Subject__c, Sample_Quantity__c, TAT__c, ContactId__c, Lab_Location__c from Quote_C__c where Id =:recId];
                if(qtREc != null){
                    return qtREc;
               }                
            }
            }
        catch(Exception e){
            System.debug('Error == >'+e.getMessage()+' & Erro line ===>'+e.getLineNumber());
        }
        return null;
    }
    
    //Method for Validating the Certification Quote
     @AuraEnabled
    Public Static Quote_C__c validateCertification(String recId){
        try{
            if(recId != null){              
            Quote_C__c qtREc = [Select Id, Subject__c, Audit_Scheme__c, Total_sites_to_be_covered__c,Area_Of_The_Units_To_Be_Audited__c,Total_Effective_employees_as_stated_in_E__c,Type_of_Audit__c,Scope_of_Audit__c, ContactId__c, Category_of_FBO__c from Quote_C__c where Id =:recId];
                if(qtREc != null){
                    return qtREc;
               }                
            }
            }
        catch(Exception e){
            System.debug('Error == >'+e.getMessage()+' & Erro line ===>'+e.getLineNumber());
        }
        return null;
    }
    
    //===========================================================================================================
    //Method to check there is a primary quote is there or not
     @AuraEnabled
    Public Static string checkOpportunityUpdated(string recId){
        Opportunity1__c oppRec = new Opportunity1__c();
        List<QuoteLineItems_c__c> quoteitemList = new List<QuoteLineItems_c__c>();
        //List<ContentDocumentLink> ContentDocList = new List<ContentDocumentLink>();
        try{
            if(recId !=null){
               oppRec = [Select Id, Primary_Quote__c from Opportunity1__c where Id =: recId];
                if(oppRec.Primary_Quote__c == null){
                    return 'Please add the Primary Quote';
                }
                 if(oppRec.Primary_Quote__c !=null){
                    quoteitemList = [Select Id, QuoteId__c from QuoteLineItems_c__c where QuoteId__c =:oppRec.Primary_Quote__c];
                    if(quoteitemList.size()<1){
                        return 'Please add the Products';
                    }
                    
                     List<Attachment> quoteAttachments = [SELECT Id FROM Attachment WHERE ParentId = :oppRec.Primary_Quote__c];
                     
                     if (quoteAttachments.isEmpty()) {
                         return 'Please generate the Quote Document!';
                     }
                 }else{
                     return 'SUCCESS';
                 }
                
                
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
      return null;
    }
    
    //=====================================================================================
    //Method to check the certification is checked or not
    Public Static Void checkCertification(List<QuoteLineItems_c__c> qliList){
        try{
            Set<Id> quoteIds = new Set<Id>();
            Map<Id, Boolean> quoteCertificationMap = new Map<Id, Boolean>();
            if(!qliList.isEmpty()){
                for (QuoteLineItems_c__c qli : qliList) {
                    quoteIds.add(qli.QuoteId__c);
                }
            }
            
            for (Quote_C__c qt : [SELECT Id, (SELECT Id, ProductId__r.Family__c FROM QuoteLineItems__r WHERE ProductId__r.Family__c = 'Certification') FROM Quote_C__c WHERE Id IN :quoteIds]) {
                quoteCertificationMap.put(qt.Id, !qt.QuoteLineItems__r.isEmpty());
            }
            
            List<Quote_C__c> quotesToUpdate = new List<Quote_C__c>();
            
            for (Id quoteId : quoteIds) {
                Boolean hasCertification = quoteCertificationMap.containsKey(quoteId) ? quoteCertificationMap.get(quoteId) : false;
                Quote_C__c qt = new Quote_C__c(Id = quoteId, Certificate__c = hasCertification);
                quotesToUpdate.add(qt);
            }
            Update quotesToUpdate;
        }
        catch(Exception e){
            System.debug('Exception Occurred: ' + e.getMessage());
        }
    }
    
    //=====================================
    Public Class oppWrapper{
        @AuraEnabled
        Public Opportunity1__c oppRec;
        @AuraEnabled
        Public List<QuoteLineItems_c__c> qliRec;
        @AuraEnabled
        public List<ContentDocumentLink> cDoc;
    }
    
    // Define a class to represent the structure of your JSON data
    public class ProductInfo {
        public String productId;
        public String Name;
        Public String quoteId;
        Public String productCode;
        Public String Method;
        public Integer quantity;
        //public Decimal discount;
        public Decimal ListPrice;
        public Decimal SalesPrice;
        public Decimal totalValue;
        //public Decimal discountedPrice;
    }
    
    public class UpdateLineitemInfo {
        public String Id;
        public String Name;
        Public String quoteId;
        public String ProductName;
        Public String Family;
        //Public String Method;
        public Integer quantity;
        public Decimal listPrice;
        public Decimal salesPrice;
        //public Decimal discount;
        public Decimal totalValue;
        //public Decimal discountedPrice;
    }


    // Metho for checking Primary Quote on Related List Opportunity record
    @AuraEnabled 
    public static String checkPrimaryQuoteFromRelatedQuoteList(String recordId){
        List<Quote_C__c> quoteList = new List<Quote_C__c>();
        Opportunity1__c oppRec = new Opportunity1__c();
        try{
            if(recordId !=null){
                quoteList = [SELECT Id,Name,Primary__c,OpportunityId__c FROM Quote_C__c WHERE OpportunityId__c=:recordId AND Primary__c = true LIMIT 1];
                if(quoteList.size()<1){
                    return 'Please add the Primary Quote';
                }else{
                   return 'SUCCESS';
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
    }
    return null;
}

}