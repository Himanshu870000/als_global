public class UserList {
    @AuraEnabled
    Public static String CopyBillingAddressData(String AccountId){
        Account AccountRec=[SELECT BillingAddress,ShippingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,
                            ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet FROM Account Where Id=:AccountId];
        
        system.debug('AccountRec BillingAddress--'+AccountRec.BillingAddress);
        system.debug('AccountRec ShippingAddress--'+AccountRec.ShippingAddress);
        string Message; 
        IF(AccountRec.BillingAddress==null && AccountRec.ShippingAddress==null){
            Message='Billing and Shipping Address Is Empty';
            
        }else{
            
            if(AccountRec.BillingStreet!=null && AccountRec.ShippingStreet==null){
                AccountRec.ShippingStreet=AccountRec.BillingStreet;
            }else if(AccountRec.ShippingStreet!=null && AccountRec.BillingStreet==null){
                AccountRec.BillingStreet=AccountRec.ShippingStreet;  
            }
            if(AccountRec.BillingCity!=null && AccountRec.ShippingCity==null){
                AccountRec.ShippingCity=AccountRec.BillingCity;
            }else if(AccountRec.BillingCity==null && AccountRec.ShippingCity!=null){
                AccountRec.BillingCity=AccountRec.ShippingCity;
            }
            if(AccountRec.BillingPostalCode!=null && AccountRec.ShippingPostalCode==null){
                AccountRec.ShippingPostalCode=AccountRec.BillingPostalCode;
            }else if(AccountRec.BillingPostalCode==null && AccountRec.ShippingPostalCode!=null){
                AccountRec.BillingPostalCode=AccountRec.ShippingPostalCode; 
            }
            if(AccountRec.BillingState!=null && AccountRec.ShippingState==null){
                AccountRec.ShippingState=AccountRec.BillingState;
            }else if(AccountRec.BillingState==null && AccountRec.ShippingState!=null){
                AccountRec.BillingState=AccountRec.ShippingState;
            }
            if(AccountRec.BillingCountry!=null && AccountRec.ShippingCountry==null){
                AccountRec.ShippingCountry=AccountRec.BillingCountry;
            }else if(AccountRec.BillingCountry==null && AccountRec.ShippingCountry!=null){
                AccountRec.BillingCountry=AccountRec.ShippingCountry;
            }
            Update AccountRec; 
            
            Message='SUCCESS';
            
        }
        
        return Message;
        
    }
    
        
    
}