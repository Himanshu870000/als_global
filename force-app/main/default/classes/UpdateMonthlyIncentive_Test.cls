@isTest
public class UpdateMonthlyIncentive_Test {

    @isTest
    static void testUpdateMonthlyIncentiveOnStageClosedWon() {
        
        List<Opportunity1__c> oppList = new List<Opportunity1__c>();
        Map<Id, Opportunity1__c> oppmap = new Map<Id, Opportunity1__c>();
        
        User useRec = UtilityTest.createUserDynamic('miguser@gmail.com');
        
        Account accRec = UtilityTest.createAccRec('Banoj');
        
        Contact conRec = UtilityTest.createConRec('test', 'contact');
        
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar', accRec.id, System.today(), useRec.id, 'New', 'South');
        oppmap.put(oppRec.Id, oppRec);
        Opportunity1__c opp = new Opportunity1__c();
        opp.Id = oppRec.Id;
        opp.StageName__c = 'Closed Won';
        update opp;
        oppList.add(opp);
        
        Incentive_Plan__c iprec = UtilityTest.createIpRec('Test incentive plan',useRec.Id, 10);
        
        Fiscal_Year__c fyRec= UtilityTest.createfyRec('Test Fiscal Year', iprec.Id);
        
        Yearly_Goal__c ygRec = UtilityTest.createYgRec('Test Year',useRec.Id, fyRec.Id);
        
        Quarterly_Goal__c qgrec = UtilityTest.createQuaRec('Test Quater',useRec.Id, ygRec.Id, fyRec.Id);
        
        Monthly_Incentive_Goal__c migRec = UtilityTest.createMIGRec('Test Month',useRec.Id, qgrec.Id,accRec.Id,fyRec.Id);
        
        //UpdateMonthlyIncentive.UpdateMonthlyIncentiveOnStageClosedWon(oppList, oppmap);
   
    }
}