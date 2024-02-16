public class BuildMaps {
    /*Condition Map*/
    public static map<string,integer> mapofMemIdByExceedCount = new map<string,integer>();
    public static map<string,Integer> mapofMemidByTodayLeadCount = new map<string,integer>();
    public static map<string,Integer> mapofMemIdByMaxLeadCountPerDay = new map<string,integer>();
    public static map<string,Integer> mapofMemIdByMaxLeadCountByGroupPerDay = new map<String,integer>();
    public static map<string,Integer> mapofMemidbyMaxleadCountFromUser = new map<string,integer>();
    public static map<string,Integer> mapofMemidByPendingLeads = new map<string,integer>();
    public static map<string,Integer> mapofMemidByMinLeadsCount = new map<string,integer>();
    public static map<string,integer> mapofMemidByTodayNewLead = new map<string,integer>();
    public static map<string,integer> mapofMemidByAssignedLead = new map<string,integer>();
    /* Condition map end*/
    
    public static Map<String, Integer> makeQNameToLastAssignedQmemberRRid(){
        Map<String, Integer> qNameToLastAssignedQmemberRRid = new Map<String, Integer>();
        List<Assignment_Group__c> allExistingQueue = new List<Assignment_Group__c>([SELECT id, name, Last_Allocated_RRid__c from Assignment_Group__c]);
        for(Assignment_Group__c q: allExistingQueue)
        {
            if(q.Last_Allocated_RRid__c != null)
            {
                qNameToLastAssignedQmemberRRid.put(q.name, Integer.valueOf(q.Last_Allocated_RRid__c));    
            }
            else 
                qNameToLastAssignedQmemberRRid.put(q.name, null);
        }
        return qNameToLastAssignedQmemberRRid;
    }
}