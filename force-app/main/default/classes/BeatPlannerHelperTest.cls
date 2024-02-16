@isTest
public class BeatPlannerHelperTest {
    
    @isTest
    static void testUpdateMonthname() {
    User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser503@example.com',
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        
        Monthly_Beat_Plan__c testmbp = UtilityTest.createMBPRec('In Progress', testUser.Id, System.today() + 10, 'January', System.today(), 'Draft');
        Weekly_Beat_Plan__c testwbp = UtilityTest.createWBPRec(System.today()+10, System.today(), 'W1', 'Week 1', testmbp.ID);
        
        List<Monthly_Beat_Plan__c> testMonthlyList = new List<Monthly_Beat_Plan__c>{testmbp};
            
        Test.startTest();
        FullCalendarController.alldataWrapper result = FullCalendarController.BeetplannerDatareturn('January', '2024');
        BeatPlannerHelper.updateMonthname(testMonthlyList);
        BeatPlannerHelper.initiateApprovalProcess(testmbp.Id);
        Test.stopTest();     
    }
    
    @isTest
    static void testDocCategories(){
        
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser303@example.com',
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        
        
        Monthly_Beat_Plan__c testmbp = UtilityTest.createMBPRec('In Progress', testUser.Id, System.today() + 10, 'January', System.today(), 'Draft');
        
        List<Monthly_Beat_Plan__c> testMonthlyList = new List<Monthly_Beat_Plan__c>{testmbp};

        Test.startTest();
        BeatPlannerHelper.docCategories(testMonthlyList);
        Test.stopTest();
    }
    
    @isTest
    static void testCreateDocumentCategories() { 
        
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser403@example.com',
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        
        Monthly_Beat_Plan__c testmbp = UtilityTest.createMBPRec('In Progress', testUser.Id, System.today() + 10, 'January', System.today(), 'Draft');
        
        List<Monthly_Beat_Plan__c> testDealList = new List<Monthly_Beat_Plan__c>{testmbp};
            
        Test.startTest();
        BeatPlannerHelper.CreateDocumentCategories(testDealList);
        Test.stopTest();    
    }
    
	@isTest
    static void testGetTaskDetails(){
		Account accRec = UtilityTest.createAccRec('TestName');
       	Visit__c testVisit = UtilityTest.createVisitRec(System.today(),accRec.Id);
       	
        Test.startTest();
        BeatPlannerHelper.getTaskdetails(accRec.Id);
        Test.stopTest();
    }
    
}