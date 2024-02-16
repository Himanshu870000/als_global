@isTest
public class UserListTest {
    @isTest
    static void testCopyBillingAddressData() {
        
        Account testAccount = new Account(
            Name = 'Test Account',
            BillingStreet = 'Billing St',
            BillingCity = 'Billing City',
            BillingState = 'Billing State',
            BillingPostalCode = '12345',
            BillingCountry = 'Billing Country',
            ShippingStreet = 'Shipping St',
            ShippingCity = 'Shipping City',
            ShippingState = 'Shipping State',
            ShippingPostalCode = '54321',
            ShippingCountry = 'Shipping Country'
        );
        insert testAccount;
        
        String result = UserList.CopyBillingAddressData(testAccount.Id);
    }
    
    @isTest
    static void testNegativeCases() {
        
        Account testAccount1 = new Account();
        testAccount1.Name = 'Test Negative Account';
        testAccount1.BillingStreet = null;
        testAccount1.ShippingStreet = null;
        testAccount1.BillingCity = null;
        testAccount1.BillingState = null;
        testAccount1.BillingPostalCode = null;
        testAccount1.ShippingStreet = null;
        testAccount1.ShippingCity = null;
        testAccount1.ShippingState = null;
        testAccount1.ShippingPostalCode = null;
        testAccount1.ShippingCountry = null;
        insert testAccount1;
        
        String result = UserList.CopyBillingAddressData(testAccount1.Id);
        
    }
    
    @isTest
    static void testBillingAdd(){
        Account testAccount2 = new Account();
        testAccount2.Name = 'Test Negative Account';
        testAccount2.BillingStreet = 'BTM 2nd Stage';
        testAccount2.ShippingStreet = null;
        insert testAccount2;
         
        UserList.CopyBillingAddressData(testAccount2.Id);
    }
    
    @isTest
    static void testBillingAdd2(){
        Account testAccount3 = new Account();
        testAccount3.Name = 'Test Negative Account';
        testAccount3.BillingStreet = null;
        testAccount3.ShippingStreet = 'BTM 2nd Stage';
        insert testAccount3;
         
        UserList.CopyBillingAddressData(testAccount3.Id);
    }
    
    @isTest
    static void testBillingCity(){
        Account testAccount4 = new Account();
        testAccount4.Name = 'Test Negative Account';
        testAccount4.BillingCity = 'Nagpur';
        testAccount4.ShippingCity = null;
        insert testAccount4;
         
        UserList.CopyBillingAddressData(testAccount4.Id);
    }
    
    @isTest
    static void testBillingCity2(){
        Account testAccount5 = new Account();
        testAccount5.Name = 'Test Negative Account';
        testAccount5.BillingCity = null;
        testAccount5.ShippingCity = 'Nagpur';
        insert testAccount5;
         
        UserList.CopyBillingAddressData(testAccount5.Id);
    }
    
    @isTest
    static void testBillingPostalCode(){
        Account testAccount6 = new Account();
        testAccount6.Name = 'Test Negative Account';
        testAccount6.BillingPostalCode = '440024';
        testAccount6.ShippingPostalCode = null;
        insert testAccount6;
         
        UserList.CopyBillingAddressData(testAccount6.Id);
    }
    
    @isTest
    static void testBillingPostalCode2(){
        Account testAccount7 = new Account();
        testAccount7.Name = 'Test Negative Account';
        testAccount7.BillingPostalCode = null;
        testAccount7.ShippingPostalCode = '440024';
        insert testAccount7;
         
        UserList.CopyBillingAddressData(testAccount7.Id);
    }
    
    @isTest
    static void testBillingState(){
        Account testAccount8 = new Account();
        testAccount8.Name = 'Test Negative Account';
        testAccount8.BillingState = 'Maharashtra';
        testAccount8.ShippingState= null;
        insert testAccount8;
         
        UserList.CopyBillingAddressData(testAccount8.Id);
    }
    
    @isTest
    static void testBillingState2(){
        Account testAccount9 = new Account();
        testAccount9.Name = 'Test Negative Account';
        testAccount9.BillingState = null;
        testAccount9.ShippingState = 'Maharashtra';
        insert testAccount9;
         
        UserList.CopyBillingAddressData(testAccount9.Id);
    }
    
     @isTest
    static void testBillingCountry(){
        Account testAccount10 = new Account();
        testAccount10.Name = 'Test Account';
        testAccount10.BillingCountry = 'India';
        testAccount10.ShippingCountry = null;
        insert testAccount10;
         
        UserList.CopyBillingAddressData(testAccount10.Id);
    }
    
    @isTest
    static void testBillingCountry2(){
        Account testAccount11 = new Account();
        testAccount11.Name = 'Test Country Account';
        testAccount11.BillingCountry = null;
        testAccount11.ShippingCountry = 'India';
        insert testAccount11;
         
        UserList.CopyBillingAddressData(testAccount11.Id);
    }
}