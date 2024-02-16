@isTest
public class LeadConstantsTest {
    @isTest
    static void testConstants() {
        System.assertEquals(System.Label.Default_Lead_Group, LeadConstants.LEAD_DEFAULT_GROUP_NAME);
    }

    @isTest
    static void testDebuggerLog() {
        
        try {
            Integer result = 1 / 0; 
            System.assert(false, 'Exception not thrown as expected.');
        } catch (Exception e) {
            LeadConstants.debuggerLog(e);
            String expectedErrorMessage = 'System.MathException: Attempt to divide by zero';
            
        }
    }
}