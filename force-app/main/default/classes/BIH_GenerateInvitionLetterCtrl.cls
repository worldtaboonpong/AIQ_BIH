/*------------------------------------------------------------
Author      : 
Company     : AIQ
Description : 
Test Class  : BIH_GenerateInvitionLetterCtrlTest
History     : 
11102022      ParthT     Clean-Up.
------------------------------------------------------------*/
global with sharing class BIH_GenerateInvitionLetterCtrl {
	global class InvitationLetterWrapper{
		@AuraEnabled
		global Invitation_Letter__c letterObj{get;set;}
		@AuraEnabled
		global List<Invitation_Letter_Person__c> letterPersonTypePatientObj{get;set;}
		@AuraEnabled
		global List<Invitation_Letter_Person__c> letterPersonTypeAttendantObj{get;set;}
		@AuraEnabled
		global Case caseObj{get;set;}
		@AuraEnabled
		global List<Invitation_Letter_Person__c> personListForDelete{get;set;}
		@AuraEnabled
		public Map<String,List<String>> InvitationLetterObjectPickListValue {get; set;}
		@AuraEnabled
		public Map<String,List<String>> CaseObjectPickListValue {get; set;}

	}
	// public BIH_GenerateInvitionLetterCtrl() {
		
	// }
	public static Map<String,List<String>> getPickListValuesIntoList(String ApiName ,List<String> field_name) {
		Map<String,List<String>> values = new Map<String,List<String>>();
		Schema.DescribeSobjectResult results = Schema.describeSObjects(new String[]{ApiName})[0];
		for(String fn : field_name) {
			List<String> tmpList = new List<String>();
			for (Schema.PicklistEntry entry : results.fields.getMap().get(fn).getDescribe().getPicklistValues()) {
				if (entry.isActive()) {
						tmpList.add(entry.getValue());
					}
				}
			values.put(fn,tmpList);
		}	
		return values;
   }
	@AuraEnabled
	global static InvitationLetterWrapper getInvitationLetterWrapper(string caseId){
		InvitationLetterWrapper wrapper = new InvitationLetterWrapper();
		Case caseObj = [SELECT Id,CaseNumber,Priority,Hospital_Number_HN__c,Subject,Full_Name__c,Passport_Number__c,Patient__r.Name,Patient__r.National_ID_Passport_Number__c,Specialty_Doctor__c,Attendant_Name__c,Appointment_Date__c FROM Case WHERE id=:caseId];
		List<Invitation_Letter__c> ilList = [SELECT Id,LastModifiedDate,LetterCountryText__c, LetterCountry__c,Generate_Date__c, LetterDear__c,LetterFrom__c, LetterTo__c, LetterSubject__c, LetterRefNo__c, Content__c, Version__c, Doc_Type__c, Case__c,LetterEmbassyType__c FROM Invitation_Letter__c WHERE Case__r.Id =:caseId ORDER BY LastModifiedDate Desc LIMIT 1 ];
		Invitation_Letter__c ilObj = new Invitation_Letter__c();
		List<Invitation_Letter_Person__c> ilpPatientList = new List<Invitation_Letter_Person__c>();
		List<Invitation_Letter_Person__c> ilpAttentdentList = new List<Invitation_Letter_Person__c>();
		Date datetoday = date.today();
		String dayStr = String.ValueOf(datetoday.day());
		String monthStr =  String.ValueOf(datetoday.month());
		String yearStr =  String.ValueOf(datetoday.year());
		wrapper.InvitationLetterObjectPickListValue = getPickListValuesIntoList('Invitation_Letter__c',new List<String>{'LetterCountry__c','LetterEmbassyType__c'});
		wrapper.CaseObjectPickListValue = getPickListValuesIntoList('Case',new List<String>{'Specialty_Doctor__c'});
		wrapper.caseObj = caseObj;
		if(ilList.size() >0){
			ilObj = ilList[0];
			List<Invitation_Letter_Person__c> ilpList = [SELECT Person_Name__c, Passport_Number__c, Appointment_Date__c, Specialty__c, Person_Type__c, Invitation_Letter__c, Id FROM Invitation_Letter_Person__c WHERE Invitation_Letter__r.Id=:ilObj.Id];
			for(Invitation_Letter_Person__c tmp: ilpList){
				if(tmp.Person_Type__c == 'Patient'){
					ilpPatientList.add(tmp);
				}else{
					ilpAttentdentList.add(tmp);
				}
			}
		}else{
			ilObj.LetterTo__c = 'Bangladesh';
			ilObj.LetterFrom__c = 'Bumrungrad International Hospital, 33 Sukhumvit 3, Bangkok, 10110, Thailand';
			ilObj.LetterDear__c = 'Sir/Madam';
			ilObj.Content__c = 'This letter is to certify that the following patient has requested to visit Bumrungrad '+
								'International Hospital for further medical examination and treatment. We respectfully '+
								'request The Royal Thai Embassy’s assistance in processing the visa for medical service '+
								'purposes. The relevant information pertaining to the visit of the patient(s) and their '+
								'attendant(s) are as follows:';
			
			Invitation_Letter_Person__c tmpPerson = new Invitation_Letter_Person__c();
			tmpPerson.Person_Name__c = (caseObj.Patient__r.Name!=null)?caseObj.Patient__r.Name:caseObj.Full_Name__c;
			tmpPerson.Passport_Number__c = (caseObj.Patient__r.National_ID_Passport_Number__c!=null)?caseObj.Patient__r.National_ID_Passport_Number__c:caseObj.Passport_Number__c;
			tmpPerson.Appointment_Date__c = caseObj.Appointment_Date__c;
			tmpPerson.Specialty__c = caseObj.Specialty_Doctor__c;
			tmpPerson.Person_Type__c = 'Patient';
			ilpPatientList.add(tmpPerson);

			//Default Attendent
	        Invitation_Letter_Person__c tmpAttentdent = new Invitation_Letter_Person__c();
	       	tmpAttentdent.Person_Name__c = caseObj.Attendant_Name__c;
	        tmpAttentdent.Person_Type__c = 'Attendant';
	        ilpAttentdentList.add(tmpAttentdent);
		}
		if(ilObj.LetterTo__c == 'Bangladesh'){
			ilObj.LetterEmbassyType__c = 'Embassy';
			ilObj.LetterCountryText__c = 'Bangladesh';
		}
		ilObj.RefCase__c = caseObj.CaseNumber;
		ilObj.Generate_Date__c = date.today();
		ilObj.LetterSubject__c = (caseObj.Priority == 'URGENT' ? '['+caseObj.Priority+'] ' : '') +'Request for Invitation letter for the patient';
		ilObj.LetterRefNo__c = caseObj.Hospital_Number_HN__c;
		ilObj.Name = 'IV'+caseObj.CaseNumber+'_'+yearStr.right(2)+ monthStr.leftPad(2,'0')+ dayStr.leftPad(2,'0'); // Display name of the files
		System.debug('ilObj : '+ilObj);

		upsert ilObj;
		wrapper.letterPersonTypePatientObj = ilpPatientList;
		wrapper.letterPersonTypeAttendantObj = ilpAttentdentList;
		wrapper.letterObj = ilObj;
		return wrapper;
	}
	@AuraEnabled
	global static Case saveInvitationLetterWrapper(InvitationLetterWrapper wrapper){
		List<Invitation_Letter_Person__c> tmpPatientList = new List<Invitation_Letter_Person__c>();
		List<Invitation_Letter_Person__c> tmpAttendantList = new List<Invitation_Letter_Person__c>();
		System.debug(wrapper.letterObj);
		System.debug(wrapper.letterPersonTypePatientObj);
		System.debug(wrapper.letterPersonTypeAttendantObj);
		System.debug(wrapper.caseObj);

		wrapper.letterObj.Case__c = wrapper.caseObj.Id;
		if(wrapper.letterObj.LetterTo__c == 'Bangladesh'){
			wrapper.letterObj.LetterEmbassyType__c = 'Embassy';
			wrapper.letterObj.LetterCountryText__c = 'Bangladesh';
		}
		upsert wrapper.letterObj;

		System.debug(wrapper.letterObj.id);
		for(Invitation_Letter_Person__c tmp :wrapper.letterPersonTypePatientObj){
			tmp.Invitation_Letter__c = wrapper.letterObj.Id;
			if(tmp.Person_Name__c != '' && tmp.Person_Name__c != null){
				tmpPatientList.add(tmp);
			}else if( tmp.Passport_Number__c == '' && tmp.Person_Name__c == '' && tmp.id != null  ){
				wrapper.personListForDelete.add(tmp);
			}
		}
		for(Invitation_Letter_Person__c tmp :wrapper.letterPersonTypeAttendantObj){
			tmp.Invitation_Letter__c = wrapper.letterObj.Id;
			if(tmp.Person_Name__c != '' && tmp.Person_Name__c != null){
				tmpAttendantList.add(tmp);
			}else if( tmp.Passport_Number__c == '' && tmp.Person_Name__c == '' && tmp.id != null  ){
				wrapper.personListForDelete.add(tmp);
			}
		}

		System.debug('wrapper.personListForDelete : '+wrapper.personListForDelete);
		// System.debug('tmpAttendantList : '+tmpAttendantList);
		upsert tmpPatientList;
		upsert tmpAttendantList;
		//upsert wrapper.caseObj;
		if( wrapper.personListForDelete != null &&  wrapper.personListForDelete.size() >0){
			delete wrapper.personListForDelete;
		}

		System.debug(wrapper.letterPersonTypePatientObj);
		return wrapper.caseObj;
	}
	@AuraEnabled
	global static Case createInvitaionLetterToPDF(string caseId){
		System.debug('caseId : '+caseId);
		PageReference pdf = Page.GeneratePDFInvitation;
		pdf.getParameters().put('id',caseId);
		pdf.getParameters().put('isCopy','false');
		pdf.setRedirect(true);
		Case caseObj = [SELECT id,CaseNumber FROM Case WHERE id=:caseId];
		Date datetoday = date.today();
		Blob body ;
		if(Test.isRunningTest()) {
  			body = blob.valueOf('Unit.Test');
		}else{
			body = pdf.getContent();
		}
		Set<String> tmpId = new Set<String>();
		tmpId.add(caseId);

		//Real Version
		System.debug('=== Real Version ===');
		List<ContentDocumentLink> tmpCD = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN: tmpId AND ContentDocument.Title LIKE 'IV%' AND ( NOT ContentDocument.Title LIKE '%_COPY.pdf')];
		System.debug('tmpCD : '+tmpCD);
		ContentVersion conVer = new ContentVersion();
		conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
		conVer.PathOnClient = 'IV'+caseObj.CaseNumber+'_'+String.ValueOf(datetoday.year()).right(2)+ String.ValueOf(datetoday.month())+String.ValueOf(datetoday.day())+'.pdf'; // The files name, extension is very important here which will help the file in preview.
		conVer.Title =  'IV'+caseObj.CaseNumber+'_'+String.ValueOf(datetoday.year()).right(2)+ String.ValueOf(datetoday.month()).leftPad(2,'0')+String.ValueOf(datetoday.day()).leftPad(2,'0')+'.pdf'; // Display name of the files
		conVer.VersionData = body; // converting your binary string to Blog
		if(tmpCD.size()>0){
			conVer.ContentDocumentId  = tmpCD[0].ContentDocumentId;
		}
		insert conVer;
		if(tmpCD.size() == 0){
			Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
			ContentDocumentLink cDe = new ContentDocumentLink();
			cDe.ContentDocumentId = conDoc;
			cDe.LinkedEntityId = caseId; // you can use objectId,GroupId etc
			cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
			cDe.Visibility = 'AllUsers';
			insert cDe;
		}

		//Copy Version
		System.debug('=== Copy Version ===');
		PageReference pdf_copy = Page.GeneratePDFInvitation;
		pdf_copy.getParameters().put('id',caseId);
		pdf_copy.getParameters().put('isCopy','true');
		pdf_copy.setRedirect(true);
		Blob body_copy ;
		if(Test.isRunningTest()) {
  			body_copy = blob.valueOf('Unit.Test');
		}else{
			body_copy = pdf_copy.getContent();
		}
		List<ContentDocumentLink> tmpCD_copy = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN: tmpId AND ContentDocument.Title LIKE 'IV%' AND ContentDocument.Title LIKE'%_COPY.pdf'];
		System.debug('tmpCD_copy : '+tmpCD_copy);
		ContentVersion conVer_copy = new ContentVersion();
		conVer_copy.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
		conVer_copy.PathOnClient = 'IV'+caseObj.CaseNumber+'_'+String.ValueOf(datetoday.year()).right(2)+ String.ValueOf(datetoday.month())+String.ValueOf(datetoday.day())+'_COPY.pdf'; // The files name, extension is very important here which will help the file in preview.
		conVer_copy.Title =  'IV'+caseObj.CaseNumber+'_'+String.ValueOf(datetoday.year()).right(2)+ String.ValueOf(datetoday.month()).leftPad(2,'0')+String.ValueOf(datetoday.day()).leftPad(2,'0')+'_COPY.pdf'; // Display name of the files
		conVer_copy.VersionData = body_copy; // converting your binary string to Blog
		if(tmpCD_copy.size()>0){
			conVer_copy.ContentDocumentId  = tmpCD_copy[0].ContentDocumentId;
		}
		insert conVer_copy;
		if(tmpCD_copy.size() == 0){
			Id conDoc_copy = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer_copy.Id].ContentDocumentId;
			ContentDocumentLink cDe_copy = new ContentDocumentLink();
			cDe_copy.ContentDocumentId = conDoc_copy;
			cDe_copy.LinkedEntityId = caseId; // you can use objectId,GroupId etc
			cDe_copy.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
			cDe_copy.Visibility = 'AllUsers';
			insert cDe_copy;
		}		
		

		return caseObj;
		
		


	}
}