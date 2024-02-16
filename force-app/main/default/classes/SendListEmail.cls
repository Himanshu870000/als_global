public class SendListEmail {
    public List<Lead__c> SelLeadLst;
    public String LeadIds;
    
    public SendListEmail(ApexPages.StandardSetController cntlr){
        SelLeadLst = cntlr.getSelected(); //get selected records from account list view
        LeadIds = '';  
        for(Lead__c con : SelLeadLst){
            LeadIds += con.Id + ','; //build list of ids string concatenated with comma                         
        }
        LeadIds = LeadIds.removeEnd(','); 
        System.debug('LeadIds === >'+LeadIds);
    }
    
    public PageReference redirectToLComp(){
        String returnUrl = '/lightning/cmp/c__SendListEmailComp?c__listofContacts='+LeadIds;
        PageReference pgReturnPage = new PageReference(returnUrl);
        System.debug('pgReturnPage === >'+pgReturnPage);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
    
    
    // Apex Class Controller
    @AuraEnabled
    public Static List<Lead__c> LeadsToSendEmail(List<String> LeadsIds){
        try{
            
            List<String> lstString = LeadsIds[0].split(',');
            
            System.debug('lstString ===>:'+lstString);
            List<Lead__c> getLeadWithEmail = [SELECT Id,Email__c,Name FROM Lead__c WHERE ID IN: lstString];
            //  System.debug('getLeadWithEmail ::'+getLeadWithEmail);
            EmailTemplate temp = [Select id, Subject, Body  From EmailTemplate Where Name = 'Testing Email'];
            List<Messaging.SingleEmailMessage> EmailList = new List<Messaging.SingleEmailMessage>();
            
            String subject = temp.Subject;
            String plainTextBody = temp.Body;
            for(Lead__c con : getLeadWithEmail){
                String htmlBody = temp.Body;
              //  htmlBody = htmlBody.replace('{!Lead__c.Name}', con.Name);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setUseSignature(false);
                mail.setHtmlBody(htmlBody);
                mail.setSubject(subject);
                mail.setPlainTextBody(plainTextBody);
                mail.setToAddresses(new String[] {con.Email__c});
                EmailList.add(mail);
            }
            if(!EmailList.isEmpty()){
                Messaging.sendEmail(EmailList);
            }
            return getLeadWithEmail;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
}