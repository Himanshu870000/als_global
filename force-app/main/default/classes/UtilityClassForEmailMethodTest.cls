@isTest
public class UtilityClassForEmailMethodTest {

    @isTest
    Static void UtilityClassForEmailMethodTestMethod(){
        List<Id> leadId = new List<Id>();
        List<Id> ECDId = new List<Id>();
        map<id,String> enqMap = new map<id,String>(); 
        map<id,String> leadMap = new map<id,String>();
        
        User useRec = UtilityTest.createUserCustomService();
        Lead__c l = new Lead__c();
        l.First_Name__c = 'Test';
        l.Name = 'Lead';
        l.OwnerId = useRec.Id;
        l.Company__c = 'Util';
        l.Email__c = 'utillabs@gmail.com';
        l.Vertical_Segment__c = 'Pharma';
        l.Region__c = 'North';
        l.Audit_Date__c = Date.newInstance(2024, 01, 31);
        l.Audit_Location__c = 'Mumbai';
        l.Audit_Notes__c = 'Test Notes';
        l.Audit_Time__c = Time.newInstance(12,5,2,7);
        l.Audited__c = true;
        Insert l;
        leadId.add(l.Id);
        leadMap.put(l.Id, l.Name);
        
        Enquiry_Contact_Details__c ecdRec = new Enquiry_Contact_Details__c();
        ecdRec.First_Name__c = 'Test';
        ecdRec.Last_Name__c = 'Enquiry';
        ecdRec.Email__c = 'utillabs@gmail.com';
        ecdRec.Lead__c = l.Id;
        Insert ecdRec;
        ECDId.add(ecdRec.Id);
        enqMap.put(ecdRec.Id, ecdRec.First_Name__c);
        
        Stakeholder_Details__c stkRec = new Stakeholder_Details__c();
        stkRec.Name__c = 'Testing Holder';
        stkRec.Email__c = 'util@gmail.com';
        stkRec.Lead__c = l.Id ;
        stkRec.Active__c = true;
        Insert stkRec;
        
        UtilityClassForEmailMethod.getECDLeadDetails(leadMap);
        UtilityClassForEmailMethod.getStakeHolderDetails(leadId);
        UtilityClassForEmailMethod.sendMOMEmail('util@gmail.com', 'Testing', 'Sending from Lead');
    }
}