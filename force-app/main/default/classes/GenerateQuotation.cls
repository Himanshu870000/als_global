public with sharing class GenerateQuotation {

    @AuraEnabled
    public static string generateSelectedQuatation(String QuotationName,string recordId){
        try{
            List<Attachment> attachList = new List<Attachment>();
            if(recordId !=null){
                blob pdfBody;
                string filename;
            Quote_C__c qarec = [SELECT Id,Name FROM Quote_C__c WHERE Id=:recordId];
            if(!String.isBlank(qarec.id) &&  QuotationName != null){

                if(QuotationName == 'Banglore Pharma Template'){
                    PageReference pdfPage = Page.BanglorePharmaPDF;   
                    pdfPage.getParameters().put('id',recordId);
                    pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                    filename = 'Banglore Pharma';
                }
                if(QuotationName == 'Mumbai Pharma Batch Quote'){
                    PageReference pdfPage = Page.MumbaiPharmaBatchPDF;   
                    pdfPage.getParameters().put('id',recordId);
                    pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                    filename = 'Mumbai Pharma Batch';
                }
                if(QuotationName == 'Mumbai Pharma EnL Quote'){
                    PageReference pdfPage = Page.MumbaiPharmaEnlPDF;   
                    pdfPage.getParameters().put('id',recordId);
                    pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                    filename = 'Mumbai Pharma EnL';
                }
                if(QuotationName == 'Mumbai Pharma General Quote'){
                    PageReference pdfPage = Page.MumbaiPharmaGeneralPDF;   
                    pdfPage.getParameters().put('id',recordId);
                    pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                    filename = 'Mumbai Pharma General';
                }
                if(QuotationName == 'Mumbai Pharma In-Vitro Quote'){
                    PageReference pdfPage = Page.MumbaiPharmaInVitroPDF;   
                    pdfPage.getParameters().put('id',recordId);
                    pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('For Test Class'));
                    filename = 'Mumbai Pharma In-Vitro';
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
              return 'SUCCESS';
            }
        }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
       return null;
    }
}