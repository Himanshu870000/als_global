@isTest
public with sharing class MonthlyVisitViewerControllerTest {
    
    @isTest
    static void fetchPageDataTest() {
        Monthly_Beat_Plan__c MBRec =  UtilityTest.createMBPRec('Approved',UserInfo.getuserId(),System.today(),'January',System.today(),'Approved');
        MBRec.Month_Name__c = 'January';
        update MBRec;
        MonthlyVisitViewerController.fetchPageData('2024-January-30');
    }     
    
    @isTest
    static void testGetCurrentUserRoutes() {
        Route__c testRoute = new Route__c(  
            Sales_User__c = UserInfo.getUserId()
        );
        insert testRoute;      
        MonthlyVisitViewerController.getCurrentUserRoutes();
          MonthlyVisitViewerController.getSobjectType();
    }
    
    
    @isTest
    static void testCreateVisits() {
        Account accRec = UtilityTest.createAccRec('TestName');
        Visit__c vRec = UtilityTest.createVisitRec(System.today(), accRec.Id);
        vRec.Planned_visit_date__c = System.today();
        update vRec;
        
        Monthly_Beat_Plan__c  mbpRec = UtilityTest.createMBPRec('In Progress', userInfo.getUserId(), System.today(),'January',System.today(),'Approved');
        
        KPI_Target__c kpiRec = new  KPI_Target__c(Target_Count__c = 10);
        insert kpiRec;
        kpiRec.Monthly_Beat_Plan__c = mbpRec.Id;
        
        
        
        List<Visit__c> testVisitList = new List<Visit__c>{vRec};
            
            MonthlyVisitViewerController.createVisits(testVisitList);
        MonthlyVisitViewerController.tagKIPToVisit(vRec.Id, kpiRec.Id);
        MonthlyVisitViewerController.showKpi(vRec.Id);
        
    }
    
    
    @isTest
    static void testGetCurrentRecordGeoLocation() {
        lead__c ldRec = UtilityTest.CreateLeadRec('fname', 'lName', 'test Org', 'North', 'email@gmail.com');
        ldRec.Geo_Location__Latitude__s = 12.951845;
        ldRec.Geo_Location__Longitude__s = 77.699577;
        update ldRec;
        
        Account accRec = UtilityTest.createAccRec('QwertyName');
        accRec.ShippingCountry = 'USA';
        accRec.ShippingState = 'CA';
        accRec.ShippingStreet = '123 Main St';
        accRec.ShippingPostalCode = '12345';
        accRec.Geo_Location__Latitude__s = 12.951845;
        accRec.Geo_Location__Longitude__s = 77.699577;
        update accRec;
        
        MonthlyVisitViewerController.getCurrentRecordGeoLocation(ldRec.Id);
    }
    
    @isTest
    static void testCreateVisitObjectType() {
        lead__c ldRec = UtilityTest.CreateLeadRec('fname', 'lName', 'test Org', 'North', 'email@gmail.com');
        Monthly_Beat_Plan__c  mbpRec = UtilityTest.createMBPRec('In Progress', userInfo.getUserId(), System.today(),'January',System.today(),'Approved');
        Weekly_Beat_Plan__c wbpRec = UtilityTest.createWBPRec(System.today()+ 30, System.today(), 'W1', 'Week 1', mbpRec.Id);
        
        
        Account accRec = UtilityTest.createAccRec('QwertyName');
        accRec.ShippingCountry = 'USA';
        accRec.ShippingState = 'CA';
        accRec.ShippingStreet = '123 Main St';
        accRec.ShippingPostalCode = '12345';
        accRec.Geo_Location__Latitude__s = 12.951845;
        accRec.Geo_Location__Longitude__s = 77.699577;
        update accRec;
        
        Visit__c vRec = UtilityTest.createVisitRec(System.today(), accRec.Id);
        vRec.Lead__c = ldRec.id;
        vRec.Assigned_User__c = UserInfo.getUserId();
        vRec.Planned_Visit_Date__c = System.today();
        vRec.Actual_Visit_Date__c = System.today();
        vRec.Weekly_Beat_Plan__c = wbpRec.Id;
        //vRec.Expected_Start_Time__c = DateTime.newInstance(2024, 2, 25, 10, 0, 0);
        //vRec.Expected_End_Time__c = DateTime.newInstance(2024, 2, 15, 10, 0, 0);
        vRec.Geo_Location__Latitude__s = 12.951845;
        vRec.Geo_Location__Longitude__s = 77.699577;    
        update vRec;
        
        
        MonthlyVisitViewerController.createVisitObjectType(ldRec.Id, '2024-01-30', '37.7749', '-122.4194');
        MonthlyVisitViewerController.createVisitObjectType(accRec.Id, '2024-01-30', '37.7749', '-122.4194');
        MonthlyVisitViewerController.createVisitObjectTypev1(ldRec.Id, '2024-01-30', '37.7749', '-122.4194', '08:00', '10:00');
    }
    
    @isTest
    static void testGetRepLeads() {
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser87@example.com',
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        lead__c ldRec = UtilityTest.CreateLeadRec('fname', 'lName', 'test Org', 'North', 'email@gmail.com');
        ldRec.OwnerId = testUser.Id;
        update ldRec;
        Account accRec = UtilityTest.createAccRec('Testing data');
        accRec.OwnerId = testUser.Id;
        update accRec;
        MonthlyVisitViewerController.getRepLeads(testUser.LastName, 'Test Location');
         MonthlyVisitViewerController.getRepAccounts(testUser.LastName, 'Test Location');
    }
    
    
    @isTest
    static void testDeleteEvent() {
        Account accRec = UtilityTest.createAccRec('Testname');
        Visit__c vRec = UtilityTest.createVisitRec(System.today(), accRec.Id);
        // vRec.Lead__c = ldRec.id;
        vRec.Assigned_User__c = UserInfo.getUserId();
        vRec.Planned_Visit_Date__c = System.today();
        vRec.Actual_Visit_Date__c = System.today();
        vRec.Geo_Location__Latitude__s = 12.951845;
        vRec.Geo_Location__Longitude__s = 77.699577;    
        update vRec;
        MonthlyVisitViewerController.deleteEvent(vRec.Id);
    }
    
    @isTest
    static void testGetUserVisitsUpdated() {
        String testRouteName = 'TestRoute';
        String testObjectType = 'Account'; // or 'Lead' 
        Test.startTest();
        Map<String, Object> resultPageData = MonthlyVisitViewerController.getUserVisitsUpdated(testRouteName, testObjectType);
        Test.stopTest();
        if (testObjectType == 'Account') {
            List<Account> accountList = (List<Account>)resultPageData.get('accountList');
        } else if (testObjectType == 'Lead') {
            List<Lead> leadList = (List<Lead>)resultPageData.get('leadList');
        } else {
            
        }
    }
    
    @isTest
    static void testFetchGroupMember() {
        String testAssignmentGroupLocation = 'TestAssignmentGroup';
        Assignment_Group__c ag= new Assignment_Group__c();
        ag.Name = testAssignmentGroupLocation;
        ag.Minimum_Lead_Volume__c = 999;
        ag.Lead_Stage__c = 'New';
        ag.Group_Type__c = 'Lead';
        insert ag;
        
        Assignment_Group_Member__c AGrpM = new Assignment_Group_Member__c();
        AGrpM.Assignment_Group__c = ag.Id;
        AGrpM.Group_Member__c = UserInfo.getUserId();
        insert AGrpM;
        
        Test.startTest();
        MonthlyVisitViewerController.fetchGroupmemeber(testAssignmentGroupLocation);
        Test.stopTest();
    }
    
}