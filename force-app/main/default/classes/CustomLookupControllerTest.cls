@isTest
private class CustomLookupControllerTest {
    
    @isTest
    static void testFetchRecords() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        List<CustomLookupController.RecordsData> result = CustomLookupController.fetchRecords('Account', 'Name', 'Test', null);
         List<CustomLookupController.RecordsData> result1 = CustomLookupController.fetchRecords('Contact', 'Name', 'Test', 'a');
        
        Exception exception1 = new System.MathException();
        exception1.setMessage('my message');
    }
}