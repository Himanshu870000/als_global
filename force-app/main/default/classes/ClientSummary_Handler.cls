public class ClientSummary_Handler {
    
    @AuraEnabled
    public static ClientSummaryWrapper getAllAccountCount(){
        try{
            Integer getAllLeadRecCount = [Select COUNT() From Lead__c WHERE  Lead_Status__c = 'New'];
            Integer getAllETBAccountRecCount = [Select COUNT() From Account where Account_Stage__c = 'Active'];
            Integer getAllNTBAccountRecCount = [Select COUNT() From Account where Account_Stage__c = 'New'];
            Integer getAllLCAccountRecCount = [Select COUNT() From Account where Account_Stage__c = 'Inactive'];
            ClientSummaryWrapper cswr = new ClientSummaryWrapper();
            if(getAllLeadRecCount != null) {
                cswr.leadToatlCount = getAllLeadRecCount;
            }
            if(getAllETBAccountRecCount != null) {
                cswr.accETBCount = getAllETBAccountRecCount;
            }
            if(getAllNTBAccountRecCount != null) {
                cswr.accNTBCount = getAllNTBAccountRecCount;
            }
            if(getAllLCAccountRecCount != null) {
                cswr.accLCCount = getAllLCAccountRecCount;
            }
            if(cswr !=null){
                System.debug('cswr == >'+cswr);
                return cswr; 
            }
        }catch(Exception e){
            System.debug('Error message == >'+e.getMessage() + ' && Error Line == >'+e.getLineNumber());
        }
        return null; 
    }
    
    public class ClientSummaryWrapper {
        @AuraEnabled
        public Integer leadToatlCount {get;set;}
        @AuraEnabled
        public Integer accETBCount {get;set;}
        @AuraEnabled
        public Integer accNTBCount {get;set;}
        @AuraEnabled
        public Integer accLCCount {get;set;}
    }
}