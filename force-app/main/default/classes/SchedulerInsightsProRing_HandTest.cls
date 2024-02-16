@isTest
public class SchedulerInsightsProRing_HandTest {
	@isTest
    static void testGetRoleAndKPI() {
       List<Roles_and_KPI__c> testData = new List<Roles_and_KPI__c>();
       for (Integer i = 0; i < 5; i++) {
            Roles_and_KPI__c rak = new Roles_and_KPI__c(Name = 'Test Role ' + i);
            testData.add(rak);
        }
        insert testData;
        
         List<Roles_and_KPI__c> result = SchedulerInsightsProgressRing_Handler.getRoleAndKPI();

    }
    
    
}