public without sharing class LeadConstants {
   
    public static final String LEAD_DEFAULT_GROUP_NAME = System.Label.Default_Lead_Group;
   
    public static void debuggerLog(Exception e) {
        System.debug('--- Error LNO: '+e.getLineNumber());
        System.debug('--- Error Message: '+ e.getMessage());
        System.debug('--- StackTrace: '+ e.getStackTraceString());

    }
}