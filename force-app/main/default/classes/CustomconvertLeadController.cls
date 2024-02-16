public class CustomconvertLeadController {

    // // Method for getting Current Lead Record Details
    // @AuraEnabled
    // public static List<lead__c> getLeadDetails(string recordId){
    //     return [select id, First_Name__c,Name, Company__c,Owner.Name from lead__c where Id =: recordId ];
    // }

    // // ========================================================================================================================================================================
    
    // // Method for Default new Contact,Opportunity and Account
    // @AuraEnabled
    // Public Static string createRecords(string accName, string Salutation, string conFirstName, string conLastName, string oppname, string ownerName,string leadId){
    //     System.debug('accName == >'+accName +' && Salutation == >'+Salutation +' && conFirstName === >'+conFirstName +' && conLastName == >'+conLastName +' && oppname === >'+oppname+' && ownerName === >'+ownerName);
    //     string LeadConvertStatus;
    //     CustomLeadMappingHandler.objectIdsWrapper wrap = new CustomLeadMappingHandler.objectIdsWrapper();
    //     try{
    //         List<Account> accountList = new List<Account>();
    //         List<Contact> conList = new List<Contact>();
    //         List<Opportunity1__c> oppList = new List<Opportunity1__c>();
    //         List<Database.SaveResult> results = new List<Database.SaveResult>();
    //         Account acc = new Account();
    //         if(accName != null){
    //             acc.Name=accName;
    //         }
    //         accountList.add(acc);
    //         Contact con = new Contact();
    //         if(Salutation !=null){
    //             con.Salutation = Salutation;
    //         }
    //         if(conFirstName !=null){
    //             Con.FirstName = conFirstName;
    //         }
    //         if(conLastName !=null){
    //             con.LastName = conLastName;
    //         }
    //         conList.add(con);
    //         Opportunity1__c opp = new Opportunity1__c();
    //         if(oppname !=null){
    //             opp.Name=oppname;
    //         }
    //         opp.CloseDate__c = system.today();
    //         opp.StageName__c = 'New';
    //         oppList.add(opp);
    //         results.addAll(Database.insert(accountList, false));
    //         results.addAll(Database.insert(conList, false));
    //         results.addAll(Database.insert(oppList, false));
    //         System.debug('results === >'+results);
    //         if(results!=null){
    //             updateContactOpportunityAccountid(results[0].getId() !=null ?  results[0].getId() : null, results[1].getId() !=null ?  results[1].getId() : null, results[2].getId() !=null ?  results[2].getId() : null);
    //             wrap.leadId = leadId !=null ? leadId : null;
    //             wrap.accountId = results[0].getId() !=null ?  results[0].getId() : null;
    //             wrap.contactId = results[1].getId() !=null ?  results[1].getId() : null;
    //             wrap.opportunityId = results[2].getId() !=null ?  results[2].getId() : null;
    //             CustomLeadMappingHandler.mapLeadFieldsToDifferentObjects(wrap);
    //             return 'SUCCESS';
    //         }else{
    //             return 'ERROR';
    //         }
    //     }catch(Exception e){
    //         System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
    //     }
    //     return 'ERROR';
    // }

    // // Method for Updating Contact & Opportunity AccountId When Contact and Opportunity Created
    // @AuraEnabled 
    // public static void updateContactOpportunityAccountid(String AccountId,String contactId,String opportunityId){
    //     System.debug('AccountId == >'+AccountId +' && contactId == >'+contactId +' && opportunityId == >'+opportunityId);
    //     try{
    //        if(AccountId !=null){
    //         if(contactId !=null){
    //             Contact conToUpdate = [SELECT Id,Name,AccountId FROM Contact WHERE Id=:contactId];
    //             if(conToUpdate.AccountId ==null){
    //                 conToUpdate.AccountId = AccountId;
    //                 Update conToUpdate;
    //                 System.debug('Updated Contact === >'+conToUpdate);
    //             }
    //         }
    //         if(opportunityId !=null){
    //             Opportunity1__c oppToUpdate = [SELECT id,Name,AccountId__c FROM Opportunity1__c WHERE Id=:opportunityId];
    //             if(oppToUpdate.AccountId__c == null){
    //                 oppToUpdate.AccountId__c = AccountId;
    //                 update oppToUpdate;
    //                 System.debug('Updated Opportunity === >'+oppToUpdate);
    //             }
    //         }
    //        }
    //     }catch(Exception e){
    //         System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
    //     }
    // }
    
    // // ========================================================================================================================================================================
     
    // // Method for updating Lead Status After Leads get Converted
    // @AuraEnabled
    // Public Static String UpdateleadStatus(String recordId){
    //     try{
    //         Lead__c ledRecToUpdate =  new Lead__c();
    //         if(recordId !=null){
    //             ledRecToUpdate = [SELECT Id, Name, Lead_Status__c from Lead__c where Id =:recordId];
    //             if(ledRecToUpdate.Lead_Status__c !=null){
    //                 ledRecToUpdate.Lead_Status__c = 'Convert';
    //                 Update ledRecToUpdate;
    //                 System.debug('Lead Converted Status ==== >'+ledRecToUpdate);
    //                 if(ledRecToUpdate !=null){
    //                     return 'SUCCESS';
    //                 }
    //             }
    //         }
    //     }catch(Exception e){
    //         System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
    //         }
    //        return 'ERROR';
    // }
    // // ========================================================================================================================================================================
    // // Method for based Selected Contact get Related Opportunity Record.
    // @AuraEnabled(Cacheable = true)
    // public static list<Opportunity1__c> getopportunityData(String accountId) {
    //     try{
    //         if(accountId !=null){
    //             list<Opportunity1__c> oppLst = [SELECT  Id,Name, AccountId__r.Name, CloseDate__c, Amount__c,AccountId__c, Owner.name From Opportunity1__c WHERE AccountId__c=:accountId];        
    //             if(oppLst.size()>0){
    //                 System.debug(' oppLst Size == >'+oppLst.size());
    //              return oppLst; 
    //             }
    //         }
    //     }catch(Exception e){
    //         System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
    //         }
    //      return null;
    // }


    // // Method for Existing Account / Contact / Opportunity
    // @AuraEnabled
    // public static string createExistingAccount_Contact_Opportunity(string accountId,String companame,String firstname,String lastname,String opportunityId,String combinationName,string contactId){
    //     System.debug('accountId == >'+accountId+' && companame === >'+companame+' && firstname === >'+firstname+' && lastname ===>'+lastname+' && opportunityId '+opportunityId);
    //     List<Account> accountListToInsert = new List<Account>();
    //     List<Contact> contactListToInsert = new List<Contact>();
    //     List<Opportunity1__c> opportunityListToInsert = new List<Opportunity1__c>();
    //     List<Database.SaveResult> results = new List<Database.SaveResult>();
    //     try{
             
    //          // Existing Account,New Contact & Existing Opportunity
    //         if(combinationName  == 'ExistingAccountNewContactExistingOpportunity'){
    //         Contact con = new Contact();
    //         con.FirstName =  firstname!=null ? firstname : null;
    //         con.LastName = lastname!=null ? lastname : null;
    //         con.AccountId = accountId!=null ? accountId : null;
    //         contactListToInsert.add(con);
    //         results.addAll(Database.insert(contactListToInsert, false));
    //         System.debug('results === >'+results);
    //         if(results[0].isSuccess()){
    //          return 'SUCCESS Contact';
    //         }else{
    //             return 'ERROR';
    //         }
    //         }

    //           // New Account,Existing Contact & New Opportunity
    //         if(combinationName =='NewAccountExistingContactNewOpportunity'){
    //             Account acc = new Account();
    //             acc.Name = companame!=null ? companame : null;
    //             insert acc;
    //             System.debug('Insrted Account 2 === >'+acc);
    //             Contact con = [SELECT Id,Name FROM Contact where Id=:contactId!=null ? contactId : null];
    //             con.AccountId =acc.Id!=null ? acc.Id : null;
    //             Update con;
    //             System.debug('Update Contact 2'+con);
    //             if(con !=null){
    //                 return 'SUCCESS Contact 1';
    //             }else{
    //                 return 'ERROR';
    //             }
    //         }
             
    //     //     Account acc = new Account();
    //     //     acc.Name = companame!=null ? companame : null;
    //     //     accountListToInsert.add(acc);

    //     //    Contact con = new Contact();
    //     //    con.FirstName =  firstname!=null ? firstname : null;
    //     //    con.LastName = lastname!=null ? lastname : null;
    //     //    con.AccountId = accountId!=null ? accountId : null;
    //     //    contactListToInsert.add(con);

    //     //    Opportunity1__c opp = new Opportunity1__c();
    //     //    opp.Name = companame!=null ? companame : null;
    //     //    opp.CloseDate__c = system.today();
    //     //    opp.StageName__c = 'New';
    //     //    opportunityListToInsert.add(opp);
    //     }catch(Exception e){
    //         System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
    //     }
    //     return null;
    // }
  


    // // Method for mapping dynamic Lead Field API Name to Account,Contact and Opportunity using Metadata.
    // public static  Map<String,String> mapValuesForAccount_Contact_Opportunity(String recordId){
    //     lead__c getLeadDetails = new lead__c();
    //     System.debug('recordId === >'+recordId);
    //     Map<String,String> mapOfApiNameValueForLeadObj = new Map<String,String>();
    //     Map<String,String> mapOfApiNameValueForAccountObj = new Map<String,String>();
    // try{
    //     List<Lead_Mapping__mdt> mappingLeadMDTList 	= new List<Lead_Mapping__mdt>();
    //    if(recordId !=null){
    //     mappingLeadMDTList = [SELECT Id,Lead_Field_API_Name__c FROM Lead_Mapping__mdt];
    //     getLeadDetails =  [select id, First_Name__c,Name, Company__c,Owner.Name from lead__c where Id =: recordId ];
    //     System.debug('getLeadDetails === >'+getLeadDetails);
    //     if(getLeadDetails !=null){
    //         Map<String, Object> populatedFields = getLeadDetails.getPopulatedFieldsAsMap();
    //          for(Lead_Mapping__mdt mdt : mappingLeadMDTList){
    //             String fieldAPINamelead = mdt.Lead_Field_API_Name__c;
    //             if (populatedFields.containsKey(fieldAPINamelead)) {
    //                 if(String.valueOf(populatedFields.get(fieldAPINamelead)) !=null){
    //                     mapOfApiNameValueForLeadObj.put(fieldAPINamelead,String.valueOf(populatedFields.get(fieldAPINamelead)));
    //                 }
    //             }
    //          }
    //          System.debug(' mapOfApiNameValueForLeadObj === >'+mapOfApiNameValueForLeadObj);
    //          if(mapOfApiNameValueForLeadObj !=null){
    //             return mapOfApiNameValueForLeadObj;
    //          }
    //     }
    //    }
     
    // }catch(Exception e){
    //     System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
    //     }
    //     return null;
    // }

    // // Create Default Contact,Account & Opportunity using Dynamic
    // @AuraEnabled
    // Public Static string createDefaultAccountContactOpportunityRecords(string accName, string Salutation, string conFirstName, string conLastName, string oppname,String recordId){
    //     System.debug('accName == >'+accName +' && Salutation == >'+Salutation +' && conFirstName === >'+conFirstName +' && conLastName == >'+conLastName +' && oppname === >'+oppname+' && recordId === >'+recordId);
    //     List<Lead_Mapping__mdt> mappingLeadMDTList 	= new List<Lead_Mapping__mdt>();
        
    //     try{
    //         if(recordId !=null){
    //             Map<String,String> mapOfLeadApiNameValueObj = mapValuesForAccount_Contact_Opportunity(recordId);
    //         }
    //         mappingLeadMDTList = [SELECT Id,MasterLabel,Account_Field_API_Name__c,Contact_Field_API_Name__c,Lead_Field_API_Name__c,Opportunity_Field_API_Name__c FROM Lead_Mapping__mdt];

    //         List<Account> accountList = new List<Account>();
    //         List<Contact> conList = new List<Contact>();
    //         List<Opportunity1__c> oppList = new List<Opportunity1__c>();
    //         List<Database.SaveResult> results = new List<Database.SaveResult>();
    //         Account acc = new Account();
    //         if(accName != null){
    //             acc.Name=accName;
    //         }
    //         accountList.add(acc);
    //         Contact con = new Contact();
    //         if(Salutation !=null){
    //             con.Salutation = Salutation;
    //         }
    //         if(conFirstName !=null){
    //             Con.FirstName = conFirstName;
    //         }
    //         if(conLastName !=null){
    //             con.LastName = conLastName;
    //         }
    //         conList.add(con);
    //         Opportunity1__c opp = new Opportunity1__c();
    //         if(oppname !=null){
    //             opp.Name=oppname;
    //         }
    //         opp.CloseDate__c = system.today();
    //         opp.StageName__c = 'New';
    //         oppList.add(opp);
    //         results.addAll(Database.insert(accountList, false));
    //         results.addAll(Database.insert(conList, false));
    //         results.addAll(Database.insert(oppList, false));
    //         System.debug('results === >'+results);
    //         if(results!=null){
    //             return 'SUCCESS';
    //         }else{
    //             return 'ERROR';
    //         }
    //     }catch(Exception e){
    //         System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
    //     }
    //     return 'ERROR';
    // }
    

    // // Duplicate Check Contact, Account & Opportunity
    // @AuraEnabled 
    // public static string checkDuplicateAccountContactOpportunity(string recordId){
    //     lead__c getLeadDetails = new lead__c();
    //     List<Account> checkDuplicateAccount = new List<Account>();
    //     List<Opportunity1__c> checkDuplicateOpportunity = new List<Opportunity1__c>();
    //     List<Contact> checkDuplicateContact = new List<Contact>();
    //     try{
    //      if(recordId !=null){
    //         getLeadDetails =  [select id, First_Name__c,Name, Company__c,Owner.Name from lead__c where Id =: recordId ];
    //         if(getLeadDetails.Company__c !=null){
    //             checkDuplicateAccount = [SELECT Id,Name FROM Account WHERE Name=:getLeadDetails.Company__c];
    //             checkDuplicateOpportunity = [SELECT Id,Name FROM Opportunity1__c WHERE Name=:getLeadDetails.Company__c];
    //             checkDuplicateContact = [SELECT Id,LastName FROM Contact WHERE LastName =:getLeadDetails.Name];
    //             if(checkDuplicateAccount.size()>0){
    //                 return 'Error Duplicate Account Found !';
    //             }
    //             if(checkDuplicateOpportunity.size()>0){
    //                 return 'Error Duplicate Opportunity Found !';
    //             }
    //             if(checkDuplicateContact.size()>0){
    //                 return 'Error Duplicate Contact Found !';
    //             }
    //         }

    //      }
    //     }catch(Exception e){
    //         System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
    //     }
    //     return null;
    // }


    // @AuraEnabled
    // Public Static String createAccount(String accName){
    //     Account acc = new Account();
    //     acc.Name = accName;
    //     Insert acc;
    //     return 'Success';
    // }
    
    // @AuraEnabled
    // Public Static String createContact(String Sal, String fname, String lname){
    //     Contact con = new Contact();
    //     con.FirstName = fname;
    //     con.LastName = lname;
    //     insert con;
    //     return 'success';
    // }
    
    // @AuraEnabled 
    // Public Static String createopportunity(String oppName){
    //     Opportunity1__c opp = new Opportunity1__c();
    //     opp.Name = oppName;
    //     opp.CloseDate__c = system.today().addDays(30);
    //     opp.StageName__c = 'Prospecting';
    //     Insert opp;
    //     return 'Success';
    // }

}