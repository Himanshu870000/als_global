public class TodayTaskAuraController {
    
    
    @AuraEnabled
    public static void createVisitActivity(Id opportunityId, Id visitId) {
        System.debug('opportunityId------>'+opportunityId);
        System.debug('visitId----->'+visitId);
        if (opportunityId != null && visitId != null) {
            Visit_Activity__c visitActivity = new Visit_Activity__c();
            visitActivity.Opportunity1__c = opportunityId;
            visitActivity.Visit__c = visitId;
            
            Opportunity1__c oppRec = new Opportunity1__c();
            oppRec.Id = opportunityId;
            oppRec.Visit__c = visitId;
            
            try {
                insert visitActivity;
                update oppRec;
                System.debug('Visit_Activity__c record created successfully.');
            } catch (Exception e) {
                System.debug('Error creating Visit_Activity__c record: ' + e.getMessage());
            }
        } else {
            System.debug('Opportunity Id and/or Visit Id is null. Visit_Activity__c record not created.');
        }
    }
    
    //==========================================================================================================================================================
    //method for getting all visit records based on date passed
    @AuraEnabled
    public static todaytaskWrapper getAllVisitTodays(String visitDate){
        System.debug('visitDate-------->'+visitDate);
        List<Visit__c> visitListToShow = new List<Visit__c>();
        try{
            if(String.isNotBlank(visitDate)){
                String[] arrTest = visitDate.split('T');
                string[] dateArray = arrTest[0].split('-');
                Integer year = Integer.valueOf(dateArray[0]);
                Integer month = Integer.valueOf(dateArray[1]);
                Integer day = Integer.valueOf(dateArray[2]);
                date VisitFormatedDate = date.newInstance(year, month, day);
                System.debug('VisitFormatedDate==>'+VisitFormatedDate);
                Id currentUserId = UserInfo.getUserId();
                System.debug('currentUserId==>'+currentUserId);
                visitListToShow = [SELECT Id, Name, Status__c, Account__c, Duration__c, Account__r.Name, Account__r.Website, Account__r.Email__c, Account__r.Phone,  Visit_Time__c,Visit_Status__c,Check_In_Time__c,
                                   Planned_Visit_Date__c, Weekly_Beat_Plan__c, KPI_Target__c, KPI_Target__r.KPI_Target_Name__c,Account__r.BillingStreet, Account__r.BillingCity, Account__r.BillingState,
                                   Account__r.BillingPostalCode,Account__r.BillingCountry,Geo_Location__latitude__s, Geo_Location__longitude__s, Weekly_Beat_Plan__r.Monthly_Beat_Plan__r.Approval_Status__c,Expected_Start_Time__c FROM Visit__c 
                                   WHERE Planned_Visit_Date__c=:VisitFormatedDate AND Account__r.BillingStreet !=null AND Account__r.BillingCity !=null AND Assigned_User__c=: currentUserId AND Status__c != 'Completed'];
                if(visitListToShow.size()>0){
                    integer compVisitCount=0;
                    integer pendingVisitCount =0;
                    boolean approved = false;
                    for(Visit__c vs : visitListToShow){
                        System.debug('Approval Status-->'+ vs.Weekly_Beat_Plan__r.Monthly_Beat_Plan__r.Approval_Status__c);
                        if(vs.Weekly_Beat_Plan__r.Monthly_Beat_Plan__r.Approval_Status__c != null && vs.Weekly_Beat_Plan__r.Monthly_Beat_Plan__r.Approval_Status__c == 'Approved'){
                            approved = true;
                        }
                        if(vs.Status__c == 'PENDING'){
                            compVisitCount =  compVisitCount + 1;
                        }
                        if(vs.Status__c == 'COMPLETED'){
                            pendingVisitCount = pendingVisitCount + 1;
                        }
                    }
                    String userId = userInfo.getUserId();
                    system.debug('userId::'+userId);
                    List<Day_Visit_Plan__c> dayVisitList = [SELECT Id, Start_Day__c, End_Date__c FROM Day_Visit_Plan__c WHERE Start_Date__c=today AND Service_Executive__c =: userId];
                    System.debug('dayVisitList === >'+dayVisitList);
                    System.debug('compVisitCount === >'+compVisitCount);
                    System.debug('pendingVisitCount === >'+pendingVisitCount);
                    todaytaskWrapper wrap = new todaytaskWrapper();
                    wrap.isApproved = approved;
                    wrap.visitList = visitListToShow;
                    wrap.completedVisit = compVisitCount;
                    wrap.pendingVisit = pendingVisitCount;
                    if(!dayVisitList.isEmpty()){
                        wrap.dvpList = dayVisitList;
                    }
                    System.debug('wrap Data === >'+wrap);
                    return wrap;
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    //  ==========================================================================================================================================================    
    @AuraEnabled
    public static todaysCompletedTaskWrapper GetCompletedVisitRecords(String visitDate){
        System.debug('visitDate------>'+visitDate);
        List<Visit__c> visitListToShow = new List<Visit__c>();
        try{
            if(String.isNotBlank(visitDate)){
                String[] arrTest = visitDate.split('T');
                string[] dateArray = arrTest[0].split('-');
                Integer year = Integer.valueOf(dateArray[0]);
                Integer month = Integer.valueOf(dateArray[1]);
                Integer day = Integer.valueOf(dateArray[2]);
                date VisitFormatedDate = date.newInstance(year, month, day);
                Id currentUserId = UserInfo.getUserId();
                visitListToShow = [SELECT Id, Name, Status__c, Account__c, Duration__c,District__c,Actual_Visit_Date__c, Visit_Objective__c, Taluk__c, Night_stay__c, Account__r.Name, Account__r.Website, Account__r.Email__c, Account__r.Phone,  Visit_Time__c,Visit_Status__c,Check_In_Time__c,
                                   Planned_Visit_Date__c, Weekly_Beat_Plan__c, KPI_Target__c, KPI_Target__r.KPI_Target_Name__c,Account__r.BillingStreet, Account__r.BillingCity, Account__r.BillingState,
                                   Account__r.BillingPostalCode,Account__r.BillingCountry,Geo_Location__latitude__s, Geo_Location__longitude__s, Weekly_Beat_Plan__r.Monthly_Beat_Plan__r.Approval_Status__c FROM Visit__c 
                                   WHERE Planned_Visit_Date__c=:VisitFormatedDate AND Account__r.BillingStreet !=null AND Account__r.BillingCity !=null AND Assigned_User__c=: currentUserId AND Status__c = 'Completed'];
                
                System.debug('visitListToShow----->'+visitListToShow);
                
                if(visitListToShow.size()>0){
                    integer compVisitCount=0;
                    integer pendingVisitCount =0;
                    boolean approved = false;
                    for(Visit__c vs : visitListToShow){
                        System.debug('Approval Status-->'+ vs.Weekly_Beat_Plan__r.Monthly_Beat_Plan__r.Approval_Status__c);
                        if(vs.Weekly_Beat_Plan__r.Monthly_Beat_Plan__r.Approval_Status__c != null && vs.Weekly_Beat_Plan__r.Monthly_Beat_Plan__r.Approval_Status__c == 'Approved'){
                            approved = true;
                        }
                        if(vs.Status__c == 'PENDING'){
                            compVisitCount =  compVisitCount + 1;
                        }
                        if(vs.Status__c == 'COMPLETED'){
                            pendingVisitCount = pendingVisitCount + 1;
                        }
                    }
                    String userId = userInfo.getUserId();
                    system.debug('userId::'+userId);
                    List<Day_Visit_Plan__c> dayVisitList = [SELECT Id FROM Day_Visit_Plan__c WHERE Start_Date__c=today AND Service_Executive__c =: userId];
                    System.debug('dayVisitList === >'+dayVisitList);
                    System.debug('compVisitCount === >'+compVisitCount);
                    System.debug('pendingVisitCount === >'+pendingVisitCount);
                    todaysCompletedTaskWrapper wrap = new todaysCompletedTaskWrapper();
                    wrap.isApproved = approved;
                    wrap.completedVisitList = visitListToShow;
                    wrap.completedVisit = compVisitCount;
                    wrap.pendingVisit = pendingVisitCount;
                    if(!dayVisitList.isEmpty()){
                        wrap.dvpList = dayVisitList;
                    }
                    System.debug('wrap Data === >'+wrap);
                    return wrap;
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    public class todaysCompletedTaskWrapper{
        @AuraEnabled
        public Integer completedVisit;
        @AuraEnabled
        public Integer pendingVisit;
        @AuraEnabled
        public List<Visit__c> visitList;
        @AuraEnabled
        public List<Visit__c> completedVisitList;
        @AuraEnabled
        public List<Day_Visit_Plan__c> dvpList;
        @AuraEnabled
        public boolean isApproved;
    }
    
    // ==========================================================================================================================================================================================================
    // Method get Selected Vist Recor Details
    @AuraEnabled
    public static Visit__c getSelectedVisitDetails(String visitId){
        Visit__c visitRec = new Visit__c();
        try{
            if(String.isNotBlank(visitId)){
                visitRec = [SELECT Id, Name, Status__c, Account__c, Duration__c, Account__r.Name, Account__r.Website, Account__r.Email__c, Account__r.Phone,  
                            CheckIn__Latitude__s, Check_Out__Latitude__s, Visit_Time__c, Planned_Visit_Date__c, Weekly_Beat_Plan__c, KPI_Target__c, KPI_Target__r.KPI_Target_Name__c,Account__r.BillingStreet, Account__r.BillingCity, Account__r.BillingState,Account__r.BillingPostalCode,Account__r.BillingCountry FROM Visit__c WHERE Id=:visitId LIMIT 1];
                if(visitRec !=null){
                    System.debug('visitRec === >'+visitRec);
                    return visitRec;
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    public class todaytaskWrapper{
        @AuraEnabled
        public Integer completedVisit;
        @AuraEnabled
        public Integer pendingVisit;
        @AuraEnabled
        public List<Visit__c> visitList;
        @AuraEnabled
        public List<Day_Visit_Plan__c> dvpList;
        @AuraEnabled
        public boolean isApproved;
    }
    
    // ==========================================================================================================================================================================================================
    // Method for Creating Day Visit Plan on Start Day Button Click
    @AuraEnabled
    public static Day_Visit_Plan__c StartDayVisitForVistitRecord(String startLat,String startLang,List<Visit__c> visitRecList){
        System.debug('startLat == >'+startLat + ' && startLang === >'+startLang + ' && visitRecList === >'+visitRecList);
        List<Visit__c> visitListToUpdate = new List<Visit__c>();
        DateTime todayDate = system.now();
        String monthName = todayDate.format('MMMMM');
        Date todayDate2 = system.today();
        //monthName = '\'%' + monthName + '%\'';
        String yearName = String.valueOf(todayDate.Year());
        Id currUserId = UserInfo.getUserId();
        System.debug('monthName-->'+ monthName);
        System.debug('yearName-->'+ yearName);
        Monthly_Travel_Expense__c mte;
        List<Monthly_Travel_Expense__c> mteList = [select id from Monthly_Travel_Expense__c WHERE Month_Name__c =:monthName AND Expense_Year__c =:yearName AND Sales_User__c =:currUserId limit 1];
        //Monthly_Travel_Expense__c mte = [select id from Monthly_Travel_Expense__c WHERE Month_Name__c =:monthName AND Expense_Year__c =:yearName AND Sales_User__c =:currUserId limit 1];
        System.debug('mteList-->' + mteList);
        if(mteList.size()==0){
            mte = new Monthly_Travel_Expense__c();
            String mteName = 'MTE - ' + monthName;
            mte.Name = mteName;
            mte.Sales_User__c = currUserId;
            mte.Start_Date__c = todayDate2.toStartOfMonth();
            mte.End_Date__c = todayDate2.addMonths(1).toStartofMonth().addDays(-1);
            insert mte;
        }else{
            mte = mteList[0];
        }
        try{
            if(String.isNotBlank(startLat) && string.isNotBlank(startLang)){
                Day_Visit_Plan__c vstPlan = new Day_Visit_Plan__c();
                vstPlan.Start_Location__Latitude__s =Decimal.valueOf(startLat);
                vstPlan.Start_Location__Longitude__s = Decimal.valueOf(startLang);
                vstPlan.Service_Executive__c = Userinfo.getUserId();
                vstPlan.Monthly_Travel_Expense__c = mte.Id;
                vstPlan.Start_Date__c = system.now();
                vstPlan.Start_Day__c = system.today();
                insert vstPlan;
                if(String.isNotBlank(vstPlan.Id)){
                    for(Visit__c vs : visitRecList){ 
                        vs.Visit_Plan__c = vstPlan.id;
                        visitListToUpdate.add(vs);
                    }
                    if(visitListToUpdate.size()>0){
                        update visitListToUpdate;
                        System.debug('Updated Visit Record ==== >'+visitListToUpdate);
                        if(visitListToUpdate.size()>0){
                            System.debug('Day Visit Plan Record ==>'+vstPlan);
                            return vstPlan;
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // ==========================================================================================================================================================================================================
    // Method for End Day Visit / Update End Location Update
    @AuraEnabled
    public static Day_Visit_Plan__c updateEndDayVisitRecord(String endLat,String endLong){
        Day_Visit_Plan__c  vstPlan = new Day_Visit_Plan__c();
        vstPlan = [select id from Day_Visit_Plan__c where Service_Executive__c =:UserInfo.getUserId() and Start_Date__c = today LIMIT 1];
        try{
            if(vstPlan != null){
                vstPlan.Id = vstPlan.Id;
                if(endLat != null)
                    vstPlan.End_Location__Latitude__s = Decimal.valueOf(endLat);
                if(endLong != null)
                    vstPlan.End_Location__Longitude__s = Decimal.valueOf(endLong);
                vstplan.End_Date__c = system.now();
                update vstPlan;
                System.debug('Updated Day Visit Plan Record ==== >'+vstPlan);
                return vstPlan;
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // ==========================================================================================================================================================================================================
    // Method for Ahmed Visit Update
    @AuraEnabled
    public static Visit__c updateAmendVisitRecord(Visit__c visitRec){
        Visit__c vsRec = new Visit__c();
        try{
            if(visitRec != null){
                update visitRec;
            }
            System.debug('visitRec === >'+visitRec);
            return visitRec;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    //==========================================================================================================================================================================================================
    @AuraEnabled
    public static void saveTask(Task taskRec){
        try{
            if(taskRec !=null){
                System.debug('taskRec === >'+taskRec);
                taskRec.OwnerId = userInfo.getUserId();
                insert taskRec;
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
    //==========================================================================================================================================================================================================
    @AuraEnabled
    public static void LogCall(Task taskRec){
        try{
            if(taskRec !=null){
                System.debug('taskRec === >'+taskRec);
                taskRec.OwnerId = userInfo.getUserId();
                insert taskRec;
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
    //==========================================================================================================================================================================================================
    @AuraEnabled
    public static void saveOpportunity(Opportunity1__c oppRec){
        try{
            if(oppRec !=null){
                System.debug('oppRec === >'+oppRec);
                insert oppRec;
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
    //==========================================================================================================================================================================================================
    @AuraEnabled
    public static void saveCase(Case caseRec){
        String userId = userInfo.getUserId();
        try{
            if(caseRec !=null){
                System.debug('caseRec === >'+caseRec);
                caseRec.OwnerId = userId;
                insert caseRec;
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
    //==========================================================================================================================================================================================================
    // Method for Check in on Visit Record
    @AuraEnabled
    public static Visit__c  checkInUpdateVisit(String checkInLat,String checkInLang, String recId){
        System.debug('checkInLat--> ' + checkInLat + 'checkInLang--> '+ checkInLang + 'recId--> '+ recId);
        Visit__c visRec = [SELECT Id,Name,Actual_Visit_Date__c,CheckIn__Latitude__s,CheckIn__Longitude__s, Check_Out__Latitude__s, Check_Out__Longitude__s, Visit_Status__c FROM Visit__c WHERE Id=:recId];
        System.debug('visRec--> ' + visRec);
        try{
            if(String.isNotBlank(checkInLat) && String.isNotBlank(checkInLang)){
                visRec.CheckIn__Latitude__s = Decimal.valueOf(checkInLat);
                visRec.CheckIn__Longitude__s =  Decimal.valueOf(checkInLang);
                visRec.Visit_Status__c = 'In Progress';
                visRec.Check_In_Time__c = System.now();
                update visRec;
                System.debug('Check In Visit Update Record === >'+visRec);
                return visRec;
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    //==========================================================================================================================================================================================================
    // Method for Check Out in Visit Record
    @AuraEnabled
    public static Visit__c checkOutUpdateVisit(String checkOutLat,string checkOutLong, String recId){
        System.debug('checkOutLat--> ' + checkOutLat + 'checkOutLong--> '+ checkOutLong + 'recId--> '+ recId);
        Visit__c visRec =[SELECT Id,Name,Actual_Visit_Date__c,CheckIn__Latitude__s,RSM__c,CheckIn__Longitude__s, Check_Out__Latitude__s, Check_Out__Longitude__s, Visit_Status__c FROM Visit__c WHERE Id=:recId];
        System.debug('visRec--> ' + visRec);
        try{
            if(String.isNotBlank(checkOutLat) && String.isNotBlank(checkOutLong)){
                visRec.Check_Out__Latitude__s = Decimal.valueOf(checkOutLat);
                visRec.Check_Out__Longitude__s =  Decimal.valueOf(checkOutLong);
                visRec.Visit_Status__c = 'COMPLETED';
                visRec.Check_Out_Time__c = System.now();
                if(visRec.RSM__c != null){
                    String RSMid = visRec.RSM__c;
                    System.debug('RSMid==> ' + RSMid);
                    List<Event> rsmEventList = [SELECT Id, Description, EndDateTime FROM Event WHERE OwnerId =: RSMid AND WhatId =: recId ORDER BY CreatedDate DESC LIMIT 1];
                    System.debug('rsmEventList==> ' + rsmEventList);
                    if(!rsmEventList.isEmpty()){
                        rsmEventList[0].Description = 'Field Visit has been Successfully Completed';
                        rsmEventList[0].EndDateTime = System.Now();
                        update rsmEventList;
                    }
                }
                update visRec;
                System.debug('Check Out Visit Update Record === >'+visRec);
                return visRec;
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    
    //==========================================================================================================================================================================================================
    // Method for getting Past Visit Records
    @AuraEnabled
    public static List<Visit__c> getPastVisitDetails(String accId){
        String userId = UserInfo.getUserId();
        List<Visit__c> pastVisitList = new List<Visit__c>();
        try{
            if(String.isNotBlank(userId)){
                pastVisitList = [SELECT Id, Name, Status__c, Account__c, Duration__c, Account__r.Name, Account__r.Website, Account__r.Email__c, Account__r.Phone,  
                                 Visit_Time__c, Planned_visit_date__c, Weekly_Beat_Plan__c, KPI_Target__c, KPI_Target__r.KPI_Target_Name__c,Account__r.BillingStreet, 
                                 Account__r.BillingCity, Account__r.BillingState,Account__r.BillingPostalCode, Check_In_Time__c, Visit_Status__c, Account__r.BillingCountry, Actual_Visit_Date__c,
                                 KPI_Target_Name__c FROM Visit__c WHERE Assigned_User__c=:userId AND Actual_Visit_Date__c < today AND Account__c =: accId];
                if(pastVisitList !=null){
                    System.debug('pastVisitList === >'+pastVisitList);
                    return pastVisitList;
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    //==========================================================================================================================================================================================================
    // Method for getting Related Opportunities List
    @AuraEnabled
    public static List<Opportunity1__c> getRelOppList(String accId){
        List<Opportunity1__c> oppList = new List<Opportunity1__c>();
        try{
            if(String.isNotBlank(accId)){
                oppList = [SELECT Id, Name, StageName__c, CloseDate__c, LeadSource__c FROM Opportunity1__c WHERE AccountId__c=:accId LIMIT 10];
                if(oppList !=null){
                    System.debug('oppList === >'+oppList);
                    return oppList;
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // ==========================================================================================================================================================
    @AuraEnabled
    public static List<SObject> getRelInvoiceList(String accId){
        List<SObject> invList = new List<SObject>();
        String userId = userInfo.getUserId();
        try{
            return invList;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // ==========================================================================================================================================================
    @AuraEnabled
    public static List<Case> getRelCaseList(String accId){
        List<Case> caseList = new List<Case>();
        String userId = userInfo.getUserId();
        try{
            if(String.isNotBlank(accId)){
                caseList = [SELECT Id, CaseNumber, Origin, Case_Status__c, Status, Description, Reason, AccountId FROM Case WHERE AccountId=:accId AND OwnerId=:userId LIMIT 10];
                if(caseList !=null){
                    System.debug('caseList === >'+caseList);
                    return caseList;
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // ==========================================================================================================================================================
    @AuraEnabled
    public static List<Task> getRelTaskList(String accId){
        List<Task> taskList = new List<Task>();
        String userId = userInfo.getUserId();
        try{
            if(String.isNotBlank(accId)){
                taskList = [SELECT Id, OwnerId, ActivityDate, Priority, Status, Subject, Type,Description FROM Task WHERE WhatId=:accId AND OwnerId=:userId LIMIT 10];
                if(taskList !=null){
                    System.debug('taskList === >'+taskList);
                    return taskList;
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    //===================================================================================
    //Method to get the today's visit records
    @AuraEnabled
    Public static List<Visit__c> getTodayVisitRecordListNew(){
        List<Visit__c> visitLst =[select Id, Name, Account__c  from Visit__c  where CreatedDate  = today];
        return visitLst;
    }
    
    // ==========================================================================================================================================================
    // Method for Creating Activit Mom Log and Send Email to Enter Stock Email - Dinesh
    @AuraEnabled
    public static String createMomActivityLog(String description, String visitId,String subject,String salesUserId,string stackholderEmail){
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        String accId = [Select Id, Account__c from Visit__c where Id = : visitId].Account__c;
        EmailTemplate temp = [SELECT Id,Subject,Body,HTMLValue FROM EmailTemplate WHERE Name ='Thank you for Meeting Mom'];
        String htmlBody = temp.HTMLValue;
        String plainTextBody = temp.body;
        Visit__c visitRec = new Visit__c();
        Contact conRec = new Contact();
        try{
            if(subject !=null && visitId !=null && accId !=null){
                visitRec = [SELECT Id,Name,Account__c,Account__r.Name FROM Visit__c WHERE ID=:visitId LIMIT 1];
                if(visitRec.Account__c !=null){
                    conRec = [SELECT Id,Name,Email,AccountId FROM Contact WHERE AccountId=: visitRec.Account__c LIMIT 1];
                }
                system.debug('visitRec === >'+visitRec);
                Task taskRec = new Task();
                taskRec.WhatId	= accId;
                taskRec.Visit__c = visitId;
                if(description !=null){
                    taskRec.Description = description;
                }
                if(salesUserId !=null){
                    taskRec.Sales_User__c = salesUserId;
                }
                if(stackholderEmail !=null){
                    taskRec.Stakeholder_Email__c = stackholderEmail;
                }
                taskRec.Subject = subject;
                taskRec.Is_Mom_Activity__c = true;
                taskRec.Priority = 'Normal';
                taskRec.Status = 'Open';
                taskRec.CurrencyIsoCode = 'INR';
                taskRec.OwnerId = userInfo.getUserId();
                insert taskRec;
                system.debug('Mom Activity record === >'+taskRec);
                if(taskRec !=null){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    // htmlBody = htmlBody.replace('{!Visit__c.Name}', visitRec.Name);
                    htmlBody = htmlBody.replace('{!OwnerFullName}', UserInfo.getName());
                    htmlBody = htmlBody.replace('{!Account.Name}', visitRec.Account__r.Name);
                    htmlBody = htmlBody.replace('{!Contact.Name}', conRec.Name);
                    htmlBody = htmlBody.replace('{!Subject}', taskRec.Subject);
                    htmlBody = htmlBody.replace('{!Description}', taskRec.Description);
                    
                    // plainTextBody = plainTextBody.replace('{!Visit__c.Name}', visitRec.Name);
                    plainTextBody = plainTextBody.replace('{!OwnerFullName}', UserInfo.getName());
                    htmlBody = htmlBody.replace('{!Account.Name}', visitRec.Account__r.Name);
                    plainTextBody = plainTextBody.replace('{!Contact.Name}', conRec.Name);
                    plainTextBody = plainTextBody.replace('{!Subject}', taskRec.Subject);
                    plainTextBody = plainTextBody.replace('{!Description}', taskRec.Description);
                    
                    mail.setHtmlBody(htmlBody);
                    mail.setSubject(temp.Subject);
                    mail.setPlainTextBody(plainTextBody);
                    mail.toAddresses = new String[] {stackholderEmail};
                    // Get the user's manager's email address and add it to the CC
                    User salesUser = [SELECT Id, Manager.Email FROM User WHERE Id = :salesUserId LIMIT 1];
                    if (salesUser != null && salesUser.Manager != null && salesUser.Manager.Email != null) {
                        mail.setCcAddresses(new String[]{salesUser.Manager.Email});
                    }
                    mailList.add(mail);
                    if(!mailList.isEmpty()){
                        Messaging.sendEmail(mailList);
                        return 'SUCCESS';
                    }
                }else{
                    return 'Something Went wrong !';
                }
            }
        }catch(Exception e){
            system.debug('Error == >'+e.getMessage()+' && Error Line === >'+e.getLineNumber());
        }
        return null;
    }
    
    // ==========================================================================================================================================================
    // Method for Before Checkout check Mom Activity Task - Dinesh
    @AuraEnabled 
    public static string checkMomActivityBeforeCheckOutVisit(string visitId){
        List<Task> momTaskList = new List<Task>();
        try{
            if(visitId !=null){
                momTaskList = [SELECT  Id,Subject,Visit__c,Is_Mom_Activity__c FROM Task WHERE Visit__c=:visitId AND Is_Mom_Activity__c = true LIMIT 1];
                if(momTaskList.size()>0){
                    return 'SUCCESS';
                }else{
                    return 'ERROR';
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    //========================================================================================================================================
    //Method to get case list related to account and display on visit record
    @AuraEnabled
    Public Static List<Case> getCaseList(String recId){
        try{
            system.debug('record id ==> '+recId);
            String accId = [Select Id, Account__c FROM Visit__c WHERE Id=:recId].Account__c;
            if(accId != null){
                List<Case> caseList = [Select Id,CaseNumber,Subject,Origin,Priority,Status from Case where AccountId=:accId];
                return caseList;
            }         
        }
        Catch(Exception e){
            System.debug('Error Occured ==>'+e.getMessage());
        }
        return null;
    }
}