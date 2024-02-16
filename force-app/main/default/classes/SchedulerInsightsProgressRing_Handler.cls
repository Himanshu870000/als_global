public class SchedulerInsightsProgressRing_Handler {
    
    @AuraEnabled
    public static List<Roles_and_KPI__c> getRoleAndKPI(){
        //List<Roles_and_KPI__c> getAllRAKList = [Select Id,Name From Roles_and_KPI__c Where Sales_User__c =: userInfo.getUserId() ];
        List<Roles_and_KPI__c> getAllRAKList = [Select Id,Name From Roles_and_KPI__c];
        //System.debug('getAllRAKList ==>'+getAllRAKList.Sales_User__r.Name);
        System.debug('getAllRAKList ==>'+getAllRAKList);
        return getAllRAKList;
    }
    
    @AuraEnabled
    public static List<KPI_Target__c> getCountOfVisitsForDifferentKPIs(String monthName, String monthYear){
        System.debug('monthName SchedulerInsightsProgressRing_Handler ==>'+monthName+'monthYear SchedulerInsightsProgressRing_Handler'+monthYear);
        Map<String, Integer> monthNumberByName = new Map<String, Integer>{'January' => 1, 'February' => 2, 'March' => 3, 'April' => 4, 'May' => 5, 'June' => 6,
            'July' => 7, 'August' => 8, 'September' => 9, 'October' => 10, 'November' => 11, 'December' => 12};
                Integer monthNumber = monthNumberByName.get(monthName);
        Integer yearNumber = Integer.valueOf(monthYear);
        Id currUserId = UserInfo.getUserId();
        
        List<KPI_Target__c> allKPItargetForCurrUser = [SELECT Id, Name, Monthly_Beat_Plan__c, KPI_Target_Name__c, Achieved_Count__c, Target_Count__c FROM KPI_Target__c WHERE OwnerId=:currUserId AND Monthly_Beat_Plan__r.Month_Name__c =: monthName AND Monthly_Beat_Plan__r.Year__c=:monthYear];
        System.debug('allKPItargetForCurrUser ==> '+allKPItargetForCurrUser);
        return allKPItargetForCurrUser;
    }
}