@isTest
public class ProductAchievedTargetBifurcationTest {

    @isTest
    Static Void ProductAchievedTargetBifurcationTestMethod(){
        List<Opportunity1__c> newoliList = new List<Opportunity1__c>();
		Map<Id,Opportunity1__c> oldoliList = new Map<Id,Opportunity1__c>();
        
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('TestAcc');
        String accReccreatedId = [Select id, CreatedById from Account where id =:accRec.Id].CreatedById;
        System.deBug('accReccreatedId::'+accReccreatedId);
        Opportunity1__c oppRec = UtilityTest.CreateOppRec('Testoppty',accRec.Id, Date.newInstance(2024, 12, 12),userRec.Id,'New','West');
        newoliList.add(oppRec);
        
        Product1__c prodRec = UtilityTest.createProdRec('Test Product','TP','Food','Food','TESTMETHOD','Chemistry',true);
        OpportunityLineItem1__c oliRec = UtilityTest.createOliRec(oppRec.Id,prodRec.Id,10,100,90,900,900,'TP');
        String oliOwnerId = [Select id, CreatedById from OpportunityLineItem1__c where id =:oliRec.Id].CreatedById;
        System.deBug('olicreatedbyId::'+oliOwnerId);
        Incentive_Plan__c ipRec = UtilityTest.createIpRec('Test Incentive Plan',userRec.Id,5);
        Fiscal_Year__c fyRec= UtilityTest.createfyRec('test FyRecord', ipRec.Id ,Date.newInstance(2024, 12, 12) );
        //Yearly_Goal__c ygRec = UtilityTest.createYgRec('Test Ygrecord', userRec.Id, fyRec.Id);
        Yearly_Goal__c Yy = new Yearly_Goal__c();
        Yy.Yearly_Goal_Start_Period__c = Date.newInstance(2024, 12, 11);
        Yy.Name = 'Testomg';
        Yy.User__c=oliOwnerId;
        System.debug('yearly goal record Yy.User__c=userRec.Id;==>oliRec.Id'+oliRec.CreatedById);
        Yy.Fiscal_Year__c = fyRec.Id;
        Yy.Yearly_Target__c = 250000;
        Yy.Yearly_Goal_End_Period__c = Date.newInstance(2024, 12, 30);
        insert Yy; 
        Quarterly_Goal__c qgRec = UtilityTest.createQuaRec('Test Quarter', userRec.Id,Yy.Id ,fyRec.Id);
        //Product_Target_Detail__c ptdRec = UtilityTest.createPtdRec(prodRec.Id,Yy.Id, 50);
        
        Product_Target_Detail__c prodTd = new Product_Target_Detail__c();
        prodTd.Yearly_Goal__c = Yy.Id;
        prodTd.Product__c = prodRec.Id;
        prodTd.Achieved_Target__c = 50000;
        prodTd.Quarterly_Goal__c = qgRec.Id;
        prodTd.Target_Order_Value__c = 70000;
        prodTd.Close_Order_Value__c = 60000;
        Insert prodTd;
               
           Opportunity1__c oli = new Opportunity1__c();
        oli.Id = oppRec.Id;
        oli.StageName__c = 'Closed Won';
        oli.PO_Date__c = Date.newInstance(2024, 12, 12);
        oli.PO_Number__c = '123';
        oli.Billing_Address__Street__s ='Appollo Hospital';
        oli.Billing_Address__City__s = 'Bengaluru';
        oli.Billing_Address__StateCode__s = 'KA';
        oli.Billing_Address__PostalCode__s = '560076';
        oli.Billing_Address__CountryCode__s = 'IN';
        oli.Quarterly_Goal__c = qgRec.Id;
        update oli;
        oldoliList.put(oppRec.Id,oppRec);
        newoliList.add(oli);
        
        ProductAchievedTargetBifurcation.CreateProductTargetBifurcation(newoliList, oldoliList);
    }
}