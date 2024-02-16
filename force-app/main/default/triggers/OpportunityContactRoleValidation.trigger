trigger OpportunityContactRoleValidation on Opportunity_Contact_Role1__c (before insert, before update) {
   
    Map<Id, Opportunity_Contact_Role1__c> opportunityIdToPrimaryRecordMap = new Map<Id, Opportunity_Contact_Role1__c>();

   
    for (Opportunity_Contact_Role1__c ocr : [SELECT Id, Opportunity1__c FROM Opportunity_Contact_Role1__c WHERE IsPrimary__c = true]) {
        opportunityIdToPrimaryRecordMap.put(ocr.Opportunity1__c, ocr);
    }

    
    for (Opportunity_Contact_Role1__c newOcr : Trigger.new) {
        
        if (newOcr.IsPrimary__c) {
            
            Opportunity_Contact_Role1__c existingPrimaryRecord = opportunityIdToPrimaryRecordMap.get(newOcr.Opportunity1__c);
            if (existingPrimaryRecord != null && existingPrimaryRecord.Id != newOcr.Id) {
                newOcr.IsPrimary__c.addError('Error: Another Opportunity Contact Role with primary status already exists for this Opportunity.');
            }
        }
    }
}