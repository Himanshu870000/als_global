/**
* @author [Dinesh B]
* @email dinesh.b@utilitarianLab.com
* @create date 2024-01-17 17:58:24
* @modify date 2024-01-17 17:58:24
* @desc [Method for Creating 3 Certificate Data in PDF]
*/

public with sharing class CertificationPDFHelper {
    public Quote_C__c quote { get; set; }
    public List<QuoteLineItems_c__c> quoteLineItems { get; set; }
    public List<QuoteLineItems_c__c> quoteLineItemsList { get; set; }
    //public Opportunity_Contact_Role1__c getOppContactDetails {get;set;}
    public Quote_C__c getOppContactDetails {get;set;}
    
    public Decimal totalAmount { get; set; }
    public String totalAmountWords { get; set; }
    public String totalAmountWordswithoutGst { get; set; }
    public Decimal discountPercentage { get; set; }
    private static final Decimal FIXED_GST_PERCENTAGE = 18;
    public Decimal gstPercentage { get; set; }
    public Decimal discountAmount { get; set; }
    public Decimal gstAmount { get; set; }
    public Decimal grandTotal { get; set; }
    public Decimal grandTotalWithouGSTAndDiscount { get; set; }
    public Decimal grandTotalwithoutdiscount { get; set; }
    Public static Fees_and_Payment__mdt feesandpayment { get; set; }
    public static Fees_And_Payment_Cert_Temp__mdt getFeesPaymentCertTemp {get;set;}
    Public static General_Terms_and_Condition__mdt genrealterms { get; set; }
    public static Information__mdt information { get; set; }
    public static Bank_Details__mdt BankDetails { get; set; }
    public Static ALS_Limited_Terms_Conditions__mdt ALSTermsandConditions { get; set; }
    public static Information_Cert_1__mdt certificationInfo { get; set; }
    public static General_Terms_and_Conditions_cert_1__mdt generalTerms { get; set; }
    public static Terms_and_Conditions_cert1__mdt termsAndConditions { get; set; }
    public static ACKNOWLEDGEMENT__mdt acknowledgement { get; set; }
    
    //Meta deta for Mumbai Pharma 
    public static ABOUT_US_Mumbai_Pharma__mdt ABOUTUS { get; set; }
    public static Mumbai_Pharma_In_Vitro_BE__mdt vitro {get; set;}
    public static Mumbai_pharma_Notes_and_terms__mdt NotesandTerms {get; set;}
    
    // Meta Data for Certification Template
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermTempGeneral {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermTempDefination {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermTempScopeofServices {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermTempConfidentiality {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermTempObligationsbyClient {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermTempLiabilityandLimitation {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermTempIndemnity {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermForceMajeure {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermArbitrationJurisdiction {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermExpirationofContract  {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermTerminationbyClient {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermTerminationbyALSIndiaCT {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermInvoicingandPayment {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermREFUNDANDCANCELLATIONS {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermACKNOWLEDGEMENT1 {get;set;}
    public General_TC_of_Term_and_Temp__mdt GeneralTCTermACKNOWLEDGEMENT2 {get;set;}
    
    // Meta data for Trainig Temp
    public Training_Template_TC__mdt trainibTempTC {get;set;}
    
    // Meta data TC 1 HygeinceHygiene_TC_1__mdt TcHygeince
    public Hygiene_TC_1__mdt TcHygeinceGeneral {get;set;}
    public Hygiene_TC_1__mdt TcHygeinceDefinitions {get;set;}
    public Hygiene_TC_1__mdt TcHygeinceScopeofService {get;set;}
    public Hygiene_TC_1__mdt TcHygeinceConfidentiality {get;set;}
    public Hygiene_TC_1__mdt TcHygeinceObligationsbyClient {get;set;}
    public Hygiene_TC_1__mdt TcHygeinceLiabilityandLimitation {get;set;}
    public Hygiene_TC_1__mdt TcHygeinceIndemnity {get;set;}
    public Hygiene_TC_1__mdt TcHygeinceForceMajeure {get;set;}
    public Hygiene_TC_1__mdt TcHygeinceArbitrationJurisdiction {get;set;}
    public Hygiene_TC_1__mdt TcHygeinceExpirationofContract {get;set;}
    
    public Hygiene_TC_1__mdt TcHygeinceTermination {get;set;}
    public Hygiene_TC_1__mdt TcHygeinceInvoicingandPayment {get;set;}
    public Hygiene_TC_1__mdt TcHygeinceREFUNDANDCANCELLATIONS {get;set;}
    public Hygiene_TC_1__mdt TcHygeinceACKNOWLEDGEMENT {get;set;}
    
    // Meta data TC 2 Hygiene_TC_2__mdt 
    public Hygiene_TC_2__mdt TCHygiene_TC_2 {get;set;}
    
    public CertificationPDFHelper(ApexPages.StandardController controller) {
        if(controller.getId()!=null){
            quote = [SELECT Id, Quote_Name__c,Address_of_unit_to_be_covered_for_conduc__c,Category_of_FBO__c,Subject__c,Audit_Scheme__c,Area_Of_The_Units_To_Be_Audited__c,Scope_of_Audit__c,Total_sites_to_be_covered__c,Type_of_Audit__c,Total_Effective_employees_as_stated_in_E__c,AccountId__r.Owner.Manager.Name, Include_GST__c,Contact_Email__c,Contact_Phone__c, OpportunityId__c, OpportunityId__r.CreatedBy.Name,OpportunityId__r.CreatedBy.MobilePhone,OpportunityId__r.Billing_Address__Street__s,OpportunityId__r.Billing_Address__City__s,OpportunityId__r.Billing_Address__PostalCode__s,OpportunityId__r.Billing_Address__StateCode__s,OpportunityId__r.Billing_Address__CountryCode__s,AccountId__r.Name, Include_Discount__c, CreatedDate, Quote_Validity__c, Discount__c, Sample_quantity__c, TAT__c, Note__c, Comment__c, Name, Email__c, ContactId__r.Name, ContactId__r.Phone, ContactId__r.Email, ContactId__r.Owner.Name,
                     (SELECT Quantity__c, Name, List_Price__c,Sales_Price__c ,Subtotal__c, Total_Price__c, ProductId__r.Name,ProductId__r.ProductCode__c,Test_Method__c,Product_Code__c FROM QuoteLineItems__r where Family__c='Certification') FROM Quote_C__c WHERE Id = :controller.getId()];
            Decimal total = 0;
            if (quote != null) {
                quoteLineItems = quote.QuoteLineItems__r;
            }
            
            if (quoteLineItems != null && !quoteLineItems.isEmpty()) {
                for (QuoteLineItems_c__c item : quoteLineItems) {
                    if (item.Subtotal__c != null) {
                        total += item.Subtotal__c;
                    }
                }
            }
            
            totalAmount = total;
            if(quote.Include_Discount__c == false  && quote.Include_GST__c == false ) {
                grandTotalWithouGSTAndDiscount = totalAmount;
            }
            system.debug('totalAmount === >'+totalAmount);  
            
            if(quote.OpportunityId__c !=null){
                //getOppContactDetails = [SELECT Id,Name,Opportunity1__c,Contact__c,IsPrimary__c,Contact__r.Name,Contact__r.Phone,Contact__r.MobilePhone,Contact__r.Email,Contact__r.MailingStreet,Contact__r.MailingCity,Contact__r.MailingState,Contact__r.MailingPostalCode,Contact__r.MailingCountry FROM Opportunity_Contact_Role1__c WHERE Opportunity1__c =:quote.OpportunityId__c AND IsPrimary__c = true LIMIT 1];
                //List<Quote_C__c> qtRec  = [SELECT Id,Name,OpportunityId__c,ContactId__c,ContactId__r.Name,ContactId__r.Phone,ContactId__r.MobilePhone,ContactId__r.Email,ContactId__r.MailingStreet,ContactId__r.MailingCity,ContactId__r.MailingState,ContactId__r.MailingPostalCode,ContactId__r.MailingCountry FROM Quote_C__c WHERE OpportunityId__c =:quote.OpportunityId__c AND Primary__c = true LIMIT 1];
                List<Quote_C__c> qtRec  = [SELECT Id,Name,OpportunityId__c,ContactId__c,ContactId__r.Name,ContactId__r.Phone,ContactId__r.MobilePhone,ContactId__r.Email,ContactId__r.Billing_Address__Street__s,ContactId__r.Billing_Address__City__s,ContactId__r.Billing_Address__StateCode__s,ContactId__r.Billing_Address__PostalCode__s,ContactId__r.Billing_Address__CountryCode__s FROM Quote_C__c WHERE OpportunityId__c =:quote.OpportunityId__c AND Primary__c = true LIMIT 1];
                if(qtRec.size()>0){
                    getOppContactDetails=qtRec[0];
                }else{
                    System.debug('please add Primary Quote');
                }
                
            }
            
            GeneralTCTermTempGeneral = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'General' LIMIT 1];
            GeneralTCTermTempDefination = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'Definitions' LIMIT 1];
            GeneralTCTermTempScopeofServices = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'Scope of Services' LIMIT 1];
            GeneralTCTermTempConfidentiality = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'Confidentiality' LIMIT 1];
            GeneralTCTermTempObligationsbyClient = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'Obligations by Client' LIMIT 1];
            GeneralTCTermTempLiabilityandLimitation = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'Liability and Limitation' LIMIT 1];
            GeneralTCTermTempIndemnity = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'Indemnity' LIMIT 1];
            GeneralTCTermForceMajeure = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'Force Majeure' LIMIT 1];
            GeneralTCTermArbitrationJurisdiction = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'Arbitration / Jurisdiction' LIMIT 1];
            GeneralTCTermExpirationofContract = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'Expiration of Contract' LIMIT 1];
            GeneralTCTermTerminationbyClient = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'Termination by Client' LIMIT 1];
            GeneralTCTermTerminationbyALSIndiaCT = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'Termination by ALS India CT' LIMIT 1];
            GeneralTCTermInvoicingandPayment = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'Invoicing and Payment' LIMIT 1];
            GeneralTCTermREFUNDANDCANCELLATIONS = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'REFUND AND CANCELLATIONS' LIMIT 1];
            GeneralTCTermACKNOWLEDGEMENT1 = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'ACKNOWLEDGEMENT' LIMIT 1];
            GeneralTCTermACKNOWLEDGEMENT2 = [SELECT Id,MasterLabel,General__c FROM General_TC_of_Term_and_Temp__mdt WHERE MasterLabel= 'ACKNOWLEDGEMENT 2' LIMIT 1];
            
            TcHygeinceGeneral = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '1. General' LIMIT 1];
            TcHygeinceDefinitions = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '2. Definitions' LIMIT 1];
            TcHygeinceScopeofService = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '3. Scope of Services' LIMIT 1];
            TcHygeinceConfidentiality = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '4. Confidentiality' LIMIT 1];
            TcHygeinceObligationsbyClient = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '5. Obligations by Client' LIMIT 1];
            
            TcHygeinceLiabilityandLimitation = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '6. Liability and Limitation' LIMIT 1];
            TcHygeinceIndemnity = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '7. Indemnity' LIMIT 1];
            TcHygeinceForceMajeure = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '8. Force Majeure' LIMIT 1];
            TcHygeinceArbitrationJurisdiction = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '9. Arbitration / Jurisdiction' LIMIT 1];
            TcHygeinceExpirationofContract = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '10. Expiration of Contract' LIMIT 1];
            
            TcHygeinceTermination = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '11. Termination' LIMIT 1];
            TcHygeinceInvoicingandPayment = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '12. Invoicing and Payment' LIMIT 1];
            TcHygeinceREFUNDANDCANCELLATIONS = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '13. REFUND AND CANCELLATIONS' LIMIT 1];
            TcHygeinceACKNOWLEDGEMENT = [SELECT Id,MasterLabel,Description__c FROM Hygiene_TC_1__mdt WHERE MasterLabel = '14. ACKNOWLEDGEMENT:' LIMIT 1];
            
            TCHygiene_TC_2 = [SELECT Id,MasterLabel,Term1__c,Term2__c,Term3__c,Term4__c,Term5__c,Term6__c,Term7__c,Term8__c,Term9__c,Term10__c,Term11__c,Term12__c,Term13__c,Term14__c,Term15__c,Term16__c,Term17__c FROM Hygiene_TC_2__mdt LIMIT 1];
            trainibTempTC = [SELECT Id,MasterLabel,Term_1__c,Term_2__c,Term_3__c,Term_4__c,Term_5__c,Term_6__c,Term_7__c,Term_8__c,Term_9__c,Term_10__c,Term_11__c,Term_12__c,Term_13__c,Term_14__c,Term_15__c,Term_16__c,Term_17__c,Term_18__c,Term_19__c,Term_20__c,Term_21__c FROM Training_Template_TC__mdt LIMIT 1];
            getFeesPaymentCertTemp = [SELECT Id,Term1__c,Term2__c,Term3__c,Term4__c,Term5__c,Term6__c,Term7__c,Term8__c,Term9__c,Term10__c,Term11__c,Term12__c,Term13__c,Term14__c,Term15__c FROM Fees_And_Payment_Cert_Temp__mdt LIMIT 1];
            
            // genrealterms = [select Term_1__c, Term_2__c, Term_3__c, Term_4__c, Term_5__c, Term_6__c from General_Terms_and_Condition__mdt limit 1];
            feesandpayment = [select Fees_and_payment_1__c,fees_and_payment_2__c, Fees_and_payment_3__c, Fees_and_payment_4__c, Fees_and_payment_5__c, Fees_and_payment_6__c, Fees_and_payment_7__c from Fees_and_Payment__mdt limit 1];
            BankDetails = [select Name_of_Beneficiary__c, IFSC_Code__c, Branch_Name__c, Bank_Name__c, Bank_Account_Number__c, Bank_Account_Name__c, ALS_GST_number__c, Address__c from Bank_Details__mdt limit 1];
            // ALSTermsandConditions = [select Term_1__c, Term_2__c, Term_3__c, Term_4__c, Term_5__c, Term_6__c, Term_7__c, Term_8__c, Term_9__c, Term_10__c, Term_11__c, Term_12__c, Term_13__c, Term_14__c, Term_15__c,Term_15_1__c,Term_15_2__c,Term_15_3__c, Term_16__c, Term_17__c, Term_18__c,Term_18_1__c,Term_18_2__c,Notes__c from ALS_Limited_Terms_Conditions__mdt limit 1];
            // information = [select Information_1__c, Information_2__c, Information_3__c, Information_4__c, Sample_pick_up_service__c, A_Sample_material_logistics__c, B_Analytical_Investigations_OOS_Devi__c, Health_Safety_and_Environment_Hazardo__c, Documentation__c, Turnaround_time__c, Notes__c from Information__mdt limit 1];
            certificationInfo = [SELECT Id, Information_1__c,Information_Cert_2__c,Information_certification_3__c FROM Information_Cert_1__mdt LIMIT 1];
            // Query for Terms_and_Conditions_cert1__mdt
            termsAndConditions = [SELECT Id, Term_1__c, Term_2__c,Term_2_1__c,Term_2_2__c, Term_3__c, Term_4__c,Term_5__c,Term_6__c,Term_7__c,Term_8__c,Term_9__c,Term_10__c,Term_11__c,Term_12__c,Term_13__c,Term_14__c,Term_15__c  FROM Terms_and_Conditions_cert1__mdt LIMIT 1];
            // Query for General_Terms_and_Conditions_cert_1__mdt
            generalTerms = [SELECT Id, Arbitration_Jurisdiction__c, Confidentiality__c, Definitions__c, Expiration_of_Contract__c, Force_Majeure__c, General__c, indemnity__c, Invoicing_and_Payment1__c, Invoicing_and_Payment2__c, Invoicing_and_Payment3__c, Invoicing_and_Payment4__c, Invoicing_and_Payment5__c, Liability_and_Limitation1__c, Liability_and_Limitation2__c, Obligations_by_Client1__c, Obligations_by_Client10__c, Obligations_by_Client2__c, Obligations_by_Client3__c, Obligations_by_Client4__c, Obligations_by_Client5__c, Obligations_by_Client6__c, Obligations_by_Client7__c, Obligations_by_Client8__c, Obligations_by_Client9__c, REFUND_AND_CANCELLATIONS__c, Scope_of_Services__c, Termination_by_ALS_India_CT__c, Termination_by_Client__c FROM General_Terms_and_Conditions_cert_1__mdt LIMIT 1];
            // Query for ACKNOWLEDGEMENT__mdt
            acknowledgement = [SELECT Id, ACKNOWLEDGEMENT1__c, ACKNOWLEDGEMENT2__c FROM ACKNOWLEDGEMENT__mdt LIMIT 1];
            // Query for for mumbai Pharma
            ABOUTUS = [select About_Us_1__c, About_Us_2__c, About_Us_3__c, About_Us_4__c, About_Us_5__c, About_Us_6__c, About_Us_7__c, Guidelines_FDA__c, Guidelines_ICH__c from ABOUT_US_Mumbai_Pharma__mdt limit 1];
            vitro =[select In_Vitro1__c, In_Vitro_2__c, In_Vitro_3__c, In_Vitro_4__c, In_Vitro_5__c,In_Vitro_5_1__c,In_Vitro_5_2__c,In_Vitro_5_3__c,In_Vitro_5_4__c,In_Vitro_5_5__c,In_Vitro_5_6__c,In_Vitro_5_7__c,In_Vitro_5_8__c,In_Vitro_5_9__c, In_Vitro_6__c, In_Vitro_6_1__c, In_Vitro_6_2__c, In_Vitro_6_3__c,In_Vitro_6_4__c, In_Vitro_6_5__c, In_Vitro_6_6__c, In_Vitro_6_7__c,Scope_1__c,Scope_2__c,Stage_1__c, Stage_2__c,Stage_3__c,Stage_3_1__c,Satge_3_2__c,Stage_4__c  from Mumbai_Pharma_In_Vitro_BE__mdt limit 1];
            NotesandTerms = [select Note_1__c, Note_2__c,Note_3__c, Note_4__c, Note_5__c, Note_6__c, Note_7__c,T_C_1__c,T_C_2__c,T_C_3__c, T_C_4__c,P_T_1__c, P_T_2__c, P_C_1__c, P_C_2__c, P_C_3__c,C_S_1__c,C_S_2__c,Sample_Dispatch_Address__c from  Mumbai_pharma_Notes_and_terms__mdt WHERE DeveloperName = 'Virto' LIMIT 1];
            gstPercentage = FIXED_GST_PERCENTAGE;
            // Fetch Discount and GST values from Quote
            discountPercentage = quote.Discount__c != null ? quote.Discount__c : 0;
            // Calculate Discount Amount and GST Amount
            discountAmount = (discountPercentage / 100) * totalAmount;
            gstAmount = (gstPercentage / 100) * totalAmount;
            Decimal discountedPrice;
            // Calculate Grand Total
            if(quote.Include_GST__c == true && quote.Include_Discount__c == true){
                discountedPrice = totalAmount-discountAmount;
                gstAmount = (FIXED_GST_PERCENTAGE / 100) * discountedPrice;
                grandTotal = discountedPrice + gstAmount;
                // grandTotal = totalAmount - discountAmount + gstAmount;
                totalAmountWords =   NumberToText.convert(Integer.valueOf(grandTotal));
                System.debug('grandTotal === >'+grandTotal);
            }
            else if(quote.Include_GST__c == false || quote.Include_Discount__c == true){
                grandTotal = totalAmount - discountAmount;
                if(grandTotal != null){
                    totalAmountWords = NumberToText.convert(Integer.valueOf(grandTotal));
                }
            }
            else if(quote.Include_Discount__c == false || quote.Include_GST__c == true){
                grandTotal = totalAmount + gstAmount;
                if(grandTotal != null){
                    totalAmountWords = NumberToText.convert(Integer.valueOf(grandTotal));
                }
            }
            else if(quote.Include_Discount__c == false  && quote.Include_GST__c == false ) {
                grandTotal = totalAmount;
                system.debug('Grandtotal===>'+grandTotal);
                totalAmountWords = NumberToText.convert(Integer.valueOf(totalAmount));
            }
        }
    }
    
    // ==================================================================================================================================================================================================================
    // Method for Downloading Selected Certificate
    @AuraEnabled
    public static string generateSelectedCertificationPDF(String CertificateName,string recordId){
        try{
            List<Attachment> attachList = new List<Attachment>();
            if(recordId !=null){
                blob pdfBody;
                string filename;
                Quote_C__c qarec = [SELECT Id,Name FROM Quote_C__c WHERE Id=:recordId];
                if(!String.isBlank(qarec.id) &&  CertificateName != null){
                    
                    if(CertificateName == 'Certificate Template'){
                        PageReference pdfPage = Page.CertificationTemplatePDF;   
                        pdfPage.getParameters().put('id',recordId);
                        pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                        filename = 'Certificate Template';
                    }
                    if(CertificateName == 'Training Template Certificate'){
                        PageReference pdfPage = Page.TrainingTemplateCertificatePDF;   
                        pdfPage.getParameters().put('id',recordId);
                        pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                        filename = 'Training Template Certificate';
                    }
                    if(CertificateName == 'Hygiene Audit Certificate'){
                        PageReference pdfPage = Page.HygieneAuditCertificatePDF;   
                        pdfPage.getParameters().put('id',recordId);
                        pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                        filename = 'Hygiene Audit Certificate';
                    }
                    Attachment attach = new Attachment(); 
                    attach.Body = pdfBody;
                    attach.Name =  filename+'_'+System.now()+'_.Pdf';
                    attach.IsPrivate = false;
                    attach.ParentId = qarec.Id;
                    attach.ContentType = 'application/pdf';
                    attachList.add(attach);
                }
                if(!attachList.isEmpty()){
                    insert attachList;
                    System.debug('attachList Size == >'+attachList.size());
                    if(attachList.size()>0){
                        return 'SUCCESS';   
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }    
    
}