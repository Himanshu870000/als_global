public class LeadTriggerHandler {
    
    public static void leadRSMAssignment(List<Lead__C> leadList) {
        system.debug('UserInfo.getUserId()' + UserInfo.getUserId());
        
        User loggedInUser = [SELECT Id, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
        system.debug('loggedInUser' + loggedInUser);
        
        List<User> userList = [SELECT Id, Profile.Name, Region__C FROM User WHERE Profile.Name = 'RSM'];
        Map<String, Id> mapOfUserRegionByUserId = new Map<String, Id>();
        
        for (User us : userList) {
            mapOfUserRegionByUserId.put(us.Region__C, us.Id);
        }
        
        for (Lead__c ld : leadList) {
            if (ld.Region__c != null && mapOfUserRegionByUserId.get(ld.Region__c) != null) {
                if (ld.Lead_Source__c != null && (ld.Lead_Source__c == 'Direct Mail' || ld.Lead_Source__c == 'Web to lead' || ld.Lead_Source__c == 'Google Ads')) {
                    ld.OwnerId = mapOfUserRegionByUserId.get(ld.Region__c);
                    ld.RSM__c = mapOfUserRegionByUserId.get(ld.Region__c);
                } else {
                    ld.RSM__c = mapOfUserRegionByUserId.get(ld.Region__c);
                }
            }
        }
    }
    
    
    
    public static void onAfterInsertLead(Map<Id,Lead__c> leadsMap) {
        Map<String,Lead__c> leadToAssignMap = new Map<String, Lead__c>();
        for(Lead__c lRec: leadsMap.values()) {
            leadToAssignMap.put(lRec.Id, lRec);
        }
        system.debug('leadToAssignMap === >'+leadToAssignMap);
        if(!leadToAssignMap.isEmpty()) {
            // LeadAssignmentExecutionCriteria.validateEntryCriteria(leadToAssignMap.values());
        }
    }
    
    public void onAfterUpdate(List<Lead__c> newLeadsList, Map<Id,Lead__c> oldLeadsMap)  {
        List<Lead__c> leadsToAssign = new List<Lead__c>();
        for(Lead__c lead: newLeadsList) {
            if(lead.Region__c != null && lead.Region__c != oldLeadsMap.get(lead.Id).Region__c){
                leadsToAssign.add(lead);
            }
        }
        system.debug('leadsToAssign === >'+leadsToAssign);
        if(!leadsToAssign.isEmpty()) {
            // LeadAssignmentExecutionCriteria.validateEntryCriteria(leadsToAssign);
        }
    }
    
    //Added by shubhi : used to tag Enquiry Contact Deatils Record after lead conversion.
    /*public static void tagEnquiryContactDetails(List<Lead__c> leadList, Map<Id, Lead__c> oldMapLead) {
        try{
            List<Lead__c> convertedLeads                                  = new List<Lead__c>();
            List<Contact> newContacts                                     = new List<Contact>();
            List<Opportunity_Contact_Role1__c> opportunityContactRoles    = new List<Opportunity_Contact_Role1__c>();
            map<Id,List<Enquiry_Contact_Details__c>> enqContDetailsByLead = new map<Id,List<Enquiry_Contact_Details__c>>();
            map<Id,Id> leadIdByAccId                                      = new map<Id,Id>();
            map<Id,Id> leadIdByOppId                                      = new map<Id,Id>();
            for (Lead__c led : leadList) {
                Lead__c oldLead = oldMapLead.get(led.Id);
                if (led.IsConverted__c && !oldLead.IsConverted__c) {
                    convertedLeads.add(led);
                    leadIdByAccId.put(led.Id , led.AccountId__c);
                }
            }
            List<Opportunity1__c> oppList = [Select id , AccountId__c from Opportunity1__c where AccountId__c IN :leadIdByAccId.values()];
            for(Opportunity1__c oppRec : oppList){
                leadIdByOppId.put(oppRec.AccountId__c,oppRec.Id);
            }
            List<Enquiry_Contact_Details__c> enquiryContactDetailsList = [SELECT Id, Name, Email__c, First_Name__c, Last_Name__c, Phone__c, Roles__c, Account__c, Lead__c
                                                                          FROM Enquiry_Contact_Details__c WHERE Lead__c IN :convertedLeads];
            
            for(Enquiry_Contact_Details__c conDetails : enquiryContactDetailsList){
                if(!enqContDetailsByLead.containsKey(conDetails.Lead__c)){
                    List<Enquiry_Contact_Details__c> enqConRecs = new List<Enquiry_Contact_Details__c>();
                    enqConRecs.add(conDetails);
                    enqContDetailsByLead.put(conDetails.Lead__c , enqConRecs);
                }else{
                    enqContDetailsByLead.get(conDetails.Lead__c).add(conDetails);
                }
            }
            system.debug('enqContDetailsByLead==>'+enqContDetailsByLead);
            
            if (!enqContDetailsByLead.keyset().isEmpty()) {
                for (Id convertedLeadId : enqContDetailsByLead.keyset()) {
                    for (Enquiry_Contact_Details__c enquiryContactDetails : enqContDetailsByLead.get(convertedLeadId)) {
                        Contact newContact = new Contact(FirstName       = enquiryContactDetails.First_Name__c,
                                                         LastName        = enquiryContactDetails.Last_Name__c,
                                                         Email           = enquiryContactDetails.Email__c,
                                                         Phone           = enquiryContactDetails.Phone__c,
                                                         Lead_Contact__c = enquiryContactDetails.Lead__c);
                        newContacts.add(newContact);
                    }
                }
                system.debug('newContacts' + newContacts);
                insert newContacts;
                system.debug('newContacts' + newContacts);
            }
            for(contact newCon : newContacts){
                Opportunity_Contact_Role1__c oppConRole = new Opportunity_Contact_Role1__c();
                oppConRole.Opportunity1__c              = leadIdByOppId.get(newCon.AccountId);
                opportunityContactRoles.add(oppConRole);
            }
            insert opportunityContactRoles;
            
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }*/
    
    //Added by shubhi : used to update task status of a Mark Audited task.
    public static void updateTaskStatus(List<Lead__c> newLeads, Map<Id, Lead__c> oldLeadsMap) {
        
        List<Task__c> tasksToUpdate = new List<Task__c>();
        
        Set<Id> leadIds = new Set<Id>();
        
        for (Lead__c newLead : newLeads) {
            Lead__c oldLead = oldLeadsMap.get(newLead.Id);
            
            if ((newLead.Audit_Date__c != oldLead.Audit_Date__c) || (newLead.Audit_Time__c != oldLead.Audit_Time__c)) {
                leadIds.add(newLead.Id);
            }
        }
        
        if (!leadIds.isEmpty()) {
            List<Task__c> relatedTasks = [SELECT Id, Status__c, Subject__c, Lead__c 
                                          FROM Task__c 
                                          WHERE Lead__c IN :leadIds 
                                          AND Subject__c = 'Mark Audited'];
            
            for (Task__c task : relatedTasks) {
                if (task.Status__c != 'Completed') {
                    task.Status__c = 'Completed';
                    tasksToUpdate.add(task);
                }
            }
            
            if (!tasksToUpdate.isEmpty()) {
                
                try {
                    update tasksToUpdate;
                } catch (Exception e) {
                    System.debug('Exception: ' + e.getMessage() + 'AND Error Line No :'+e.getLineNumber());
                    
                }
            }
        }
    }
    
    //Added by shubhi : used to update Owner of open tasks.
    public static void updateRelatedTaskOwnersOnLeadOwnerChange(List<Lead__c> newLeads, Map<Id, Lead__c> oldLeadMap) {
        
        List<Task__c> tasksToUpdate = new List<Task__c>();
        Map<Id, Id> leadIdToNewOwnerIdMap = new Map<Id, Id>();
        
        for (Lead__c newLead : newLeads) {
            Lead__c oldLead = oldLeadMap.get(newLead.Id);
            
            if (newLead.OwnerId != oldLead.OwnerId) {
                leadIdToNewOwnerIdMap.put(newLead.Id, newLead.OwnerId);
            }
        }
        
        if (!leadIdToNewOwnerIdMap.isEmpty()) {
            List<Task__c> openTasks = [SELECT Id,Lead__c, OwnerId FROM Task__c WHERE Lead__c IN :leadIdToNewOwnerIdMap.keySet() AND Status__c = 'Open'];
            
            for (Task__c openTask : openTasks) {
                openTask.OwnerId = leadIdToNewOwnerIdMap.get(openTask.Lead__c);
                tasksToUpdate.add(openTask);
            }
            
            if (!tasksToUpdate.isEmpty()) {
                update tasksToUpdate;
            }
        }
    }
    
    //Added by shubhi : used to stop status update in case no Visit Record Tagged.
    /*public static void validateLeadStatusChange(List<Lead__c> newLeads, Map<Id, Lead__c> oldLeadMap) {

List<String> errorMessage = new List<String>();

for (Lead__c newLead : newLeads) {
Lead__c oldLead = oldLeadMap.get(newLead.Id);

if (newLead.Lead_Status__c == 'Fix Appointment' && oldLead.Lead_Status__c != 'Fix Appointment') {

if (!hasVisitRecord(newLead.Id)) {
newLead.addError('Cannot change Lead status to "Fix Appointment" without adding a Visit Record.');
}
}
}
}

private static Boolean hasVisitRecord(Id leadId) {

List<Visit__c> visitRecords = [SELECT Id FROM Visit__c WHERE Lead__c = :leadId LIMIT 1];
return !visitRecords.isEmpty();
}*/
    
    public static void validateLeadConversion(List<Lead__c> newLeads, Map<Id, Lead__c> oldLeadsMap) {
        
        List<Lead__c> leadsToCheck = new List<Lead__c>();
        for (Lead__c newLead : newLeads) {
            Lead__c oldLead = oldLeadsMap.get(newLead.Id);
            
            if (newLead.Lead_Status__c == 'Audit' && !String.isBlank(oldLead.Lead_Status__c)) {
                leadsToCheck.add(newLead);
            }
        }
        
        if (!leadsToCheck.isEmpty()) {
            for (Lead__c lead : leadsToCheck) {
                if (lead.Audit_Date__c == null || String.isBlank(lead.Audit_Location__c) ||
                    lead.Audit_Time__c == null || String.isBlank(lead.Audit_Notes__c)) {
                        
                        lead.addError('Add audit details for this Lead.');
                    }
            }
        }
    }
    
    public static void sendEmailtoStakeHolders(List<Lead__c> newLeadList, Map<Id, Lead__c> oldLeadMap) {
        
        List<Id> leadIdsToCheck = new List<Id>();
        for (Lead__c newLead : newLeadList) {
            Lead__c oldLead = oldLeadMap.get(newLead.Id);
            
            if (newLead.Lead_Status__c == 'Audit' && newLead.Lead_Status__c != oldLead.Lead_Status__c){
                leadIdsToCheck.add(newLead.Id);
            }
        }
        
        if (!leadIdsToCheck.isEmpty()) {
            UtilityClassForEmailMethod.getStakeHolderDetails(leadIdsToCheck);
        }
    }
    
}