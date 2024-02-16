public class Update_Product_Achived_Target {
    
    Public static void getclosedOwn_Opportunity(set<Id> closedOwn_Opportunity_Id){
        set<Id> OpportunityId                                                   =new set<Id>();
        Map<Id,List<Opportunity1__c>>IdFiscalYear_Related_Opportunity           =new Map<Id,List<Opportunity1__c>>();
        Map<Id,List<OpportunityLineItem1__c>>OpportunityId_Related_OppLineItem  =new Map<Id,List<OpportunityLineItem1__c>>();
        Map<Id,List<Product_Achived_Target__c>>FiscalYearId_Related_PAT         =new Map<Id,List<Product_Achived_Target__c>>();
        List<Fiscal_Year__c> FiscalList                                         =[Select Id From Fiscal_Year__c];
        List<Product_Achived_Target__c> PATList_To_Update                       =new List<Product_Achived_Target__c>();
        List<Opportunity1__c> OpportunityMap                                    = new List<Opportunity1__c>();
        try{
            system.debug('closedOwn_Opportunity_Id--'+closedOwn_Opportunity_Id);
            //ClosedOwn Opportunity Related To Fiscal_year
            if(!closedOwn_Opportunity_Id.IsEmpty()){
                 OpportunityMap=[Select Id,Fiscal_Year__c From Opportunity1__c Where StageName__c!=null AND StageName__c='Closed Won' AND Fiscal_Year__c!=null AND Id=:closedOwn_Opportunity_Id]; 
            }
            system.debug('OpportunityMap--'+OpportunityMap);
            if(OpportunityMap!=null && OpportunityMap.size()>0){
                for(Opportunity1__c Opp:OpportunityMap){
                    OpportunityId.add(Opp.Id);
                    if(IdFiscalYear_Related_Opportunity.containsKey(Opp.Fiscal_Year__c)){
                        IdFiscalYear_Related_Opportunity.get(Opp.Fiscal_Year__c).add(Opp);
                    }else{
                        IdFiscalYear_Related_Opportunity.put(Opp.Fiscal_Year__c,new List<Opportunity1__c>{Opp}); 
                    }  
                }
                system.debug('OpportunityId--'+OpportunityId);
                system.debug('IdFiscalYear_Related_Opportunity--'+IdFiscalYear_Related_Opportunity);
            }
            
            if(!OpportunityId.isEmpty() && OpportunityId.size()>0){
                //OpportunityLineItem Related To Opportunity
                List<OpportunityLineItem1__c> OppLineItemList=[Select Id,Opportunity1Id__c,Product1Id__c,ListPrice__c,Subtotal__c
                                                               From OpportunityLineItem1__c Where Opportunity1Id__c IN: OpportunityId AND Subtotal__c!=null];  
                
                if(OppLineItemList!=null && !OppLineItemList.isEmpty()){
                    for(OpportunityLineItem1__c OppLitem:OppLineItemList){
                        if(OppLitem.Opportunity1Id__c!=null){
                            if(OpportunityId_Related_OppLineItem.containsKey(OppLitem.Opportunity1Id__c)){
                                OpportunityId_Related_OppLineItem.get(OppLitem.Opportunity1Id__c).add(OppLitem);
                            }else{
                                OpportunityId_Related_OppLineItem.put(OppLitem.Opportunity1Id__c,new List<OpportunityLineItem1__c>{OppLitem});
                            }   
                        }  
                    }
                }
                
                system.debug('OppLineItemList--'+OppLineItemList);
                system.debug('OpportunityId_Related_OppLineItem--'+OpportunityId_Related_OppLineItem);
            }
            //Fiscal Year Related Product_Achived_Target
            List<Product_Achived_Target__c> PATList=[Select Id,Product__c,Fiscal_Year__c,Target__c,Achived_Target__c From Product_Achived_Target__c Where Fiscal_Year__c!=null AND IsActive__c=true];
            if(PATList!=null && !PATList.isEmpty()){
                for(Product_Achived_Target__c PAT:PATList){
                    if(PAT.Fiscal_Year__c!=null){
                        if(FiscalYearId_Related_PAT.containsKey(PAT.Fiscal_Year__c)){
                            FiscalYearId_Related_PAT.get(PAT.Fiscal_Year__c).add(PAT);
                        }else{
                            FiscalYearId_Related_PAT.put(PAT.Fiscal_Year__c,new List<Product_Achived_Target__c>{PAT}); 
                        }  
                    }
                }
            }
            system.debug('PATList--'+PATList);
            system.debug('FiscalYearId_Related_PAT--'+FiscalYearId_Related_PAT);
            //Fiscal List
            if(!FiscalList.isEmpty()){
                system.debug('FiscalList--'+FiscalList);
                for(Fiscal_Year__c FY:FiscalList){
                    if(IdFiscalYear_Related_Opportunity.get(FY.Id)!=null && FiscalYearId_Related_PAT.get(FY.Id)!=null && OpportunityId_Related_OppLineItem!=null){
                        List<Product_Achived_Target__c> duplicate_PATlist=PreparedataAsPerFiscalYearValue(IdFiscalYear_Related_Opportunity.get(FY.Id),FiscalYearId_Related_PAT.get(FY.Id),OpportunityId_Related_OppLineItem);
                        system.debug('duplicate_PATlist--'+duplicate_PATlist);
                        if(duplicate_PATlist.size()>0 && duplicate_PATlist!=null){
                            PATList_To_Update.addAll(duplicate_PATlist);
                        } 
                    }   
                } 
            }
             system.debug('PATList_To_Update--'+PATList_To_Update);
             system.debug('PATList_To_Update--'+PATList_To_Update.size());
            if(!PATList_To_Update.isEmpty()){
                Update PATList_To_Update;
            }
        }catch (Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());  
        }
    }
    
    Public static List<Product_Achived_Target__c> PreparedataAsPerFiscalYearValue(List<Opportunity1__c>FiscalYear_Related_Opportunity,List<Product_Achived_Target__c>FiscalYearId_Related_PAT,Map<Id,List<OpportunityLineItem1__c>>OpportunityId_Related_OppLineItem){
        system.debug('FiscalYear_Related_Opportunity--'+FiscalYear_Related_Opportunity);
        system.debug('FiscalYearId_Related_PAT--'+FiscalYearId_Related_PAT);
        system.debug('OpportunityId_Related_OppLineItem--'+OpportunityId_Related_OppLineItem);
        
        List<OpportunityLineItem1__c> Fiscalyear_Related_Opportunity_OpportunityLineItem   =new List<OpportunityLineItem1__c>();
        Map<Id,List<OpportunityLineItem1__c>> Product2Id_Related_OpportunityLineItem       =new Map<Id,List<OpportunityLineItem1__c>>();
        Map<Id,Decimal> ProductId_Related_Total_priceCount                                 =new Map<Id,Decimal>();
        if(FiscalYear_Related_Opportunity!=null && !FiscalYear_Related_Opportunity.isEmpty()){
            for(Opportunity1__c OppRec:FiscalYear_Related_Opportunity){
                if(!OpportunityId_Related_OppLineItem.isEmpty() && OpportunityId_Related_OppLineItem.containsKey(OppRec.Id)){
                    Fiscalyear_Related_Opportunity_OpportunityLineItem.addAll(OpportunityId_Related_OppLineItem.get(OppRec.Id));
                } 
            }
            system.debug('Fiscalyear_Related_Opportunity_OpportunityLineItem--'+Fiscalyear_Related_Opportunity_OpportunityLineItem);
        }
        
        if(!Fiscalyear_Related_Opportunity_OpportunityLineItem.isEmpty()){
            for(OpportunityLineItem1__c OPPL:Fiscalyear_Related_Opportunity_OpportunityLineItem){
                if(OPPL.Product1Id__c!=null && OPPL.ListPrice__c!=null){
                    if(ProductId_Related_Total_priceCount.containsKey(OPPL.Product1Id__c)){
                        ProductId_Related_Total_priceCount.put(OPPL.Product1Id__c,ProductId_Related_Total_priceCount.get(OPPL.Product1Id__c)+OPPL.ListPrice__c);
                    }else{
                        ProductId_Related_Total_priceCount.put(OPPL.Product1Id__c,OPPL.Subtotal__c);  
                    }
                }
            }
            system.debug('ProductId_Related_Total_priceCount--'+ProductId_Related_Total_priceCount);
        }
        
        if((FiscalYearId_Related_PAT.size()>0 && FiscalYearId_Related_PAT!=null) && ProductId_Related_Total_priceCount!=null){
            for(Product_Achived_Target__c PAT:FiscalYearId_Related_PAT){
                if(PAT.Product__c!=null && ProductId_Related_Total_priceCount.containsKey(PAT.Product__c)){
                    PAT.Achived_Target__c = PAT.Achived_Target__c!=null ? PAT.Achived_Target__c+ProductId_Related_Total_priceCount.get(PAT.Product__c) :0+ProductId_Related_Total_priceCount.get(PAT.Product__c);
                }
            }
            system.debug('FiscalYearId_Related_PAT To Update--'+FiscalYearId_Related_PAT);
        }
        return FiscalYearId_Related_PAT;
    }
}