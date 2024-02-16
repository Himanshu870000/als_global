@isTest
public class FullCalendarControllerTest {
    
    @isTest
    Static Void FullCalendarControllerTestMethod(){
        //User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('TestAccount');
        String accReccreatedId = [Select id, CreatedById from Account where id =:accRec.Id].CreatedById;
        System.deBug('accReccreatedId::'+accReccreatedId);
        Contact ConRec = UtilityTest.createConRec('Test','Contact');
        //Opportunity1__c oppRec = UtilityTest.CreateOppRec('Testoppty',accRec.Id, Date.newInstance(2024, 12, 12),UserInfo.getUserId(),'New','West');
        
        Datetime startDateTime = Datetime.newInstance(2024, 2, 5, 10, 0, 0);
        Datetime endDateTime = Datetime.newInstance(2024, 2, 15, 12, 0, 0);
        
        Event ent = new Event();
        ent.Subject = 'Test Event Description';
        ent.StartDateTime = startDateTime;
        ent.EndDateTime = endDateTime;
        ent.WhoId = ConRec.Id ;
        ent.WhatId = accRec.Id;
        Insert ent;
        
        Monthly_Beat_Plan__c mbp = UtilityTest.createMBPRec('In Progress',UserInfo.getUserId(), Date.newInstance(2024, 12, 30), 'February', Date.newInstance(2024, 12, 12), 'Draft');
        Weekly_Beat_Plan__c wbp = UtilityTest.createWBPRec(Date.newInstance(2024, 12, 30), Date.newInstance(2024, 12, 10), 'W1', 'Week 1', mbp.Id);
        Roles_and_KPI__c rkp =  UtilityTest.createKPIRec('Test Role and Kpi', true, UserInfo.getUserId());
        String rkiReccreatedId = [Select id, CreatedById,Name from Roles_and_KPI__c where id =:rkp.Id].Name;
        System.deBug('rkiReccreatedId::'+rkiReccreatedId);
        KPI_Target__c kpt = UtilityTest.createKPIRec(10, UserInfo.getUserId(), 20, rkp.Id , mbp.Id);
        String kpiReccreatedId = [Select id, CreatedById,KPI_Target_Name__c from KPI_Target__c where id =:kpt.Id].KPI_Target_Name__c;
        System.deBug('kpiReccreatedId::'+kpiReccreatedId);
        Visit__c vrec = UtilityTest.createVisitRec(Date.newInstance(2024, 2, 10), accRec.Id);
        
        Visit__c vsrec = new Visit__c();
        vsrec.Id = vrec.Id;
        vsrec.Weekly_Beat_Plan__c = wbp.Id;
        update vsrec;
        
        FullCalendarController.getEvents();
        FullCalendarController.BeetplannerDatareturn('February', '2024');
        FullCalendarController.getWeeklyKPI(mbp.Id);
        FullCalendarController.formatDate(Date.newInstance(2024, 12, 30));
    }
}