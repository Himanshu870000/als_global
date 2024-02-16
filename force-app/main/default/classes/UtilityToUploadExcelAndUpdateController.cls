public class UtilityToUploadExcelAndUpdateController {

    @AuraEnabled
    Public static String CreateSampleUpdateRecords(List<Sample_Update__c> sampleUpdateList){
            Set<String> QuoteName=new Set<String>();
            Map<String,Quote_C__c> QuoteName_RelatedQuote=new Map<String,Quote_C__c>();

            List<Sample_Update__c> sampleListToUpdate=new List<Sample_Update__c> ();

            try{
                    if(!sampleUpdateList.isEmpty()){
                for(Sample_Update__c SM :sampleUpdateList){
                    QuoteName.add(SM.Quote_Name__c);
                }
                 system.debug('QuoteName === >'+QuoteName) ;
                if(!QuoteName.isEmpty()){
                     List<Quote_C__c> quotelist=[Select Id,OpportunityId__c,Name From Quote_C__c Where Name=:QuoteName];
                     system.debug('quotelist Size === >'+quotelist.size()) ;
                    if(!quotelist.isEmpty()){
                       for(Quote_C__c QC:quotelist){
                            QuoteName_RelatedQuote.put(QC.Name,QC);
                       }
                    }
                    if(!QuoteName_RelatedQuote.isEmpty()){
                            for(Sample_Update__c SM :sampleUpdateList){
                                    System.debug('QuoteName_RelatedQuote.get(SM.Quote_Name__c).OpportunityId__c ===> ' + QuoteName_RelatedQuote.get(SM.Quote_Name__c).OpportunityId__c);
                                     SM.Opportunity1_Name__c=QuoteName_RelatedQuote.containskey(SM.Quote_Name__c) ? QuoteName_RelatedQuote.get(SM.Quote_Name__c).OpportunityId__c:null;
                            }
                    }
                    sampleListToUpdate=sampleUpdateList;
                }else {
                     sampleListToUpdate=sampleUpdateList;
                }
                if(!sampleListToUpdate.isEmpty()){
                    Upsert sampleListToUpdate;
                }
            }
            }catch (Exception e){
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
            return 'SUCCESS';
    }
}