public class sendMOMFromOpportunityController {
    
    @AuraEnabled(cacheable=true)
    public static List<emailContactWrapper> getContacts(String oppId) {
        system.debug('oppId === >' + oppId);
        List<emailContactWrapper> contactWrapperList = new List<emailContactWrapper>();
        Boolean hasMatchingContact = false;
        
        for(Opportunity1__c leadRec : [SELECT Id, Name,Contact_Person__r.FirstName,Contact_Person__r.LastName,Contact_Person__r.Email,(
            SELECT Id,Contact__r.FirstName,Contact__r.LastName,Contact__r.Email FROM Opportunity_Contact_Role__r) FROM Opportunity1__c WHERE Id = : oppId]){
                emailContactWrapper contactWrapper = new emailContactWrapper();
                
                if(leadRec.Opportunity_Contact_Role__r.size() == 0){
                    system.debug('opp con person === >' + leadRec.Contact_Person__r.FirstName +  '&&  opp con role person ==> ' + leadRec.Contact_Person__r.Email);
                    contactWrapper.FirstName = leadRec.Contact_Person__r.FirstName;
                    contactWrapper.LastName = leadRec.Contact_Person__r.LastName;
                    contactWrapper.emailId = leadRec.Contact_Person__r.Email;
                    contactWrapper.Id = leadRec.Id;
                    contactWrapperList.add(contactWrapper);
                }
                
                for (Opportunity_Contact_Role1__c ocr : leadRec.Opportunity_Contact_Role__r) {
                    if (ocr.Contact__r.Id == leadRec.Contact_Person__r.Id) {
                        hasMatchingContact = true;
                        break; // No need to continue checking if a matching contact is found
                    }
                }
                if (leadRec.Opportunity_Contact_Role__r.size() >= 1 && !hasMatchingContact) {
                    // Add Opportunity1__c details to contactWrapperList
                    system.debug('opp con person 1  == >' + leadRec.Contact_Person__r.FirstName + ' opp con role person 1 === > ' + leadRec.Contact_Person__r.Email);
                    contactWrapper.FirstName = leadRec.Contact_Person__r.FirstName;
                    contactWrapper.LastName = leadRec.Contact_Person__r.LastName;
                    contactWrapper.emailId = leadRec.Contact_Person__r.Email;
                    contactWrapper.Id = leadRec.Id;
                    contactWrapperList.add(contactWrapper);
                }
                
                for(Opportunity_Contact_Role1__c ecd : leadRec.Opportunity_Contact_Role__r){
                    emailContactWrapper contactWrapperECD = new emailContactWrapper();
                    system.debug('opp con person 2 == >' + ecd.Contact__r.FirstName + ' opp con role person 2 == > ' + ecd.Contact__r.LastName + ' opp con role person 2 == >' + ecd.Contact__r.Email);
                    contactWrapperECD.FirstName = ecd.Contact__r.FirstName;
                    contactWrapperECD.LastName  = ecd.Contact__r.LastName;
                    contactWrapperECD.emailId   = ecd.Contact__r.Email;
                    contactWrapperECD.Id        = ecd.Id;
                    contactWrapperList.add(contactWrapperECD);
                    
                }
            }
            System.debug('contactWrapperList === >'+contactWrapperList);
        return contactWrapperList;
    }
    
  /*  
    // Not used
    @AuraEnabled
    public static void sendEmailToSelectedContacts(List<String> selectedContactIds, String meetingNotes) {
        System.debug('selectedContactIds === >'+selectedContactIds);
        System.debug('meetingNotes === >'+meetingNotes);
        // Get the email template body
        String body = [SELECT Id, Name, Body FROM EmailTemplate WHERE Name = 'MOM Email Template'].Body;
        
        // Map to store contact details by contact Id
        Map<Id, Opportunity_Contact_Role1__c> contactsById = new Map<Id, Opportunity_Contact_Role1__c>
            ([SELECT Id,Contact__r.FirstName,Contact__r.LastName,Contact__r.Email FROM Opportunity_Contact_Role1__c WHERE Contact__c IN :selectedContactIds]);
        
        Map<Id, Opportunity1__c> leadContactById = new Map<Id, Opportunity1__c>
            ([SELECT Id, Name,Contact_Person__r.FirstName,Contact_Person__r.LastName,Contact_Person__r.Email FROM Opportunity1__c WHERE Contact_Person__c IN :selectedContactIds]);
        
        // Iterate through selected contacts
        for (String contactId : selectedContactIds) {
            if (contactsById.containsKey(contactId)) {
                system.debug('contactId :: '+contactId);
                Opportunity_Contact_Role1__c selectedContact = contactsById.get(contactId);
                
                // Replace placeholders in the email template body
                body = body.replace('{!Enquiry_Contact_Details__c.First_Name__c}', selectedContact.Contact__r.FirstName);
                body = body.replace('{!Enquiry_Contact_Details__c.Last_Name__c}', selectedContact.Contact__r.LastName);
                body = body.replace('{!Task__c.MOM__c}', meetingNotes);
                
                // Send email to the selected contact
                sendMOMEmail(selectedContact.Contact__r.Email, 'Minutes of Meeting', body);
            } 
            else if (leadContactById.containsKey(contactId)) {
                system.debug('contactId :: '+contactId);
                Opportunity1__c selectedLeadContact = leadContactById.get(contactId);
                
                // Replace placeholders in the email template body
                body = body.replace('{!Enquiry_Contact_Details__c.First_Name__c}', selectedLeadContact.Contact_Person__r.FirstName);
                body = body.replace('{!Enquiry_Contact_Details__c.Last_Name__c}', selectedLeadContact.Contact_Person__r.LastName);
                body = body.replace('{!Task__c.MOM__c}', meetingNotes);
                
                // Send email to the selected contact
                sendMOMEmail(selectedLeadContact.Contact_Person__r.Email, 'Minutes of Meeting', body);
            }
        }
    }
    
    // Not Used
    public static Boolean sendMOMEmail(String toAddress, String subject, String body) {
        System.debug('toAddress === >'+toAddress);
        System.debug('toAddress === >'+toAddress);

        try {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            // Set the recipient email address
            email.setToAddresses(new String[]{toAddress});
            
            // Set the email subject and body
            email.setSubject(subject);
            email.setHtmlBody(body);
            
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            
            // Email sent successfully
            return true;
        } catch (Exception e) {
            // Handle the exception (log, display, etc.)
            System.debug('Error sending email: ' + e.getMessage());
            return false;
        }
    }
   */ 
    // Not used
    public class emailContactWrapper {
        @AuraEnabled public String FirstName;
        @AuraEnabled public String LastName;
        @AuraEnabled public String Id;
        @AuraEnabled public String emailId;
    }

    // Method to Send the Selected Contact Email - Dinesh
    @AuraEnabled
    public static string SendEmailToSelectedContactNew(List<String> selectedContactIds, String meetingNotes){
        System.debug('selectedContactIds == >'+selectedContactIds);
        System.debug('meetingNotes == >'+meetingNotes);
        set<String> contactIdSetFromOpp = new Set<String>();
        Set<String> oppContactId = new Set<String>();
        Set<String> contactIdfromOppRole = new Set<String>();
        Set<String> allContactIds = new Set<String>();
        Set<String> OppIdSet = new Set<String>();

        String sObjName;
        for(String str : selectedContactIds){
            sObjName = Id.valueOf(str).getSObjectType().getDescribe().getName();
            System.debug('sObjName == >'+sObjName);
            if(sObjName == 'Opportunity1__c'){
                OppIdSet.add(str);
            }
            if(sObjName ==  'Opportunity_Contact_Role1__c'){
                oppContactId.add(str);
            }
        }
    
       System.debug('oppContactId == >'+oppContactId);
       if(OppIdSet.size()>0){
        List<Opportunity1__c> oppList = [SELECT id,Name,Contact_Person__c FROM Opportunity1__c WHERE Id IN:OppIdSet];
        if(oppList.size()>0){
            for(Opportunity1__c opp : oppList){
                contactIdSetFromOpp.add(opp.Contact_Person__c);
            }
        }
       }
        List<Opportunity_Contact_Role1__c> oppConList = [SELECT Id,Name,Contact__c FROM Opportunity_Contact_Role1__c WHERE Id IN:oppContactId];
        if(oppConList.size()>0){
            for(Opportunity_Contact_Role1__c opcon : oppConList){
                contactIdfromOppRole.add(opcon.Contact__c);
            }
        }
        allContactIds.addAll(contactIdfromOppRole);
        allContactIds.addAll(contactIdSetFromOpp);
        System.debug('allContactIds 2 == >'+allContactIds);
        EmailTemplate temp =[Select Id,Subject,Description, HtmlValue,DeveloperName,Body from EmailTemplate where name = 'MOM Email Template'];
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        List<String> EmaiListToSendEmail = new List<String>();
        List<Messaging.SendEmailResult> sendEmailResults = new List<Messaging.SendEmailResult>();
        try{
            if(allContactIds.size()>0){
              for(Contact con : [SELECT Id,LastName,FirstName,Email FROM Contact WHERE Id IN :allContactIds]){
                String htmlBody = temp.HTMLValue;
                String plainTextBody = temp.body;
                plainTextBody = plainTextBody.replace('{!Enquiry_Contact_Details__c.First_Name__c}', con.FirstName);
                plainTextBody = plainTextBody.replace('{!Enquiry_Contact_Details__c.Last_Name__c}', con.LastName);
                plainTextBody = plainTextBody.replace('{!Task__c.MOM__c}',meetingNotes);

                htmlBody = htmlBody.replace('{!Enquiry_Contact_Details__c.First_Name__c}', con.FirstName);
                htmlBody = htmlBody.replace('{!Enquiry_Contact_Details__c.Last_Name__c}', con.LastName);
                htmlBody = htmlBody.replace('{!Task__c.MOM__c}', meetingNotes);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setHtmlBody(htmlBody);
                mail.setSubject(temp.Subject);
                mail.setPlainTextBody(plainTextBody);
                if(con.Email !=null){
                    System.debug('Email == >'+con.Email);
                    mail.toAddresses = new String[] {con.Email};
                }
                mailList.add(mail);
              }
              if(!mailList.isEmpty()){
                sendEmailResults = Messaging.sendEmail(mailList);
                System.debug(' Result === >'+sendEmailResults[0].isSuccess());
                if(sendEmailResults[0].isSuccess()){
                    return 'SUCCESS';
                }else{
                    return 'FAILURE';
                }
            }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
       return null;
    }

}