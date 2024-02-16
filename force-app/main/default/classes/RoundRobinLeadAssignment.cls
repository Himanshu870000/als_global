public class RoundRobinLeadAssignment {
    
    public static boolean reccuringTrigger = true;
    public static string groupName = '';
    Private List<Lead__c> updatedLeadList ;
    
    @future
    public Static void assignLeadsToBDS(String courseName,Set<String> leadIdList){

        system.debug('courseName 1.1 === >'+ courseName);
        system.debug('leadIdList 1.2 === >'+ leadIdList);
        boolean withinWorkingHour = false;
        Boolean isInsertLeadFlow = false;
        List<Lead__c> updateLeadList = new List<Lead__c>();
        List<Assignment_Group__c> QtoBeUpdated = new List<Assignment_Group__c>();
        Map<String, List<String>> QueueNameToQmemberIdList = new Map<String, List<String>>();
        Map<String, Boolean> userIdToUserAvailablityMap = new Map<String, Boolean>();
        Map<String, List<Lead__c>> qNameToListOfLeadsMap = new map<String,List<Lead__c>>();
        Map<String, Integer> qNameAndMemberIdTORoundRobinIDMaP = new Map<String, Integer>();
        Map<String, Integer> qNameToLastAssignedQmemberRRid = new Map<String, Integer>();
        Map<String, String> QnameAndRRidToMemberIDMap = new Map<String, String>();
        List<Lead> listOfEmailTobeSendLeads = new List<Lead>();
        //In case the Method fails assign to first member 
        String Assignee = '';
        //withinWorkingHour = BuildMaps.CheckBusinessHours();
        //Getting the Leads which are in default queue from this List Lead..
        If(leadIdList.size() > 0){
            List<Lead__c> LeadData =  [SELECT id,Name,Region__c FROM Lead__c WHERE  id IN:leadIdList and Region__c !=null limit 50000];
            qNameToListOfLeadsMap.put(courseName,LeadData);//makeQueueNameToListOfAssignedLeadsMap(courseName,leadIdList);//Group wise leads based on source intent
        }
        system.debug('qNameToListOfLeadsMap 1.3 === >'+qNameToListOfLeadsMap);
        system.debug('leadIdList Size 1.4 == >'+leadIdList.size());
        //Getting the Group Members Corresponding to the groups where do not Consider For Lead Assignment = false
        QueueNameToQmemberIdList = makeCustomQueueNameToListOfUserId(courseName); // group by group member
        system.debug('QueueNameToQmemberIdList 1.5 === >'+qNameToListOfLeadsMap);
        userIdToUserAvailablityMap = makeuserIdToUserAvailablityMap(courseName); // group by group member availability
         system.debug('userIdToUserAvailablityMap 1.6 === >'+userIdToUserAvailablityMap);
        //qNameAndMemberIdTORoundRobinIDMaP = makeqNameAndMemberIdTORoundRobinIDMaP(courseName);
        qNameToLastAssignedQmemberRRid = BuildMaps.makeQNameToLastAssignedQmemberRRid(); // qname with last allocated ID
         system.debug('qNameToLastAssignedQmemberRRid 1.7 === >'+userIdToUserAvailablityMap);
        QnameAndRRidToMemberIDMap = makeQnameAndRRidToMemberID(courseName); // qname with qname+rrid
         system.debug('QnameAndRRidToMemberIDMap 1.8 === >'+QnameAndRRidToMemberIDMap);
        //BuildMaps.validateUserCapacityForRM(courseName,leadIdList);
        
        for(String qName: qNameToListOfLeadsMap.keySet()){
            if(qName != null){
                for(Lead__c ld: qNameToListOfLeadsMap.get(qName)){
                    Boolean isAssigned = false;
                    Integer qMemberSize = 1;
                    While(QueueNameToQmemberIdList != null && qMemberSize != null && QueueNameToQmemberIdList.get(qName) != null && isAssigned == false && qMemberSize <= QueueNameToQmemberIdList.get(qName).size()){
                        Assignee = QueueNameToQmemberIdList.get(qName)[0];
                        Integer currentRRid, LastRRid; 
                        String QnameAndRRid, qMemberID;
                        if(qNameToLastAssignedQmemberRRid.get(qName) != null)
                            LastRRid = qNameToLastAssignedQmemberRRid.get(qName); 
                        if(LastRRid == null || LastRRid < 1){
                            qNameToLastAssignedQmemberRRid.remove(qName);
                            qNameToLastAssignedQmemberRRid.put(qName, 0);
                            currentRRid = 1;
                        }
                        if(LastRRid < QueueNameToQmemberIdList.get(qName).size()){
                            currentRRid = LastRRid + 1;
                        }
                        else{
                            currentRRid = 1;
                            LastRRid = 0;
                        }
                        QnameAndRRid = qName + String.valueOf(currentRRid);
                        qMemberID = QnameAndRRidToMemberIDMap.get(QnameAndRRid);
                        boolean test = true;
                        if(assignmentConditionSatisfied(qName,qMemberID,'123')){//qName,qMemberID,userIdbyLeadcount,ld.Learner_Uid__c,assignmentConditionSatisfied(true)
                            if(userIdToUserAvailablityMap.get(qMemberID) == true){
                                ld.ownerId = Id.valueOf(qMemberID);
                                updateLeadList.add(ld); 
                                isAssigned = true;
                                if(BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) == null)
                                    BuildMaps.mapofMemidByTodayLeadCount.put(qMemberID,0);
                                BuildMaps.mapofMemidByTodayLeadCount.put(qMemberID,BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID)+1);
                                if(BuildMaps.mapofMemidByPendingLeads.get(qMemberID) == null)
                                    BuildMaps.mapofMemidByPendingLeads.put(qMemberID,0);
                                BuildMaps.mapofMemidByPendingLeads.put(qMemberID,BuildMaps.mapofMemidByPendingLeads.get(qMemberID) + 1);
                                if(BuildMaps.mapofMemidByTodayNewLead.get(qMemberID) == null)
                                    BuildMaps.mapofMemidByTodayNewLead.put(qMemberID,0);
                                BuildMaps.mapofMemidByTodayNewLead.put(qMemberID,BuildMaps.mapofMemidByTodayNewLead.get(qMemberID)+1);
                                if(BuildMaps.mapofMemidByAssignedLead.get(qMemberID) == null)
                                    BuildMaps.mapofMemidByAssignedLead.put(qMemberID,0);
                                BuildMaps.mapofMemidByAssignedLead.put(qMemberID,BuildMaps.mapofMemidByAssignedLead.get(qMemberID) + 1);
                            }
                            LastRRid = LastRRid +1; 
                            qNameToLastAssignedQmemberRRid.remove(qName);
                            qNameToLastAssignedQmemberRRid.put(qName, LastRRid);
                            qMemberSize ++;
                        }else{
                            LastRRid = LastRRid +1; 
                            qNameToLastAssignedQmemberRRid.remove(qName);
                            qNameToLastAssignedQmemberRRid.put(qName, LastRRid);
                            qMemberSize ++;
                        }
                    }
                }
            }
        }
        
        if(!qNameToLastAssignedQmemberRRid.keySet().isEmpty())
        {
            List<Assignment_Group__c> updateQrId = new List<Assignment_Group__c>();
            updateQrId = [Select id, name, Last_Allocated_RRid__c  from Assignment_Group__c where Name IN: qNameToLastAssignedQmemberRRid.keySet()];
            for(Assignment_Group__c Q: updateQrId)
            {
                Q.Last_Allocated_RRid__c = qNameToLastAssignedQmemberRRid.get(Q.Name);
                QtoBeUpdated.add(q);
            }
        }
        if(updateLeadList.size()>0){
            update updateLeadList;
            System.debug('updateLead Lead List Record == >'+updateLeadList);
        }
        if(!QtoBeUpdated.isEmpty())
            Update QtoBeUpdated;
    }
    
    public void execute(QueueableContext context) {
        
    }
    
    public static boolean assignmentConditionSatisfied(string qName,string qMemberID,string learnerUid){
        
        boolean isconditionapproved = false;
        if(qMemberID != null && learnerUid.contains(qMemberID) != null && learnerUid.contains(qMemberID)){
            return false;
        }
        system.debug('qMemberID'+qMemberID);
        system.debug('BuildMaps.mapofMemidByAssignedLead.get(qMemberID)::'+BuildMaps.mapofMemidByAssignedLead.get(qMemberID));
        system.debug('BuildMaps.mapofMemidbyMaxleadCountFromUser.get(qMemberID)::'+BuildMaps.mapofMemidbyMaxleadCountFromUser.get(qMemberID));
        if(BuildMaps.mapofMemidByAssignedLead.get(qMemberID) == null){
            system.debug('Coming Here');
            isconditionapproved = true;
        }else if(BuildMaps.mapofMemidByAssignedLead.get(qMemberID) != null && BuildMaps.mapofMemidbyMaxleadCountFromUser.get(qMemberID) != null &&  BuildMaps.mapofMemidByAssignedLead.get(qMemberID) < BuildMaps.mapofMemidbyMaxleadCountFromUser.get(qMemberID)){
            if(BuildMaps.mapofMemidByPendingLeads.get(qMemberID) == null || (BuildMaps.mapofMemidByPendingLeads.get(qMemberID) != null && BuildMaps.mapofMemIdByExceedCount.get(qMemberID) != null && BuildMaps.mapofMemidByPendingLeads.get(qMemberID) < BuildMaps.mapofMemIdByExceedCount.get(qMemberID))){
                if(BuildMaps.mapofMemidByTodayNewLead.get(qMemberID) == null ||(BuildMaps.mapofMemidByTodayNewLead.get(qMemberID) != null && BuildMaps.mapofMemidByMinLeadsCount.get(qMemberID) != null && BuildMaps.mapofMemidByTodayNewLead.get(qMemberID) < BuildMaps.mapofMemidByMinLeadsCount.get(qMemberID) && BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) != null && BuildMaps.mapofMemIdByMaxLeadCountPerDay.get(qMemberID) != null && BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) < BuildMaps.mapofMemIdByMaxLeadCountPerDay.get(qMemberID))){
                    isconditionapproved = true;
                }else if(BuildMaps.mapofMemIdByMaxLeadCountPerDay.get(qMemberID) == null && BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) != null && BuildMaps.mapofMemIdByMaxLeadCountByGroupPerDay.get(qMemberID) != null && BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) < BuildMaps.mapofMemIdByMaxLeadCountByGroupPerDay.get(qMemberID)){
                    isconditionapproved = true;
                }else if(BuildMaps.mapofMemIdByMaxLeadCountByGroupPerDay.get(qMemberID) == null && BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) != null && BuildMaps.mapofMemidbyMaxleadCountFromUser.get(qMemberID) != null &&  BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) < BuildMaps.mapofMemidbyMaxleadCountFromUser.get(qMemberID)){
                    isconditionapproved = true;
                }  
            }else{
                isconditionapproved = true;
                system.debug('Coming Here00000000');
            }
        }
        system.debug('isconditionapproved'+isconditionapproved);
        isconditionapproved = true;
        return isconditionapproved;
    }
    
    public static Map<String, List<String>> makeCustomQueueNameToListOfUserId(string assignmentGroupName){
        try{
            Map<String, List<String>> customQueueNameToListOfUserId = new Map<String, List<String>>();
            List<Assignment_Group__c> queueWithQueueMembers = new List<Assignment_Group__c>();
            Map<String, Id> queueNameToQueueIdMap = new Map<String, Id> ();
            
            List<Assignment_Group__c> listOfExistingQueue = new List<Assignment_Group__c>();
            listOfExistingQueue = [select id, name,Max_Lead_Per_Day__c from Assignment_Group__c];
            List<Assignment_Group_Member__c > listOfExistingQueueMembers = new List<Assignment_Group_Member__c >();
            listOfExistingQueueMembers = [select id, name,Out_Of_Office__c,Assignment_Group__c,Assignment_Group__r.name, Assignment_Id__c,Leave_End_Date__c,Leave_Start_Date__c,Group_Member__c,Group_Member__r.Id from Assignment_Group_Member__c where Assignment_Group__r.name =: assignmentGroupName ];
            system.debug('listOfExistingQueueMembers == >'+listOfExistingQueueMembers);
            Set<Id> existingQueueMembersQueueId = new Set<Id>();
            
            if(!listOfExistingQueueMembers.isEmpty()){
                for(Assignment_Group_Member__c agm : listOfExistingQueueMembers){
                    if(customQueueNameToListOfUserId.containsKey(agm.Assignment_Group__r.name)){
                        customQueueNameToListOfUserId.get(agm.Assignment_Group__r.name).add(agm.Group_Member__r.Id);
                    }else{
                        customQueueNameToListOfUserId.put(agm.Assignment_Group__r.name,new list<string>{agm.Group_Member__r.Id});
                    }
                }
            }
            system.debug('customQueueNameToListOfUserId ==>'+customQueueNameToListOfUserId);
            return customQueueNameToListOfUserId;
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
       return null;
    }
    
    public static Map<String, Boolean> makeuserIdToUserAvailablityMap(string assignmentGroupName){
        try{
            /**Need to  handle leave*/ 
            Map<String, Boolean> userIdToUserAvailablityMap = new Map<String, Boolean>();   
            List<Assignment_Group_Member__c> agentAvailablity = new List<Assignment_Group_Member__c>();  
            agentAvailablity = [select id,Out_Of_Office__c,Group_Member__r.Id,Assignment_Group__r.name from Assignment_Group_Member__c where Assignment_Group__r.name =: assignmentGroupName and Out_Of_Office__c = false];
            system.debug('agentAvailablity == >'+agentAvailablity);
            for(Assignment_Group_Member__c Aa: agentAvailablity)
            {
                userIdToUserAvailablityMap.put(aa.Group_Member__r.Id, true);    
            }
            System.debug('userIdToUserAvailablityMap === >'+userIdToUserAvailablityMap);
            return userIdToUserAvailablityMap;
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return null;
    }
    
    public static Map<String, String> makeQnameAndRRidToMemberID(String groupName){
        try{
            Map<String, String> QnameAndRRidToMemberIDMap = new Map<String, String>();
            list<Assignment_Group_Member__c> agmList = new list<Assignment_Group_Member__c>();
            agmList = [select id,Assignment_Group__r.name,Assignment_Id__c,Group_Member__r.Id,Out_Of_Office__c from Assignment_Group_Member__c where Assignment_Group__r.name =: groupName and Out_Of_Office__c = false];
            system.debug('agmList == >'+agmList);
            if(!agmList.isEmpty()){
                for(Assignment_Group_Member__c agm : agmList){
                    String qName = agm.Assignment_Group__r.name; String qMember = string.valueOf(agm.Assignment_Id__c);
                    system.debug('qName == >'+qName);
                    system.debug('qMember ==> '+qMember);
                    if(!string.isBlank(qName) && !String.isBlank(qMember)){
                        String qNameAndQmamber = qName+qMember;
                        system.debug('qNameAndQmamber ==>'+qNameAndQmamber);
                        QnameAndRRidToMemberIDMap.put(qNameAndQmamber, String.valueOf(agm.Group_Member__r.Id));
                    } 
                }
            }
            return QnameAndRRidToMemberIDMap;   
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return null;
    }
    
    
}