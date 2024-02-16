public class convertLeadController {
    
    @AuraEnabled(cacheable=true)
    public static List<lead> getLeads(string recordId){
        return [select id, FirstName, LastName, Company,Owner.Name from Lead where Id =: recordId ];
    }
    
    @AuraEnabled
    Public Static string createRecords(string accName, string Salutation, string conFirstName, string conLastName, string oppname, string ownerName){
        System.debug('accName == >'+accName +' && Salutation == >'+Salutation +' && conFirstName === >'+conFirstName +' && conLastName == >'+conLastName +' && oppname === >'+oppname+' && ownerName === >'+ownerName);
        string LeadConvertStatus;
        try{
            List<Account> accountList = new List<Account>();
            List<Contact> conList = new List<Contact>();
            List<Opportunity> oppList = new List<Opportunity>();
            List<Database.SaveResult> results = new List<Database.SaveResult>();
                Account acc = new Account();
                if(accName != null){
                    acc.Name=accName;
                }
                accountList.add(acc);
                Contact con = new Contact();
                if(Salutation !=null){
                    con.Salutation = Salutation;
                }
                if(conFirstName !=null){
                    Con.FirstName = conFirstName;
                }
                if(conLastName !=null){
                    con.LastName = conLastName;
                }
                conList.add(con);
                Opportunity opp = new Opportunity();
                if(oppname !=null){
                    opp.Name=oppname;
                }
                opp.CloseDate = system.today();
                opp.StageName = 'New';
                oppList.add(opp);
                results.addAll(Database.insert(accountList, false));
                results.addAll(Database.insert(conList, false));
                results.addAll(Database.insert(oppList, false));
                System.debug('Result === >'+results);
                if(results !=null){
                    return 'SUCCESS';
                }else{
                    return 'ERROR';
                }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return 'ERROR';
    }
    
    
    @AuraEnabled
    Public Static String createAccount(String accName){
        Account acc = new Account();
        acc.Name = accName;
        Insert acc;
        return 'Success';
    }
    
    @AuraEnabled
    Public Static String createContact(String Sal, String fname, String lname){
        Contact con = new Contact();
        con.FirstName = fname;
        con.LastName = lname;
        insert con;
        return 'success';
    }
    
    @AuraEnabled 
    Public Static String createopportunity(String oppName){
        Opportunity opp = new Opportunity();
        opp.Name = oppName;
        opp.CloseDate = system.today().addDays(30);
        opp.StageName = 'Prospecting';
        Insert opp;
        return 'Success';
    }
    
    @AuraEnabled
    Public Static String UpdateleadStatus(String LeadId){
        List<Lead> leadList  = new List<Lead>();
        Lead ld = [SELECT Id, Name, Status from Lead where Id =:LeadId];
        Lead l = new Lead();
        l.Id = ld.Id;
        l.Status = 'Closed - Converted';
        leadList.add(l);
        if(!leadList.isEmpty()){
            Update leadList;
        }
        return 'Success';
    }
    
    @AuraEnabled(Cacheable = true)
    public static list<Opportunity> getopportunityData(String oppkey) {
        list<Opportunity> oppLst = [SELECT  Id,Name, Account.Name, CloseDate, Amount, Owner.name From Opportunity WHERE AccountId=:oppkey];        
        if(oppLst.isEmpty()) {
            throw new AuraHandledException('No Record Found..');
        }
        return oppLst; 
    }
}