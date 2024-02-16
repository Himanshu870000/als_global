@isTest
public class CertificationPDFHelperTest {

    @isTest
    static void testGenerateSelectedCertificationPDF() {
		User useRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar',accRec.id,System.today(),useRec.id,'New','South');
        Quote_C__c quotRec = new Quote_C__c(Name = 'Testing',OpportunityId__c =oppRec.id);
        insert quotRec;

        CertificationPDFHelper controller = new CertificationPDFHelper(new ApexPages.StandardController(quotRec));
        String result = CertificationPDFHelper.generateSelectedCertificationPDF('Training Template Certificate', quotRec.Id);  
        String resultA = CertificationPDFHelper.generateSelectedCertificationPDF('Certificate Template', quotRec.Id); 
        String resultB = CertificationPDFHelper.generateSelectedCertificationPDF('Hygiene Audit Certificate', quotRec.Id);  
    }

    @isTest
    static void testConstructor() {
        
        User useRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar',accRec.id,System.today(),useRec.id,'New','South');
        Quote_C__c quotRec = new Quote_C__c(Name = 'Testing',OpportunityId__c =oppRec.id);
        insert quotRec;

        CertificationPDFHelper controller = new CertificationPDFHelper(new ApexPages.StandardController(quotRec));
        

        
      
       
    }

    
}