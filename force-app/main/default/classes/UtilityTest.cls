public class UtilityTest {
    
    public static User createUser(){
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser01@example.com',
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        return testUser;  
    }   
    
    public static User createUserDynamic(String username){
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = username,
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        return testUser;  
    }   
    
    public static User createUserCustomService(){ 
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Service'].Id,
            FirstName = 'Test 1',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuseqwertr@example.com',
            Alias = 'tufser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        return testUser;
    }   
    
    public static Opportunity1__c CreateOppRec(String name,String accountId,Date closedate,string userId,String stage,String region){
        Opportunity1__c oppRec = new Opportunity1__c(Name = name,AccountId__c =accountId,CloseDate__c = closedate,Customer_Success__c=userId,StageName__c=stage,Region__c = region);
        insert oppRec;
        return oppRec;
    }
    
    public static Product1__c createProdRec(String name,String ProductCode,String family,String vertical,String method,String Depatment, Boolean isactive){
        Product1__c prodRec = new Product1__c(Name=name, ProductCode__c=ProductCode, Family__c=family, Vertical__c=vertical,Method__c=method,Department__c=Depatment,IsActive__c=isactive);
        Insert prodRec;
        Return prodRec;
    }
    
    public static Opportunity1__c CreateOppRecCustomerService(String name,String accountId,Date closedate,string userId,String stage,String region){
        Opportunity1__c oppRec = new Opportunity1__c(Name = name,AccountId__c =accountId,CloseDate__c = closedate,Customer_Success__c=userId,StageName__c=stage,Region__c = region);
        insert oppRec;
        return oppRec;
    }
    
    public static OpportunityLineItem1__c createOliRec(String OppId,String ProductId,Integer Quantity,Integer ListPrice,Integer UnitPrice,Integer Subtotal, Integer TotalPrice,String ProductCode){
        OpportunityLineItem1__c newOli = new OpportunityLineItem1__c(Opportunity1Id__c = OppId,Product1Id__c = ProductId, Quantity__c = Quantity,ListPrice__c = ListPrice,UnitPrice__c = UnitPrice,Subtotal__c = Subtotal,TotalPrice__c = TotalPrice,ProductCode__c = ProductCode);
        Insert newOli;
        Return newOli;
    }
    
    public static QuoteLineItems_c__c createQLIRec(String QuoteId, String ProdId, Integer Quantity,Integer ListPrice,Integer SalesPrice,Integer discount,Integer Subtotal, Integer TotalPrice,String ProductCode){
        QuoteLineItems_c__c qliRec = new QuoteLineItems_c__c(QuoteId__c=QuoteId,ProductId__c=ProdId,Quantity__c=Quantity,List_Price__c=ListPrice,Sales_Price__c=SalesPrice,Discount__c=discount,Subtotal__c=Subtotal,Total_Price__c=TotalPrice,Product_Code__c=ProductCode);
        Insert qliRec;
        Return qliRec;
    }
    
    public static Lead__c createLeadRec(String fname,String lName,String cmpName,String region,String email, String VertcialSegment){
        Lead__c leadRec = new Lead__c(First_Name__c = fname,Name = lName,Company__c = cmpName,Region__c = region,Email__c = email, Vertical_Segment__c =VertcialSegment );
        insert leadRec;
        return leadRec;
    }      
    
    public static Account createAccRec(String name ){
        Account accRec = new Account(Name = name );
        insert accRec;
        return accRec;
    }
    
    public static Contact createConRec(String fName,String lName){
        Contact con = new Contact(FirstName = fName,LastName = lName);
        insert con;
        return con;
    }
    
    public Static Case createCsRec(Id accountId,Id contactId,String Status,String origin,String Reason,String priority,String type,String subject,String description){
        Case caseRec = new Case(AccountId=accountId,ContactId=contactId,Status = status,Origin = origin,Reason = reason,Priority = priority,Type=type,Subject= subject,Description = description );
        insert caseRec;
        return caseRec;
    } 
    
    public Static Feedback__c createFbRec(Id accountId,String branch,String description,String userId,Integer rating,Id contactId){
        Feedback__c fb = new Feedback__c(Account__c=accountId,Branch__c=branch,Description__c=description,Feedback_For__c=userId,Feedback_Rating__c=rating,Gieven_By__c=contactId);
        insert fb;
        return fb;
    }
    
    public Static Quote_C__c createQuoteRec(Id accountId,String name,String description,String status,Id contactId,String oppId ){
        Quote_C__c qu = new Quote_C__c(AccountId__c=accountId,Name=name,Description__c=description,Status__c=status,ContactId__c=contactId,OpportunityId__c=oppId);
        insert qu;
        return qu;
    }
    
    public Static Sample_Update__c createSuRec(Id oppRec,String qtName,String description,String userId){
        Sample_Update__c su = new Sample_Update__c(Opportunity1_Name__c=oppRec,Quote_Name__c=qtName,Business_Manager__c = userId);
        insert su;
        return su;
    }
    
    public Static Visit__c createVisitRec(Date visitdate,Id accountId){
        Visit__c vsRec = new Visit__c(Planned_Visit_Date__c =visitdate,Account__c = accountId);
        
        insert vsRec;
        return vsRec;
    }
    
    public Static Monthly_Beat_Plan__c createMBPRec(String appStatus,string userId,Date endDate,String month,Date startDate,String status){
        Monthly_Beat_Plan__c mbp = new Monthly_Beat_Plan__c(Approval_Status__c = appStatus,Sales_User__c =userId,End_Date__c = endDate,Month_Name__c=month,Start_Date__c=startDate,Status__c=status);
        insert mbp;
        return mbp;
    }
    
    public Static Weekly_Beat_Plan__c createWBPRec(Date endweek,Date startweek,String wkIdentifer,String wkNumber,String mbpId){
        Weekly_Beat_Plan__c wbp = new Weekly_Beat_Plan__c(End_Day_of_Week__c = endweek,Start_Day_of_Week__c = startweek, Week_Identifier__c= wkIdentifer,Week_Number__c = wkNumber,Monthly_Beat_Plan__c= mbpId);
        insert wbp;
        return wbp;
    }
    
    public Static Monthly_Travel_Expense__c createMTERec(String name,String status,Date startDate,Date endDate,Date mteDate,string userId){
        Monthly_Travel_Expense__c mte = new Monthly_Travel_Expense__c(Name = name,Approval_Status__c =status,Start_Date__c = startDate,End_Date__c= endDate,MTE_Date__c = mteDate,Sales_User__c = userId);
        insert mte;
        return mte;
    }
    
    public Static Day_Visit_Plan__c createDVPRec(string userId,Date startDay,String monthName,String monthYear,Date startDate,Date endDate,String mtexpID){
        Day_Visit_Plan__c dvp = new Day_Visit_Plan__c(Service_Executive__c = userId,Start_Day__c = startDay,Month_Name__c = monthName,Month_Year__c = monthYear,Start_Date__c = startDate,End_Date__c = endDate,Monthly_Travel_Expense__c = mtexpID);
        insert dvp;
        return dvp;
    }
    
    public Static Task__c createTask(String subject,String priority,String status,String leadId,String opportunityId,Date dueDate,String AssignedTo){
        Task__c tassk = new Task__c(Subject__c= subject,Priority__c = priority,Status__c = status,Lead__c= leadId,Opportunity1Id__c = opportunityId,ActivityDate__c = dueDate,Assigned_To__c=AssignedTo);
        insert tassk;
        return tassk;
    }
    
    public Static Roles_and_KPI__c createKPIRec(String name,boolean isActive ,Id userID){
        Roles_and_KPI__c Rkpi = new Roles_and_KPI__c(Name= name,IsActive__c = isActive,Sales_User__c = userID);
        insert Rkpi;
        return Rkpi;
    }
    
    public Static KPI_Target__c createKPIRec(Integer aCount,Id userId,Integer tCount,Id rolKpiId,Id mbpId){
        KPI_Target__c kpi = new KPI_Target__c(Achieved_Count__c= aCount,Sales_User__c = userId,Target_Count__c= tCount,Roles_and_KPI__c = rolKpiId,Monthly_Beat_Plan__c = mbpId);
        insert kpi;
        return kpi;
    }
    
    Public Static Yearly_Goal__c createYgRec(String name, String UserId, String fyId){
        Yearly_Goal__c ygRec = new Yearly_Goal__c(Name=name, User__c=UserId,Fiscal_Year__c=fyId);
        Insert ygRec;
        Return ygRec;
    }
    
     Public Static Incentive_Plan__c createIpRec(String name, String userId, Decimal target){
        Incentive_Plan__c IpRec = new Incentive_Plan__c(Name=name, User__c=userId,Target__c=target);
        Insert IpRec;
        Return IpRec;
    } 
    
    Public Static Fiscal_Year__c createfyRec(String name, String IncentivePlanId, Date FiscalYearStartPeriod ){
        Fiscal_Year__c fyRec = new Fiscal_Year__c(Name=name, Incentive_Plan__c=IncentivePlanId, Fiscal_Year_Start_Period__c = FiscalYearStartPeriod );
        Insert fyRec;
        Return fyRec;
    } 
    
    Public Static Quarterly_Goal__c createQuaRec(String name, String userId, String ygId, String fyId){
        Quarterly_Goal__c qgRec = new Quarterly_Goal__c(Name=name, User__c=userId,Yearly_Goal__c=ygId,Fiscal_Year__c=fyId);
        Insert qgRec;
        return qgRec;
    }
    
    Public static Monthly_Incentive_Goal__c createMIGRec(String name, String userId, String quarterId, String accId,String fyId){
        Monthly_Incentive_Goal__c mig = new Monthly_Incentive_Goal__c(Name=name,User__c=userId,Quarterly_Goal__c=quarterId,Account__c=accId,Fiscal_Year__c=fyId);
        Insert mig;
        return mig;
    }
    
    Public Static Product_Target_Detail__c createPtdRec(String Product, String YearlyGoal,Decimal AchievedTarget){
        Product_Target_Detail__c ptd = new Product_Target_Detail__c(Product__c=Product,Yearly_Goal__c=YearlyGoal,Achieved_Target__c=AchievedTarget);
        insert ptd;
        return ptd;
    }
    
}