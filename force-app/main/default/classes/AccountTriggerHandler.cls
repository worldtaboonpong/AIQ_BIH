public class AccountTriggerHandler {

    public static Id CONTACT_AUTO_RECORD_ID {get{
        if(CONTACT_AUTO_RECORD_ID==null){
            CONTACT_AUTO_RECORD_ID = [select Id from RecordType where (DeveloperName='Automated_Contact') and (SobjectType='Contact')].Id;
        }
        return CONTACT_AUTO_RECORD_ID;
    }set;}

    public static Id PATIENT_RECORD_ID {get{
        if(PATIENT_RECORD_ID==null){
            PATIENT_RECORD_ID = [select Id from RecordType where (DeveloperName='Person_Account') and (SobjectType='Account')].Id;
        }
        return PATIENT_RECORD_ID;
    }set;}

    public static Map<String,Account> mapEmailwthAccount {get{
        if(mapEmailwthAccount==null){
            mapEmailwthAccount = new Map<String,Account>();
        }
        return mapEmailwthAccount;
    }set;}

    
	public static void handleAfterInsert(List<Account> newList) {
        System.debug('$$$$$$$$$$$$$$$$$ handleAfterInsert');
        for(Account acc: newList){

             //check record type != patient
            if(acc.recordtypeid!=PATIENT_RECORD_ID){
                //collect account email mapping accountid
                if(acc.Email__c!=null){
                    mapEmailwthAccount.put(acc.Email__c,acc);
                }

                //add account with email 2-5
                for(Integer i=2;i<=5;i++){
                    string emailNo = (string) acc.get('Email'+i+'__c');
                    if(emailNo!=null){
                        mapEmailwthAccount.put(emailNo,acc);
                    }
                }
            }
            
        }

        createContactByEmail(mapEmailwthAccount);
        
        
        
    }
    
    public static void handleBeforeUpdate(Map<Id, Account> oldMap, Map<Id, Account> newMap) {
		System.debug('$$$$$$$$$$$$$$$$$ handleBeforeUpdate');
        Map<String,Contact> mapContactwithEmail = new Map<String,Contact>();
        List<Contact> updateContact = new List<Contact>();

        //check existing contact is found same email.
        for(Contact c : [Select id,Email,Accountid from Contact where Accountid in:newMap.keySet()]){
            if(c.email!=null){
                mapContactwithEmail.put(c.AccountId+c.email,c);
            }
        }

        for(Account acc: newMap.values()){
            if(acc.recordtypeid!=PATIENT_RECORD_ID){
                string new_email;
                string old_email;

               if(acc.Email__c!=null && (oldMap.get(acc.id).Email__c != acc.Email__c)){
                   new_email = acc.Email__c;
                   old_email = oldMap.get(acc.id).Email__c;
                   
                   Contact con = mapContactwithEmail.get(acc.id+old_email);
                   if(con != null){
                       con.email = new_email;
                       updateContact.add(con);
                   }else{
                       mapEmailwthAccount.put(new_email,acc);
                   }
                   
               } 

               for(Integer i=2;i<=5;i++){
                    string new_emailNo = (string) acc.get('Email'+i+'__c');
                    string old_emailNo = (string) oldMap.get(acc.id).get('Email'+i+'__c');
                    
                    if(new_emailNo!=null && (new_emailNo!=old_emailNo)){
                        Contact con = mapContactwithEmail.get(acc.id+old_emailNo);
                        if(con != null){
                            con.email = new_emailNo;
                            updateContact.add(con);
                        }else{
                            mapEmailwthAccount.put(new_emailNo,acc);
                        }
                    }
                }
            }
        }

        createContactByEmail(mapEmailwthAccount);

        if(updateContact.size() > 0){
            try{
                update updateContact;
            }catch(Exception ex){
                system.debug(ex);
            }
        }
        
    }

    public static void createContactByEmail(Map<String,Account> mapEmailAcc) {
        System.debug('$$$$$$$$$$$$$$$$$ createContactByEmail');
        //Create contact auto
        List<Contact> createContact = new List<Contact>();

        if(mapEmailAcc.size() > 0){
            for (String key : mapEmailAcc.keySet()) {
                Account acc = mapEmailAcc.get(key);
                Contact c = new Contact();
                c.AccountId = acc.id;
                c.Lastname = acc.name;
                c.RecordTypeId= CONTACT_AUTO_RECORD_ID;
                c.Email = key;
                createContact.add(c);
            }
            
        }

        if(createContact.size() > 0){
            try{
                insert createContact;
            }catch(Exception ex){
                system.debug(ex);
            }
        }
        
    }
}