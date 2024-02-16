public class BeatPlanController {
    
    @AuraEnabled
    Public  static List<Roles_and_KPI__c> AllRolesXKPICurrentUser(){
        Id currentUserId = UserInfo.getUserId();
        List<Roles_and_KPI__c> RKPList=[Select Id,Name From Roles_and_KPI__c Where Sales_User__c=: currentUserId]; //:UserInfo.getUserId()
        return RKPList;
    }
    
    @AuraEnabled
    Public Static String GetAllMonthlyBeatPlanner(String StartDate,String LastDate,List<WrapperClass> WrapperRecList){
        Integer weeksBetween = 0;
        Monthly_Beat_Plan__c MBP=new Monthly_Beat_Plan__c();
        List<Weekly_Beat_Plan__c> WBPList=new List<Weekly_Beat_Plan__c>(); 
        List<KPI_Target__c> ListKPITarget=new List<KPI_Target__c>();
        
        if(StartDate!=null && LastDate!=null){
            //Creating Monthly Beat Plan
            Map<Integer, String> monthNamebyNumber = new Map<Integer, String>{1=>'January', 2 => 'February', 3 => 'March', 4 => 'April', 5 => 'May', 6 => 'June', 7 => 'July', 8 => 'August'
                , 9 => 'September', 10 => 'October', 11 => 'November', 12 => 'December'};
            String monthName = monthNamebyNumber.get(Date.valueOf(StartDate).month());
            System.debug('monthName === >' + monthName);
            String year = StartDate.subString(0,4);
            System.debug('Year == >'+year);
            Id userId = UserInfo.getUserId();
            List<Monthly_Beat_Plan__c> existingBeatPlan = [SELECT Id, Name,Year__c FROM Monthly_Beat_Plan__c WHERE Month_Name__c =: monthName AND Year__c=:year AND Sales_User__c =: userId];
            if(existingBeatPlan.size()>0){
                System.debug('Found Exisiting MBP');
                return 'ErrorFound';
            }

            MBP.Start_Date__c=Date.valueOf(StartDate);
            MBP.End_Date__c=Date.valueOf(LastDate);
            MBP.Sales_User__c=UserInfo.getUserId(); 
            MBP.Month_Name__c = monthName;
            insert MBP;
            System.debug('MBP Inserted Record ==> ' + MBP);
            if(MBP !=null){
                sendEmailToRSMonMontlyBeatPlanCreation(MBP.id);
            }

            Date SelectedDate=Date.valueOf(StartDate);
            date firstDate = SelectedDate.toStartOfMonth();
            Integer month = SelectedDate.month();
            Integer DaysInMonth=date.daysInMonth(SelectedDate.year(), month) -1;
            Date LastDateOfMonth=firstDate.addDays(DaysInMonth);
            Datetime startDateTime=firstDate;
            Datetime endDateEndDateTime=LastDateOfMonth;
            System.debug('startDateTime ===> ' + startDateTime);
            System.debug('endDateEndDateTime ===> ' + endDateEndDateTime);
            if(MBP.Id!=null){
                System.debug('Inside Creating Weekly Beat Plan Records');
                Date NextWeekStartDate;
                //Creating Weekly Beat Plan
                Date WeekStartDate=firstDate;
                integer i= 0;
                date lastWeekEndDate;
                while (startDateTime <= endDateEndDateTime) {
                    Weekly_Beat_Plan__c WBP=new Weekly_Beat_Plan__c();
                    WBP.Monthly_Beat_Plan__c=MBP.Id;
                    date previousWeekEnddate;     
                    if (string.valueof(startDateTime.format('E')) == 'Sun'){   
                        weeksBetween++;    
                        WBP.End_Day_of_Week__c=Date.valueOf(startDateTime);
                        if (weeksBetween == 1) {
                            WBP.Start_Day_of_Week__c = (Date.valueOf(StartDate)).toStartOfMonth();
                        }
                        else {
                            WBP.Start_Day_of_Week__c = (WBP.End_Day_of_Week__c).addDays(-6);
                        }
                        previousWeekEnddate = WBP.End_Day_of_Week__c;
                        lastWeekEndDate = WBP.End_Day_of_Week__c;
                        system.debug('WBP.Start_Day_of_Week__c ===> '+WBP.Start_Day_of_Week__c);
                        WBPList.add(WBP);
                        System.debug('WBPList =====> ' + WBPList);
                    } else if(Date.valueOf(startDateTime) == LastDateOfMonth){
                        WBP.Start_Day_of_Week__c = lastWeekEndDate.addDays(1);
                        WBP.End_Day_of_Week__c = Date.valueOf(startDateTime);
                        if(WBP.Start_Day_of_Week__c != WBP.End_Day_of_Week__c){
                            WBPList.add(WBP);
                            lastWeekEndDate = WBP.End_Day_of_Week__c;
                        }
                    }
                    startDateTime = startDateTime.addDays(1);                    
                }
            }else{
                System.debug('No Monthly Beat Plan Found =====> ');
            }
            if(!WBPList.isEmpty()){
                
                Date startDateOfWeek;    // = Date.newInstance(2024, 2, 28); 
                Integer dayOfMonth ; // = startDate.day();
                Integer weekNumber; // = (dayOfMonth - 1) / 7 + 1;
                
                Insert WBPList;
                List<Weekly_Beat_Plan__c> updateWBPList = new List<Weekly_Beat_Plan__c>();
                for(Weekly_Beat_Plan__c wbp : WBPList){
                    Weekly_Beat_Plan__c wbpUpdate = new Weekly_Beat_Plan__c();
                    if(wbp.Start_Day_of_Week__c !=null){
                        startDateOfWeek = wbp.Start_Day_of_Week__c;
                        dayOfMonth = startDateOfWeek.day();
                        weekNumber = (dayOfMonth - 1) / 7 + 1;
                        wbpUpdate.id = wbp.id;
                        if(weekNumber == 1){
                            wbpUpdate.Week_Identifier__c = 'W1';
                            wbpUpdate.Week_Number__c = 'Week 1';
                        }
                        if(weekNumber == 2){
                            wbpUpdate.Week_Identifier__c = 'W2';
                            wbpUpdate.Week_Number__c = 'Week 2';
                        }
                        if(weekNumber == 3){
                            wbpUpdate.Week_Identifier__c = 'W3';
                            wbpUpdate.Week_Number__c = 'Week 3';
                        }
                        if(weekNumber == 4){
                            wbpUpdate.Week_Identifier__c = 'W4';
                            wbpUpdate.Week_Number__c = 'Week 4';
                        }
                        if(weekNumber == 5){
                            wbpUpdate.Week_Identifier__c = 'W5';
                            wbpUpdate.Week_Number__c = 'Week 5';
                        }
                        updateWBPList.add(wbpUpdate);
                        system.debug('Week Date == >'+startDateOfWeek+' && Week No ===>'+weekNumber);
                    }
                }
                if(updateWBPList.size()>0){
                    update updateWBPList;
                }
                system.debug('WBPList Inserted Size ===>'+WBPList.size());
            }
            if(!WrapperRecList.isEmpty()){
                for(WrapperClass rec:WrapperRecList){
                    KPI_Target__c KT=new KPI_Target__c();
                    if(rec.targetvalue!=null && rec.targetvalue!=''){
                        KT.Roles_and_KPI__c=rec.Id;
                        KT.Monthly_Beat_Plan__c=MBP.Id;
                        KT.Target_Count__c=Integer.valueOf(rec.targetvalue);
                        KT.Sales_User__c = UserInfo.getUserId();
                        ListKPITarget.add(KT);
                    }
                }  
            }
            if(!ListKPITarget.isEmpty()){
                Insert ListKPITarget;
                system.debug('ListKPITarget Inserted Size ===>'+ListKPITarget.size());
            }
        }
        return 'Success';     
    }
    
    Public Class WrapperClass{        
        @AuraEnabled
        Public String Id{get;set;}
        @AuraEnabled
        Public String Name{get;set;}
        @AuraEnabled
        Public string targetvalue{get;set;}
    }
    
    // Method for Sending Email to RSM , On Monthly Beat Plan Creation
    @AuraEnabled 
    public static string sendEmailToRSMonMontlyBeatPlanCreation(string recordId){
        Monthly_Beat_Plan__c MbeatPlanRec = new Monthly_Beat_Plan__c();
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate temp = [SELECT Id,Subject,Body,HTMLValue FROM EmailTemplate WHERE Name ='New Beat Plan Email'];
        User CurrentUserRec = new User();
        try{
            if(recordId !=null){
                String htmlBody = temp.HTMLValue;
                String plainTextBody = temp.body;
                MbeatPlanRec = [SELECT Id,Name,Month_Name__c,OwnerId FROM Monthly_Beat_Plan__c WHERE Id=:recordId];
                system.debug('MbeatPlanRec === >'+MbeatPlanRec);
                String MBPBaseURL = System.label.MontlyBeatPlanURL;
                if(MbeatPlanRec.OwnerId !=null){
                    CurrentUserRec = [select userName,id,manager.name,manager.Email, manager.profile.name from user WHERE Id=:MbeatPlanRec.OwnerId LIMIT 1];
                    system.debug('CurrentUserRec == >'+CurrentUserRec);
                    if(CurrentUserRec.manager.name !=null && CurrentUserRec.manager.Email !=null){
                        if(MbeatPlanRec.Month_Name__c !=null){
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                htmlBody = htmlBody.replace('{!Manager.Name}', CurrentUserRec.manager.name);
                                htmlBody = htmlBody.replace('{!Monthly_Beat_Plan__c.Month_Name__c}', MbeatPlanRec.Month_Name__c);
                                htmlBody = htmlBody.replace('{!Monthly_Beat_Plan__c.Id}', MbeatPlanRec.Id);
                                htmlBody = htmlBody.replace('{!RecordURL}', MBPBaseURL+MbeatPlanRec.Id+'/view');

                                plainTextBody = plainTextBody.replace('{!Monthly_Beat_Plan__c.Month_Name__c}', MbeatPlanRec.Month_Name__c);
                                plainTextBody = plainTextBody.replace('{!Monthly_Beat_Plan__c.Id}', MbeatPlanRec.Id);
                                plainTextBody = plainTextBody.replace('{!Manager.Name}', CurrentUserRec.manager.name);
                                plainTextBody = plainTextBody.replace('{!RecordURL}', MBPBaseURL+MbeatPlanRec.Id+'/view');


                            mail.setHtmlBody(htmlBody);
                            mail.setSubject(temp.Subject);
                            mail.setPlainTextBody(plainTextBody);
                            mail.toAddresses = new String[] {CurrentUserRec.manager.Email};
                                mailList.add(mail);
                            if(!mailList.isEmpty()){
                                Messaging.sendEmail(mailList);
                                return 'SUCCESS';
                            }
                           
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }

}