public class UtilityClassForEmailMethod {
    
    public static void getECDLeadDetails(map<id,String> leadIDByMom) {
        string body = [Select Id, Name , body from Emailtemplate where name    = 'MOM Email Template'].body;
        map<id,List<Enquiry_Contact_Details__c>> enquiryDetailsRecordsbyLeadId = new map<id,List<Enquiry_Contact_Details__c>>();
        
        map<String,String> emailIdsByName                                      = new map<String,String>();
        List<Id> leadOwnerIDs                                                  = new List<Id>();
        List<Enquiry_Contact_Details__c> enqContDetails                        = [Select Id, Name , First_Name__c,Email__c,lead__r.OwnerId  
                                                                                  from Enquiry_Contact_Details__c where Lead__c IN : leadIDByMom.keyset() and Email__c != null];
        for(Enquiry_Contact_Details__c ecd : enqContDetails){
            leadOwnerIDs.add(ecd.lead__r.OwnerId);
            emailIdsByName.put(ecd.First_Name__c , ecd.Email__c);
            if(enquiryDetailsRecordsbyLeadId.containsKey(ecd.Lead__c)){
                enquiryDetailsRecordsbyLeadId.get(ecd.Lead__c).add(ecd);
            }else{
                List<Enquiry_Contact_Details__c> newenqContDetails = new List<Enquiry_Contact_Details__c> ();
                newenqContDetails.add(ecd);
                enquiryDetailsRecordsbyLeadId.put(ecd.Lead__c,newenqContDetails);
            }
        }
        List<User> userData = [Select Id, Name , Email from user where ID IN :leadOwnerIDs];
        for(User usRec : userData){
            emailIdsByName.put(usRec.Name,usRec.Email);
        }
        
        for(String leadId : enquiryDetailsRecordsbyLeadId.keySet()){
            if(leadIDByMom.get(leadId) != null){
                body = body.replace('{!Task__c.MOM__c}',leadIDByMom.get(leadId));
            }
            
            for(string emailRec : emailIdsByName.keyset()){
                system.debug('emailRec==>'+emailRec);
                body = body.replace('Hi','Hi '+emailRec);
                body = body.stripHtmlTags();
                sendMOMEmail(emailIdsByName.get(emailRec),'Minutes of meeting',body);
            }
            
        }
        system.debug('emailIdsByName==>'+emailIdsByName);
    }
    
    public static Boolean sendMOMEmail(String toAddress, String subject, String body) {
        try {
            system.debug('body==>'+body);
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
    
    public static void getStakeHolderDetails(List<Id> recordIds) {
        
        string body = [Select Id, Name , body from Emailtemplate where name    = 'Audit Details Template'].body;
        
        map<id,List<Stakeholder_Details__c>> stakeholderRecordsbyLeadId        = new map<id,List<Stakeholder_Details__c>>();
        map<id,Lead__c> leadDetailsbyLeadId                                    = new map<id,Lead__c>();
        
        map<String,String> emailIdsByName                                      = new map<String,String>();
        List<Id> leadOwnerIDs                                                  = new List<Id>();
        List<Stakeholder_Details__c> shDetails                                 = [Select Id, Name , Name__c,Email__c,Lead__c,Active__c 
                                                                                  from Stakeholder_Details__c where Lead__c IN : recordIds and Active__c = True];
        List<Lead__c> leadAudtiDetails                                         = [Select Id, Name ,Audit_Date__c,Audit_Location__c,Audit_Notes__c,Audit_Time__c
                                                                                  from Lead__c where Id IN : recordIds];
        
        for(Stakeholder_Details__c shd : shDetails){
            emailIdsByName.put(shd.Name__c , shd.Email__c);
            if(stakeholderRecordsbyLeadId.containsKey(shd.Lead__c)){
                stakeholderRecordsbyLeadId.get(shd.Lead__c).add(shd);
            }else{
                List<Stakeholder_Details__c> newSHDetails = new List<Stakeholder_Details__c> ();
                newSHDetails.add(shd);
                stakeholderRecordsbyLeadId.put(shd.Lead__c,newSHDetails);
            }
        }
        for(Lead__c leadRec : leadAudtiDetails){
            leadDetailsbyLeadId.put(leadRec.Id,leadRec);
        }
        
        
        for(String leadId : stakeholderRecordsbyLeadId.keySet()){
            
            for(string emailRec : emailIdsByName.keyset()){
                system.debug('emailRec==>'+emailRec);
                body = body.replace('Hi','Hi '+emailRec + ',' +'<br/>');
                body = '<br/>' + body.replace('{!Lead__c.Audit_Date__c}',+string.valueOf(leadDetailsbyLeadId.get(leadId).Audit_Date__c)+'<br/>');
                body = body.replace('{!Lead__c.Audit_Time__c}',string.valueOf(leadDetailsbyLeadId.get(leadId).Audit_Time__c)+'<br/>');
                body = body.replace('{!Lead__c.Audit_Location__c}',string.valueOf(leadDetailsbyLeadId.get(leadId).Audit_Location__c)+'<br/>');
                body = body.replace('{!Lead__c.Audit_Notes__c}',string.valueOf(leadDetailsbyLeadId.get(leadId).Audit_Notes__c)+'<br/>' +'<br/>');
                body = body.stripHtmlTags();
              //  sendMOMEmail(emailIdsByName.get(emailRec),'Audit Details',body);
            }
            
        }
        system.debug('emailIdsByName==>'+emailIdsByName);
    }
    

    // Method to Send Audit Details to the Stack Holder Contacts
    @AurAEnabled 
    public static string sendAduitDetailsToStackHolderEmail(String recordId){
        System.debug('recordId == >'+recordId);
        try{
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            EmailTemplate temp = [SELECT Id,Subject,Body,HTMLValue FROM EmailTemplate WHERE Name ='Audit Details Template New'];
            Lead__c leadRec = new Lead__c();
            List<Stakeholder_Details__c> stacHolderList = new List<Stakeholder_Details__c>();
            List<Messaging.SendEmailResult> sendEmailResults = new List<Messaging.SendEmailResult>();
            List<String> toAddresses = new List<String>();
            if(recordId !=null){
                String htmlBody = temp.HTMLValue;
                String subject = temp.Subject;
                String plainTextBody = temp.body;

                leadRec = [SELECT Id,Name ,Audit_Date__c,Audit_Location__c,Audit_Notes__c,Audit_Time__c,Lead_Status__c FROM Lead__c WHERE Id=:recordId];
                System.debug('leadRec == >'+leadRec);
                if(leadRec !=null){
                    stacHolderList = [SELECT Id,Name , Name__c,Email__c,Lead__c,Active__c  FROM Stakeholder_Details__c WHERE Lead__c=:leadRec.id AND Active__c = true];
                    System.debug('stacHolderList == >'+stacHolderList);
                    if(stacHolderList.size()>0){
                      for(Stakeholder_Details__c stack : stacHolderList){
                            if(stack.Email__c !=null){
                                toAddresses.add(stack.Email__c);
                            }
                      }
                      System.debug('toAddresses === >'+toAddresses);
                      htmlBody = htmlBody.replace('{!Lead__c.Audit_Date__c}', String.valueOf(leadRec.Audit_Date__c));
                      plainTextBody = plainTextBody.replace('{!Lead__c.Audit_Date__c}', String.valueOf(leadRec.Audit_Date__c));

                      Datetime combinedDateTime = Datetime.newInstance(leadRec.Audit_Date__c, leadRec.Audit_Time__c);
                        System.debug('combinedDateTime Time: ' + combinedDateTime);


                        //DateTime dt = Datetime.now();
                        String strTimeInAMorPM = combinedDateTime.format('hh:mm:ss a');
                        System.debug('time in am and pm ==> '+strTimeInAMorPM); 

                      htmlBody = htmlBody.replace('{!Lead__c.Audit_Time__c}', String.valueOf(strTimeInAMorPM));
                      plainTextBody = plainTextBody.replace('{!Lead__c.Audit_Time__c}', String.valueOf(strTimeInAMorPM));

                      htmlBody = htmlBody.replace('{!Lead__c.Audit_Location__c}', String.valueOf(leadRec.Audit_Location__c));
                      plainTextBody = plainTextBody.replace('{!Lead__c.Audit_Location__c}', String.valueOf(leadRec.Audit_Location__c));
                      htmlBody = htmlBody.replace('{!Lead__c.Audit_Notes__c}', String.valueOf(leadRec.Audit_Notes__c));
                      plainTextBody = plainTextBody.replace('{!Lead__c.Audit_Notes__c}', String.valueOf(leadRec.Audit_Notes__c));
                      Messaging.SingleEmailMessage mailTemp = new Messaging.SingleEmailMessage();
                      mailTemp.setHtmlBody(htmlBody);
                      mailTemp.setSubject(temp.subject);
                      mailTemp.setPlainTextBody(plainTextBody);
                      mailTemp.setToAddresses(toAddresses);
                      mailList.add(mailTemp);
                      if(!mailList.isEmpty()){
                        sendEmailResults = Messaging.sendEmail(mailList);
                        System.debug(' Result === >'+sendEmailResults[0].isSuccess());
                        if(sendEmailResults[0].isSuccess()){
                            leadRec.Lead_Status__c = 'Audit';
                            update leadRec;
                            System.debug('leadRec Audit Update == >'+leadRec);
                            return 'SUCCESS';
                        }else{
                            return 'FAILURE';
                        }
                    }
                    }else{
                        return 'Please add Stack Holder Details';
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
      return null;
    }
}