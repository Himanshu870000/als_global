/**
* @author [Dinesh B]
* @email dinesh.b@utilitarianLab.com
* @create date 2024-01-02 16:08:57
* @modify date 2024-01-02 16:08:57
* @desc [Method for Custom Lead Conversion ]
*/

public class CustomLeadMappingHandler {
    
    // Method for Getting Current Lead Record Details
    @AuraEnabled
    public static List<lead__c> getLeadDetails(string recordId){
        return [select id, First_Name__c,Name, Company__c,Owner.Name from lead__c where Id =: recordId ];
    }
    
    // ===================================================================================================================
    // Method for Default new Contact,Opportunity and Account
    @AuraEnabled
    Public Static string createRecords(string accName, string Salutation, string conFirstName, string conLastName, string oppname, string ownerName,string leadId){
        System.debug('accName == >'+accName +' && Salutation == >'+Salutation +' && conFirstName === >'+conFirstName +' && conLastName == >'+conLastName +' && oppname === >'+oppname+' && ownerName === >'+ownerName);
        string LeadConvertStatus;
        Account acc = new Account();
        CustomLeadMappingHandler.objectIdsWrapper wrap = new CustomLeadMappingHandler.objectIdsWrapper();
        try{
            List<Account> accountList = new List<Account>();
            List<Contact> conList = new List<Contact>();
            List<Contact> conListFromenqDetails = new List<Contact>();
            List<Opportunity1__c> oppList = new List<Opportunity1__c>();
            List<Opportunity_Contact_Role1__c> opportunityContactRoles    = new List<Opportunity_Contact_Role1__c>();
            map<Id,List<Enquiry_Contact_Details__c>> enqContDetailsByLead = new map<Id,List<Enquiry_Contact_Details__c>>();
            List<Database.SaveResult> results = new List<Database.SaveResult>();
            
            if(accName != null){
                acc.Name=accName;
                insert acc;
                System.debug('Inserted Account 1.1 === >'+acc);
            }
            
            Contact con = new Contact();
            if(Salutation !=null){
                con.Salutation = Salutation;
            }
            if(conFirstName !=null){
                Con.FirstName = conFirstName;
            }
            if(conLastName !=null){
                con.LastName = conLastName;
            }
            conList.add(con);
            Opportunity1__c opp = new Opportunity1__c();
            if(oppname !=null){
                opp.Name=oppname;
            }
            opp.CloseDate__c = system.today();
            opp.StageName__c = 'New';
            OPP.AccountId__c = acc.id;
            oppList.add(opp);
            //  results.addAll(Database.insert(accountList, false));
            results.addAll(Database.insert(conList, false));
            results.addAll(Database.insert(oppList, false));
            System.debug('results === 33 >'+results);
            if(results!=null){
                updateContactOpportunityAccountid(results[0].getId() !=null ?  results[0].getId() : null, results[1].getId() !=null ?  results[1].getId() : null, acc.Id !=null ? acc.id : null);
                System.debug('results[0].getId() ====>'+results[0].getId());
                System.debug('results[1].getId() ====>'+results[1].getId());
                System.debug('acc.id ====>'+acc.id);
                System.debug('leadId ====>'+leadId);
                
                wrap.leadId = leadId !=null ? leadId : null;
                wrap.contactId = results[0].getId() !=null ?  results[0].getId() : null;
                wrap.opportunityId = results[1].getId() !=null ?  results[1].getId() : null;
                wrap.accountId = acc.Id !=null ?  acc.Id : null;
                
                List<Enquiry_Contact_Details__c> EnqConRoleList = [Select id , First_Name__c ,Email__c , Phone__c, Last_Name__c from Enquiry_Contact_Details__c where Lead__c =:leadId ];
                for(Enquiry_Contact_Details__c conDetail  : EnqConRoleList){
                    Contact newcon = new Contact();
                    newcon.FirstName = conDetail.First_Name__c;
                    newcon.LastName = conDetail.Last_Name__c;
                    newcon.Email = conDetail.Email__c;
                    newcon.Phone = conDetail.Phone__c;
                    newcon.AccountId = wrap.accountId;
                    conListFromenqDetails.add(newcon);
                }
                insert conListFromenqDetails;
                for(Contact conRec : conListFromenqDetails){
                    Opportunity_Contact_Role1__c oppConRole = new Opportunity_Contact_Role1__c();
                    oppConRole.Contact__c = conRec.Id ;
                    oppConRole.Opportunity1__c = wrap.opportunityId;
                    opportunityContactRoles.add(oppConRole);
                }
                insert  opportunityContactRoles;
                mapLeadFieldsToDifferentObjects(wrap);
                // opp method 1 for insert opp
              //  createInitialReqOnLeadConvertion(results[1].getId() !=null ?  results[1].getId() : null); // Method commented New Method == > moveInitialRequirementsFromLeadToOpportunity
              moveInitialRequirementsFromLeadToOpportunity(leadId,results[1].getId() !=null ?  results[1].getId() : null);

                return acc.id;
            }else{
                return 'ERROR';
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return 'ERROR';
    }
    
    // ===================================================================================================================
    // Method for Updating Contact & Opportunity AccountId When Contact and Opportunity Created
    @AuraEnabled 
    public static void updateContactOpportunityAccountid(String contactId,String opportunityId,String AccountId){
        System.debug('AccountId == >'+AccountId +' && contactId == >'+contactId +' && opportunityId == >'+opportunityId);
        try{
            if(AccountId !=null){
                if(contactId !=null){
                    Contact conToUpdate = [SELECT Id,Name,AccountId FROM Contact WHERE Id=:contactId];
                    if(conToUpdate.AccountId ==null){
                        conToUpdate.AccountId = AccountId;
                        Update conToUpdate;
                        System.debug('Updated Contact 2.1 === >'+conToUpdate);
                    }
                }
                if(opportunityId !=null){
                    Opportunity1__c oppToUpdate = [SELECT id,Name,AccountId__c FROM Opportunity1__c WHERE Id=:opportunityId];
                    if(oppToUpdate.AccountId__c == null){
                        oppToUpdate.AccountId__c = AccountId;
                        update oppToUpdate;
                        System.debug('Updated Opportunity 3.1 === >'+oppToUpdate);
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
    }
    
    public static void mapLeadFieldsToDifferentObjects(objectIdsWrapper objectWrapper){
        System.debug('objectWrapper For Lead Field Data Mapping === >'+objectWrapper);
        // Fetch metadata details
        // leads data as per metadata
        // iterate on metadata for loop
        // write the assignment logic
        
        mappingLeadFieldToAccountOpportunityContactObj(objectWrapper.leadId, objectWrapper.contactId !=null ? objectWrapper.contactId : null, objectWrapper.opportunityId !=null ? objectWrapper.opportunityId : null,objectWrapper.accountId !=null ? objectWrapper.accountId : null);
        // mappingLeadFieldToOpportunityObj(objectWrapper.leadId,objectWrapper.opportunityId);
    }
    
    // ===================================================================================================================
    // Method for updating Lead Status After Leads get Converted
    @AuraEnabled
    Public Static String UpdateleadStatus(String recordId){
        try{
            Lead__c ledRecToUpdate =  new Lead__c();
            if(recordId !=null){
                ledRecToUpdate = [SELECT Id, Name, Lead_Status__c from Lead__c where Id =:recordId];
                if(ledRecToUpdate.Lead_Status__c !=null){
                    ledRecToUpdate.Lead_Status__c = 'Convert';
                    ledRecToUpdate.IsConverted__c	 = true;
                    Update ledRecToUpdate;
                    System.debug('Lead Converted Status ==== >'+ledRecToUpdate);
                    if(ledRecToUpdate !=null){
                        return 'SUCCESS';
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return 'ERROR';
    }
    
    // ========================================================================================================================================================================
    // Method for based Selected Account get Related Opportunity Record.
    @AuraEnabled(Cacheable = true)
    public static list<Opportunity1__c> getopportunityData(String accountId) {
        try{
            if(accountId !=null){
                list<Opportunity1__c> oppLst = [SELECT  Id,Name, AccountId__r.Name, CloseDate__c, Amount__c,AccountId__c,AccountId__r.Owner.Name From Opportunity1__c WHERE AccountId__c=:accountId];        
                if(oppLst.size()>0){
                    System.debug(' oppLst Size == >'+oppLst.size());
                    return oppLst; 
                }
            }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return null;
    }
    
    // ========================================================================================================================================================================
    // Method for Existing Account / Contact / Opportunity
    @AuraEnabled
    public static string createExistingAccount_Contact_Opportunity(string accountId,String companame,String firstname,String lastname,String opportunityId,String combinationName,string contactId){
        System.debug('accountId == >'+accountId+' && companame === >'+companame+' && firstname === >'+firstname+' && lastname ===>'+lastname+' && opportunityId '+opportunityId);
        List<Account> accountListToInsert = new List<Account>();
        List<Contact> contactListToInsert = new List<Contact>();
        List<Opportunity1__c> opportunityListToInsert = new List<Opportunity1__c>();
        List<Database.SaveResult> results = new List<Database.SaveResult>();
        try{
            // Existing Account,New Contact & Existing Opportunity
            if(combinationName  == 'ExistingAccountNewContactExistingOpportunity'){
                Contact con = new Contact();
                con.FirstName =  firstname!=null ? firstname : null;
                con.LastName = lastname!=null ? lastname : null;
                con.AccountId = accountId!=null ? accountId : null;
                contactListToInsert.add(con);
                results.addAll(Database.insert(contactListToInsert, false));
                System.debug('results ===  11>'+results);
                if(results[0].isSuccess()){
                    return 'SUCCESS Contact';
                }else{
                    return 'ERROR';
                }
            }
            // New Account,Existing Contact & New Opportunity
            if(combinationName =='NewAccountExistingContactNewOpportunity'){
                Account acc = new Account();
                acc.Name = companame!=null ? companame : null;
                insert acc;
                System.debug('Insrted Account 2 === >'+acc);
                Contact con = [SELECT Id,Name FROM Contact where Id=:contactId!=null ? contactId : null];
                con.AccountId =acc.Id!=null ? acc.Id : null;
                Update con;
                System.debug('Update Contact 2'+con);
                if(con !=null){
                    return 'SUCCESS Contact 1';
                }else{
                    return 'ERROR';
                }
            }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return null;
    }
    
    // ========================================================================================================================================================================
    // Create Default Contact,Account & Opportunity using Dynamic
    @AuraEnabled
    Public Static string createDefaultAccountContactOpportunityRecords(string accName, string Salutation, string conFirstName, string conLastName, string oppname,String recordId){
        System.debug('accName == >'+accName +' && Salutation == >'+Salutation +' && conFirstName === >'+conFirstName +' && conLastName == >'+conLastName +' && oppname === >'+oppname+' && recordId === >'+recordId);
        List<Lead_Mapping__mdt> mappingLeadMDTList 	= new List<Lead_Mapping__mdt>();
        try{
            Lead__c Leadrec = [Select id , Email__c , phone__c from Lead__c where id = :recordId];
            mappingLeadMDTList = [SELECT Id,MasterLabel,Account_Field_API_Name__c,Contact_Field_API_Name__c,Lead_Field_API_Name__c,Opportunity_Field_API_Name__c FROM Lead_Mapping__mdt];
            List<Account> accountList = new List<Account>();
            List<Contact> conList = new List<Contact>();
            List<Opportunity1__c> oppList = new List<Opportunity1__c>();
            List<Database.SaveResult> results = new List<Database.SaveResult>();
            Account acc = new Account();
            if(accName != null){
                acc.Name=accName;
                insert acc;
                System.debug('Inserted Account 11.1 == >'+acc);
            }
            accountList.add(acc);
            Contact con = new Contact();
            if(Salutation !=null){
                con.Salutation = Salutation;
            }
            if(conFirstName !=null){
                Con.FirstName = conFirstName;
            }
            if(conLastName !=null){
                con.LastName = conLastName;
            }
            con.Email = Leadrec.Email__c;
            con.Phone = Leadrec.Phone__c;    
            conList.add(con);
            Opportunity1__c opp = new Opportunity1__c();
            if(oppname !=null){
                opp.Name=oppname;
            }
            opp.CloseDate__c = system.today();
            opp.StageName__c = 'New';
            opp.AccountId__c = acc.id;
            oppList.add(opp);
            // results.addAll(Database.insert(accountList, false));
            results.addAll(Database.insert(conList, false));
            results.addAll(Database.insert(oppList, false));
            System.debug('results === 22 >'+results);
            // opp method 2 for insert opp
            // createInitialReqOnLeadConvertion.TriggerOpportunityHandler(results[0].)
            if(results!=null){
                return acc.id;
            }else{
                return 'ERROR';
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return 'ERROR';
    }
    
    
    // ========================================================================================================================================================================
    // Duplicate Check Contact, Account & Opportunity
    @AuraEnabled 
    public static string checkDuplicateAccountContactOpportunity(string recordId){
        lead__c getLeadDetails = new lead__c();
        List<Account> checkDuplicateAccount = new List<Account>();
        List<Opportunity1__c> checkDuplicateOpportunity = new List<Opportunity1__c>();
        List<Contact> checkDuplicateContact = new List<Contact>();
        try{
            if(recordId !=null){
                getLeadDetails =  [select id, First_Name__c,Name, Company__c,Owner.Name,Email__c,Phone__c from lead__c where Id =: recordId ];
                if(getLeadDetails.Company__c !=null){
                    checkDuplicateAccount = [SELECT Id,Name FROM Account WHERE Name=:getLeadDetails.Company__c];
                    checkDuplicateOpportunity = [SELECT Id,Name FROM Opportunity1__c WHERE Name=:getLeadDetails.Company__c];
                    checkDuplicateContact = [SELECT Id,LastName FROM Contact WHERE LastName =:getLeadDetails.Company__c];
                    if(checkDuplicateAccount.size()>0){
                        //return 'Error Duplicate Account Found !';
                    }
                    if(checkDuplicateOpportunity.size()>0){
                        //return 'Error Duplicate Opportunity Found !';
                    }
                    if(checkDuplicateContact.size()>0){
                        //return 'Error Duplicate Contact Found !';
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return null;
    }
    
    // ========================================================================================================================================================================
    // Method for Mapping Lead Fields to Account
    public static string mappingLeadFieldToAccountOpportunityContactObj(String leadId,String contactId,String opportunityId,String accountId){
        System.debug(' Mapping  leadId === >'+leadId +' && accountId === >'+accountId+' && opportunityId == >'+opportunityId+' && contactId === >'+contactId);
        
        Account accRec = new Account();
        Opportunity1__c oppRec = new Opportunity1__c();
        Contact conRec = new Contact();
        
        List<Lead_Mapping__mdt> mappingLeadMDTList 	= new List<Lead_Mapping__mdt>();
        String ErrorMessage='Required Fields Are Missing';
        lead__c ledRec = new lead__c();
        try{
            mappingLeadMDTList = [SELECT Id,Lead_Field_API_Name__c,Account_Field_API_Name__c,Contact_Field_API_Name__c,Opportunity_Field_API_Name__c FROM Lead_Mapping__mdt];
            if(leadId !=null){
                ledRec = Database.Query(CreateDynamicQueryForLead(leadId,mappingLeadMDTList));
                if(ledRec.Company__c == null){
                    ErrorMessage='Company Field value Is Missing'; 
                    return ErrorMessage;
                }
                if(ledRec.First_Name__c == null){
                    ErrorMessage='FirstName Field value Is Missing'; 
                    return ErrorMessage;
                }
                if(ledRec.Name == null){
                    ErrorMessage='LastName Field value Is Missing'; 
                    return ErrorMessage;
                }
                
                // for Account
                if(accountId !=null){
                    accRec.Id = accountId;
                    if(ledRec.Company__c !=null){
                        for(Lead_Mapping__mdt data : mappingLeadMDTList){
                            System.debug('Account Mapping  data.Account_Field_API_Name__c == >'+data.Account_Field_API_Name__c);
                            System.debug('LEAD Mapping  data.Lead_Field_API_Name__c == >'+data.Lead_Field_API_Name__c);
                            if(data.Account_Field_API_Name__c !=null && data.Lead_Field_API_Name__c !=null){
                                accRec.put(data.Account_Field_API_Name__c,ledRec.get(data.Lead_Field_API_Name__c));
                            }
                        }
                        if(accRec !=null){
                            update accRec;
                            System.debug('Updated Account LEAD MAPPING ==>'+accRec);
                            //  return 'SUCCESS';
                        }
                    }
                }
                // For Opportunity
                if(opportunityId !=null){
                    oppRec.Id = opportunityId;
                    if(ledRec.Company__c !=null){
                        for(Lead_Mapping__mdt data : mappingLeadMDTList){
                            System.debug('Opportunity Mapping  data.Opportunity_Field_API_Name__c == >'+data.Opportunity_Field_API_Name__c);
                            System.debug('LEAD Mapping  data.Lead_Field_API_Name__c == >'+data.Lead_Field_API_Name__c);
                            if(data.Opportunity_Field_API_Name__c !=null && data.Lead_Field_API_Name__c !=null){
                                if(ledRec.get(data.Lead_Field_API_Name__c) !=null){
                                    oppRec.put(data.Opportunity_Field_API_Name__c,ledRec.get(data.Lead_Field_API_Name__c));
                                }else{
                                    System.debug('Blank Value === >'+ledRec.get(data.Lead_Field_API_Name__c));
                                }
                            }
                        }
                        if(oppRec !=null){
                            update oppRec;
                            System.debug('Updated Opportunity LEAD MAPPING == >'+oppRec);
                            //  return 'SUCCESS';
                        }
                    }
                }
                // For Contact
                if(contactId !=null){
                    conRec.Id = contactId;
                    if(ledRec.Company__c !=null){
                        for(Lead_Mapping__mdt data : mappingLeadMDTList){
                            System.debug('Contact Mapping  data.Contact_Field_API_Name__c == >'+data.Contact_Field_API_Name__c);
                            System.debug('LEAD Mapping  data.Lead_Field_API_Name__c == >'+data.Lead_Field_API_Name__c);
                            if(data.Contact_Field_API_Name__c !=null && data.Lead_Field_API_Name__c !=null){
                                conRec.put(data.Contact_Field_API_Name__c,ledRec.get(data.Lead_Field_API_Name__c));
                            }
                        }
                        if(conRec !=null){
                            update conRec;
                            System.debug('Updated Contact LEAD MAPPING == >'+conRec);
                            //  return 'SUCCESS';
                        }
                    }
                }
                return 'SUCCESS';
            }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return null;
    }
    
    
    // ========================================================================================================================================================================
    // Method for Dynamic Query for Lead Record
    public static string CreateDynamicQueryForLead(String leadId,List<Lead_Mapping__mdt> metaDataList){
        try{
            String Query = 'SELECT Id';
            for(Lead_Mapping__mdt meta : metaDataList){
                if(String.isNotBlank(meta.Lead_Field_API_Name__c)){
                    if(!Query.contains(',' + meta.Lead_Field_API_Name__c)){
                     Query +=' ,'+meta.Lead_Field_API_Name__c;   
                    }
                }
            }
            Query += ' FROM lead__c WHERE ID=:leadId';
            System.debug('Query == >'+Query);
            return Query;
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return null;
    }
    
    // ========================================================================================================================================================================
    // Method to create Initial Requirement record when lead convertion to opportunity
    // Public Static String createInitialReqOnLeadConvertion(String recordId){
    //     List<Initial_Requirement__c> InReqToInsert = new List<Initial_Requirement__c>();
    //     String oppName = [Select Name from Opportunity1__c where Id =: recordId].Name;
    //     try{
    //         if(recordId != null){
    //             Initial_Requirement__c inReq = new Initial_Requirement__c();
    //             inReq.Name = oppName; 
    //             inreq.Opportunity1Id__c = recordId;
    //             InReqToInsert.add(inReq);
    //             if(InReqToInsert.size()>0){
    //                 insert InReqToInsert;
    //                 system.debug('Initial Req Record Size ==>' +InReqToInsert.size());
    //                 if(InReqToInsert.size()>0){
    //                     return InReqToInsert[0].Id;
    //                 }else{
    //                     return 'Something went wrong..!';
    //                 }
    //             }
    //         }
    //     }catch(Exception e){
    //         system.debug('The Error ::' +e.getmessage() + 'And Error Line No : ' +e.getLineNumber());
    //     }
        
    //     return null;
    // }
    
    // ========================================================================================================================================================================
    
    public class objectIdsWrapper{
        public Id leadId;
        public Id contactId;
        public Id opportunityId;
        public Id accountId;
    }

    //========================================================================================================================================================================
    // Method for creating Intital Requirements from Lead to Opportunity Records
    public static void moveInitialRequirementsFromLeadToOpportunity(String leadId,String opportunityId){
        System.debug('leadId == >'+leadId+' && opportunityId == >'+opportunityId);
        List<Initial_Requirement__c> intailReqList = new List<Initial_Requirement__c>();
        List<Initial_Requirement__c> intailReqListToUpdate = new List<Initial_Requirement__c>();
        try{
          if(leadId !=null && opportunityId !=null){
            intailReqList = [SELECT id,Name,LeadId__c,Opportunity1Id__c FROM Initial_Requirement__c WHERE LeadId__c=:leadId];
            if(intailReqList.size()>0){
                // intailReqList[0].LeadId__c = null;
                // intailReqList[0].Opportunity1Id__c = opportunityId;
                // update intailReqList;
                // System.debug('Update Record Intital Requirements === >'+intailReqList);
                for(Initial_Requirement__c intRec : intailReqList){
                    Initial_Requirement__c intRecToUpdate = new Initial_Requirement__c();
                    intRecToUpdate.id = intRec.id;
                    intRecToUpdate.LeadId__c = null;
                    intRecToUpdate.Opportunity1Id__c = opportunityId;
                    intailReqListToUpdate.add(intRecToUpdate);
                }
                if(intailReqListToUpdate.size()>0){
                    update intailReqListToUpdate;
                    System.debug('Update Int Requirements frpm Lead to Opportunity == '+intailReqListToUpdate.size());
                }
            }
          }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
    }

}