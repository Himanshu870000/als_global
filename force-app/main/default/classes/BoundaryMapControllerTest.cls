@isTest
public class BoundaryMapControllerTest {
    
    @isTest
    public static void getBoundaryMap(){ 
        Route__c testRoute = new Route__c( Route_Name_del__c = 'Sarjapur', Sales_User__c =UserInfo.getUserId());   
        insert testRoute;
            
        Map<String, List<Object>> routeToAccounts = new Map<String, List<Object>>();
        List<Account> acclist = New List<Account>();
        Account testAccount = new Account(
            Name = 'Test Account',
            BillingStreet = 'Sarjapur',
            Geo_Location__latitude__s = 37.7749,
            Geo_Location__longitude__s = -122.4194
        );
        insert testAccount;
        
        if(testAccount != null){
            acclist.add(testAccount);   
        }
              
        if(!acclist.IsEmpty()){
            routeToAccounts.put('Sarjapur',acclist);
        }
        
        Test.startTest();
        BoundaryMapController.getBoundaryMap();
        Test.stopTest();
    }
}