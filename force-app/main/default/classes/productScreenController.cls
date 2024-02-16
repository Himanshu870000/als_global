public class productScreenController {
    
    @AuraEnabled(cacheable=true)
    public static List<Product1__c> getProduct(string priceName){
        return [SELECT Id, Name, ProductCode__c, Description__c, Family__c, 
                (SELECT Id, Name FROM PriceBooks1__r WHERE Name = :priceName) 
                FROM Product1__c];
    }
    
    // Testing code
    @AuraEnabled(cacheable=true)
    public static List<PriceBookEntry1__c> getNewPBE(string priceName){
        return [SELECT id,Product1Id__c,Product1Id__r.Name,Product1Id__r.ProductCode__c,UnitPrice__c,Name,
                Product1Id__r.Description__c,Product1Id__r.Family__c FROM PriceBookEntry1__c 
                where Pricebook1Id__r.Name = 'standard'];
    }
    
    @AuraEnabled
    public static String createOpportunityLineItems(String jsonData, String oppId) {
        Boolean isApprovalToFire= false;
        try{
            System.debug('jsonData: ===>' + jsonData);
            List<OpportunityLineItem1__c> OLIToInsertList = new List<OpportunityLineItem1__c>();
            List<ProductInfo> productInfoList = (List<ProductInfo>)JSON.deserialize(jsonData, List<ProductInfo>.class);
            for (ProductInfo productInfo : productInfoList) {
                OpportunityLineItem1__c otirec = new OpportunityLineItem1__c();
                otirec.Product1Id__c = productInfo.productId;
                otirec.External_product_id__c = productInfo.productId;
                otirec.Name = productInfo.Name;
                otirec.Opportunity1Id__c = productInfo.OpportunityId;
                otirec.UnitPrice__c = productInfo.salesPrice;
                otirec.Quantity__c = productInfo.quantity;
                otirec.ListPrice__c = productInfo.listPrice;
                otirec.Discount__c = productInfo.discount;
                otirec.TotalPrice__c = productInfo.discountedPrice;
                otirec.Subtotal__c = productInfo.totalValue;
                OLIToInsertList.add(otirec);
            }
            insert OLIToInsertList;
            
            for(OpportunityLineItem1__c oppLineItem : OLIToInsertList){
                if(oppLineItem.ListPrice__c != null && oppLineItem.UnitPrice__c !=null){
                    if(oppLineItem.ListPrice__c > oppLineItem.UnitPrice__c){
                        if(oppId != null){
                            isApprovalToFire = true;
                        }else{
                            isApprovalToFire = false;
                        }
                    }
                }
            }
            if(isApprovalToFire){
                TriggerOpportunityHandler.ApprovalProcessForQuoteLineITem(oppId);
                System.debug('Approval Process Conditon Matched for QLI Inserted');
            }
            return 'SUCCESS';
            // system.debug('OLIToInsertList insert size====>'+OLIToInsertList.sizE());
        }catch(Exception e){
            System.debug('Error == >'+e.getMessage()+' & Erro line ===>'+e.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled
    public static string createQuote(String oppId){
        try{
            
            List<Quote_C__c> quoteSize = [Select Id from Quote_C__c where OpportunityId__c =:oppId];
            string accId = [select Id, AccountId__c from Opportunity1__c where Id=:oppId].AccountId__c;
            if(quoteSize.size()<1){
                Quote_C__c qt = new Quote_C__c();
                if(oppId != null){
                    qt.OpportunityId__c = oppId;
                }           
                if(accId != null){
                    qt.AccountId__c = accId;
                }            
                Insert qt;
            }
        }
        catch(Exception e){
            System.debug('Exception Occurs ==>'+e.getMessage());
        }
        return 'Success';
    }
    
    @AuraEnabled
    Public Static String getOppName(String recId){
        string oppName= [Select Name from Opportunity1__c where Id=:recId].Name;
        return oppName;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<PriceBookEntry1__c> getPBERecords(string priceName,String oppId){
        system.debug('The account id is==>'+oppId);
        String Accid = [Select id , AccountId__c from Opportunity1__c where id = :oppId].AccountId__c;
        map<id,Product_Fixed_Price__c> prodIdByPFP = new map<id,Product_Fixed_Price__c>();
        List<PriceBookEntry1__c> newPriceBookEntryList = new List<PriceBookEntry1__c>();
        for(Product_Fixed_Price__c pfp : [Select id , Product__c , Selling_Price__c from Product_Fixed_Price__c where Account__c = :accId]){
            prodIdByPFP.put(pfp.Product__c , pfp);
        }
        system.debug('prodIdByPFP==>'+prodIdByPFP);
        List<PriceBookEntry1__c> prodFixedPriceList = [SELECT id,Product1Id__c,List_Price__c,Product1Id__r.Name,Product1Id__r.ProductCode__c,UnitPrice__c,Product1Id__r.Description__c,Product1Id__r.Family__c FROM PriceBookEntry1__c where Pricebook1Id__r.Name =: priceName];
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
    
    @AuraEnabled(cacheable=true)
    Public Static List<OpportunityLineItem1__c> getOppLineItems(String OppId){
        return [Select Id, Name, Quantity__c, ListPrice__c, UnitPrice__c,Discount__c, Subtotal__c, TotalPrice__c from OpportunityLineItem1__c where Opportunity1Id__c =:OppId];
    }
    
    @AuraEnabled
    Public Static String updateOppLineItem(String OLILIST ,String oppId){
        Boolean isApprovalToFire= false;
       // String oppId;
        try{
            System.debug('jsonData: ===>' + OLILIST);
            List<OpportunityLineItem1__c> OLIToInsertList = new List<OpportunityLineItem1__c>();
            List<UpdateLineitemInfo> productInfoList = (List<UpdateLineitemInfo>)JSON.deserialize(OLILIST, List<UpdateLineitemInfo>.class);
            system.debug('Opp line Info == >'+productInfoList);
            for (UpdateLineitemInfo productInfo : productInfoList) {
                OpportunityLineItem1__c otirec = new OpportunityLineItem1__c();
                otirec.id = productInfo.Id;
                otirec.Name = productInfo.Name;
                otirec.UnitPrice__c = productInfo.salesPrice;
                otirec.Quantity__c = productInfo.quantity;
                otirec.ListPrice__c = productInfo.listPrice;
                otirec.Discount__c = productInfo.discount;
                otirec.TotalPrice__c = productInfo.discountedPrice;
                otirec.Subtotal__c = productInfo.totalValue;
                OLIToInsertList.add(otirec);
            }
            Update OLIToInsertList;
            System.debug('Updated OLI == >'+OLIToInsertList);

            for(OpportunityLineItem1__c oppLineItem : OLIToInsertList){
                System.debug('oppLineItem == >'+oppLineItem);
                if(oppLineItem.ListPrice__c != null && oppLineItem.UnitPrice__c !=null){
                System.debug('oppLineItem.ListPrice__c == >'+oppLineItem.ListPrice__c);
                System.debug('oppLineItem.UnitPrice__c == >'+oppLineItem.UnitPrice__c);
                    if(oppLineItem.ListPrice__c > oppLineItem.UnitPrice__c){
                            if(oppId !=null){
                                isApprovalToFire = true;
                            }else{
                                isApprovalToFire = false;
                            }
                    }
                }
            }
            System.debug('oppId == >'+oppId);
            if(isApprovalToFire){
                //TriggerOpportunityHandler.ApprovalProcessForQuoteLineITem(oppId);
                System.debug('Approval Process Conditon Matched for QLI Updated');
            }
            return 'SUCCESS';
            // system.debug('OLIToInsertList insert size====>'+OLIToInsertList.sizE());
        }catch(Exception e){
            System.debug('Error == >'+e.getMessage()+' & Erro line ===>'+e.getLineNumber());
        }
        return null;
    }
    
    
    @AuraEnabled
    Public Static string DeleteOpportunityLineItem(List<String> OppLineItemId){
        List<OpportunityLineItem1__c> oliList =  [Select Id, Name, Quantity__c, ListPrice__c, UnitPrice__c,Discount__c, Subtotal__c, TotalPrice__c from OpportunityLineItem1__c where Id IN:OppLineItemId];
        If(!oliList.isEmpty()){
            Delete oliList;
        }
        return 'success';
    }
    
    // Define a class to represent the structure of your JSON data
    public class ProductInfo {
        public String productId;
        public String Name;
        Public String opportunityId;
        Public String opportunityName;
        public Integer quantity;
        public Decimal discount;
        public Decimal salesPrice;
        public Decimal listPrice;
        public Decimal totalValue;
        public Decimal discountedPrice;
    }
    
    public class UpdateLineitemInfo {
        public String Id;
        public String Name;
        Public String opportunityId;
        public Integer quantity;
        public Decimal discount;
        public Decimal salesPrice;
        public Decimal listPrice;
        public Decimal totalValue;
        public Decimal discountedPrice;
    }
    
    // Your JSON data
    //  String jsonData = '[{"productId":"a0M5g000000OkadEAC","productName":"Test Product 3","quantity":"2","discount":0,"salesPrice":600,"listPrice":600,"totalValue":1200,"discountedPrice":1200}]';
    
    // Deserialize the JSON data into a list of ProductInfo objects
    
}