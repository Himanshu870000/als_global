@isTest
public class ALS_Quote_pdf_controllerTest {
     @isTest static void testALSQuotePdfController() {
         
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
               
        Opportunity1__c opp1 = new Opportunity1__c();
        opp1.Name = 'Test';
        opp1.StageName__c = 'New';
        opp1.CloseDate__c = system.today();
        opp1.Region__c = 'West';
        Opp1.AccountId__c = acc.Id;
        Insert opp1;
                
      Quote_C__c quoRec = new Quote_C__c();
        quoRec.Name = 'Test';
         quoRec.OpportunityId__c = opp1.Id;
        insert quoRec;
         
        ApexPages.StandardController sc = new ApexPages.StandardController(quoRec);
        PageReference pageRef = Page.ALS_Mumbai_In_Vitro; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(quoRec.Id));
        Test.setCurrentPage(pageRef);
         
        Test.startTest();
         
          ALS_Quote_pdf_controller pdf1 = new ALS_Quote_pdf_controller(sc);
         
        Test.stopTest();

     }

}