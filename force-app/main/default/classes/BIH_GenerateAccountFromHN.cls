global class BIH_GenerateAccountFromHN implements Queueable, Database.AllowsCallouts { /**Change to Queueable*/
	
	public List<Id> caseId {get;set;}
	
	global BIH_GenerateAccountFromHN(List<id> cid) {
		this.caseId = cid;
		
	}

	/**Change to Queueable
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([Select id,accountid,patient__c,Hospital_Number_HN__c
                                         from Case
                                         where origin != 'Web' and  id in:caseId 
                                        ]);
	}
    */

    /**Change to Queueable*/
   	//global void execute(Database.BatchableContext BC, List<Case> scope) {
   	global void execute(QueueableContext context) { 
        List<Case> scope = new List<Case>([ Select id,accountid,patient__c,Hospital_Number_HN__c
                                            from Case
                                            where origin != 'Web' and  id in:caseId 
                                          ]);

		List<BIH_PatientInformationService.patientInfoData> pTnfo = new List<BIH_PatientInformationService.patientInfoData>();
		Set<string> hnSet = new Set<string>();
		Map<String,Account> hnMap = new Map<String,Account>();

	    system.debug('scope size : '+scope.size());

	    //CHECK AMOUNT OF CASE 
   		if(scope.size() > 0){
	        for(Case c: scope){
	            if(c.Hospital_Number_HN__c != null){
	            	
                    BIH_PatientInformationService.getPatientInformation(c.Hospital_Number_HN__c);
                    pTnfo = BIH_PatientInformationService.patientInformation;

                    if(pTnfo.size() > 0 && pTnfo.get(0) !=null && pTnfo.get(0).hn !=null){
                         hnSet.add(pTnfo.get(0).hn);
                    }

                    //ADD SET HN NUMBER
	                hnSet.add(c.Hospital_Number_HN__c);
	            }
	        }
            
            if(hnSet.size() > 0){

                //GET EXISTING ACCOUNT BY HN NUMBER
                List<Account> accList = [SELECT id,FirstName,LastName,PersonBirthdate,Hospital_Number_HN__c FROM Account WHERE Hospital_Number_HN__c IN:hnSet];
                if(accList.size() > 0){
                    for(Account a: accList){
                        hnMap.put(a.Hospital_Number_HN__c,a);
                    }
                }               

               
                List<Account> updateAccList = new List<Account>();
                List<Account> insertAccList = new List<Account>();
                
                for(Case c : scope){
                    //Get Patient from Trakcare
                    if(c.Hospital_Number_HN__c !=null){
                        //HN is found on Trakcare
                        if(pTnfo.size() > 0){
                            //HN is found on SF,Update account value from Trakcare
                            if(hnMap.containsKey(c.Hospital_Number_HN__c)){
                                Account updateAcc = hnMap.get(c.Hospital_Number_HN__c);
                                updateAcc.PersonBirthdate = Date.ValueOf(pTnfo.get(0).dateOfBirth);
                                updateAcc.Salutation = pTnfo.get(0).title;
                                updateAcc.firstName = pTnfo.get(0).firstName;
                                updateAcc.lastName = pTnfo.get(0).lastName;
                                updateAcc.Gender__c = pTnfo.get(0).getGender(pTnfo.get(0).sex);
                                updateAcc.PersonEmail = pTnfo.get(0).email;
                                updateAcc.Phone = pTnfo.get(0).mobilePhone;
        
                                updateAccList.add(updateAcc);
                            }
                            else if(pTnfo.get(0) !=null && hnMap.containsKey(pTnfo.get(0).hn)){
                                Account updateAcc = hnMap.get(pTnfo.get(0).hn);
                                updateAcc.PersonBirthdate = Date.ValueOf(pTnfo.get(0).dateOfBirth);
                                updateAcc.Salutation = pTnfo.get(0).title;
                                updateAcc.firstName = pTnfo.get(0).firstName;
                                updateAcc.lastName = pTnfo.get(0).lastName;
                                updateAcc.Gender__c = pTnfo.get(0).getGender(pTnfo.get(0).sex);
                                updateAcc.PersonEmail = pTnfo.get(0).email;
                                updateAcc.Phone = pTnfo.get(0).mobilePhone;
        
                                updateAccList.add(updateAcc);
                            }else{
                            //HN not found on SF,Create account from Trakcare
                                Account newAcc = new Account();
                                newAcc.Hospital_Number_HN__c = pTnfo.get(0).hn;
                                newAcc.PersonBirthdate = Date.ValueOf(pTnfo.get(0).dateOfBirth);
                                newAcc.Salutation = pTnfo.get(0).title;
                                newAcc.firstName = pTnfo.get(0).firstName;
                                newAcc.lastName =  pTnfo.get(0).lastName;
                                newAcc.Gender__c = pTnfo.get(0).getGender(pTnfo.get(0).sex);
                                newAcc.PersonEmail = pTnfo.get(0).email;
                                newAcc.Phone = pTnfo.get(0).mobilePhone;
        
                                insertAccList.add(newAcc);
                            }                      
                        }
                    }
                }
                
                try{
                    if(insertAccList.size() > 0 ){
                        insert insertAccList;
                        
                        //add new account to list
                        for(Account a: insertAccList){
                            hnMap.put(a.Hospital_Number_HN__c,a);
                        }
                    }
                    
                    if(updateAccList.size() > 0 ){
                        update updateAccList;
                    }
                    
                   //mapping patient__c to account on case
                    for(Case c : scope){
                        if(hnMap.containsKey(c.Hospital_Number_HN__c)){//c.patient__c == null && 
                            c.patient__c = hnMap.get(c.Hospital_Number_HN__c).id;
                        }
                    }
                } catch (Exception e) {
                    system.debug(e);
                }
    
                Database.SaveResult[] lsr = Database.update(scope, false);
                // Iterate through each returned result
                for (Database.SaveResult sr : lsr) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully updated HN on account with ID: ' + sr.getId());
                    } else {
                        // Operation failed, so get all errors
                        for (Database.Error err : sr.getErrors()) {
                            System.debug(logginglevel.ERROR, 'There is error updating HN on account. Error Message is: ' + err.getMessage());
                        }
                    }
                }

            }
            
	   		/*for(Case c : scope){
	   			
	   			if(hnMap.containsKey(c.Hospital_Number_HN__c)){
	   				//Existing Account is found
	   				c.AccountId = hnMap.get(c.Hospital_Number_HN__c).id;
   				}else{
   					//Not found, Create account from Trakcare
   					BIH_PatientInformationService.getPatientInformation(c.Hospital_Number_HN__c);
	                pTnfo = BIH_PatientInformationService.patientInformation;

	                if(pTnfo!=null){
	                	Account newAcc = new Account();
		                newAcc.Hospital_Number_HN__c = pTnfo.hn;
		                newAcc.Date_of_Birth__c = Date.ValueOf(pTnfo.dateOfBirth);
		                newAcc.Salutation = pTnfo.title;
		                newAcc.firstName = pTnfo.firstName;
		                newAcc.lastName = pTnfo.lastName;
		                newAcc.Gender__c = pTnfo.getGender(pTnfo.sex);
		                newAcc.Email__c = pTnfo.email;
		                newAcc.Phone = pTnfo.mobilePhone;

		                trakcareAccList.add(newAcc);
	                }
   				}
	   		}

	   		if(trakcareAccList.size() > 0 ){
	   			insert trakcareAccList;
	   			
	   			//add new account to list
	   			for(Account a: trakcareAccList){
		            hnMap.put(a.Hospital_Number_HN__c,a);
		        }
	   		}
	   		
	   		for(Case c : scope){
	   			if(c.accountid == null && hnMap.containsKey(c.Hospital_Number_HN__c)){
		   			c.AccountId = hnMap.get(c.Hospital_Number_HN__c).id;
		   		}
		   	}

	   		update scope;*/
   		}

   		

	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}