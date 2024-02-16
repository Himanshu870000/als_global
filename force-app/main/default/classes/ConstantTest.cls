@isTest
public class ConstantTest {
    @isTest
    static void testConstants() {
        // Test constant values
        System.assertEquals('Check Quote Feasibility', Constant.CHECK_QUOTE_FEASIBILITY);
        System.assertEquals('Quote Submitted By Sales User', Constant.QUOTE_SUBMITTED_BY_SALES_USER);
        System.assertEquals('Quote Initiated By Customer Success', Constant.QUOTE_INITIATED_BY_CUSTOMER_SUCCESS);
        System.assertEquals('Meeting With Customer', Constant.LEAD_STAGE_SQL);
    }
}