public class SendMOMfromLeadController {
    
    @AuraEnabled(cacheable=true)
    public static List<emailContactWrapper> getContacts(String leadId) {
        system.debug('leadId' + leadId);
        List<emailContactWrapper> contactWrapperList = new List<emailContactWrapper>();
        
        for(Lead__c leadRec : [SELECT Id, First_Name__c, Name, Email__c,(
            SELECT Id, First_Name__c, Last_Name__c,Email__c FROM Enquiry_Contact_Details__r) FROM Lead__c WHERE Id = : leadId]){
                emailContactWrapper contactWrapper = new emailContactWrapper();
                contactWrapper.FirstName = leadRec.First_Name__c;
                contactWrapper.LastName = leadRec.Name;
                contactWrapper.emailId = leadRec.Email__c;
                contactWrapper.Id = leadRec.Id;
                contactWrapperList.add(contactWrapper);
                
                for(Enquiry_Contact_Details__c ecd : leadRec.Enquiry_Contact_Details__r){
                    emailContactWrapper contactWrapperECD = new emailContactWrapper();
                    contactWrapperECD.FirstName = ecd.First_Name__c;
                    contactWrapperECD.LastName  = ecd.Last_Name__c;
                    contactWrapperECD.emailId   = ecd.Email__c;
                    contactWrapperECD.Id        = ecd.Id;
                    contactWrapperList.add(contactWrapperECD);

                }
            }
        return contactWrapperList;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static Task__c getRelatedTaskMOM(String leadId) {
        List<Task__c> tasks = [SELECT Id, MOM__c, Status__c, Subject__c FROM Task__c 
                               WHERE Lead__c = :leadId AND Subject__c = 'First Touch With Customer' LIMIT 1];
        return tasks.isEmpty() ? null : tasks[0];
    }
    
    @AuraEnabled
    public static void sendEmailToSelectedContacts(List<String> selectedContactIds, String meetingNotes) {
        // Get the email template body
		system.debug('the meeting notes are '+meetingNotes);
        String body = [SELECT Id, Name, Body FROM EmailTemplate WHERE Name = 'MOM Email Template'].Body;
        
        // Map to store contact details by contact Id
        Map<Id, Enquiry_Contact_Details__c> contactsById = new Map<Id, Enquiry_Contact_Details__c>
            ([SELECT Id, First_Name__c, Last_Name__c, Email__c FROM Enquiry_Contact_Details__c WHERE Id IN :selectedContactIds]);
        
        Map<Id, Lead__c> leadContactById = new Map<Id, Lead__c>
            ([SELECT Id, First_Name__c, Name, Email__c FROM Lead__c WHERE Id IN :selectedContactIds]);
        
        // Iterate through selected contacts
        for (String contactId : selectedContactIds) {
            if (contactsById.containsKey(contactId)) {
                Enquiry_Contact_Details__c selectedContact = contactsById.get(contactId);
                
                // Replace placeholders in the email template body
                body = body.replace('{!Enquiry_Contact_Details__c.First_Name__c}', selectedContact.First_Name__c);
                body = body.replace('{!Enquiry_Contact_Details__c.Last_Name__c}', selectedContact.Last_Name__c);
                body = body.replace('{!Task__c.MOM__c}', meetingNotes);
                
                // Send email to the selected contact
                sendMOMEmail(selectedContact.Email__c, 'Minutes of Meeting', body);
            } 
            else if (leadContactById.containsKey(contactId)) {
                Lead__c selectedLeadContact = leadContactById.get(contactId);
                
                // Replace placeholders in the email template body
                body = body.replace('{!Enquiry_Contact_Details__c.First_Name__c}', selectedLeadContact.First_Name__c);
                body = body.replace('{!Enquiry_Contact_Details__c.Last_Name__c}', selectedLeadContact.Name);
                body = body.replace('{!Task__c.MOM__c}', meetingNotes);
                
                // Send email to the selected contact
                sendMOMEmail(selectedLeadContact.Email__c, 'Minutes of Meeting', body);
            }
        }
    }

    
    public static Boolean sendMOMEmail(String toAddress, String subject, String body) {
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
    
    @AuraEnabled
    public static void updateTaskStatus(String taskId, String status) {
        Task__c taskToUpdate = [SELECT Id,Status__c,isCompleted__c FROM Task__c WHERE Id = :taskId LIMIT 1];
        taskToUpdate.Status__c = status;
        taskToUpdate.isCompleted__c = true;
        update taskToUpdate;
    }
    
    public class emailContactWrapper {
        @AuraEnabled public String FirstName;
        @AuraEnabled public String LastName;
        @AuraEnabled public String Id;
        @AuraEnabled public String emailId;
    }
    
    
}