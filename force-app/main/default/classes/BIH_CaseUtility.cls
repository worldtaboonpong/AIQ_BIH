global class BIH_CaseUtility {
	// public BIH_CaseUtility() {
		
	// }


    @AuraEnabled
    public static string getBtnConfig(){
        BIH_Constants__mdt cons = [Select Id, MasterLabel , DeveloperName , Value_1__c From BIH_Constants__mdt WHERE DeveloperName = 'VERIFY_BTN_CONFIG'];
        return cons.Value_1__c;
    }

   @AuraEnabled
    public static Map<String,Mapping_Close_Case_Record_Type__mdt> mapClosedCase (){
        
            Map<String,Mapping_Close_Case_Record_Type__mdt> mapClosecase = new Map<String,Mapping_Close_Case_Record_Type__mdt>();
            for(Mapping_Close_Case_Record_Type__mdt mapClose : [Select MasterLabel, Channel__c, Close_Record_Type__c,Active_Record_Type__c  from Mapping_Close_Case_Record_Type__mdt]){
                mapClosecase.put(mapClose.MasterLabel,mapClose);
            }
    
        return mapClosecase;
    }
    @AuraEnabled
    public static Map<String,RecordType> recordTypeMap (){
        Map<String,RecordType> recordMaps = new Map<String,RecordType>();
        // RecordType record = [SELECT Id, DeveloperName, Name FROM RecordType WHERE DeveloperName= :recordName];
        for (RecordType mapRecord :[SELECT Id, DeveloperName, Name FROM RecordType]){
            recordMaps.put(mapRecord.DeveloperName, mapRecord);
        }
        // system.debug('recordMaps: '+recordMaps);
    
        return recordMaps;
    }
    @AuraEnabled
    public static Map<String,RecordType> ClosedrecordTypeMap (){
        Map<String,RecordType> recordMaps = new Map<String,RecordType>();
        // RecordType record = [SELECT Id, DeveloperName, Name FROM RecordType WHERE DeveloperName= :recordName];
        for (RecordType mapRecord :[SELECT Id, DeveloperName, Name FROM RecordType]){
            recordMaps.put(mapRecord.Name, mapRecord);
        }
        // system.debug('recordMaps: '+recordMaps);
    
        return recordMaps;
    }
    @AuraEnabled
    public static Map<String,Group> ownerMap (){
        // system.debug('ownerName: '+ownerName);
        Map<String,Group> ownerMaps = new Map<String,Group>();
        for (Group mapOwner : [SELECT Id, Name, DeveloperName, Type FROM Group WHERE Type='Queue']){
            ownerMaps.put(mapOwner.Name,mapOwner);
        }
        // List<Group> owner = [SELECT Id, Name, DeveloperName, Type FROM Group WHERE Type=:ownerName];
        // system.debug('ownerMaps: '+ownerMaps);
        
        return ownerMaps;
    }
    @AuraEnabled
    public static Map<String,Mapping_Channel_with_User_Team__mdt> mapDataChildcase (){
        
            Map<String,Mapping_Channel_with_User_Team__mdt> mapChildcase = new Map<String,Mapping_Channel_with_User_Team__mdt>();
            for(Mapping_Channel_with_User_Team__mdt mapChild : [Select Id, MasterLabel, Channel__c, Owner_Type__c,Queue_Name__c ,Child_Case__c,Record_Type_Name__c  from Mapping_Channel_with_User_Team__mdt]){
                if (mapChild.Child_case__c == true){
                mapChildcase.put(mapChild.Channel__c,mapChild);
                }
            }
    
        return mapChildcase;
    }
	@AuraEnabled
    public static List<Case> validateCaseDuplicate(Id caseId){
    	List<Case> duplicateList = new List<Case>();

    	//RO Duplicate Email , 2 Ro send email is same patient and subject.


    	//Mail duplicate from email2case by Subject email
        List<Case> currentCase = [Select id,subject,createddate,parentid,Walk_in__c,Sender_Type__c,
                                SuppliedEmail,Contact_Number__c,accountid 
                                from Case where id =: caseId];

        Set<String> subjectSet = new Set<String>();
        Set<Id> senderSet = new Set<Id>();
        Set<String> senderEmailSet = new Set<String>();
        Set<String> senderContactNumberSet = new Set<String>();

        for(Case cSubj : currentCase){
            if(cSubj.parentid ==null && !cSubj.Walk_in__c){

                if(cSubj.Sender_Type__c == 'Referral Office'){
                    //set subject for filter subject dup.
                    subjectSet.add(cSubj.subject);
                }else if(cSubj.Sender_Type__c == 'Individual'){
                    //set sender for filter sender dup.
                    senderSet.add(cSubj.accountid);
                }else if(cSubj.Sender_Type__c == 'Unclassified Type' && cSubj.SuppliedEmail != null){
                    senderEmailSet.add(cSubj.SuppliedEmail);
                }else if(cSubj.Sender_Type__c == 'Unclassified Type' && cSubj.Contact_Number__c != null){
                    senderContactNumberSet.add(cSubj.Contact_Number__c);
                }
  
            }
        }
    

        if(subjectSet.size() > 0){
            Map<Id,Case> subjMappingCase = new Map<Id,Case>([Select id,CaseNumber,Subject,OwnerId,Owner.Name ,CreatedDate,SuppliedEmail,AccountId,Account.Name
                                                         from case 
                                                         where subject in: subjectSet
                                                        and status != 'closed' 
                                                        and parentid = null]);
 			duplicateList = subjMappingCase.values();
        }

        if(senderSet.size() > 0){
            Map<Id,Case> subjMappingCase = new Map<Id,Case>([Select id,CaseNumber,Subject,OwnerId,Owner.Name ,
                                                        CreatedDate,SuppliedEmail,AccountId,Account.Name
                                                         from case 
                                                         where accountid in: senderSet
                                                        and status != 'closed' 
                                                        and parentid = null]);
            duplicateList = subjMappingCase.values();
        }

        if(senderEmailSet.size() > 0){
            Map<Id,Case> subjMappingCase = new Map<Id,Case>([Select id,CaseNumber,Subject,OwnerId,Owner.Name ,
                                                        CreatedDate,SuppliedEmail,AccountId,Account.Name
                                                         from case 
                                                         where SuppliedEmail in: senderEmailSet
                                                        and status != 'closed' 
                                                        and parentid = null]);
            duplicateList = subjMappingCase.values();
        }

        if(senderContactNumberSet.size() > 0){
            Map<Id,Case> subjMappingCase = new Map<Id,Case>([Select id,CaseNumber,Subject,OwnerId,Owner.Name ,
                                                        Contact_Number__c,CreatedDate,SuppliedEmail,AccountId,Account.Name
                                                         from case 
                                                         where Contact_Number__c in: senderContactNumberSet
                                                        and status != 'closed' 
                                                        and parentid = null
                                                        and Contact_Number__c!=null]);
            duplicateList = subjMappingCase.values();
        }
        
       

    	//Junk mail


    	return duplicateList;
    }
    
    @AuraEnabled
    public static List<Case> getAllChildCase(Id caseId){
        Map<Id,Case> parentCase = new Map<Id,Case>([Select id,channel__c from case where id =: caseId]);
        List<Case> childList = [Select id,CaseNumber,Subject,Status,Cancellation_Appointment__c,Close_Case_Reason__c,OwnerId,Owner.Name,Channel__c,parentid,parent.Close_Case_Reason__c  from case where parentid =:caseId];
        List<Case> caseList = new List<Case>();
        for(Case c : childList){
            if(parentCase.get(c.parentid)!=null && 
            parentCase.get(c.parentid).channel__c == c.channel__c &&
            !c.Cancellation_Appointment__c){
                caseList.add(c);
            }
        }

        return caseList;
    }
    
    @AuraEnabled
    public static List<Case> getCaseInfo(Id caseId){
        
        List<Case> caseList = [Select id,IsClosed,CaseNumber,Owner_Change_Reason__c,Subject,RecordTypeId,RecordType.Name,
                               Status,OwnerId,Owner.Name,Owner.Type,Lead_Source__c,
                               AccountId,Account.FirstName,Account.Lastname,Account.Name,
                               Hospital_Number_HN__c,SuppliedEmail,Full_Name__c,
                               Phone__c,Patient_Email__c,Patient__c,
                               Patient__r.FirstName,Patient__r.Lastname,Patient__r.Name,
                               Procedure_1__c,Procedure_2__c,Procedure_3__c ,Channel__c,Origin, Age_Formula__c
                               from case where id =:caseId];

        for(Case c : caseList){
            //update lead source
            if(c.Channel__c !=null  && c.Channel__c !=''){
                string channelWithOrigin = c.Channel__c+c.origin;
                if(channelWithOrigin !=null && channelWithOrigin!= ''){
                    if(mapLeadSource.get(channelWithOrigin)!=null ){
                        c.Lead_Source__c = mapLeadSource.get(channelWithOrigin).Source__c;
                    }else if (c.Origin != 'RO Website'){
                        if(mapLeadSource.get('Default'+c.origin) != null ){
                            c.Lead_Source__c =  mapLeadSource.get('Default'+c.origin).Source__c;
                        }
                    }
                }
            }
        }

        system.debug('Current case : '+caseList);
        return caseList;
    }

    public static  Map<String,Service_Type_Matrix__c> mapSVTM {get{
        if(mapSVTM==null){
         mapSVTM = new Map<String,Service_Type_Matrix__c>();
            for(Service_Type_Matrix__c svtm : [SELECT Id,SMS_Template__c, Category_Level1_English__c, 
                                                Category_Level2_English__c, Category_Level3_English__c, SLA__c,Responsible_Team__c
                                            FROM Service_Type_Matrix__c]){
                mapSVTM.put(svtm.Category_Level1_English__c+svtm.Category_Level2_English__c+svtm.Category_Level3_English__c, svtm);
                                                
            }

        }
        return mapSVTM;

    }set;}

    public static  Map<String,Lead_Source_Mapping__mdt> mapLeadSource {get{
        if(mapLeadSource==null){
         mapLeadSource = new Map<String,Lead_Source_Mapping__mdt>();
            for(Lead_Source_Mapping__mdt ls : [SELECT Id, Team__c, Source__c, Origin__c FROM Lead_Source_Mapping__mdt]){
                mapLeadSource.put(ls.Team__c+ls.Origin__c, ls);
                                            
            }

        }
        return mapLeadSource;

    }set;}
    
    @AuraEnabled
    public static Lead convertCaseToLead(Lead l){
        try{
            insert l;
        }catch(Exception ex){
            System.debug(ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
        
        system.debug('Lead '+l);
        return l;
    }
    @AuraEnabled
    public static List<Case> getcloseAllCase(String caseId){
        // try {
            List<Case> parentCase = [Select id,Status,Close_Case_Reason__c,channel__c from case where id=: caseId];
            return parentCase;
        // }catch(Exception ex){
        //     System.debug('Close All Case Error');
        //     System.debug(ex.getMessage());
        //     return null;
        // }
    }
    @AuraEnabled
    public static List<Case> getcloseAllChildCase(String caseId,String channel){
        List<Case> caseList = [Select id,CaseNumber,Subject,Status,Close_Case_Reason__c,
                                    OwnerId,Owner.Name,parent.Close_Case_Reason__c 
                                    from case where parentid =:caseId 
                                    and status != 'Closed' and Channel__c =: channel];        
        return caseList;
        
    }
    @AuraEnabled
    public static List<Case> closeAllChildCase(String caseId,String closeReason,List<Case> childCase){

        List<Case> updateCaseList = new List<Case>();
        
        string channel = '';
        try{

            if(caseId != '' && caseId!=null){
                List<Case> parentCase = [Select id,Status,Close_Case_Reason__c,channel__c,RecordTypeId from case where id=: caseId];
                
                //update parent
                parentCase[0].status = 'Closed';
                parentCase[0].Close_Case_Reason__c = closeReason;
                parentCase[0].isClosedAll__c = true;
                channel = parentCase[0].channel__c;
                
                updateCaseList.add(parentCase[0]);
                System.debug('+++++++++++++---------------');
                System.debug('+++++++++++++--- recordtype.name1111.1 : ' + parentCase[0].RecordTypeId);
                //update child
                List<Case> caseList = [Select id,CaseNumber,Subject,Status,Close_Case_Reason__c,
                                    OwnerId,Owner.Name,parent.Close_Case_Reason__c,Cancellation_Appointment__c
                                    from case where parentid =:caseId 
                                    and status != 'Closed' and Channel__c =: channel 
                                    and Cancellation_Appointment__c = false];

                system.debug('caseList'+caseList);
                for(Case c : caseList){
                    c.status = 'Closed';
                    c.Close_Case_Reason__c = closeReason;
                    c.isClosedAll__c = true;
                    updateCaseList.add(c);
                }

                update updateCaseList;
                //
                 List<Case> parentCase2 = [Select id,Status,Close_Case_Reason__c,channel__c,RecordTypeId from case where id=: caseId];
                System.debug('');
                System.debug('+++++++++++++---------------');
                System.debug('+++++++++++++--- recordtype.name222.1 : ' + parentCase2[0].RecordTypeId);
            }
        }catch(DMLException ex){
            System.debug(ex.getMessage());
            String errorMessage = ex.getMessage();
            Integer occurence;
            if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                errorMessage = errorMessage.mid(occurence, errorMessage.length());
                occurence = errorMessage.lastIndexOf(':');
                errorMessage = errorMessage.mid(0, occurence);
            }
            else {
                errorMessage = ex.getMessage();
            }
            throw new AuraHandledException(errorMessage);
        }
        System.debug('close case updated: ' + updateCaseList);
        return updateCaseList;
    }
    
    public static Map<Id,RecordType> caseRecordTypeName {get{
        if(caseRecordTypeName==null){
            caseRecordTypeName = new Map<Id,RecordType>([
                SELECT Id,  Name, DeveloperName, Description 
                FROM RecordType WHERE SobjectType = 'Case']);
        }
        return caseRecordTypeName;
    }set;}

    public static Map<Id,Case_Status_with_Record_Type__mdt> mapCaseStatusWithRecordType {get{
        if(mapCaseStatusWithRecordType==null){
            mapCaseStatusWithRecordType = new Map<Id,Case_Status_with_Record_Type__mdt>([
                                            SELECT Id, MasterLabel, Close_Reason__c, Status__c, Record_Type_Developer_Name__c, Order__c 
                                            FROM Case_Status_with_Record_Type__mdt order by Order__c]);
        }
        return mapCaseStatusWithRecordType;
    }set;}

    @AuraEnabled
    public static List<String> getPickListValuesCloseCaseReason(String objectType,String recordTypeId,String fieldName){ // String caseid
        List<String> pickListValuesList = new List<String>();
        // String SessionId = UserInfo.getOrganizationId().substring(0, 15) + ' ' +  UserInfo.getSessionId().substring(15);
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        // Case c = [SELECT recordTypeId FROM Case WHERE Id = :recordId];
        // String recordTypeId = c.recordTypeId;
        System.debug('recordTypeId: '+ recordTypeId);
        // string paramvalue = EncodingUtil.base64Encode(Blob.valueOf(userinfo.getSessionId()));
        // System.debug('paramvalue: '+paramvalue);
        String endpoint = URL.getSalesforceBaseUrl().toExternalForm();
        endpoint += '/services/data/v41.0';
        endpoint += '/ui-api/object-info/{0}/picklist-values/{1}/{2}';
        endpoint = String.format(endpoint, new String[]{ objectType, recordTypeId, fieldName });
        String SessionId = getUserSessionId();
        System.debug('endpoint: '+endpoint);
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + SessionId); 
        // req.setHeader('', '');
        // System.debug(test);
        System.debug('UserInfo: '+ SessionId);
        req.setEndpoint(endpoint);
        EncodingUtil.urlEncode(endpoint,'UTF-8');
        try {
            res = http.send(req);
            System.debug('res: '+ res);
        } catch (Exception e) {
            System.debug('ERROR: '+e);
            throw e;
        }
        System.debug('res.getBody() : '+res.getBody());
        Map<String,Object> root = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
        System.debug('root: '+ root);
        if (root == null){
            return pickListValuesList;
        }
    
        // List<Object> pValues = (List<Object>)root;
        List<Object> pValues = (List<Object>)root.get('values');
        for(Object pValue : pValues){
            Map<String,Object> pValueMap = (Map<String,Object>)pValue;
            pickListValuesList.add((String)pValueMap.get('label'));
        }

        return pickListValuesList;
    }
    @AuraEnabled
    public static String getUserSessionId(){
        String sessionId = '';
        // Refer to the Page
        PageReference reportPage = Page.PicklistValuesPage;
        // Get the content of the VF page
        String vfContent ='';
        if(Test.isRunningTest()){
            vfContent = 'Start_Of_Session_Id123456789012345679End_Of_Session_Id';
        }else{
            vfContent = reportPage.getContent().toString();
        }
        System.debug('vfContent '+vfContent);
        // Find the position of Start_Of_Session_Id and End_Of_Session_Id
        Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
        endP = vfContent.indexOf('End_Of_Session_Id');
        // Get the Session Id
        sessionId = vfContent.substring(startP, endP);
        System.debug('sessionId '+sessionId);
        // Return Session Id
        // 
        return sessionId;
 }
    
    @AuraEnabled
    public static List<String> getPickListValuesLeadSource(){
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Lead.LeadSource.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }

    public static Map<String,List<String>> getPickListValuesCaseMapping( List<String> field_name) {
        Map<String,List<String>> values = new Map<String,List<String>>();
        Schema.DescribeSobjectResult results = Schema.describeSObjects(new String[]{'Case'})[0];
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
    public static List<String> getPickListValuesCase(String field_name) {
        List<String> values = new List<String>();
        Schema.DescribeSobjectResult results = Schema.describeSObjects(new String[]{'Case'})[0];
        for (Schema.PicklistEntry entry : results.fields.getMap().get(field_name).getDescribe().getPicklistValues()) {
            if (entry.isActive()) {
                    values.add(entry.getValue());
             } 
        }
     
        return values;
   }
   @AuraEnabled
    public static Follow_Up_Step__c getFollowUpStep(String caseId) {
        Follow_Up_Step__c follow = new Follow_Up_Step__c();
        try {
            follow = [SELECT Id, Step__c, Remark__c, Contact_Date__c,
            Case__c, Phone_SMS_Email__c, Step_Status__c FROM Follow_Up_Step__c WHERE Case__c = :caseId
            ORDER BY Step__c DESC LIMIT 1];
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return follow;
        
   }

//     public static String getLabelByFieldCase(String field_name) {
//         String values;
//         Schema.DescribeSobjectResult results = Schema.describeSObjects(new String[]{'Case'})[0];
//         values = results.fields.getMap().get(field_name).getDescribe().getLabel();
//         return values;
//    }

   @AuraEnabled
    public static List<Case> UpdateCaseRecord(List<Case> caseList){
        try {
            for (Integer i = 0;i<caseList.size();i++){
                system.debug(caseList[i]);
                system.debug(caseList[i].Owner);
                system.debug('---------'); 
            }
                
            update caseList;
            // Case[] tmpCaseObj = (Case)caseList;
            // System.debug(tmpCaseObj);
            // upsert tmpCaseObj;

            // List<Account> tmpAccList = new List<Account>{patientObj,senderObj};
            // upsert tmpAccList;

            return caseList;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static User getCurrent()
    {
        User curr = new User();
        try {
            curr = [SELECT Id, Name,User_Team__c,UserRole.Name FROM User WHERE Id = :UserInfo.getUserId()];
        } catch (Exception e) {
            curr = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId()];
            System.debug(e.getMessage());
        }
        return curr; 
    }

    @AuraEnabled
    public static Case UpdateCase(Case caseOwner){
        try {
            update caseOwner;
            System.debug('Success');

            return caseOwner;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Boolean getisCC(String recordId){
        Boolean isCC = false;
        Case cc = [SELECT Channel__c,recordTypeId FROM Case WHERE Id = :recordId];
        System.debug('--------------------------');
        System.debug('cc.recordTypeId : '+cc.recordTypeId);
        System.debug('BIH_Constants.CONTACT_CENTER_CASE_RECORDTYPE : '+BIH_Constants.CONTACT_CENTER_CASE_RECORDTYPE);
        if (cc.Channel__c == 'Contact Center' || cc.recordTypeId == BIH_Constants.CONTACT_CENTER_CASE_RECORDTYPE){
            isCC = true;
        }
        return isCC;
    }
    
    @AuraEnabled
    public static Boolean getisPreRegis(String recordId){
        System.debug('+++++++++++++++++++++++++++');
        System.debug('recordId : '+recordId);
        Id REGISTRATION_CASE_RECORDTYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Registration Case').getRecordTypeId();
        Id Insurance_Case_RECORDTYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Case').getRecordTypeId();
         //System.debug('BIH_Constants.CONTACT_CENTER_CASE_RECORDTYPE : '+BIH_Constants.CONTACT_CENTER_CASE_RECORDTYPE);
        System.debug('REGISTRATION_CASE_RECORDTYPE : '+REGISTRATION_CASE_RECORDTYPE);
        Boolean isPreRegis = false;
        Case cc = [SELECT Channel__c,recordTypeId FROM Case WHERE Id = :recordId];

        System.debug('cc.Channel__c : '+cc.Channel__c);
        System.debug('cc.recordTypeId : '+cc.recordTypeId);
        
        /*System.debug('a1 : ');
        if (cc.Channel__c == 'PreRegistration'){
            System.debug('a2 : ');
        }
        System.debug('a3 : ');
        if (cc.recordTypeId == 'Registration Case'){
            System.debug('a4 : ');
        }*/
        
        System.debug('cc.recordTypeId : '+cc.recordTypeId);
        System.debug('REGISTRATION_CASE_RECORDTYPE : '+REGISTRATION_CASE_RECORDTYPE);
        
        if (cc.Channel__c == 'PreRegistration' || cc.recordTypeId == REGISTRATION_CASE_RECORDTYPE || cc.Channel__c == 'Insurance' ||cc.recordTypeId == Insurance_Case_RECORDTYPE){
            isPreRegis = true;
        }
        
        System.debug('isPreRegis : '+isPreRegis);
        return isPreRegis;
    }
    
    @AuraEnabled
    public static Boolean getisPC(String recordId){
        System.debug('+++++++++++++++++++++++++++PRIMARY_CASE_RECORDTYPE');
        System.debug('recordId : '+recordId);
        Id PRIMARY_CASE_RECORDTYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Primary Case').getRecordTypeId();
        System.debug('PRIMARY_CASE_RECORDTYPE : '+PRIMARY_CASE_RECORDTYPE);
        Boolean isPC = false;
        Case cc = [SELECT Channel__c,recordTypeId FROM Case WHERE Id = :recordId];
        System.debug('cc.recordTypeId : '+cc.recordTypeId);

        if ( cc.recordTypeId == PRIMARY_CASE_RECORDTYPE ){
            isPC = true;
        }
        
        System.debug('isPC : '+isPC);
        return isPC;
    }

    

    @AuraEnabled
    public static Case getSMSCase(String recordId){
        try {
            // case c = new case();
            DescribeSObjectResult describeResult = Case.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
            List<Case> caseObj = new List<Case>();

            String query = 'SELECT ' +
                            String.join( fieldNames, ',' ) +
                            ' ,Doctor__r.Name,Parent.CaseNumber,CreatedBy.Name,LastModifiedBy.Name,Account.Name,Patient__r.Name,Account.Hospital_Number_HN__c,Patient__r.Hospital_Number_HN__c'+
                            ' FROM ' +
                            describeResult.getName()  +
                            ' Where id = :recordId ';

            caseObj = Database.query(query);
        if (caseObj[0].App_Date__c != null){
            DateTime dt =  Date.valueOf(caseObj[0].App_Date__c);
            String strDatetime  = dt.format('dd-MM-yyyy');
            caseObj[0].App_Date_Format__c = strDatetime;
        }if (caseObj[0].App_Time__c != null){
            String strTimeChange = String.valueOf(caseObj[0].App_Time__c);
                            String[] strTimeSplit = strTimeChange.split(':');
                            Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                                ,Integer.valueOf(strTimeSplit[1]) //min
                                                                ,0                                //sec
                                                                ,0);
            String times = DateTime.newInstance(Date.today(), timeChange).format('HH:mm');
            caseObj[0].App_Time_Format__c = times;
        }
            return caseObj[0];
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static String sendSMSMessage(String message,Case caseObj,String contactNumber){
        try {
            String res = BIH_SendSMSService.getAppointmentInformation(message,caseObj,contactNumber);
            return res;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Map<String,Service_Type_Matrix__c> getSVTM(){
        return mapSVTM;
    }
    @AuraEnabled
    public static Map<String,SMS_Template__c> getSMSTemplate(){
        
        List<SMS_Template__c> sms = [SELECT Id,SMS_Template_Subject__c,Field_Mapping_TH__c,Field_Mapping_EN__c, SMS_TH__c, SMS_EN__c FROM SMS_Template__c];
        Map<String,SMS_Template__c> a = new Map<String,SMS_Template__c>();
        for (SMS_Template__c s : sms) {
            a.put(s.SMS_Template_Subject__c,s);
        }
        return a;
    }
    @AuraEnabled
    public static List<String> getSMSTemplateKey(){
        List<SMS_Template__c> key = [SELECT SMS_Template_Subject__c FROM SMS_Template__c ];
        List<String> keys = new List<String>();
        for (SMS_Template__c a : key){
            keys.add(a.SMS_Template_Subject__c);
        }
        return keys;
    }
     @AuraEnabled
    public static Case_Quick_Button_Assignment__mdt getCaseQuickButtonAssignment(string user_team){
        System.debug('user_team : '+user_team);
        List<Case_Quick_Button_Assignment__mdt> cqbaList = [SELECT Id, Close_All__c, Generate_Invitation_Letter__c, Reactivate_Case__c, Convert_to_Lead__c, Accept_or_Change_Owner__c, Team_Name__c, SMS_Message__c, Validate_Case_Duplicate__c,Close_By_Myself__c,Close_with_support__c FROM Case_Quick_Button_Assignment__mdt WHERE Team_Name__c =:user_team];
        Case_Quick_Button_Assignment__mdt cqbaObj = new Case_Quick_Button_Assignment__mdt();
        if(cqbaList.size() > 0){
           cqbaObj = cqbaList[0];
        }
        return cqbaObj;
    }
    global class Request {
        public String md_code { get; set; }
        public String request_type { get; set; }
        public String request_cancellation_date {get; set;}
        public String additional_appt_cancellation_date {get; set;}
        public String cost_center_cancel {get; set;}
        public String department_cancel {get; set;}
        public String doctor_name {get; set;}
        public String specialty {get; set;}
        public String patients {get; set;}
        // public Request() {
        // }

        global void convertToObject(String responseBody){
            System.debug('responseBody slam  ' + responseBody);
            Request temp = (Request)JSON.deserialize(responseBody, Request.class);
            this.md_code = temp.md_code;
            this.request_type = temp.request_type;
            this.request_cancellation_date = temp.request_cancellation_date;
            this.cost_center_cancel = temp.cost_center_cancel;
            this.department_cancel = temp.department_cancel;
            this.doctor_name = temp.doctor_name;
            this.specialty = temp.specialty;
            this.patients = temp.patients;
            System.debug('Temp ura ' + temp);
        }
    }
    @AuraEnabled
    public static List<BIH_PicklistOption> getPickListValuesCaseStatus (String recordTypeId) {
        System.debug('########### getPickListValuesCaseStatus ###########');
        List<BIH_PicklistOption> picklistFieldValues = new List<BIH_PicklistOption>();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        String shost = URL.getSalesforceBaseUrl().toExternalForm();
        //String shost = URL.getOrgDomainURL().toExternalForm();
        String url = shost + '/services/data/v43.0/ui-api/object-info/Case/picklist-values/' + recordTypeId + '/Status';
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Authorization', 'OAuth ' + getUserSessionId());
        try {
            response = http.send(request);
            System.debug('response: '+ response);
        } catch (Exception e) {
            System.debug('ERROR: '+e);
            throw e;
        }
        System.debug('response.getBody() : '+response.getBody());
        
        Map<String,Object> root = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        if(root == null){
            return picklistFieldValues;
        }
    
        List<Object> pValues = (List<Object>)root.get('values');
        for(Object pValue : pValues){
            System.debug('pValue: '+ pValue);
            Map<String,Object> pValueMap = (Map<String,Object>)pValue;
            BIH_PicklistOption pl = new BIH_PicklistOption((String)pValueMap.get('value'), (String)pValueMap.get('label'));
            picklistFieldValues.add(pl);
        }
        return picklistFieldValues;
   }
    @AuraEnabled
    public static void closeCaseByMyselfAction(Id caseId) {
        // Fetch the case record
        Case caseRecord = [SELECT Id, Status,Close_Case_Reason__c FROM Case WHERE Id = :caseId LIMIT 1];
        
        // Update the case status to 'Closed' with your predefined close reason
        caseRecord.Status = 'Closed'; // Adjust this based on your specific status values
        caseRecord.Close_Case_Reason__c = 'Completed by myself';
        
        // Update the case record
        update caseRecord;
    }   
   @AuraEnabled
    public static void closeCaseSuppotAction(Id caseId) {
        // Fetch the case record
        Case caseRecord = [SELECT Id, Status,Close_Case_Reason__c FROM Case WHERE Id = :caseId LIMIT 1];
        
        // Update the case status to 'Closed' with your predefined close reason
        caseRecord.Status = 'Closed'; // Adjust this based on your specific status values
        caseRecord.Close_Case_Reason__c = 'Completed with support';
        
        // Update the case record
        update caseRecord;
    }    
}