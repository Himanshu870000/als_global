public class OpportunityHelper {
    
    // Method to Send Reqlease Quote-Send Email to Opportunity Owner - CC- RSM & Change Stage to Quote Initiated
    @AuraEnabled 
    public static string sendReleaseQuoteToOpportunityOwner(String recordId){
        Opportunity1__c oppRecToUpdate = new Opportunity1__c();
        EmailTemplate temp =[Select Id,Subject,Description, HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Release Quote Email'];
        string perViouseTaskToClose = Constant.QUOTE_SUBMITTED_BY_SALES_USER;
        Task__c taskToConplete = [SELECT Id,Opportunity1Id__c,Status__c,Subject__c FROM Task__c WHERE Opportunity1Id__c=: recordId  AND Subject__c =:perViouseTaskToClose LIMIT 1];
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        try{
            if(recordId !=null){
                oppRecToUpdate = [SELECT Id,Name,RSM__c,RSM__r.Email,OwnerId__c,OwnerId__r.Name,OwnerId__r.Email,StageName__c,CreatedBy.Email,CreatedBy.Name,createdBy.Id FROM Opportunity1__c WHERE Id=:recordId];
                System.debug('oppRecToUpdate == >'+oppRecToUpdate);
                if(oppRecToUpdate.RSM__c !=null){
                    String htmlBody = temp.HTMLValue;
                    String plainTextBody = temp.body;
                    plainTextBody = plainTextBody.replace('{!OwnerId__r.Name}', oppRecToUpdate.CreatedBy.Name);
                    htmlBody = htmlBody.replace('{!OwnerId__r.Name}', oppRecToUpdate.CreatedBy.Name);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setHtmlBody(htmlBody);
                    mail.setSubject(temp.Subject);
                    mail.setPlainTextBody(plainTextBody);
                    
                    mail.toAddresses = new String[] {oppRecToUpdate.CreatedBy.Email};
                        if(oppRecToUpdate.RSM__r.Email !=null){
                            mail.setCcAddresses(new List<String>{oppRecToUpdate.RSM__r.Email}); 
                        }
                    Messaging.SendEmailResult[] results = Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail });
                    if(results[0].isSuccess()){
                        System.debug('Email sent successfully');
                        oppRecToUpdate.StageName__c = 'Quote Initiated';
                        update oppRecToUpdate;
                        System.debug('Update oppRecToUpdate == >'+oppRecToUpdate);
                        if(oppRecToUpdate !=null){
                              if(taskToConplete.Status__c !='Completed'){
                                taskToConplete.Status__c ='Completed'; 
                                update taskToConplete;
                                System.debug('Completed Task on Release Quote -> Quote Submited by Sales User'+taskToConplete);
                              }
                            Task__c taskRec = new Task__c();
                            taskRec.Assigned_To__c = oppRecToUpdate.createdBy.Id;
                            taskRec.ActivityDate__c = system.today();
                            taskRec.Opportunity1Id__c = oppRecToUpdate.Id;
                            taskRec.Status__c = 'Open';
                            taskRec.Subject__c = 'Quote Initiated By Customer Success';
                            insert taskRec;
                            if(taskRec !=null){
                                return 'SUCCESS';
                            }
                            else{
                                System.debug('Something went wrong !');
                                return 'ERROR';
                            }
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return  null;
    }
    
    // ==================================================================================================================================================
    //Method to Share Opportunity record with Customer Success with Email Notification and CC-RSM ==>Submit Quote Request Helper
    // Before make any changes in method plase ask me once - Dinesh
    @AuraEnabled 
    Public Static String shareRecordToCustomerSuccessOnSubmitQuote(String recordId){
        Opportunity1__c oppRec= new Opportunity1__c();
        Task__c getTaskRec = new Task__c();
        String TaskSubject = Constant.CHECK_QUOTE_FEASIBILITY;
        EmailTemplate temp =[Select Id,Subject,Description, HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Customer SuccessTemplate'];
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        try{
            if(recordId !=null){
                getTaskRec = [SELECT Id,Subject__c,Opportunity1Id__c,Status__c FROM Task__c WHERE Opportunity1Id__c =:recordId AND Subject__c =:TaskSubject];
                oppRec = [SELECT Id,Name,RSM__c,StageName__c,ContactPerson__c,RSM__r.Email,Billing_Address__c , Contact_Person__c , Shipping_Address__c,Customer_Success__c,Customer_Service_User_Id__c,Customer_Success__r.Email,Customer_Success__r.Name,AccountId__c FROM Opportunity1__c WHERE Id=:recordId];
                    if(oppRec.StageName__c != 'Quote Feasibility'){
                        oppRec.StageName__c = 'Quote Feasibility';
                    }
                    update oppRec;
                    if(oppRec !=null){
                        if(getTaskRec !=null){
                            if(getTaskRec.Status__c != 'Completed'){
                                getTaskRec.Status__c = 'Completed';
                            }
                            update getTaskRec;
                            System.debug('Updated Quote Feasibility Task == >'+getTaskRec);
                        }
                        Task__c task = new Task__c();
                        task.Assigned_To__c = oppRec.Customer_Success__c;
                        task.ActivityDate__c = system.today();
                        task.Opportunity1Id__c = oppRec.Id;
                        task.Status__c = 'Open';
                        task.Subject__c = 'Quote Submitted By Sales User';
                        insert Task;
                        System.debug('Task Inserted for Quote Submit == >'+Task);
                        if(oppRec.AccountId__c !=null && oppRec.Customer_Success__c !=null){
                            AccountShare accountShare = new AccountShare();
                            accountShare.AccountId = oppRec.AccountId__c;
                            accountShare.UserOrGroupId = oppRec.Customer_Service_User_Id__c;
                            accountShare.AccountAccessLevel = 'Edit';
                            accountShare.OpportunityAccessLevel = 'Edit';
                            accountShare.RowCause = Schema.AccountShare.RowCause.Manual;
                            Database.SaveResult sr = Database.insert(accountShare,false);
                            System.debug('Share record Customer Success results == >'+sr);
                            if(sr.isSuccess()){
                                System.debug('Inside success');
                                String htmlBody = temp.HTMLValue;
                                String plainTextBody = temp.body;
                                plainTextBody = plainTextBody.replace('{!Customer_Success__r.Name}', oppRec.Customer_Success__r.Name);
                                htmlBody = htmlBody.replace('{!Customer_Success__r.Name}', oppRec.Customer_Success__r.Name);
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                mail.setHtmlBody(htmlBody);
                                mail.setSubject(temp.Subject);
                                mail.setPlainTextBody(plainTextBody);
                                mail.toAddresses = new String[] {oppRec.Customer_Success__r.Email};  // 'dinesh.butilitarianlab@gmail.com'
                                    if(oppRec.RSM__r.Email !=null){
                                        mail.setCcAddresses(new List<String>{oppRec.RSM__r.Email}); // 'dinesh.b@utilitarianlabs.com'
                                    }
                                Messaging.SendEmailResult[] results = Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail });
                                System.debug('results == >'+results);
                                if(results[0].isSuccess()){
                                    return  'SUCCESS';
                                }else{
                                     return 'ERROR';
                                }
                            }
                        }else{
                            system.debug('Account Id or Billing Address is Missing !');
                        }
                    }    
            }
        }catch(Exception e){
            system.debug('The Error ::' +e.getmessage() + 'And Error Line No : ' +e.getLineNumber());
        }
        return null;
    }

    // ==================================================================================================================================================
    // Method for Getting Opportunity Details
    @AuraEnabled 
    public static Opportunity1__c getOppDetails(string recordId){
        Opportunity1__c oppRec = new Opportunity1__c();
        try{
            if(recordId !=null){
                oppRec = [SELECT Id,Name,Customer_Success__c,Contact_Person__c FROM Opportunity1__c WHERE Id=:recordId];
                if(oppRec !=null){
                    System.debug('oppRec Check Customer Success === >'+oppRec);
                    return oppRec;
                }
            }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return null;
    }
    
    // ==================================================================================================================================================
    // Method for updating Negotiation Notes and updating stage to stage Negotiation and also send email to CS and CC-RMS
    @AuraEnabled 
    Public Static String UpdateNegotiationnotes(String negotiationvalue, string recordId){
        System.debug('negotiationvalue == >'+negotiationvalue +' && recordId == >'+recordId);
        Task__c getTaskRec = new Task__c();
        String TaskSubjectQuoteIntiatedByUser = Constant.QUOTE_INITIATED_BY_CUSTOMER_SUCCESS;
        Opportunity1__c oppRecToUpdate = new Opportunity1__c();
        EmailTemplate temp =[Select Id,Subject,Description, HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Customer SuccessTemplate'];
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        try{
            if(recordId != null){
                getTaskRec = [SELECT Id,Subject__c,Opportunity1Id__c,Status__c FROM Task__c WHERE Opportunity1Id__c =:recordId AND Subject__c =:TaskSubjectQuoteIntiatedByUser];
                oppRecToUpdate = [SELECT Id,Name,RSM__c,RSM__r.Email,Customer_Success__c,Customer_Success__r.Email,Customer_Success__r.Name,AccountId__c,Negotiation_Notes__c,StageName__c FROM Opportunity1__c where Id =:recordId ];
                System.debug('oppRecToUpdate == >'+oppRecToUpdate);
                if(negotiationvalue !=null){
                    oppRecToUpdate.Negotiation_Notes__c = negotiationvalue;
                }
                if(oppRecToUpdate.StageName__c != 'Negotiation'){
                    oppRecToUpdate.StageName__c = 'Negotiation';
                }
                update oppRecToUpdate;
                System.debug('Updated oppRecToUpdate == >'+oppRecToUpdate);
                if(oppRecToUpdate !=null){

                    Task__c task = new Task__c();
                    task.Assigned_To__c = oppRecToUpdate.Customer_Success__c;
                    task.ActivityDate__c = system.today();
                    task.Opportunity1Id__c = oppRecToUpdate.Id;
                    task.Status__c = 'Open';
                    task.Subject__c = 'Negotiation Initiated By Sales User';
                    insert Task;


                    if(getTaskRec !=null){
                        if(getTaskRec.Status__c != 'Completed'){
                            getTaskRec.Status__c = 'Completed';
                        }
                        update getTaskRec;
                        System.debug('Updated Quote Initiated by User == >'+getTaskRec);
                    }

                    String htmlBody = temp.HTMLValue;
                    String plainTextBody = temp.body;
                    plainTextBody = plainTextBody.replace('{!Customer_Success__r.Name}', oppRecToUpdate.Customer_Success__r.Name);
                    htmlBody = htmlBody.replace('{!Customer_Success__r.Name}', oppRecToUpdate.Customer_Success__r.Name);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setHtmlBody(htmlBody);
                    mail.setSubject(temp.Subject);
                    mail.setPlainTextBody(plainTextBody);
                    mail.toAddresses = new String[] {oppRecToUpdate.Customer_Success__r.Email};  // 'dinesh.butilitarianlab@gmail.com'
                        if(oppRecToUpdate.RSM__r.Email !=null){
                            mail.setCcAddresses(new List<String>{oppRecToUpdate.RSM__r.Email}); // 'dinesh.b@utilitarianlabs.com'
                        }
                    Messaging.SendEmailResult[] results = Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail });
                    System.debug('results Negotiation == >'+results);
                    if(results[0].isSuccess()){
                        return 'SUCCESS';
                    }else{
                        return 'ERROR';
                    }
                }
            }
            
        }catch( exception e){
            System.debug('error= '+e.getmessage() +' && Error line => '+e.getlinenumber());
        }
        return null;
    }
  
  
    // Method to get State,Country and Area PickList;
    @AuraEnabled(cacheable=true)
    public static String fetchDependentPicklistValues(){
        List<State_City_Area_Data__mdt> StateCityAreaList = [SELECT Id,State__c,City__c,Area__c FROM State_City_Area_Data__mdt];
        Map<String,List<Map<String,List<String>>>> MapOfStateCityAreaList = new Map<String,List<Map<String,List<String>>>>();
        Map<String,List<String>> mapOfCityArea = new  Map<String,List<String>>();
        for(State_City_Area_Data__mdt data : StateCityAreaList){
            mapOfCityArea = new Map<String,List<String>>();
            List<String> areaList = data.Area__c.split(','); 
            mapOfCityArea.put(data.City__c,areaList);
            if(MapOfStateCityAreaList.containsKey(data.State__c)){
                MapOfStateCityAreaList.get(data.State__c).add(mapOfCityArea);
            }
            else{
                MapOfStateCityAreaList.put(data.State__c,new List<Map<String,List<String>>>{mapOfCityArea});
            }
        }
        system.debug('MapOfStateCityAreaList == >'+MapOfStateCityAreaList);
        return JSON.serialize(MapOfStateCityAreaList);
    }

    // // Method for Storing Route record
    @AuraEnabled
    public static Route__c createRouteRecord(String State,String city,String routename,String salesUserId){
        System.debug('State == >'+State +' and City ==>'+city +' && routename ==>'+routename +' salesUserId === >'+salesUserId);
        try{
            if(State!=null && city !=null && routename!=null && salesUserId !=null){
                Route__c routeRec = new Route__c();
                routeRec.Route_Name_New__c = routename;
                routeRec.City_Name__c = city;
                routeRec.State_Name__c = State;
                routeRec.Sales_User__c = salesUserId;
                insert routeRec;
                System.debug('routeRec === >'+routeRec);
                if(routeRec !=null){
                    return routeRec;
                }
            }
        }catch(Exception e){
            System.debug('The Error '+e.getMessage()+'&& Erron Line '+e.getLineNumber());
        }
        return null;
    }
    
}