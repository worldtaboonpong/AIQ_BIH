global class DeleteContactCTIBatch implements Queueable { /**Change to Queueable*/
    global Integer recordsProcessed = 0;
    global Set<String> phoneList = new Set<String>();
    global Datetime startTime{get;set;}
    global Datetime finishTime{get;set;}
    global List<String> allPhone = new List<String>();
    global List<String> phoneSuccess = new List<String>();
    global List<String> phoneFail = new List<String>();
    global final String query;

    global DeleteContactCTIBatch(String q) {
        query = q;
    }
    
    /**Change to Queueable
    global Database.QueryLocator start(Database.BatchableContext BC) {
        startTime = Datetime.now();
        return Database.getQueryLocator(query);
    }
    */

    /**Change to Queueable*/
    //global void execute(Database.BatchableContext bc,List<Contact> scope){
    global void execute(QueueableContext context){
        startTime = Datetime.now();
        List<Contact> scope = Database.query(query);

        try {
            List<Id> conList = new List<Id>();
            List<Task> newListTask = new List<Task>();
            List<String> newListTaskId = new List<String>();
            List<Contact> contactList = new List<Contact>();
            List<String> newContactList = new List<String>();
            Map<Id,Task> mapTask = new Map<Id,Task>();
            Map<Id,Contact> mapContact = new Map<Id,Contact>();
            List<Database.DeleteResult> contactUpdateResultList = new List<Database.DeleteResult>();

            if(scope.size() > 0){
                for (Contact con : scope){
                    conList.add(con.Id);
                    mapContact.put(con.Id,con);
                }
                
                List<Task> listTask = [SELECT WhatId,WhoId,Id FROM Task WHERE WhoId in:conList];
            
                if(listTask.size() > 0){
                    for (Task t : listTask){
                        mapTask.put(t.WhoId,t);
                    }
                    System.Debug('listTask '+listTask.size()+'WhoId : '+mapTask.keyset());
                }
                
                List<Case> listCase = [SELECT Phone__c,Id,ContactId,Contact.Phone,Verified_Patient__c,
                                        Patient__r.Name,Patient__r.FirstName,Patient__r.Local_First_Name__c,
                                        Patient__r.Phone,AccountId, Patient__r.PersonContactId,Patient__r.PersonContact.Phone    
                                        FROM Case WHERE ContactId in:conList];

                List<Case> listUpdateCase = new List<Case>();
                
                System.Debug('listCase: '+listCase);

                if(listCase.size()>0){
                    //Find case has created by contact
                    for (Case cases:listCase){
                        // System.Debug('cases.Contact.Phone: '+cases.Contact.Phone);
                        // System.Debug('cases.Patient__r.Phone: '+cases.Patient__r.Phone);
                        // System.Debug('cases.Verified_Patient__c: '+cases.Verified_Patient__c);

                        Contact currContact = mapContact.get(cases.ContactId);
                        

                        // System.Debug('currContact: '+currContact);

                        //Replace Phone Number
                        String contactPhone = cases.Contact.Phone;
                        
                        String casePhone = cases.Patient__r.Phone;
                        if (casePhone != null && casePhone != ''){
                            casePhone = casePhone.replaceAll('\\D','');
                            if (casePhone.startsWith('66')){
                                casePhone = casePhone.substring(2, casePhone.length());
                                casePhone = '0'+casePhone;
                            }
                        }
                        if (contactPhone != null && contactPhone != ''){
                            contactPhone = contactPhone.replaceAll('\\D','');
                            if (contactPhone.startsWith('66')){
                                contactPhone = contactPhone.substring(2, contactPhone.length());
                                contactPhone = '0'+contactPhone;
                            }
                        }
                        // System.Debug('contactPhone: '+contactPhone);
                        // System.Debug('casePhone: '+casePhone);

                        //Check Case
                        if (currContact != null){
                            if ((contactPhone == casePhone) && cases.Verified_Patient__c == true 
                            && ((currContact.FirstName == cases.Patient__r.FirstName)||(currContact.FirstName == cases.Patient__r.Local_First_Name__c))){
                                // System.Debug('CORRECT');
                                // System.Debug('cases.ContactId: '+cases.ContactId);
                                

                                Task thisTask = mapTask.get(cases.ContactId);
                                // System.Debug('thisTask: '+thisTask);
                                phoneList.add(contactPhone);
                                //Update Task
                                if (thisTask != null){
                                    listUpdateCase.add(cases);
                                    cases.ContactId = null;
                                    thisTask.WhatId = cases.Patient__c;
                                    thisTask.WhoId = null;

                                    if(!newListTaskId.contains(thisTask.Id)){
                                        newListTask.add(thisTask);
                                        newListTaskId.add(thisTask.Id);
                                    }
                                    
                                    if(!newContactList.contains(currContact.Id)){
                                        contactList.add(currContact);
                                        newContactList.add(currContact.Id);
                                    }
                                    
                                    recordsProcessed += 1;
                                }
                                // System.Debug('THISCASE : '+cases);
                            }
                        }
                    }
                }

                Set<String> phoneNumbers = new Set<String>();
                Map<String,Contact> mTmp = new Map<String,Contact>();
                for(Contact mCase :  [SELECT Id,Phone,FirstName FROM Contact WHERE Id in:conList and IsPersonAccount = false]){
                    String contactPhone = mCase.Phone;
                    if (contactPhone != null && contactPhone != ''){
                        contactPhone = contactPhone.replaceAll('\\D','');
                        if (contactPhone.startsWith('66')){
                            contactPhone = contactPhone.substring(2, contactPhone.length());
                            contactPhone = '0'+contactPhone;
                        }
                        
                        if(mCase.FirstName!=null){
                            phoneNumbers.add(mCase.FirstName);
                            // System.debug(mCase.FirstName.toUpperCase()+contactPhone+'');
                            mTmp.put(mCase.FirstName.toUpperCase()+contactPhone+'', mCase);
                        }
                    }
                }

                for(Account mAcc :  [SELECT Id,Phone,FirstName FROM Account WHERE FirstName IN: phoneNumbers]){
                    if(mAcc.FirstName!=null&&mAcc.Phone!=null){
                        String contactPhone = mAcc.Phone;
                        contactPhone = contactPhone.replaceAll('\\D','');
                        if (contactPhone.startsWith('66')){
                            contactPhone = contactPhone.substring(2, contactPhone.length());
                            contactPhone = '0'+contactPhone;
                        }
                        // System.debug(mAcc.FirstName.toUpperCase()+contactPhone+'');
                        if(mTmp.containsKey(mAcc.FirstName.toUpperCase()+contactPhone+'')){
                            
                            Contact ct = mTmp.get(mAcc.FirstName.toUpperCase()+contactPhone+'');

                            phoneList.add(contactPhone);
                            if(!newContactList.contains(ct.Id)){
                                contactList.add(mapContact.get(ct.Id));
                                newContactList.add(ct.Id);
                            }

                            Task thisTask = mapTask.get(ct.Id);
                            
                            if (thisTask != null){
                                
                                thisTask.WhatId = mAcc.Id;
                                thisTask.WhoId = null;

                                if(!newListTaskId.contains(thisTask.Id)){
                                    newListTask.add(thisTask);
                                    newListTaskId.add(thisTask.Id);
                                }
                            }
                        }
                    }
                }

                //SavePoint sp = Database.setSavePoint();

                System.Debug('listCase: '+listUpdateCase);
                System.Debug('newListTask: '+newListTask);
                System.Debug('contactList: '+contactList);
                System.Debug('phoneList: '+phoneList);
                phoneSuccess.addAll(phoneList);
                allPhone.addAll(phoneList);

                if (listUpdateCase.size()>0){
                    try {
                        update listUpdateCase;
                        System.Debug('UPDATE CASE SUCCESS');
                    } catch (Exception e) {
                        //Database.rollback(sp);
                        throw e;
                    }
                }
                if (newListTask.size()>0){
                    try {
                        update newListTask;
                        System.Debug('UPDATE SUCCESS');
                    } catch (Exception e) {
                        //Database.rollback(sp);
                        throw e;
                    }
                }
                if (contactList.size() > 0){
                    try {
                        // delete contactList;
                        contactUpdateResultList = Database.delete(contactList, false);
                        for (Integer i = 0 ; i < contactUpdateResultList.size() ; i++){
                            Database.DeleteResult dr = contactUpdateResultList.get(i);
                            System.debug('dr >> ' + dr);
                            
                            if (!dr.isSuccess()) {
                                // assignFail += 1;
                                String errormsg = '';

                                for(Database.Error err : dr.getErrors()) {
                                    errormsg += err.getStatusCode() + ':' + err.getMessage();
                                }
                                System.debug('errormsg >> ' + errormsg);
                                phoneFail.add(allPhone.get(i));
                                phoneSuccess.remove(phoneSuccess.indexOf(allPhone.get(i)));
                                System.debug('phoneSuccess >> ' + phoneSuccess);
                                System.debug('phoneFail >> ' + phoneFail);
                            }
                        }
                        System.Debug('DELETE SUCCESS');
                    }catch(DmlException dex){
                        System.debug('>>> DmlException Delete Contact: ' + dex.getMessage() + ' Line Number: ' + dex.getLineNumber());
                    } catch (Exception e) {
                        //Database.rollback(sp);
                        System.debug('>>> Exception Delete Contact: ' + e.getMessage() + ' Line Number: ' + e.getLineNumber() + '>>' + e.getStackTraceString());
                        throw e;
                    }
                }
            } 
        
        }catch(DmlException dex){
            System.debug('>>> DmlException From DeleteContactCTIBatch (Main): ' + dex.getMessage() + ' Line Number: ' + dex.getLineNumber());
        } catch (Exception e) {
            String errmsg = e.getMessage();
            String errdetail = e.getStackTraceString();
            System.debug('>>> Exception From DeleteContactCTIBatch (Main): ' + e.getMessage() + ' Line Number: ' + e.getLineNumber() + '>>' + e.getStackTraceString());
            //throw e;
        }

    }
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed.');
        AsyncApexJob job = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, 
        NumberOfErrors,CreatedBy.Email FROM AsyncApexJob WHERE Id = :bc.getJobId()];
        System.debug(job.Id + '|'+job);
        System.debug('phoneSuccess >> ' + phoneSuccess);
        System.debug('phoneFail >> ' + phoneFail);
        finishTime = Datetime.now();
        string phoneSuccessText = '';
        string phoneFailText = '';
        if(phoneSuccess.size() > 0){
            phoneSuccessText = String.join(phoneSuccess, ', ');
        }
        if(phoneFail.size() > 0){
            phoneFailText = String.join(phoneFail, ', ');
        }
        BatchEmailService.SendEmailForDeleteCTIBatch(startTime,finishTime,job,phoneSuccess.size(),phoneSuccessText, phoneFailText);
    }
}