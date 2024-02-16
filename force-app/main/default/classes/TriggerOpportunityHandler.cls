public class TriggerOpportunityHandler {
    
    public static void oncreationHandleCreateFlag(List<Opportunity1__c> oppList){
        for(Opportunity1__c opp : oppList){
            opp.Opportunity_Created__c = true;
        }
    }
    
    public static void OppRSMAssignment(List<Opportunity1__c> oppList){
        
        system.debug('UserInfo.getUserId()' + UserInfo.getUserId());
        
        User loggedInUser= [select id,Profile.Name from User where id =: UserInfo.getUserId()];
        system.debug('loggedInUser' + loggedInUser);
        
        List<User> userList = [Select Id,profile.Name,Region__C from User where profile.Name ='RSM'];
        Map<String,Id> mapOfUserRegionByUserId = New Map<String,Id>();
        
        For(User us : userList){
            mapOfUserRegionByUserId.put(us.Region__C,us.id);
        }
        for(Opportunity1__c opp : oppList){
            if(opp.Region__c != null && mapOfUserRegionByUserId.get(opp.Region__C) != null){
                     opp.RSM__c = mapOfUserRegionByUserId.get(opp.Region__c);           
            }
        }
    }
    
    /* Public static void updateAmountOnPrimaryQuoteUpdate(List<Opportunity1__c> oppList,Map<Id,Opportunity1__c> oldMap){
       for(Opportunity1__c opp : oppList){
if(opp.Primary_Quote__c != null && opp.Primary_Quote__c){

}
}
    }*/
    
    // Method for Populate trhe Opportunity Name with Account Name
    Public Static Void provideOppnameWithAcc(List<Opportunity1__c> newOpp){
        for(Opportunity1__c opp : newOpp){
            if(opp.AccountId__c != null){
                String accountName = [Select Name from Account where Id =: opp.AccountId__c].Name;
                opp.Name = accountName+'-'+System.today().format()+'-'+opp.Name;
            }
        }
    }
    
    //============================================================================================================================
    //Method to update the opportunity feasibility
    @AuraEnabled
    public static String updateFeasibleStatus(String recordId, String statusReason) {
        try {
            if (recordId != null) {
                Opportunity1__c opp = [SELECT Id, Name, Sub_Status__c, Feasibility_Reason__c FROM Opportunity1__c WHERE Id = :recordId];
                if (opp != null && opp.Sub_Status__c != null) {
                    if (opp.Sub_Status__c == 'Feasible') {
                        opp.Sub_Status__c = 'Not Feasible';
                        opp.Feasibility_Reason__c = statusReason;
                    } else if (opp.Sub_Status__c == 'Not Feasible') {
                        opp.Sub_Status__c = 'Feasible';
                        opp.Feasibility_Reason__c = statusReason;
                    }
                    update opp;
                    System.debug('Updated opportunity: ' + opp);
                    if(opp !=null){
                        return 'SUCCESS';
                    }
                } 
            } 
        } catch (Exception e) {
            System.debug('An error occurred: ' + e.getMessage());
        }
        return null;
    }
    
    // ===========================================================================================================================
    // Method to Update the probabilty on opportunity creation
    Public Static Void updateProbabilityonCreation(List<Opportunity1__c> newOpp){
        Map<String, Decimal> StageProbabilityMap = new Map<String,Decimal>();
        List<Opportunity_Probability__mdt> metadataList = [select id, Label, Probability__c from Opportunity_Probability__mdt];
        for(Opportunity_Probability__mdt metadata : metadataList){
            StageProbabilityMap.put(metadata.Label, metadata.Probability__c);
        }
        
        for(Opportunity1__c opp : newOpp){
            string stagename = opp.StageName__c;
            if(StageProbabilityMap.containsKey(stagename)){
                opp.Probability__c = StageProbabilityMap.get(stagename);
            }
        }
    }
    
    // ===========================================================================================================================
    // Method to Updating Probabilty upon stage Changing
    Public Static Void updateProbability(List<Opportunity1__c> newOpp, Map<Id, Opportunity1__c> oldOppMap){
        Map<String, Decimal> StageProbabilityMap = new Map<String,Decimal>();
        List<Opportunity_Probability__mdt> metadataList = [select id, Label, Probability__c from Opportunity_Probability__mdt];
        for(Opportunity_Probability__mdt metadata : metadataList){
            StageProbabilityMap.put(metadata.Label, metadata.Probability__c);
        }
        
        for(Opportunity1__c opp : newOpp){
            string stagename = opp.StageName__c;
            if(opp.StageName__c != oldOppMap.get(opp.Id).StageName__c){
                if(StageProbabilityMap.containsKey(stagename)){
                    opp.Probability__c = StageProbabilityMap.get(stagename);
                } 
            }            
        }
    }
    
    // ===========================================================================================================================
    // Method for Creating Configure Final Product on Opportunity, // Not using;
   /*  @AuraEnabled 
   public static string createConfigureTaskOnOpportunity(string recordId){
        system.debug('recordId::::::::>'+recordId);
        List<Task__c> taskListToInsert = new List<Task__c>();
        try{
            if(recordId !=null){
                Task__c taskRec = new Task__c();
                taskRec.Subject__c = 'Please Configure Final Product.';
                taskRec.Opportunity1Id__c = recordId;
                taskRec.Assigned_To__c =  UserInfo.getUserId() != null ? UserInfo.getUserId() : null;
                taskRec.Status__c = 'Open';
                taskListToInsert.add(taskRec);
                if(taskListToInsert.size()>0){
                    insert taskListToInsert;
                    System.debug('Task Record Size === >'+taskListToInsert.size());
                    if(taskListToInsert.size()>0){
                        return taskListToInsert[0].Id;
                    }else{
                        return 'Something went wrong !';
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return null;
    } */
    
   
    // ===========================================================================================================================
    //Method to Share Opportunity record to csr user in programatically
    @AuraEnabled 
    Public Static Boolean shareToCsrUser(String recordId){
        
        try{
            //String userId = UserInfo.getUserId();
            String accId=[Select AccountId__c from Opportunity1__c where Id=:recordId].AccountId__c;
            String userId=System.Label.CSRUserID;
            
            AccountShare accountShare = new AccountShare();
            accountShare.AccountId = accId;
            accountShare.UserOrGroupId = userId;
            accountShare.AccountAccessLevel = 'Edit';
            accountShare.OpportunityAccessLevel = 'Edit';
            accountShare.RowCause = Schema.AccountShare.RowCause.Manual;
            Database.SaveResult sr = Database.insert(accountShare,false);
            System.debug('Share record results...'+sr);
            if(sr.isSuccess()){
                System.debug('Inside success');
                return true;
            }
            else {
                Database.Error err = sr.getErrors()[0];
                if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
                   err.getMessage().contains('AccessLevel')){
                       return false;
                   }
            }
        }catch(Exception e){
            system.debug('The Error ::' +e.getmessage() + 'And Error Line No : ' +e.getLineNumber());
        }
        return false;
    }
    
    // ===========================================================================================================================
    // Method for Approval Process for Quote OLI selling Price is Less than List Prices
   /*
    @AuraEnabled 
    public static string ApprovalProcessForQuoteLineITem(string recordId){
        Quote_C__c quoteRec = new Quote_C__c();
        Approval.processSubmitRequest req = new Approval.processSubmitRequest();
        try{
            if(recordId !=null){
                quoteRec = [SELECT Id,Name,RSM__c FROM Quote_C__c WHERE Id=:recordId];
                system.debug('quoteRec Unit Sales price == >'+quoteRec);
                if(quoteRec.RSM__c != null){
                    req = new Approval.processSubmitRequest();
                    req.setComments('OLI selling Price is Less than List Prices'); 
                    req.setObjectId(recordId);
                    req.setProcessDefinitionNameOrId('Quote_SPrice_greater_than_LPrice');
                    req.setNextApproverIds(new List<String> {quoteRec.RSM__c});
                    Approval.processResult result = Approval.Process(req);  
                    System.debug('result === >'+result);
                    if(result.isSuccess()){
                        return 'SUCCESS';
                    }
                }else{
                    System.debug('RSM is Null - Approval for OLI Sales Price is Less then List Price');
                }
            }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return null;
    }
*/
    
    // ===========================================================================================================================
    // Method for Approval Process for Opportunity Insert If Amount is Greater Than 50Lakh
   /*
    @AuraEnabled 
    public static string ApprovalProcessForQuoteAmount(List<Quote_C__c>  oppList){
        String recordId;
        recordId = oppList[0].Id;
        Quote_C__c quteRec = new Quote_C__c();
        Approval.processSubmitRequest req = new Approval.processSubmitRequest();
        try{
            if(recordId !=null){
                quteRec = [SELECT Id,Name,RSM__c,OpportunityId__c,OpportunityId__r.Amount__c FROM Quote_C__c WHERE Id=:recordId];
                system.debug('quteRec For Approval Process 50 Lakh == >'+quteRec);
                if(quteRec.RSM__c != null && quteRec.OpportunityId__r.Amount__c > 500000){
                    req = new Approval.processSubmitRequest();
                    req.setComments('Opportunity Amount is Greater than 50 Lakh'); 
                    req.setObjectId(recordId);
                    req.setProcessDefinitionNameOrId('Approval_Process_for_QLI');
                    req.setNextApproverIds(new List<String> {quteRec.RSM__c});
                    Approval.processResult result = Approval.Process(req);  
                    System.debug('result === >'+result);
                    if(result.isSuccess()){
                        system.debug('Approval Fired for Opportunity Amount > 50 Lakh');
                        return 'SUCCESS';
                    }
                }else{
                    System.debug('RSM__c is null OR  Amount__c is less then 50 Lakh');
                }
            }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return null;
    }
*/
    
   // ===========================================================================================================================
        // Method for Quote Approval When Discount is Greater than 20%
    /*   
    @AuraEnabled 
        public static string ApprovalProcessForQuoteDiscount(List<QuoteLineItems_c__c> quoteList){
            String recordId;
            recordId = quoteList[0].Id;
            Quote_C__c QuoteRec = new Quote_C__c();
            Approval.processSubmitRequest req = new Approval.processSubmitRequest();
            try{
                if(recordId !=null){
                    QuoteRec = [SELECT Id,Name,Discount__c,RSM__c FROM Quote_C__c WHERE Id=:recordId];
                    system.debug('QuoteRec For Approval Process Discount 20 == >'+QuoteRec);
                    if(QuoteRec.RSM__c != null && QuoteRec.Discount__c > 20 ){
                        req = new Approval.processSubmitRequest();
                        req.setComments('Quote Discount is Greater than 20%'); 
                        req.setObjectId(recordId);
                        req.setProcessDefinitionNameOrId('Quote_Discount_20');
                        req.setNextApproverIds(new List<String> {QuoteRec.RSM__c});
                        Approval.processResult result = Approval.Process(req);  
                        System.debug('result === >'+result);
                        if(result.isSuccess()){
                            return 'SUCCESS';
                        }
                    }else{
                        System.debug('RSM__c is null OR  Discount__c is less then 20%');
                    }
                }
            }catch(Exception e){
                System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
            }
            return null;
        }
*/
    
   
    
    Public static void get_closedown_opportunity(List<Opportunity1__c> oppList){
        set<Id> Opportunity_Id=new set<Id>();
        if(!oppList.isEmpty()){
            for(Opportunity1__c Opprec:oppList){
                if(Opprec.Id!=null && Opprec.StageName__c=='Closed Won'){
                    Opportunity_Id.add(Opprec.Id);
                }
            }
            system.debug('Trigger_closedOwnOppId'+Opportunity_Id);
            if(!Opportunity_Id.isEmpty()){
                system.debug('Trigger_closedOwnOppId'+Opportunity_Id);
                Update_Product_Achived_Target.getclosedOwn_Opportunity(Opportunity_Id);
            }
        }
    }  
    
    public static void updateClosedDateOnOpp(List<Opportunity1__c> newOppList){
        
        for(Opportunity1__c opp : newOppList){
            //Date createdDate = opp.CreatedDate.Date();
            if(opp.CloseDate__c == null){
               opp.CloseDate__c = system.today().addDays(90); 
            }        
        }
    }
}