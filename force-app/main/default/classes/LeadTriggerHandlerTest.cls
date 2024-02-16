@isTest
public class LeadTriggerHandlerTest {
    @isTest
    static void testLeadRSMAssignment() {
        
        List<Lead__c> ldList = new List<Lead__c>();
        Map<Id,Lead__c> ldMap = new Map<Id,Lead__c>();
        
         List<Lead__c> convertldList = new List<Lead__c>();
        Map<Id,Lead__c> convertldMap = new Map<Id,Lead__c>();
        
        Profile salesUserProfile = [SELECT Id FROM Profile WHERE Name = 'RSM' LIMIT 1];
        User salesUser = new User(
            ProfileId = salesUserProfile.Id,
            Username = 'salesuser222@test.com',
            Email = 'salesuser@test.com',
            FirstName = 'Sales',
            LastName = 'User',
            Alias = 'suser',
            Region__c = 'North',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert salesUser;
        
        Lead__c ldRec = UtilityTest.createLeadRec('Test', 'Nano', 'Maruti Suzuki', 'North', 'testnano@gmail.com', 'Food Service');
        Lead__c ld = new Lead__c();
        ld.Id = ldRec.Id;
        ld.Region__c = 'South';
        ld.Lead_Status__c = 'Audit';
        ld.Audit_Date__c = Date.newInstance(2024,2,28);
        ld.Audit_Location__c = 'Mumbai';
        ld.Audit_Notes__c = 'Test Notes';
        ld.Audit_Time__c =Time.newInstance(3, 14, 15, 926);
        ld.Audited__c = true;
        update ld;
        ldMap.put(ldRec.Id,ldRec);
        ldList.add(ld);
        
        Lead__c ldRec1 = UtilityTest.createLeadRec('Test', 'Audi', 'Audi test', 'North', 'testnano@gmail.com', 'Food Service');
        Lead__c ld1 = new Lead__c();
        ld1.Id = ldRec1.Id;
        ld1.Region__c = 'South';
        ld1.Lead_Status__c = 'Audit';
        ld1.IsConverted__c = true;
        ld1.Audit_Date__c = Date.newInstance(2024,2,28);
        ld1.Audit_Location__c = 'Mumbai';
        ld1.Audit_Notes__c = 'Test Notes';
        ld1.Audit_Time__c =Time.newInstance(3, 14, 15, 926);
        ld1.Audited__c = true;
        update ld1;
        convertldMap.put(ldRec1.Id,ldRec1);
        convertldList.add(ld1);
        
        Account accRec = UtilityTest.createAccRec('TestName');
        
        Enquiry_Contact_Details__c ecd = new Enquiry_Contact_Details__c();
        ecd.First_Name__c = 'Test ecd';
        ecd.Last_Name__c = 'Testy Dummy';
        ecd.Email__c = 'Test@gmail.com';
        ecd.Account__c = accRec.Id;
        ecd.Lead__c = ldRec.Id;
        insert ecd;
        
         Enquiry_Contact_Details__c ecd1 = new Enquiry_Contact_Details__c();
        ecd1.First_Name__c = 'Test ecd1';
        ecd1.Last_Name__c = 'Testy Dummy';
        ecd1.Email__c = 'Test@gmail.com';
        ecd1.Account__c = accRec.Id;
        ecd1.Lead__c = ldRec1.Id;
        insert ecd1;
        
        
        Task__c tkRec = new Task__c();
        tkRec.Lead__c = ldRec.Id;
        tkRec.Subject__c ='Send Quote Letter';
        tkRec.Assigned_To__c = salesUser.Id;
        tkRec.OwnerId = salesUser.Id;
        tkRec.Status__c = 'Open';
        insert tkRec;
        
        LeadTriggerHandler.leadRSMAssignment(ldList);
        LeadTriggerHandler.onAfterInsertLead(ldMap);
        LeadTriggerHandler ldhandler = new LeadTriggerHandler();
          ldhandler.onAfterUpdate(ldList, ldMap);
        LeadTriggerHandler.tagEnquiryContactDetails(convertldList, convertldMap);
        LeadTriggerHandler.updateTaskStatus(ldList, ldMap);
        LeadTriggerHandler.updateRelatedTaskOwnersOnLeadOwnerChange(ldList, ldMap);
        LeadTriggerHandler.validateLeadConversion(ldList, ldMap);
        LeadTriggerHandler.sendEmailtoStakeHolders(ldList, ldMap);
            
            }
}