/**
 * @author [Dinesh B]
 * @email dinesh.b@utilitarianLab.com
 * @create date 2023-12-27 18:22:14
 * @modify date 2023-12-27 18:22:14
 * @desc [description]
 */

public with sharing class EamilUtilityClass {
   
    // Method for Sending Email on Lead Creation to Lead Email
    public Static void SendEmailOnLeadCreation(List<Lead__c> leadList){
        System.debug('leadList:::::::>'+leadList);
        try{
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            EmailTemplate temp = [SELECT Id,Subject,Body,HTMLValue FROM EmailTemplate WHERE Name ='Lead Creation Email'];
             String str = temp.Body;
             String body = temp.body;
            for(Lead__c led : leadList){
                if(led.Email__c !=null){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setHtmlBody(str);
                    mail.setSubject(temp.Subject);
                    mail.setPlainTextBody(body);
                    mail.toAddresses = new String[] {led.Email__c};
                    mailList.add(mail);
               }
            }
            if(!mailList.isEmpty())
                Messaging.sendEmail(mailList);
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
    }
}