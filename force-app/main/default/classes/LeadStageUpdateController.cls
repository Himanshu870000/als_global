public class LeadStageUpdateController {
    @AuraEnabled
    public static void updateStageToAudit(String recordId){
        Lead__c leadRec = new Lead__c(id=recordId , Sub_Stage__c = 'Audit', Lead_Status__c = 'Audit');
        update leadRec;
    }
    
    @AuraEnabled
    public static void updateStageToJunk(String recordId){
        Lead__c leadRec = new Lead__c(id=recordId , Sub_Stage__c = 'Junk');
        update leadRec;
    }
    
    @AuraEnabled
    public static Boolean fetchStakeHolderDetails(String recordId){
        Boolean shdRec = false;
        List<Stakeholder_Details__c> shdList = [SELECT Id, Name, Name__c, Lead__c FROM Stakeholder_Details__c WHERE Lead__c = :recordId];
        
        if(shdList.size() > 0){
            shdRec = true;
        }
        return shdRec;
    }
}