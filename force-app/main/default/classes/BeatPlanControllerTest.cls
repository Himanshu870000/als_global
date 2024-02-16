@isTest
public class BeatPlanControllerTest {
    @isTest
    static void testAllRolesXKPICurrentUser() {
        
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser72@example.com',
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        
        Roles_and_KPI__c testRKP = new Roles_and_KPI__c(
            Name = 'Test Role',
            Sales_User__c = testUser.Id
        );
        insert testRKP;
        
        Test.startTest();
        List<Roles_and_KPI__c> result = BeatPlanController.AllRolesXKPICurrentUser();
        Test.stopTest();
    }
    
    
    @isTest
    static void testGetAllMonthlyBeatPlanner() {
        
        Date startDate = Date.today();
        Date lastDate = startDate.addMonths(1).toStartOfMonth().addDays(-1);
        List<Monthly_Beat_Plan__c> existingBeatPlan = new List<Monthly_Beat_Plan__c>();
        
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Monthly_Beat_Plan__c existingRecord = new Monthly_Beat_Plan__c(
                Month_Name__c = 'January',
               // Year__c = String.valueOf(startDate.year()),
                Sales_User__c = UserInfo.getUserId()
            );
            existingBeatPlan.add(existingRecord);
            insert existingBeatPlan;
        }

      //  BeatPlannerController  bpc = new BeatPlannerController();

        Test.startTest();
       // BeatPlannerController.GetAllMonthlyBeatPlanner(startDate.format(),lastDate.format(),new List<BeatPlannerController.WrapperClass>());
        Test.stopTest();
    }    
    
   /* @isTest
    static void testSendEmailToRSMonMontlyBeatPlanCreation() {
        Monthly_Beat_Plan__c testMbeatPlan = new Monthly_Beat_Plan__c(
            //Name = 'Test Beat Plan',
            Month_Name__c = 'January'    
        );
        insert testMbeatPlan;
        
        EmailTemplate mockTemplate = new EmailTemplate(
            Name = 'New Beat Plan Email',
            Subject = 'Test Subject',
            Body = 'Test Body',
            HTMLValue = '<html><body>{!Manager.Name} {!Monthly_Beat_Plan__c.Month_Name__c} {!Monthly_Beat_Plan__c.Id} {!RecordURL}</body></html>'
            
        );
        insert mockTemplate;
               
        testMbeatPlan.OwnerId = UserInfo.getUserId();
        update testMbeatPlan;
               
        Test.startTest();
        String result = BeatPlanController.sendEmailToRSMonMontlyBeatPlanCreation(testMbeatPlan.Id);
        Test.stopTest();   
    } */
}