public class CreateOpportunityOnAccount {
    
    
    @AuraEnabled
    public static List<String> getFieldSet(){
        List<Schema.FieldSetMember> FieldSetListFromOPp  = SobjectType.Opportunity1__c.FieldSets.Opportunityfieldset.getFields();
        List<String> FieldSet = new List<String>();
        for(Schema.FieldSetMember fieldsToAdd : FieldSetListFromOPp){
            System.debug('Fields === >'+String.valueOf(fieldsToAdd.sobjectfield));
            FieldSet.add(String.valueOf(fieldsToAdd.sobjectfield));
            
        } 
        return FieldSet;
    }
    @AuraEnabled
    public static Map<String, Object> getAllCustomerAddress(String custId){
        
        try {
            Map<String, Object> returnWrapperMap = new Map<String, Object>();
            List<CustomerAddressWrapper> customerShippingAddressWrapper = new List<CustomerAddressWrapper>();
            List<CustomerAddressWrapper> customerBillingAddressWrapper = new List<CustomerAddressWrapper>();
            //  System.debug('--- custId'+custId);
            
            if(!String.isBlank(custId)) {
                //Opportunity1__c customerAcc = [SELECT Id, Name, AccountId__r.Id,AccountId__r.BillingState, AccountId__r.BillingStreet, AccountId__r.BillingCountry, AccountId__r.BillingPostalCode, AccountId__r.BillingCity, AccountId__r.ShippingState, AccountId__r.ShippingStreet, AccountId__r.ShippingCountry, AccountId__r.ShippingCity, AccountId__r.ShippingPostalCode, AccountId__r.AccountSource FROM Opportunity1__c WHERE Id = :custId];
                Opportunity1__c customerAcc = [SELECT Id, Name, AccountId__r.Id FROM Opportunity1__c WHERE Id = :custId];
                //  System.debug('--- customerAcc: ' + customerAcc);
/*  
                if(customerAcc != null && !String.isBlank(customerAcc.AccountId__r.BillingCountry)) {
                    customerBillingAddressWrapper.add(new CustomerAddressWrapper('Billing', customerAcc.AccountId__r.BillingStreet, customerAcc.AccountId__r.BillingState, customerAcc.AccountId__r.BillingCountry, customerAcc.AccountId__r.BillingCity, customerAcc.AccountId__r.BillingPostalCode, 'Billing', true));
                    returnWrapperMap.put('ship_selected_index', 0);
                }
                
                if(customerAcc != null && !String.isBlank(customerAcc.AccountId__r.ShippingCountry)) {
                    customerShippingAddressWrapper.add(new CustomerAddressWrapper('Shipping', customerAcc.AccountId__r.ShippingStreet, customerAcc.AccountId__r.ShippingState, customerAcc.AccountId__r.ShippingCountry, customerAcc.AccountId__r.ShippingCity, customerAcc.AccountId__r.ShippingPostalCode,  'Shipping', true));
                    returnWrapperMap.put('bill_selected_index', 0); 
                }

                
                 if(customerAcc != null && !String.isBlank(customerAcc.Billing_Address__CountryCode__s)) {
                    customerBillingAddressWrapper.add(new CustomerAddressWrapper('Billing', customerAcc.Billing_Address__Street__s, customerAcc.Billing_Address__StateCode__s, customerAcc.Billing_Address__CountryCode__s, customerAcc.Billing_Address__City__s, customerAcc.Billing_Address__PostalCode__s, 'Billing', true));
                	returnWrapperMap.put('ship_selected_index', 0);
                }
                
                if(customerAcc != null && !String.isBlank(customerAcc.Shipping_Address__CountryCode__s)) {
                    customerShippingAddressWrapper.add(new CustomerAddressWrapper('Shipping', customerAcc.Shipping_Address__Street__s, customerAcc.Shipping_Address__StateCode__s, customerAcc.Shipping_Address__CountryCode__s, customerAcc.Shipping_Address__City__s, customerAcc.Shipping_Address__PostalCode__s, 'Shipping', true));
                	returnWrapperMap.put('bill_selected_index', 0);
                }
  */              
                for(Dispatch_Address__c custAddress :[SELECT Id, Address__Street__s, ToLabel(Address__StateCode__s), Address__PostalCode__s, ToLabel(Address__CountryCode__s), Address__City__s, Type__c FROM Dispatch_Address__c WHERE Account__c =:customerAcc.AccountId__r.Id]) {
                    
                    if(custAddress.Type__c == 'Billing') {
                        customerBillingAddressWrapper.add(new customerAddressWrapper(custAddress.Id, custAddress.Address__Street__s, custAddress.Address__StateCode__s, custAddress.Address__CountryCode__s, custAddress.Address__City__s, custAddress.Address__PostalCode__s, custAddress.Type__c, false));
                    }else {
                        customerShippingAddressWrapper.add(new customerAddressWrapper(custAddress.Id, custAddress.Address__Street__s, custAddress.Address__StateCode__s, custAddress.Address__CountryCode__s, custAddress.Address__City__s, custAddress.Address__PostalCode__s, custAddress.Type__c, false));
                    }
                }
            
                
                //System.debug('--- customerAddressWrapper'+customerAddressWrapper);
                returnWrapperMap.put('account', customerAcc);
                returnWrapperMap.put('customer_ship_addresses', customerShippingAddressWrapper);
                returnWrapperMap.put('customer_bill_addresses', customerBillingAddressWrapper);
                // System.debug('--- response Wrapper '+returnWrapperMap);
                
                // System.debug('--- returnWrapperMap: ' + returnWrapperMap);
            }
	
            return returnWrapperMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    

    
    @AuraEnabled
    public static string UpdateOpportunityAccountAddresss(String oppId,String shippindId,String billingId){
        system.debug('shippindId'+shippindId);
        system.debug('billingId'+billingId);
        try{
            
            Opportunity1__c oppRecord = new Opportunity1__c();
            Dispatch_Address__c shippingAddress = new Dispatch_Address__c();
            Dispatch_Address__c billingAddress = new Dispatch_Address__c();
            Opportunity1__c oppDetails = new Opportunity1__c();
            Account accRec = new Account();

            if(oppId !=null){
                oppDetails =  [SELECT Id,Name,AccountId__c FROM Opportunity1__c WHERE Id=:oppId LIMIT 1];
                if(oppDetails.AccountId__c !=null){
                   accRec = [SELECT Id,Name,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet FROM Account WHERE Id=:oppDetails.AccountId__c LIMIT 1];
                   Opportunity1__c oppToUpdateForDefault = new Opportunity1__c();
                     oppToUpdateForDefault.id = oppId;
                     if(shippindId == 'Shipping' ){
                        if(accRec.ShippingStreet !=null){
                        oppToUpdateForDefault.Shipping_Address__Street__s = accRec.ShippingStreet;
                    }
                    if(accRec.ShippingCity !=null){
                        oppToUpdateForDefault.Shipping_Address__City__s = accRec.ShippingCity;
                    }
                    if(accRec.ShippingPostalCode !=null){
                        oppToUpdateForDefault.Shipping_Address__PostalCode__s = accRec.ShippingPostalCode;
                    }
                    /*if(accRec.ShippingState !=null){
                        oppToUpdateForDefault.Shipping_Address__StateCode__s = accRec.ShippingState;
                    }*/
                    /*if(accRec.ShippingCountry !=null){
                        oppToUpdateForDefault.Shipping_Address__CountryCode__s = accRec.ShippingCountry;
                    }*/
                    }
                    if(billingId == 'Billing'){
                     if(accRec.BillingStreet !=null){
                        oppToUpdateForDefault.Billing_Address__Street__s = accRec.BillingStreet;
                    }
                    if(accRec.BillingCity !=null){
                        oppToUpdateForDefault.Billing_Address__City__s = accRec.BillingCity;
                    }
                    if(accRec.BillingPostalCode !=null){
                        oppToUpdateForDefault.Billing_Address__PostalCode__s = accRec.BillingPostalCode;
                    }
                    /*if(accRec.BillingState !=null){
                        oppToUpdateForDefault.Billing_Address__StateCode__s = accRec.BillingState;
                    }*/
                    //if(accRec.BillingCountry !=null){
                        //oppToUpdateForDefault.Billing_Address__CountryCode__s = accRec.BillingCountry;
                   // }
                    }
                    update oppToUpdateForDefault;
                    system.debug('by default selected address===>'+oppToUpdateForDefault);
                    }
                    
                    }
          
            
            
            if(oppId !=null && shippindId !=null && billingId !=null && shippindId!='Shipping' && billingId!= 'Billing'){
                oppRecord = [SELECT Id,Name,AccountId__c FROM Opportunity1__c WHERE Id =:oppId];
                shippingAddress= [SELECT id,Name,Address__Street__s,Address__City__s,Address__PostalCode__s,Address__StateCode__s,Address__CountryCode__s FROM Dispatch_Address__c WHERE Id=:shippindId];
                billingAddress= [SELECT id,Name,Address__Street__s,Address__City__s,Address__PostalCode__s,Address__StateCode__s,Address__CountryCode__s FROM Dispatch_Address__c WHERE Id=:billingId];
                
                System.debug('--- oppRecord: ' + oppRecord);
                
                System.debug('--- shippingAddress: ' + shippingAddress);
                
                System.debug('--- billingAddress: ' + billingAddress);
                
                Opportunity1__c oppToUpdate = new Opportunity1__c();
                oppToUpdate.id = oppRecord.id;
                if(billingAddress !=null){
                    if(billingAddress.Address__Street__s !=null){
                        oppToUpdate.Billing_Address__Street__s = billingAddress.Address__Street__s;
                    }
                    if(billingAddress.Address__City__s !=null){
                        oppToUpdate.Billing_Address__City__s = billingAddress.Address__City__s;
                    }
                    if(billingAddress.Address__PostalCode__s !=null){
                        oppToUpdate.Billing_Address__PostalCode__s = billingAddress.Address__PostalCode__s;
                    }
                    if(billingAddress.Address__StateCode__s !=null){
                        oppToUpdate.Billing_Address__StateCode__s = billingAddress.Address__StateCode__s;
                    }
                    if(billingAddress.Address__CountryCode__s !=null){
                        oppToUpdate.Billing_Address__CountryCode__s = billingAddress.Address__CountryCode__s;
                    }
                }
                if(shippingAddress !=null){
                    if(shippingAddress.Address__Street__s !=null){
                        oppToUpdate.Shipping_Address__Street__s = shippingAddress.Address__Street__s;
                    }
                    if(shippingAddress.Address__City__s !=null){
                        oppToUpdate.Shipping_Address__City__s = shippingAddress.Address__City__s;
                    }
                    if(shippingAddress.Address__PostalCode__s !=null){
                        oppToUpdate.Shipping_Address__PostalCode__s = shippingAddress.Address__PostalCode__s;
                    }
                    if(shippingAddress.Address__StateCode__s !=null){
                        oppToUpdate.Shipping_Address__StateCode__s = shippingAddress.Address__StateCode__s;
                    }
                    if(shippingAddress.Address__CountryCode__s !=null){
                        oppToUpdate.Shipping_Address__CountryCode__s = shippingAddress.Address__CountryCode__s;
                    }
                }
                update oppToUpdate;
                String AccountId = [SELECT Id,Name,AccountId__c FRom Opportunity1__c Where Id=: oppRecord.id ].AccountId__c;
                System.debug('AccountId  === > ' + AccountId);
                if(AccountId !=null){
                    Account accToUpdate = new Account();
                    accToUpdate.id = AccountId;
                    if(oppToUpdate.Billing_Address__Street__s !=null){
                        accToUpdate.BillingStreet =oppToUpdate.Billing_Address__Street__s;
                    }
                    if(oppToUpdate.Billing_Address__City__s !=null){
                        accToUpdate.BillingCity =oppToUpdate.Billing_Address__City__s; 
                    }
                    if(oppToUpdate.Billing_Address__PostalCode__s !=null){
                        accToUpdate.BillingPostalCode=oppToUpdate.Billing_Address__PostalCode__s;
                    }
                    if(oppToUpdate.Billing_Address__CountryCode__s !=null){
                        accToUpdate.BillingCountry=oppToUpdate.Billing_Address__CountryCode__s;
                    }
                    if(oppToUpdate.Shipping_Address__Street__s !=null){
                        accToUpdate.ShippingStreet=oppToUpdate.Shipping_Address__Street__s;
                    }
                    if(oppToUpdate.Shipping_Address__City__s !=null){
                        accToUpdate.ShippingCity=oppToUpdate.Shipping_Address__City__s;
                    }
                    if(oppToUpdate.Shipping_Address__StateCode__s !=null){
                        accToUpdate.ShippingState=oppToUpdate.Shipping_Address__StateCode__s;
                    }
                    if(oppToUpdate.Shipping_Address__PostalCode__s !=null){
                        accToUpdate.ShippingPostalCode=oppToUpdate.Shipping_Address__PostalCode__s;
                    }
                    if(oppToUpdate.Shipping_Address__CountryCode__s !=null){
                        accToUpdate.ShippingCountry=oppToUpdate.Shipping_Address__CountryCode__s;
                    } 
                    update accToUpdate;
                    System.debug('Updated Account Address ' + accToUpdate);  
                    if(accToUpdate !=null){
                        return 'SUCCESS';
                    }
                }    
            }
            
        }catch(Exception e){
            System.debug('Error == >'+e.getMessage() +' && Error Line == >'+e.getLineNumber());
        }
        return 'ERROR';
    }
    
    
    public class CustomerAddressWrapper {
        @auraEnabled
        public String id;
        @auraEnabled
        public String street;
        @auraEnabled
        public String state;
        @auraEnabled
        public String country;
        @auraEnabled
        public String city;
        
        @auraEnabled
        public String type;
        @AuraEnabled
        public String postalCode;
        @AuraEnabled
        public Boolean checked;
        
        public CustomerAddressWrapper(String id, String street, String state, String country, String city, String postalCode, String type, Boolean checked) {
            this.id = id;
            this.street = street;
            this.state = state;
            this.country = country;
            this.city = city;
            
            this.postalCode = postalCode;
            this.type = type;
            this.checked = checked;
        }
    }
    
}