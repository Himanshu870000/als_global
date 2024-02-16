@isTest
public class EamilUtilityClassTest {
    @isTest
    static void SendEmailOnLeadCreationTest(){
        List<Lead__c> lstOfrec = new List<Lead__c>();
        Lead__c ledRec = new Lead__c();
        ledRec.Vertical_Segment__c = 'Food Service';
        ledRec.First_Name__c = 'Banoj';
            ledRec.Name = 'Samal';
        ledRec.Email__c = 'mac.anwarchikle@gmail.com';
        ledRec.Company__c = 'Test Classes';
        ledRec.Region__c = 'South';
        Insert  ledRec;
        lstOfrec.add(ledRec);
        EamilUtilityClass.SendEmailOnLeadCreation(lstOfrec);
    }
}