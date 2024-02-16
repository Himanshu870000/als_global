@isTest
public class SendMOMfromLeadControllerTest {

    @isTest
    Static Void SendMOMfromLeadTestMethod(){
        List<String> leadId = new List<String>();
        List<String> ECDId = new List<String>();
        List<String> tskId = new List<String>();
        List<String> conId = new List<String>();
        
        Lead__c l = new Lead__c();
        l.First_Name__c = 'Test';
        l.Name = 'Lead';
        l.Company__c = 'Util';
        l.Email__c = 'utillabs@gmail.com';
        l.Vertical_Segment__c = 'Pharma';
        l.Region__c = 'North';
        Insert l;
        leadId.add(l.Id);

        contact conRec = new contact();
        conRec.FirstName = 'Test';
        conRec.LastName = 'Contact';
        conRec.Email = 'utillabs@gmail.com';
        Insert conRec;
        conId.add(conRec.Id);
        
        Enquiry_Contact_Details__c ecdRec = new Enquiry_Contact_Details__c();
        ecdRec.First_Name__c = 'Test';
        ecdRec.Last_Name__c = 'Enquiry';
        ecdRec.Email__c = 'utillabs@gmail.com';
        ecdRec.Lead__c = l.Id;
        Insert ecdRec;
        ECDId.add(ecdRec.Id);

        Task__c ts = new Task__c();
        ts.Status__c = 'Open';
        ts.Subject__c = 'First Touch With Customer';
        ts.MOM__c = 'Testing MOM from';
        Insert ts;
        tskId.add(ts.Id);

        SendMOMfromLeadController.getContacts(l.Id);
        SendMOMfromLeadController.getRelatedTaskMOM(l.Id);
        SendMOMfromLeadController.sendEmailToSelectedContacts(leadId, 'For Testing Purpose from Lead');
        SendMOMfromLeadController.sendEmailToSelectedContacts(ECDId, 'For Testing Purpose from Lead');
        SendMOMfromLeadController.updateTaskStatus(ts.Id, 'Completed');

        
    }
}