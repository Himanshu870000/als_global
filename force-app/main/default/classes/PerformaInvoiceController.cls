public class PerformaInvoiceController {
    
    public Opportunity1__c  getOpportunityDetails {get;set;}
    public List<OpportunityLineItem1__c> OpportunityLineItemList { get; set; }
    public List<Opportunity_Contact_Role1__c> opportunityContactRole { get; set; }
    public static Bank_Details__mdt BankDetails { get; set; }
    public static Mumbai_Bank_Details__mdt Mumbai_BankDetails { get; set; }
    public static ALS_details__mdt ALS_Details { get; set; }
    public List<Quote_C__c> Quotes { get; set; }
    
    public Decimal Subtotal { get; set; }
    public static final Decimal IGST_RATE = 18;
    public Decimal IGST { get; set; }
    public Decimal GrandTotal { get; set; }
    
    public String recordId {get;set;}
    public PerformaInvoiceController(ApexPages.StandardController controller) {
        try{
            recordId = controller.getId();
            if(recordId !=null){
                getOpportunityDetails = [SELECT Id,Enable_IGST__c, PO_Number__c,(SELECT Quantity__c, Name, ListPrice__c, UnitPrice__c, TotalPrice__c, Product1Id__r.Name, Product1Id__r.ProductCode__c, Product1Id__r.HSN_CODE__c FROM OpportunityLineItems1__r), (SELECT Contact__r.Name, Contact__r.MailingStreet, Contact__r.MailingAddress, Contact__r.MailingCity, Contact__r.MailingState, Contact__r.MailingPostalCode, Contact__r.MailingCountry FROM Opportunity_Contact_Role__r WHERE IsPrimary__c = true), (SELECT Name,CreatedDate  FROM Quotes__r WHERE Primary__c = true) FROM Opportunity1__c WHERE Id = :recordId];
                Decimal total = 0;
                if (getOpportunityDetails.OpportunityLineItems1__r != null) {
                    OpportunityLineItemList = getOpportunityDetails.OpportunityLineItems1__r;
                }
                if (OpportunityLineItemList != null && !OpportunityLineItemList.isEmpty()) {
                    
                    
                    
                    
                    for (OpportunityLineItem1__c item : OpportunityLineItemList) {
                        if (item.TotalPrice__c != null) {
                            total += item.TotalPrice__c;
                        }
                    }
                }
                
                
                Subtotal = total;
                IGST = (IGST_RATE / 100) * Subtotal;
                
                GrandTotal = Subtotal + IGST;
                if (getOpportunityDetails.Opportunity_Contact_Role__r != null) {
                    opportunityContactRole = getOpportunityDetails.Opportunity_Contact_Role__r;
                }
                if (getOpportunityDetails.Quotes__r != null) {
                    Quotes = getOpportunityDetails.Quotes__r;
                }
                
            }
            Bank_Details__mdt[] bankDetailsList = [select Name_of_Beneficiary__c, IFSC_Code__c, Swift_code__c,Branch_Name__c, Bank_Name__c, Bank_Account_Number__c, Bank_Account_Name__c, ALS_GST_number__c, Address__c from Bank_Details__mdt limit 1];
            if (bankDetailsList != null && !bankDetailsList.isEmpty()) {
                BankDetails = bankDetailsList[0];
            } else {
                BankDetails = new Bank_Details__mdt();
            }
            
            Mumbai_Bank_Details__mdt[] MumbaibankDetailsList = [select Bank_Name__c, Account_No__c, IFSC_CODE__c from Mumbai_Bank_Details__mdt limit 1];
            if (MumbaibankDetailsList != null && !MumbaibankDetailsList.isEmpty()) {
                Mumbai_BankDetails = MumbaibankDetailsList[0];
            } else {
                Mumbai_BankDetails = new Mumbai_Bank_Details__mdt();
            }
            
            ALS_details__mdt[] ALSDetailsList = [select Company_s_PAN__c, Company_s_GST_No__c, SAC_Code__c from ALS_details__mdt limit 1];
            if (ALSDetailsList != null && !ALSDetailsList.isEmpty()) {
                ALS_Details = ALSDetailsList[0];
            } else {
                ALS_Details = new ALS_details__mdt();
            }
            
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        
    }
    
    // Method for Downloading Selected Proforma Invoice
    @AuraEnabled
    public static string generateSelectedProformaInvoice(String InvoiceName,string recordId){
        try{
            List<Attachment> attachList = new List<Attachment>();
            if(recordId !=null){
                blob pdfBody;
                string filename;
                Opportunity1__c Opp = [SELECT Id,Name FROM Opportunity1__c WHERE Id=:recordId];
                if(!String.isBlank(Opp.id) &&  InvoiceName != null){
                    
                    if(InvoiceName == 'Bangalore Proforma Invoice'){
                        PageReference pdfPage = Page.BangloerePerfomaInvoice;   
                        pdfPage.getParameters().put('id',recordId);
                        pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                        filename = 'Bangalore Proforma Invoice';
                    }
                    if(InvoiceName == 'Mumbai Proforma Invoice'){
                        PageReference pdfPage = Page.MumbaiPerfomaInvoice;   
                        pdfPage.getParameters().put('id',recordId);
                        pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                        filename = 'Mumbai Proforma Invoice';
                    }
                    Attachment attach = new Attachment(); 
                    attach.Body = pdfBody;
                    attach.Name =  filename+'_'+System.now()+'_.Pdf';
                    attach.IsPrivate = false;
                    attach.ParentId = Opp.Id;
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