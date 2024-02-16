@isTest
public class TestSendMOMfromLeadController {
    
    @isTest
    static void testGetContacts() {
        Lead__c testLead = new Lead__c(First_Name__c = 'Test', Name = 'Lead', Company__c = 'Test Company', Company_Type__c = 'Manufacturer',
                                      Email__c = 'test.lead@example.com', Vertical_Segment__c = 'Pharma', Industry_Verticle__c = 'Pharma',
                                      RSM__c = UserInfo.getUserId());
        insert testLead;
        
        Enquiry_Contact_Details__c testContact = new Enquiry_Contact_Details__c(
            First_Name__c = 'Test',
            Last_Name__c = 'Contact',
            Lead__c = testLead.Id
        );
        insert testContact;
       
        List<Enquiry_Contact_Details__c> resultContacts = SendMOMfromLeadController.getContacts(testLead.Id);
     
    }
    
    @isTest
    static void testGetRelatedTaskMOM() {
        
        Lead__c testLead = new Lead__c(First_Name__c = 'Test', Name = 'Lead1', Company__c = 'Test Company1', Company_Type__c = 'Manufacturer',
                                      Email__c = 'test.lead1@example.com', Vertical_Segment__c = 'Pharma', Industry_Verticle__c = 'Pharma',
                                      RSM__c = UserInfo.getUserId());
        insert testLead;
        
        Task__c testTask = new Task__c(
            Lead__c = testLead.Id,
            Subject__c = 'Meeting With Customer',
            Status__c = 'Open',
            MOM__c = 'Sample Meeting Notes'
        );
        insert testTask;
        
        Task__c resultTask = SendMOMfromLeadController.getRelatedTaskMOM(testLead.Id);
       
    }
    
    @isTest
    static void testSendEmailToSelectedContacts() {
          
        Lead__c testLead = new Lead__c(First_Name__c = 'Test', Name = 'Lead2', Company__c = 'Test Company2', Company_Type__c = 'Manufacturer',
                                      Email__c = 'test.lead2@example.com', Vertical_Segment__c = 'Pharma', Industry_Verticle__c = 'Pharma',
                                      RSM__c = UserInfo.getUserId());
        
        Enquiry_Contact_Details__c testContact1 = new Enquiry_Contact_Details__c(
            First_Name__c = 'Test',
            Last_Name__c = 'Contact1',
            Email__c = 'contact1@example.com',
            Lead__c = testLead.Id
        );
        insert testContact1;
        
        Enquiry_Contact_Details__c testContact2 = new Enquiry_Contact_Details__c(
            First_Name__c = 'Test',
            Last_Name__c = 'Contact2',
            Email__c = 'contact2@example.com',
            Lead__c = testLead.Id
        );
        insert testContact2;
        
        Test.startTest();
        EmailTemplate emailTemplate = new EmailTemplate(
            Name = 'MOM Email Template',
            Body = 'Hi {!Enquiry_Contact_Details__c.First_Name__c}, Meeting Notes: {!Task__c.MOM__c}'
        );
        insert emailTemplate;
        Test.stopTest();
        
        List<String> selectedContactIds = new List<String>{testContact1.Id, testContact2.Id};
            SendMOMfromLeadController.sendEmailToSelectedContacts(selectedContactIds, 'Test Meeting Notes');
     
    }
    
    @isTest
    static void testSendMOMEmail() {
        
        Lead__c testLead = new Lead__c(First_Name__c = 'Test', Name = 'Lead3', Company__c = 'Test Company3', Company_Type__c = 'Manufacturer',
                                      Email__c = 'test.lead3@example.com', Vertical_Segment__c = 'Pharma', Industry_Verticle__c = 'Pharma',
                                      RSM__c = UserInfo.getUserId());
        insert testLead;
        
        Enquiry_Contact_Details__c testContact = new Enquiry_Contact_Details__c(
            First_Name__c = 'Test',
            Last_Name__c = 'Contact3',
            Email__c = 'contact3@example.com',
            Lead__c = testLead.Id
        );
        insert testContact;
        
        Boolean result = SendMOMfromLeadController.sendMOMEmail(testContact.Email__c, 'Test Subject', 'Test Body');
        
    }
    
    @isTest
    static void testUpdateTaskStatus() {
       
         Lead__c testLead = new Lead__c(First_Name__c = 'Test', Name = 'Lead4', Company__c = 'Test Company4', Company_Type__c = 'Manufacturer',
                                      Email__c = 'test.lea4d@example.com', Vertical_Segment__c = 'Pharma', Industry_Verticle__c = 'Pharma',
                                      RSM__c = UserInfo.getUserId());
        insert testLead;
        
        Task__c testTask = new Task__c(
            Lead__c = testLead.Id,
            Subject__c = 'Meeting With Customer',
            Status__c = 'Open'
        );
        insert testTask;
       
        SendMOMfromLeadController.updateTaskStatus(testTask.Id, 'Completed');
        
        Task__c updatedTask = [SELECT Id, Status__c FROM Task__c WHERE Id = :testTask.Id LIMIT 1];
        
    }
    
}