global class EmailServiceInbound implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
          String threadId 					= null;
        Id leadId 							= null;
        boolean existingThreadCheck 		= false;
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        
        
        if(email.inReplyTo == null && email.messageId != null){
            threadId = email.messageId;
        }else{
            threadId = email.inReplyTo;
        }
        
        if(threadId != null){
            Lead leadRecordTobeInsert = new Lead();
            
            try{
                List<Lead> leadRecord = [SELECT Id FROM Lead WHERE Email_Thread_Id__c = :threadId Limit 1];
                leadId = leadRecord[0].Id;
                system.debug('leadRecord--'+leadRecord);
                if(leadRecord[0].Id != null){
                    existingThreadCheck = true;
                }
            }catch(exception e){
                existingThreadCheck = false;
            }
            system.debug('existingThreadCheck--'+existingThreadCheck);
            system.debug('threadId--'+threadId); 
            if(existingThreadCheck==false){
                leadRecordTobeInsert.Email = email.FromAddress;
                leadRecordTobeInsert.FirstName =  '';
                leadRecordTobeInsert.LastName = email.FromName;
                leadRecordTobeInsert.company = email.subject;
                leadRecordTobeInsert.Email_Thread_Id__c = threadId;
                insert leadRecordTobeInsert;
                system.debug('leadRecordTobeInsert--'+leadRecordTobeInsert);
            }
            
            
            
            EmailMessage conEmailMessage = new EmailMessage();
            if(existingThreadCheck==false){
                conEmailMessage.Lead__c = leadRecordTobeInsert.Id;
            }else{
                conEmailMessage.Lead__c = leadId;
            } 
            conEmailMessage.ToAddress =  String.join(email.toAddresses, ',');
            conEmailMessage.FromAddress = email.FromAddress;
            conEmailMessage.FromName = email.FromName;
            conEmailMessage.Subject = email.subject;
            conEmailMessage.status = '2';
            conEmailMessage.HtmlBody = email.htmlBody;
            conEmailMessage.Incoming= True;
            conEmailMessage.TextBody = email.plainTextBody;
            insert conEmailMessage;
            
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.EmailMessageId = conEmailMessage.id;
            if(!existingThreadCheck){
                emr.RelationId = leadRecordTobeInsert.Id;
            }else{
                emr.RelationId = leadId;
            }
            emr.RelationAddress = email.FromAddress;
            emr.RelationType = 'FromAddress';
            insert emr;
        }
        return result; 
    }
}