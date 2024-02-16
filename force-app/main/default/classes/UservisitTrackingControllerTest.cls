@isTest
public class UservisitTrackingControllerTest {
  
    
    @isTest
    static void testCreateVisitPlanAcrossUser() {
        Account accRec = UtilityTest.createAccRec('Test Account');
        Visit__c vRec = UtilityTest.createVisitRec(System.today(), accRec.Id);
        vRec.Planned_visit_date__c = System.today();
        vRec.Geo_Location__Latitude__s = 12.951845;
        vRec.Geo_Location__Longitude__s = 77.699577;
        vRec.Assigned_User__c = UserInfo.getUserId();
        update vRec;
        UservisitTrackingController.createVisitPlanAcrossUser( 37.7749,-122.4194,UserInfo.getUserId(),String.valueOf(vRec.Planned_Visit_Date__c));
        UservisitTrackingController.fetchPlannedVisitDetails('2024-02-01');
        UservisitTrackingController.changePlannedVisitdate('2024-02-01',vRec.id);
        UservisitTrackingController.userPopulated('2024-02-01',UserInfo.getUserId(), 37, -122);
    }
    
    @isTest
    static void testEndDay() {
        Monthly_Travel_Expense__c mteRec = UtilityTest.createMTERec('testName', 'Approved', System.today(), System.today(), System.today(), UserInfo.getUserId());
        Day_Visit_Plan__c dvpRec = UtilityTest.createDVPRec(UserInfo.getUserId(), System.today(), 'January', '2024', System.today(), System.today(), mteRec.Id);
        dvpRec.End_Location__Latitude__s = 37.7749;
        dvpRec.End_Location__Longitude__s = -122.4194;
        update dvpRec;
        
        UservisitTrackingController.endDay(dvpRec.End_Location__Latitude__s,dvpRec.End_Location__Longitude__s,UserInfo.getUserId(),dvpRec.Id);
    }
}