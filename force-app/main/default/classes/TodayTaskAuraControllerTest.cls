@IsTest
public class TodayTaskAuraControllerTest {
   
    @isTest
    Static Void TodayTaskAuraControllerTestMethod(){
        List<Visit__c> visitList = new List<Visit__c>();
        
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('TestName');
        Account acc = new Account();
        acc.Id = accrec.Id;
        acc.BillingStreet = 'btm';
        acc.BillingCity = 'Banglore';
        acc.BillingState = 'KA';
        acc.BillingPostalCode = '560076';
        acc.BillingCountry = 'IN';
        acc.Geo_Location__Latitude__s = 12.9296628;
        acc.Geo_Location__Longitude__s = 77.5915664;
        update acc;
        Contact conRec = UtilityTest.createConRec('Test','Name');
        //Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('TestOpportunity', accRec.Id, Date.newInstance(2024,12,12), userRec.Id, 'New','North');
        Opportunity1__c oppRec = UtilityTest.CreateOppRec('TestOpportunity', accRec.Id, Date.newInstance(2024,12,12), userRec.Id, 'New', 'North');
        System.debug('Opportunity Id from test Class ==>'+oppRec.Id);
      /*
         Opportunity1__c oppRec = new Opportunity1__c();
        oppRec.Name = '';
        oppRec.AccountId__c = '';
        oppRec.CloseDate__c = ;
        system.debug('Opportunity Id from test Class ==>'+opp.Id);
*/
        Case caseRec = UtilityTest.createCsRec(accRec.Id, conRec.Id, 'On Hold', 'Phone', 'Test Reason', 'High', 'Problem', 'Test Subject', 'Test Description');
        Monthly_Beat_Plan__c mbpRec = UtilityTest.createMBPRec('In Progress',userRec.Id,Date.newInstance(2024,12,30) , 'January', Date.newInstance(2024,12,12), 'Draft');
        Weekly_Beat_Plan__c wbpRec = UtilityTest.createWBPRec(Date.newInstance(2024,12,30), Date.newInstance(2024,12,12), 'W4', 'Week 4', mbpRec.Id);
        Monthly_Travel_Expense__c mteRec = UtilityTest.createMTERec('Test','In Progress',Date.newInstance(2024,12,12),Date.newInstance(2024,12,31),Date.newInstance(2024,12,20),UserInfo.getUserId());
        Day_Visit_Plan__c dvpRec = UtilityTest.createDVPRec(UserInfo.getUserId(), Date.newInstance(2024,12,12), 'January', '2024', Date.newInstance(2024,12,12), Date.newInstance(2024,12,31), mteRec.Id);
        Visit__c vRec = UtilityTest.createVisitRec(Date.newInstance(2024,12,12), accRec.Id);
        Visit__c vst = new Visit__c();
        vst.Id = vRec.Id;
        vst.Planned_Visit_Date__c = Date.newInstance(2024,12,12);
        vst.Monthly_Beat_Plan__c = mbpRec.Id;
        vst.Assigned_User__c = userRec.Id;
        vst.Weekly_Beat_Plan__c = wbpRec.Id;
        update vst;
        visitList.add(vst);
        Task testTask = new Task();
        testTask.Subject = 'Test Mom Activity Task';
        testTask.Visit__c = vRec.Id;
        testTask.Is_Mom_Activity__c = true;
        testTask.WhoId = conRec.Id;
        testTask.WhatId = accRec.Id;
        insert testTask; 
        
        TodayTaskAuraController.createVisitActivity(oppRec.Id, vst.Id);
        TodayTaskAuraController.getAllVisitTodays('2024-12-12'); //Date.today().format()
        TodayTaskAuraController.GetCompletedVisitRecords(Date.today().format());
        TodayTaskAuraController.getSelectedVisitDetails(vst.Id);
        TodayTaskAuraController.StartDayVisitForVistitRecord('12.9296628', '77.5915664', visitList);
        TodayTaskAuraController.updateEndDayVisitRecord('37.531319', '-82.100868');
        TodayTaskAuraController.updateAmendVisitRecord(vst);
        TodayTaskAuraController.saveTask(testTask);
        TodayTaskAuraController.LogCall(testTask);
        TodayTaskAuraController.LogCall(testTask);
        TodayTaskAuraController.saveOpportunity(oppRec);
        TodayTaskAuraController.saveCase(caseRec);
        TodayTaskAuraController.checkInUpdateVisit('12.9296628', '77.5915664',vst.Id);
        TodayTaskAuraController.checkOutUpdateVisit('12.9296628', '77.5915664',vst.Id);
        TodayTaskAuraController.getPastVisitDetails(acc.Id);
        TodayTaskAuraController.getRelOppList(acc.Id);
        TodayTaskAuraController.getRelInvoiceList(acc.Id);
        TodayTaskAuraController.getRelCaseList(acc.Id);
        TodayTaskAuraController.getRelTaskList(acc.Id);
        TodayTaskAuraController.getTodayVisitRecordListNew();
        TodayTaskAuraController.createMomActivityLog('Test Description', vst.Id, 'Test Subject', userRec.Id, 'util@gmail.com');
        TodayTaskAuraController.checkMomActivityBeforeCheckOutVisit(vst.Id);
    }
    
}