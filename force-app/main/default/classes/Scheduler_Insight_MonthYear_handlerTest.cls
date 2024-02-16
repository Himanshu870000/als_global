@isTest
public class Scheduler_Insight_MonthYear_handlerTest { 
    
   @isTest
    static void testGetMonthBeatPlan() {
        
        User userRec =UtilityTest.createUserDynamic('tushar@util.com');
           
        Monthly_Beat_Plan__c mbpRec = UtilityTest.createMBPRec('In Progress',UserInfo.getUserId(),System.today(),'January',System.today(),'Approved');
        
        Scheduler_Insight_MonthYear_handler.getMonthBeatPlan('January', '2024');
    }
    @isTest
    static void testGetMonthlyRecord() {
        Monthly_Travel_Expense__c mteRec = UtilityTest.createMTERec('MTEtest - January', 'Approved', System.today(), System.today(), System.today(), UserInfo.getUserId());
        Day_Visit_Plan__c dvpRec = UtilityTest.createDVPRec(UserInfo.getUserId(), System.today(), 'January', '2024', System.today(), System.today(), mteRec.Id);
       // dvpRec.Total_Distance__c = 100;
        dvpRec.Total_Covered_Distance__c = 102;
        update dvpRec;
        
         Scheduler_Insight_MonthYear_handler.getMonthlyRecord('January', '2024'); 
    }
    
    @isTest
    static void testSaveFilesUnderMTE() {
        Monthly_Travel_Expense__c mteRec = UtilityTest.createMTERec('MTEtest - January', 'Approved', System.today(), System.today(), System.today(), UserInfo.getUserId());
       // mteRec.Month_Name__c = 'January';
        update mteRec;

         Scheduler_Insight_MonthYear_handler.saveFilesUnderMTE('January', '2024');
    }
}