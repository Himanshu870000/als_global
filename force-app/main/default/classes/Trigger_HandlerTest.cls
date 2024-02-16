@isTest
public class Trigger_HandlerTest {
    @isTest static void FirstMethod(){
        List<Fiscal_Year__c> fList = new List<Fiscal_Year__c>();
        Fiscal_Year__c fy = new Fiscal_Year__c();
        fy.Fiscal_Year_Start_Period__c = system.today();
        fy.Name = 'Testomg';
        insert fy;
        fList.add(fy);
        Trigger_Handler.CreateQuarterPeriodsRec(fList);
    }
    @isTest static void secondMethod(){
        Fiscal_Year__c fy = new Fiscal_Year__c();
        fy.Fiscal_Year_Start_Period__c = system.today();
        fy.Name = 'Testomg';
        insert fy;
        List<Yearly_Goal__c> yList = new List<Yearly_Goal__c>();
        Yearly_Goal__c Yy = new Yearly_Goal__c();
        Yy.Yearly_Goal_Start_Period__c = system.today();
        Yy.Name = 'Testomg';
        Yy.Fiscal_Year__c = fy.Id;
        Yy.Yearly_Target__c = 250000;
        Yy.Yearly_Goal_End_Period__c = system.today()+10;
        insert Yy; 
        yList.add(Yy);
       Trigger_Handler.CreateQuarterlyGoalRec(yList);
    }

}