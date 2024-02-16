@isTest
public with sharing class Scheduler_Insights_HandlerTest {
    
	 @isTest
    static void testGetAllDateOfSchedulerSight() {
        Account accRec = UtilityTest.createAccRec('Test Account');
        Contact conRec = UtilityTest.createConRec('Test','Data');
        Monthly_Beat_Plan__c mbpRec = UtilityTest.createMBPRec('In Progress',UserInfo.getUserId(),System.today(),'January',System.today(),'Approved');
        Roles_and_KPI__c rkpiRec= UtilityTest.createKPIRec('Test Role KPI',true ,UserInfo.getUserId());
        KPI_Target__c kpiRec = UtilityTest.createKPIRec(10,UserInfo.getUserId(),15,rkpiRec.Id,mbpRec.Id);
        Visit__c vRec = UtilityTest.createVisitRec(System.today(),accRec.Id);
        vRec.Actual_Visit_Date__c = System.today();
        vRec.KPI_Target__c = kpiRec.Id;
        update vRec;
        Lead__c ldRec = UtilityTest.createLeadRec('Testname','DemoName','Testy Corpotion','North','Test@gmail.com');
        Monthly_Travel_Expense__c mteRec = UtilityTest.createMTERec('MTEtest - January', 'Approved', System.today(), System.today(), System.today(), UserInfo.getUserId());
        Day_Visit_Plan__c dvpRec = UtilityTest.createDVPRec(UserInfo.getUserId(), System.today(), 'January', '2024', System.today(), System.today(), mteRec.Id);
        dvpRec.Total_Covered_Distance__c = 102;
        update dvpRec;
        Feedback__c fbRec = UtilityTest.createFbRec(accRec.Id,'Ghaziabad','TestDdescription',UserInfo.getUserId(),6,conRec.Id);
        Case csRec = UtilityTest.createCsRec(accRec.Id,conRec.Id,'New','Email','New problem','High','Problem','Testsubject','Testdescription');
        User userRec = UtilityTest.createUserCustomService();
        Opportunity1__c oppRec = UtilityTest.CreateOppRec('Test Opp',accRec.Id,System.today(),userRec.id,'New','North');
        Quote_C__c quRec = UtilityTest.createQuoteRec(accRec.Id,'Test Quote','TestDescription','Draft',conRec.Id,oppRec.id );
        
        List<Event> eventRecords = new List<Event>();
        for (Integer i = 0; i < 10; i++) {
            eventRecords.add(new Event(
                WhoId = ldRec.Id,  
                Type = 'Meeting',
                StartDateTime = DateTime.now(),
                EndDateTime = DateTime.now().addHours(1),
                Description = 'Test Event Description' + i
                
            ));
        }
       // insert eventRecords;
        
        Test.startTest();
        Scheduler_Insights_Handler.SchedulerInsightsWrapper var = new Scheduler_Insights_Handler.SchedulerInsightsWrapper();
       var =  Scheduler_Insights_Handler.getAllDateOfSchdeularSight(1, 10, 'January', '2024');
        Test.stopTest();
    }

	@isTest
    static void testGetAllDateOfTravelDayVisitPlan() {
        
        List<Day_Visit_Plan__c> testDvpList = new List<Day_Visit_Plan__c>();
        String testUserId = UserInfo.getUserId();
        String testMonth = 'January'; 
        String testYear = String.valueOf(System.now().year()); 

        for (Integer i = 0; i < 5; i++) {
            Day_Visit_Plan__c dvp = new Day_Visit_Plan__c();
            dvp.Service_Executive__c = testUserId;
            dvp.Month_year__c = testYear;
            dvp.Month_Name__c = testMonth;
            
            testDvpList.add(dvp);
        }

        List<Day_Visit_Plan__c> result = Scheduler_Insights_Handler.getAllDateOfTravelDayVisitPlan(testMonth, testYear);      
    }
    
    @isTest
    static void testUpdateMonthName() {
             
        List<Day_Visit_Plan__c> testDvpList = new List<Day_Visit_Plan__c>();
        
        Monthly_Travel_Expense__c mteRec = UtilityTest.createMTERec('MTEtest - January', 'Approved', System.today(), System.today(), System.today(), UserInfo.getUserId());
        Day_Visit_Plan__c dvpRec = UtilityTest.createDVPRec(UserInfo.getUserId(), System.today(), 'January', '2024', System.today(), System.today(), mteRec.Id);
       // dvpRec.Total_Distance__c = 100;
        dvpRec.Total_Covered_Distance__c = 102;
        update dvpRec;
        
        testDvpList.add(dvpRec);
        
        Test.startTest();
        Scheduler_Insights_Handler.updateMonthname(testDvpList);
        Test.stopTest();
    }
}