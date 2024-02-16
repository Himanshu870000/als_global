public class ALS_Quote_pdf_controller {
    public Quote_C__c quote { get; set; }
    public List<QuoteLineItems_c__c> quoteLineItems { get; set; }
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
    
    public ALS_Quote_pdf_controller(ApexPages.StandardController controller) {
        if(controller.getId()!=null){
            quote = [SELECT Id, Quote_Name__c,Subject__c,Subtotal__c,Total_Price1__c, Include_GST__c, Sample_Requirement__c,OpportunityId__c, OpportunityId__r.CreatedBy.Name,OpportunityId__r.CreatedBy.MobilePhone,OpportunityId__r.Billing_Address__Street__s,
                     OpportunityId__r.Billing_Address__City__s,OpportunityId__r.Billing_Address__PostalCode__s,OpportunityId__r.Billing_Address__StateCode__s,
                     OpportunityId__r.Billing_Address__CountryCode__s,AccountId__r.Name, Include_Discount__c, CreatedDate, Quote_Validity__c, Discount__c, Sample_Quantity__c, 
                     TAT__c, Note__c, Comment__c, Name, Email__c, ContactId__r.Name, ContactId__r.Phone, ContactId__r.Email, ContactId__r.Owner.Name,ContactId__r.Owner.MobilePhone,
                     (SELECT Quantity__c, Name, List_Price__c,Sales_Price__c,Subtotal__c, Total_Price__c, ProductId__r.Name,ProductId__r.ProductCode__c,ProductId__r.Method__c,Test_Method__c,Product_Code__c FROM QuoteLineItems__r) 
                     FROM Quote_C__c 
                     WHERE Id = :controller.getId()];
            Decimal total = 0;
            if (quote != null) {
                quoteLineItems = quote.QuoteLineItems__r;
                total += quote.Subtotal__c;
            }
            /*
if (quoteLineItems != null && !quoteLineItems.isEmpty()) {

for (QuoteLineItems_c__c item : quoteLineItems) {
if (item.Total_Price__c != null) {
total += item.Total_Price__c;
}
}
}
*/
            
            totalAmount = total;
            
            //  totalAmountWords =  NumberToText.convert(Integer.valueOf(totalAmount));            //   ConvertIntgerIntoString.english_number(totalAmount);
            
            genrealterms = [select Term_1__c, Term_2__c, Term_3__c, Term_4__c, Term_5__c, Term_6__c from General_Terms_and_Condition__mdt limit 1];
            
            feesandpayment = [select Fees_and_payment_1__c,fees_and_payment_2__c, Fees_and_payment_3__c, Fees_and_payment_4__c, Fees_and_payment_5__c, Fees_and_payment_6__c, Fees_and_payment_7__c from Fees_and_Payment__mdt limit 1];
            
            BankDetails = [select Name_of_Beneficiary__c, IFSC_Code__c, Branch_Name__c, Bank_Name__c, Bank_Account_Number__c, Bank_Account_Name__c, ALS_GST_number__c, Address__c from Bank_Details__mdt limit 1];
            
            ALSTermsandConditions = [select Term_1__c, Term_2__c, Term_3__c, Term_4__c, Term_5__c, Term_6__c, Term_7__c, Term_8__c, Term_9__c, Term_10__c, Term_11__c, Term_12__c, Term_13__c, Term_14__c, Term_15__c,Term_15_1__c,Term_15_2__c,Term_15_3__c, Term_16__c, Term_17__c, Term_18__c,Term_18_1__c,Term_18_2__c,Notes__c from ALS_Limited_Terms_Conditions__mdt limit 1];
            
            information = [select Information_1__c, Information_2__c, Information_3__c, Information_4__c, Sample_pick_up_service__c, A_Sample_material_logistics__c, B_Analytical_Investigations_OOS_Devi__c, Health_Safety_and_Environment_Hazardo__c, Documentation__c, Turnaround_time__c, Notes__c from Information__mdt limit 1];
            
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
            Decimal discountedPrice;
            gstAmount = (FIXED_GST_PERCENTAGE / 100) * totalAmount;
            
            // Calculate Grand Total based on conditions
            if (quote.Include_GST__c && quote.Include_Discount__c) {
                //grandTotal = totalAmount + gstAmount - discountAmount;
                discountedPrice = totalAmount-discountAmount;
                gstAmount = (FIXED_GST_PERCENTAGE / 100) * discountedPrice;
                grandTotal = discountedPrice + gstAmount;
            } else if (quote.Include_GST__c) {
                grandTotal = totalAmount + gstAmount;
            } else if (quote.Include_Discount__c) {
                grandTotal = totalAmount - discountAmount;
            } else {
                grandTotal = totalAmount;
            }
            totalAmountWords = NumberToText.convert(Integer.valueOf(grandTotal));
            
            
        }
        
        
    }
    
}