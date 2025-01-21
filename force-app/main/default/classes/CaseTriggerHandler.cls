public class CaseTriggerHandler Implements Database.AllowsCallouts {

    public static integer countBeforeUpdate = 0;
    public static integer countAfterUpdate = 0;

static final Decimal MINIMUM_SLA = 240;
    
    public static Id CASE_AIRPORT_RECORD_ID {get{
        if(CASE_AIRPORT_RECORD_ID==null){
            CASE_AIRPORT_RECORD_ID = [select Id from RecordType where (DeveloperName='Airport_Transfer_Case') and (SobjectType='Case')].Id;
        }
        return CASE_AIRPORT_RECORD_ID;
    }set;}
    
    public static Id CASE_TeleMed_RECORD_ID {get{
        if(CASE_TeleMed_RECORD_ID==null){
            CASE_TeleMed_RECORD_ID = [select Id from RecordType where (DeveloperName='TeleMed_Case') and (SobjectType='Case')].Id;
        }
        return CASE_TeleMed_RECORD_ID;
    }set;}

    public static Id CASE_PRIMARY_RECORD_ID {get{
        system.debug('+++++++++++-----0');
        if(CASE_PRIMARY_RECORD_ID==null){
            CASE_PRIMARY_RECORD_ID = [select Id from RecordType where (DeveloperName='Primary_Case') and (SobjectType='Case')].Id;
            system.debug('+++++++++++-----0.1'+CASE_PRIMARY_RECORD_ID);
        }
        return CASE_PRIMARY_RECORD_ID;
    }set;}
    
    public static Id CASE_PHARMACY_RECORD_ID {get{
        if(CASE_PHARMACY_RECORD_ID==null){
            CASE_PHARMACY_RECORD_ID = [select Id from RecordType where (DeveloperName='Pharmacy_Case') and (SobjectType='Case')].Id;
        }
        return CASE_PHARMACY_RECORD_ID;
    }set;}

    public static Id CASE_CONTACT_CENTER_RECORD_ID {get{
        if(CASE_CONTACT_CENTER_RECORD_ID==null){
            CASE_CONTACT_CENTER_RECORD_ID = [select Id from RecordType where (DeveloperName='Contact_Center_Case') and (SobjectType='Case')].Id;
        }
        return CASE_CONTACT_CENTER_RECORD_ID;
    }set;}

    public static Map<Id,User> mapUser {get{
        if(mapUser==null){
            mapUser = new Map<Id,User>([select ID, Name,User_Team__c from user where IsActive = true]);
            system.debug('+++++++++++-----0.2'+mapUser);
        }
        return mapUser;
    }set;}

    public static Map<Id,Group> mapQueue {get{
        if(mapQueue==null){
            mapQueue = new Map<Id,Group>([Select ID, DeveloperName, Name  from Group where Type = 'Queue']);
            system.debug('+++++++++++-----0.3'+mapQueue);
        }
        return mapQueue;
    }set;}

    public static List<Mapping_Channel_with_User_Team__mdt> mappingChannelList {get{
        if(mappingChannelList==null){
            mappingChannelList = new List<Mapping_Channel_with_User_Team__mdt>([SELECT Id, Owner_Type__c, Channel__c, Queue_Name__c, User_Team__c,Record_Type_Name__c FROM Mapping_Channel_with_User_Team__mdt]);
        	system.debug('+++++++++++-----1'+mappingChannelList);
        }
        return mappingChannelList;
    }set;}

    public static Map<String,RecordType> recordTypeMap  {get{
        system.debug('+++++++++++-----1.1recordTypeMap'+recordTypeMap);
        if(recordTypeMap==null){
            recordTypeMap = new Map<String,RecordType>();
            for (RecordType mapRecord :[SELECT Id, DeveloperName, Name FROM RecordType]){
                recordTypeMap.put(mapRecord.DeveloperName, mapRecord);
                system.debug('+++++++++++-----2'+recordTypeMap.put(mapRecord.DeveloperName, mapRecord));
            }

            
        }
        return recordTypeMap;
    }set;}

    public static void handleBeforeInsert(List<Case> caseList) {
		system.debug('+++++++++++-----1.2handleBeforeInsert');
        Map<Id, Case> newMap = new Map<Id, Case>();
    
        searchCategoryByKeyword(caseList);
        searchSenderByEmail(caseList);
        stampSLAFromServiceTypeMatrix(caseList);
        
        //default case 
        for(Case c : caseList){
            newMap.put(c.id,c);
            if(c.case_detail__c == null && c.origin.contains('Email')){
                c.case_detail__c = System.Label.Case_Detail_Default;
                system.debug('+++++++++++-----3');
            }else if(c.case_detail__c == null){
                c.case_detail__c = 'N/A';
                system.debug('+++++++++++-----4');
            }
    
            if(c.subject != null && c.subject.contains(system.label.Walk_In_Subject_Default) && c.walk_in__c){
                Date d = System.today();
                string createdateStr = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd-MMM-yyyy');
                c.subject += ' '+c.Case_Category_Level1__c+' ('+createdateStr+')';
                system.debug('+++++++++++-----5');
            }
    
        }
    
        updateCaseContactInformation(caseList);
        updateChannelInfo(null,newMap);
    
        //default case cc channel
        for(Case c : caseList){
    
            //Default Contact Center Channnel = Outbound
            if(c.origin != null && c.origin.contains('Email') && c.channel__c == 'Contact Center'){
                c.Contact_Center_Channel__c = System.Label.Contact_Center_Channel_Outbound;
                system.debug('+++++++++++-----6');
            }
    
            //Check voice mail subject => 'Message from Unknown sender'
            if(c.subject != null && c.subject.containsIgnoreCase(System.Label.Voice_Mail_English) && 
                c.origin.contains('Phone') && c.channel__c == 'Contact Center'){
                //Set cc channel => 'Voice Mail'
                c.Contact_Center_Channel__c = System.Label.Contact_Center_Channel_Voice_Mail;
                    system.debug('+++++++++++-----7');
            }
    
        }
        
        //IIG Fixed SOQL 101
        //Editor: Siwapongsakorn D.
        //Fixed Date: 14/08/2020
        /** Start Fix SOQL 101 **/

        // update social post case subject 
        /*for (Case c : caseList) {
            String subject = editSocialCaseSubject(c.SourceId);
            System.debug('Social Case Subject = '+subject);
            if(subject != '' && subject != null) {
                c.Subject = subject;
            }        
        }*/

        Set<String> mCaseSourceIdSet = new Set<String>();
        for (Case mCaseItem : caseList) 
        {
            mCaseSourceIdSet.add(mCaseItem.SourceId); 
            system.debug('+++++++++++-----8');
        }
        
        if(mCaseSourceIdSet.size() > 0)
        {
            Map<String, String> mSocialCaseSubjectMap = editSocialCaseSubject(mCaseSourceIdSet);
            for (Case mCaseItem : caseList) 
            {
                String mSubject = mSocialCaseSubjectMap.get(mCaseItem.SourceId);
                System.debug('Social Case Subject = '+mSocialCaseSubjectMap.get(mCaseItem.SourceId));
                
                if(mSubject != '' && mSubject != null) 
                {
                    mCaseItem.Subject = mSubject;
                    system.debug('+++++++++++-----9');
                }  
            }
        }
       /** End Fix SOQL 101 **/
        
    }
    
    public static void handleBeforeUpdate(Map<Id, Case> oldMap, Map<Id, Case> newMap) {
        system.debug('+++++++++++-----handleBeforeUpdate-10');
        String debugMsg = '';
        debugMsg = '';
        debugMsg+='Auto close related case when parent is closed.';
        debugMsg = '';
        debugMsg+='Auto close related case when parent is closed.';
        debugMsg = '';
        debugMsg+='Auto close related case when parent is closed.';
        debugMsg = '';
        debugMsg+='Auto close related case when parent is closed.';
        System.debug(debugMsg);


        Map<String,Group>  mapQueueName = new Map<String,Group>();
        if(mapQueue.size() > 0){
            system.debug('+++++++++++-----11');
            for(Group g : mapQueue.values()){
                mapQueueName.put(g.DeveloperName, g);                    
            }
        }

        //searchSenderByEmail(newMap.values()); not used when case is changed.
        
        //update sla and record type
        List<Case> caseChangeSLA = new List<Case>();
        Set<Id> caseIdSet = new Set<Id>();
        List<Case> caseCancelAppointmentList = new List<Case>();

        for(Case c : newMap.values()){
        system.debug('+++++++++++-----12');
        caseIdSet.add(c.Id);

        	if(c.Cancellation_Appointment__c && c.Status =='Closed' && c.channel__c == 'Contact Center'){
            	caseCancelAppointmentList.add(c);
            	system.debug('+++++++++++-----13');
        	}

            //auto stamp user and clear pending
            if(c.Status == 'Closed' && c.Status != oldMap.get(c.id).Status) {
                c.OwnerId = UserInfo.getUserId();
                system.debug('+++++++++++-----14');
                if(c.Pending_team__c != null || c.Pending_Reason__c != null || c.Pending_Person__c != null ||
                    c.Doctor__c != null || c.Specialty_Doctor__c != null || c.Specialty_Doctor2__c != null){
                    c.Pending_team__c       = null;
                    c.Pending_Reason__c     = null;
                    c.Pending_Person__c     = null;
                        system.debug('+++++++++++-----15');
                    // c.Doctor__c             = null;
                    // c.Specialty_Doctor__c   = null;
                    // c.Specialty_Doctor2__c  = null;
                }
            }
            
            if(oldMap.get(c.Id).Case_Category_Level1__c != c.Case_Category_Level1__c || 
                oldMap.get(c.Id).Case_Category_Level2__c != c.Case_Category_Level2__c || 
                oldMap.get(c.Id).Case_Category_Level3__c != c.Case_Category_Level3__c){
                caseChangeSLA.add(c);
                    system.debug('+++++++++++-----16');
            }
        }
        
        if(caseChangeSLA.size() > 0){
            stampSLAFromServiceTypeMatrix(caseChangeSLA);
            system.debug('+++++++++++-----17');
        }
        

        for (ID caseID : newMap.keySet()) {
            Case newCase = newMap.get(caseID);
            Case oldCase = oldMap.get(caseID);
            system.debug('+++++++++++-----18');

            //Default status case to 'New' when change owner to Airport transfer Queue
            if ((newCase.OwnerId != oldCase.OwnerId) && (newCase.status != 'New') 
                && (newCase.OwnerId == mapQueueName.get('Airport_Transfer_Team').id)){
                    newCase.status = 'New';
                    system.debug('+++++++++++-----19');
            }

            //stamp channel when owner is changed 
            if (newCase.OwnerId != oldCase.OwnerId){
                updateChannelInfo(oldMap,newMap);
                system.debug('+++++++++++-----20');
            }
        }

        updateCaseContactInformation(newMap.values());

        //****Close Case Logic****//

        if(caseCancelAppointmentList.size() > 0){
            system.debug('+++++++++++-----21');
            //check follow up steps before close case cancellation appointment 
            Set<Id> caseCancelID = new Set<Id>();
            for(Case cancelAppCase : caseCancelAppointmentList){
                caseCancelID.add(cancelAppCase.id);
                system.debug('+++++++++++-----22');
            }

            List<Follow_Up_Step__c> followUpSteplst = [SELECT Id, Step_Status__c, Phone_SMS_Email__c, 
                                                Case__c, Contact_Date__c, Remark__c, Step__c 
                                                FROM Follow_Up_Step__c
                                                where Case__c in: caseCancelID
                                                order by createddate desc];
            if(followUpSteplst.size() > 0){
                system.debug('+++++++++++-----23');
                boolean isSuccess = false;
                Map<ID,Boolean> caseFollowup = new Map<ID,Boolean> ();
                for(Follow_Up_Step__c fus : followUpSteplst){
                    system.debug('+++++++++++-----24');
                    //check current follow up step is completed.
                    if(fus.Step__c == 'Call 3' && (fus.Step_Status__c == 'Success' || fus.Step_Status__c == 'Unsuccess')){
                        isSuccess = true;
                    }
                    else if(fus.Step__c == 'Call 2' && fus.Step_Status__c == 'Success'){
                        isSuccess = true;
                    }
                    else if(fus.Step__c == 'Call 1' && fus.Step_Status__c == 'Success'){
                        isSuccess = true;
                    }

                    caseFollowup.put(fus.Case__c,isSuccess);
                }

                if(caseFollowup.size() > 0){
                    for(Case cancelAppCase : caseCancelAppointmentList){
                        if(caseFollowup.get(cancelAppCase.id)!=null && !caseFollowup.get(cancelAppCase.id)){
                            cancelAppCase.addError(System.Label.Closed_Case_Follow_Up_Steps);
                        }
                    }
                }
            }

            for(Case cc : caseCancelAppointmentList){
                if(cc.Cancellation_Appointment__c && cc.Status =='Closed' && followUpSteplst.isempty() ){
                    cc.addError(System.Label.Closed_Case_Follow_Up_Steps);
                }
            }

        }else{
            //check case have child case or not?
            Map<Id,Case> caseMappingChild = new Map<Id,Case>();
            for(Case childCase : [Select id,parentid from case where parentid in:caseIdSet and status != 'Closed']){
                caseMappingChild.put(childCase.parentid,childCase);
                system.debug('caseMappingChild'+caseMappingChild);
            }
            
            if(caseMappingChild.size() > 0){
                for(Case currentCase : newMap.values()){
                    if(!currentCase.isClosedAll__c  
                        && currentCase.Status =='Closed' 
                        && caseMappingChild.get(currentCase.id) !=null){
                    currentCase.addError('This case have pending child cases,Please close case by Close All button.');
                    }
                }
            }                                             
        }       
    }

    public static void handleAfterInsert(List<Case> caseList) {
        system.debug('+++++++++++-----25handleAfterInsert');
        List<Id> copyEmailCaseIdSet = new List<Id>();
        List<Id> verifyHNCaseIdSet = new List<Id>();

        for(Case c : caseList){
            System.debug('c.origin: '+c.origin + '|'+c.Id);
            if(c.origin !=null && c.origin.contains('Email') ){
                copyEmailCaseIdSet.add(c.Id);
            }

            if(c.Hospital_Number_HN__c != null && c.origin.contains('Email') ){
                verifyHNCaseIdSet.add(c.Id);
            }
        }

        if(!Test.isRunningTest()){
            system.debug('+++++++++++-----26');
            if(verifyHNCaseIdSet.size() > 0){
                BIH_GenerateAccountFromHN createAcc = new BIH_GenerateAccountFromHN(verifyHNCaseIdSet);
                if(System.IsBatch() == false && System.isFuture() == false){
                    //Id BatchProcessId = Database.ExecuteBatch(createAcc,1);
                    Id BatchProcessId = System.enqueueJob(createAcc);
                }
            }
        }
        //Auto forward email to external team.
        /*BIH_CloneEmail2Case cloneEmail2Case = new BIH_CloneEmail2Case(cid);
        Id BatchProcessId2 = Database.ExecuteBatch(cloneEmail2Case,1);*/
        
        //Copy email body to richtext
        System.debug('copyEmailCaseIdSet: '+copyEmailCaseIdSet);
        if(copyEmailCaseIdSet.size() > 0){
            system.debug('+++++++++++-----27');
            if(System.IsBatch() == false && System.isFuture() == false){
                copyEmailBodyHTML(copyEmailCaseIdSet);
            }
        }

        try {
            //Stamp owner
            List<Work_Duration__c> workList = New List<Work_Duration__c>();
            for (Case newCaseInsert : caseList) {
            	system.debug('+++++++++++-----28');
                Work_Duration__c workUser = New Work_Duration__c();
                workUser.Case__c = newCaseInsert.ID;
                workUser.Case_Status__c = newCaseInsert.Status;
                
                //Check owner
                String OwnerID = newCaseInsert.OwnerId;
                system.debug('+++++++++++-----29');
                if (OwnerID.startsWith('005')) {
                    workUser.User_Link__c = newCaseInsert.OwnerId;
                    workUser.Name = mapUser.get(newCaseInsert.ownerID).Name;
                } else {
                    workUser.Queue_Link__c  = newCaseInsert.OwnerId;
                    workUser.Name = mapQueue.get(newCaseInsert.ownerID).Name;
                }
                workUser.Start_Date_Time__c = system.now();
                workList.add(workUser);
                
            }
            if (workList.size() > 0) {
                system.debug('+++++++++++-----30');
                Database.SaveResult[] lsr = Database.insert(workList, false);
                // Iterate through each returned result
                for (Database.SaveResult sr : lsr) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted work duration with ID: ' + sr.getId());
                    } else {
                        // Operation failed, so get all errors
                        for (Database.Error err : sr.getErrors()) {
                            System.debug(logginglevel.ERROR, 'There is error inserting work duration. Error Message is: ' + err.getMessage());
                        }
                    }
                }
                
            }
            
        } catch (Exception e) {
            system.debug(e);
        }
        
        //To update messaging session language
        Set<Id> caseIdSet = new Set<Id>();
        for(Case c : caseList) {
            caseIdSet.add(c.Id);
        }
        
        //system.debug('+++++++++++-----handleAfterInsert --- test0');
        //new 
        createAccountAndAssociateCase(caseList);
        
        //system.debug('+++++++++++-----handleAfterInsert --- test1');
        //SMS Auto Sent to Patient
        //SmsAutoSentPatient(caseList);
        
    }

    public static void updateChannelInfo(Map<Id, Case> oldMap, Map<Id, Case> newMap) {
        system.debug('+++++++++++-----31updateChannelInfo');

        Map<String,String> mapChannelwithQueue = new Map<String,String>();
        Map<String,String> mapChannelwithUserTeam = new Map<String,String>();
        Map<String,String> mapChannelwithRecordtype = new Map<String,String>();

        if(mappingChannelList.size() > 0){
            system.debug('+++++++++++-----32');
            for(Mapping_Channel_with_User_Team__mdt mdtChannel : mappingChannelList){

                if(mdtChannel.Queue_Name__c != null){
                    string queueNameAndType = mdtChannel.Queue_Name__c+mdtChannel.Owner_Type__c;
                    mapChannelwithQueue.put(queueNameAndType,mdtChannel.Channel__c);
                    mapChannelwithRecordtype.put(queueNameAndType,mdtChannel.Record_Type_Name__c);
                }

                if(mdtChannel.User_Team__c != null){
                    string userTeamAndType = mdtChannel.User_Team__c+mdtChannel.Owner_Type__c;
                    mapChannelwithUserTeam.put(userTeamAndType,mdtChannel.Channel__c);
                }
            }
        }
        for (ID caseID : newMap.keySet()) {
            Case newCase = newMap.get(caseID);

            //Check owner
            String OwnerID = newCase.OwnerId;
            String OwnerType;
            String OwnerName;
            if (OwnerID.startsWith('005')) {
                OwnerType = 'User';
                if(mapUser.get(newCase.OwnerId)!=null){
                    OwnerName = mapUser.get(newCase.OwnerId).User_Team__c;
                    if(mapChannelwithUserTeam.get(OwnerName+OwnerType)!=null){
                        newCase.Channel__c = mapChannelwithUserTeam.get(OwnerName+OwnerType);
                    }
                }else{
                    OwnerName = 'Other';
                    if(mapChannelwithUserTeam.get(OwnerName+OwnerType)!=null){
                        newCase.Channel__c = mapChannelwithUserTeam.get(OwnerName+OwnerType);
                    }
                }
            }else if (OwnerID.startsWith('00G')) {
                OwnerType = 'Queue';
                if(mapQueue.get(newCase.OwnerId)!=null){
                    OwnerName = mapQueue.get(newCase.OwnerId).Name;
                    if(mapChannelwithQueue.get(OwnerName+OwnerType)!=null){
                        newCase.Channel__c = mapChannelwithQueue.get(OwnerName+OwnerType);
                    }

                    //set record type when change owner 
                    string recordtypeName = mapChannelwithRecordtype.get(OwnerName+OwnerType);
                    if(recordtypeName!=null){
                        newCase.recordtypeid = recordTypeMap.get(recordtypeName).id;
                    }
                }else{
                    OwnerName = 'Other';
                    if(mapChannelwithQueue.get(OwnerName+OwnerType)!=null){
                        newCase.Channel__c = mapChannelwithQueue.get(OwnerName+OwnerType);
                    }
                }
            
            }
            System.debug('newCase.Channel__c'+newCase.Channel__c);

        }

        
    }
    
    public static void handleAfterUpdate(Map<Id, Case> oldMap, Map<Id, Case> newMap) {        
        // order 3
        //Auto close related case when parent is closed.
        system.debug('+++++++++++-----33handleAfterUpdate');
        String debugMsg = '';
        debugMsg+='Auto close related case when parent is closed.';
        debugMsg = '';
        debugMsg+='Auto close related case when parent is closed.';
        debugMsg = '';
        debugMsg+='Auto close related case when parent is closed.';
        debugMsg = '';
        debugMsg+='Auto close related case when parent is closed.';
        debugMsg = '';
        debugMsg+='Auto close related case when parent is closed.';
        System.debug(debugMsg);

        Map<Id,Case> mapCloseCase = new Map<Id,Case>();
        List<Case> relatedCase = new List<Case>();
        for (ID caseID : newMap.keySet()) {
            system.debug('+++++++++++-----34');
            Case newCase = newMap.get(caseID);
            //Case oldCase = oldMap.get(caseID);
            if(newCase.IsClosed && !newCase.Cancellation_Appointment__c){
                mapCloseCase.put(newCase.id,newCase);
            }
        }
        
        if(mapCloseCase.size() > 0){
            system.debug('+++++++++++-----35');
            relatedCase = [Select id,status,parentid,channel__c,Close_Case_Reason__c,IsClosed 
            from case 
            where parentid in:mapCloseCase.keySet()];
        }

        List<Case> relatedCaseNew = new List<Case>();
        
        if(relatedCase.size() > 0){
            system.debug('+++++++++++-----36');
            for(Case c : relatedCase){
                if(!c.IsClosed && mapCloseCase.get(c.parentid)!=null
                && mapCloseCase.get(c.parentid).channel__c == c.channel__c ){
                    c.Status = mapCloseCase.get(c.parentid).status;
                    c.Close_Case_Reason__c = mapCloseCase.get(c.parentid).Close_Case_Reason__c;

                    relatedCaseNew.add(c);
                }
            }
            
            Database.SaveResult[] lsr = Database.update(relatedCaseNew, false);
            // Iterate through each returned result
            for (Database.SaveResult sr : lsr) {
                if (sr.isSuccess()) {
                    system.debug('+++++++++++-----37');
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully updated related Case with ID: ' + sr.getId());
                } else {
                    // Operation failed, so get all errors
                    for (Database.Error err : sr.getErrors()) {
                        System.debug(logginglevel.ERROR, 'There is error updating related Case. Error Message is: ' + err.getMessage());
                    }
                }
            }

        }
        
        //Auto stamp work duration
        Map<String, Work_Duration__c> map_workOwner = New Map<String, Work_Duration__c>();
        List<Work_Duration__c> workList = [Select ID, Name, User_Link__c, Case__c, Start_Date_Time__c, End_Date_Time__c, Queue_Link__c 
                                        from Work_Duration__c where End_Date_Time__c = null and Case__c in: newMap.keySet()];

        //Mapping previous owner for caculate SLA per user
        if (workList.size() > 0) {
            system.debug('+++++++++++-----38');
            for (Work_Duration__c workOwner : workList) {
                //Check if previous owner is user
                if (workOwner.User_Link__c != null) {
                    system.debug('+++++++++++-----39');
                    map_workOwner.put(string.valueof(workOwner.User_Link__c) + string.valueof(workOwner.Case__c), workOwner);
                } else {
                    //Previous owner is queue
                    system.debug('+++++++++++-----40');
                    map_workOwner.put(workOwner.Queue_Link__c + string.valueof(workOwner.Case__c), workOwner);
                }
            }
        }
        
        List<Work_Duration__c> newWorkList = new List<Work_Duration__c>();
        List<Work_Duration__c> oldWorkList = New List<Work_Duration__c>();
        
        for (ID caseID : newMap.keySet()) {
            Case newCase = newMap.get(caseID);
            Case oldCase = oldMap.get(caseID);
            if ((newCase.OwnerId != oldCase.OwnerId) || (newCase.status != oldCase.status)){
                
                if((newCase.status == 'In Progress' || newCase.status == 'Pending') || ((newCase.OwnerId != oldCase.OwnerId)&& newCase.status != 'Closed')){
                    //Stamp Current Owner
                    system.debug('+++++++++++-----41');
                    Work_Duration__c newWorkOwner = New Work_Duration__c();
                    newWorkOwner.Case__c = newCase.ID;
                    newWorkOwner.Case_Status__c = newCase.Status;

                    newWorkOwner.Doctor__c = newCase.Doctor__c;
                    newWorkOwner.Specialty_Doctor_1__c = newCase.Specialty_Doctor__c;
                    newWorkOwner.Specialty_Doctor_2__c = newCase.Specialty_Doctor2__c;
                    if(newCase.status == 'Pending'){
                        newWorkOwner.Pending_Reason__c = newCase.Pending_Reason__c;
                        newWorkOwner.Pending_Team__c = newCase.Pending_team__c;
                        newWorkOwner.Pass_to_Doctor_Date__c = newCase.Pass_to_Doctor_Date__c;
                    }

                    //Check owner
                    String OwnerID = newCase.OwnerId;
                    if (OwnerID.startsWith('005')) {
                        system.debug('+++++++++++-----42');
                        newWorkOwner.User_Link__c = newCase.OwnerId;
                        newWorkOwner.Name = mapUser.get(newCase.ownerID).Name;
                    } else {
                        system.debug('+++++++++++-----43');
                        newWorkOwner.Queue_Link__c  = newCase.OwnerId;
                        newWorkOwner.Name = mapQueue.get(newCase.ownerID).Name;
                    }
                    newWorkOwner.Start_Date_Time__c = system.now();
                    newWorkList.add(newWorkOwner);
                    
                    //Query previous owner to update end date
                    Work_Duration__c  old_WorkOwner = map_workOwner.get(string.valueOf(oldCase.OwnerId) + string.valueOf(oldCase.ID));
                    if (old_WorkOwner != null) {
                        system.debug('+++++++++++-----44');
                        //old_WorkOwner.Pending_team__c = newCase.Pending_team__c;
                        old_WorkOwner.End_Date_Time__c = system.Now();
                        //old_WorkOwner.Case_Status__c = newCase.Status;
                        oldWorkList.add(old_WorkOwner);
                    }
                }

                if (newCase.isClosed){
                    Work_Duration__c  old_WorkOwner = map_workOwner.get(string.valueOf(oldCase.OwnerId) + string.valueOf(oldCase.ID));
                    if (old_WorkOwner != null) {
                        system.debug('+++++++++++-----45');
                        //old_WorkOwner.Pending_team__c = newCase.Pending_team__c;
                        old_WorkOwner.End_Date_Time__c = system.Now();
                        //old_WorkOwner.Case_Status__c = newCase.Status;
                        oldWorkList.add(old_WorkOwner);
                    }
                    
                    Work_Duration__c newWorkOwner = New Work_Duration__c();
                    newWorkOwner.Case__c = newCase.ID;
                    newWorkOwner.Case_Status__c = newCase.Status;
                    newWorkOwner.Start_Date_Time__c = system.now();
                    newWorkOwner.End_Date_Time__c = system.Now();
                    
                    String OwnerID = newCase.OwnerId;
                    if (OwnerID.startsWith('005')) {
                        system.debug('+++++++++++-----46');
                        newWorkOwner.User_Link__c = newCase.OwnerId;
                        newWorkOwner.Name = mapUser.get(newCase.ownerID).Name;
                    } else {
                        system.debug('+++++++++++-----46');
                        newWorkOwner.Queue_Link__c  = newCase.OwnerId;
                        newWorkOwner.Name = mapQueue.get(newCase.ownerID).Name;
                    }
                    
                    newWorkList.add(newWorkOwner);
                    system.debug('newWorkList'+newWorkList);
                }
            }
        }
        
        try {
            if (newWorkList.size() > 0) {
            insert newWorkList;
            }
            if (oldWorkList.size() > 0) {
                update oldWorkList;
            }
        } catch (Exception e) {
            system.debug(e);
        }
        
        //To update messaging session language
        Set<Id> caseIdSet = new Set<Id>();
        for (Id caseId : newMap.keySet()) {
            system.debug('+++++++++++-----47');
            caseIdSet.add(caseId);
        }

        
        
    }
    
    public static void stampSLAFromServiceTypeMatrix(List<Case> caseList) {
        system.debug('+++++++++++-----48stampSLAFromServiceTypeMatrix');
        
    Map<String,Group>  mapQueueName = new Map<String,Group>();
        if(mapQueue.size() > 0){
            system.debug('+++++++++++-----49');
            for(Group g : mapQueue.values()){
                mapQueueName.put(g.DeveloperName, g);                    
            }
        }
        
        system.debug('mapQueueName'+mapQueueName);
        
        for(Case c : caseList){
            string cat1 = (c.Case_Category_Level1__c!=null)?c.Case_Category_Level1__c:null;
            string cat2 = (c.Case_Category_Level2__c!=null)?c.Case_Category_Level2__c:null;
            string cat3 = (c.Case_Category_Level3__c!=null)?c.Case_Category_Level3__c:null;
            string CategoryConCat = cat1+cat2+cat3;
            
            if(c.Case_Category_Level1__c!=null){
                system.debug('+++++++++++-----50');
                system.debug('CategoryConCat : '+CategoryConCat);
                if(CategoryConCat != null && BIH_CaseUtility.mapSVTM.get(CategoryConCat)!=null && BIH_CaseUtility.mapSVTM.get(CategoryConCat).Responsible_Team__c != System.Label.At_Home){
                    
                    c.SLA__c = BIH_CaseUtility.mapSVTM.get(CategoryConCat).SLA__c;
                    c.SLA_Temp_for_Swap__c = BIH_CaseUtility.mapSVTM.get(CategoryConCat).SLA__c;
                    c.Service_Type_Matrix__c = BIH_CaseUtility.mapSVTM.get(CategoryConCat).id; //stamp phase4
                    system.debug('Team : '+BIH_CaseUtility.mapSVTM.get(CategoryConCat).Responsible_Team__c);
                    
                    
                     if (BIH_CaseUtility.mapSVTM.get(CategoryConCat).Responsible_Team__c == System.Label.Referral_Team){
                         system.debug('+++++++++++-----51');
                        
                        c.recordtypeid = CASE_PRIMARY_RECORD_ID;

                    }else if (BIH_CaseUtility.mapSVTM.get(CategoryConCat).Responsible_Team__c == System.Label.Airport_Team){
                        system.debug('+++++++++++-----52');
                        
                        c.recordtypeid = CASE_AIRPORT_RECORD_ID;

                    }else if (BIH_CaseUtility.mapSVTM.get(CategoryConCat).Responsible_Team__c == System.Label.Pharmacy_Team){
                        system.debug('+++++++++++-----53');
                        
                        c.recordtypeid = CASE_PHARMACY_RECORD_ID;

                    }
                    // else{
                    //     c.recordtypeid = CASE_PRIMARY_RECORD_ID;
                    // }

                }
                else{
                    if(c.contact_center_channel__c !=null){
                        system.debug('+++++++++++-----54');
                        c.SLA__c = null;
                        c.SLA_TeleMed__c   = null;
                    }
                    else if (CategoryConCat != null && BIH_CaseUtility.mapSVTM.get(CategoryConCat)!=null && BIH_CaseUtility.mapSVTM.get(CategoryConCat).Responsible_Team__c == System.Label.At_Home){
                        c.recordtypeid = CASE_TeleMed_RECORD_ID;
                        c.SLA_TeleMed__c = BIH_CaseUtility.mapSVTM.get(CategoryConCat).SLA__c;
                        c.SLA__c = c.SLA_Temp_for_Swap__c;
                        system.debug('+++++++++++-----55');
                    }
                    
                    else{
                        c.SLA__c = MINIMUM_SLA;
                        c.SLA_TeleMed__c   = MINIMUM_SLA;
                        system.debug('+++++++++++-----56');
                    }             
                }
            }else{
                c.Case_Category_Level1__c = 'Undefined';
                c.Case_Category_Level2__c = 'N/A';
                c.Case_Category_Level3__c = 'N/A';
                system.debug('+++++++++++-----57');
            }
        System.debug('Test data : '+c.Channel__c + ' and '+c.RecordTypeId);
        }
            
    }
    
    public static void searchSenderByEmail(List<Case> caseList){
        System.debug('+++++++++++-----58searchSenderByEmail');
        Map<String,Case> mapEmailandCase = new  Map<String,Case>();
        Map<String,Account> emailAccId = new  Map<String,Account>();
        Map<String,Contact> emailContactId = new  Map<String,Contact>();

        for(Case c : caseList){
            if(c.SuppliedEmail !=null){
                mapEmailandCase.put(c.SuppliedEmail, c);
            }
        }

        if(mapEmailandCase.size() > 0){
			system.debug('+++++++++++-----58');
            //check contact on case is null,find existing contact that email = suppliedEmail
            List<Contact> listContactEmail = [select id,email,accountid,account.Phone
                                                from contact where email in: mapEmailandCase.keySet()];
            if(listContactEmail.size() >0){
                system.debug('+++++++++++-----59');
                for(Contact c : listContactEmail){
                    emailContactId.put(c.email,c);
                }

                if(emailContactId.size() > 0){
                    system.debug('+++++++++++-----60');
                    for(Case c : caseList){
                        if(emailContactId.get(c.SuppliedEmail)!=null){
                            c.AccountId = emailContactId.get(c.SuppliedEmail).AccountId ;
                            c.Sender_Phone__c = emailContactId.get(c.SuppliedEmail).account.Phone  ;
                            c.ContactId = emailContactId.get(c.SuppliedEmail).id;
                        }
                    }
                }
            }else{
                //if contact not found find email on account 
                List<Account> listAccountEmail = [select id,PersonEmail,email__c,Phone ,Hospital_Number_HN__c 
                                                from account where PersonEmail in: mapEmailandCase.keySet() or email__c in: mapEmailandCase.keySet()];
                system.debug('+++++++++++-----60.1'+mapEmailandCase.keySet());
                if(listAccountEmail.size() > 0){
                    for(Account acc : listAccountEmail){
                        system.debug('+++++++++++-----60.1.1');
                        if(acc.PersonEmail!=null){
                            emailAccId.put(acc.PersonEmail,acc);
                        }
                        if(acc.email__c!=null){
                        system.debug('+++++++++++-----60.1.2');
                            emailAccId.put(acc.email__c,acc);
                        }
                    }
                }
            
                if(emailAccId.size() > 0){
                    for(Case c : caseList){
                        if(emailAccId.get(c.SuppliedEmail)!=null){
                            c.AccountId = emailAccId.get(c.SuppliedEmail).id ;
                            c.Sender_Phone__c = emailAccId.get(c.SuppliedEmail).Phone  ;
                            c.Sender_HN__c = emailAccId.get(c.SuppliedEmail).Hospital_Number_HN__c ;
                        }
                    }
                }
                
            }
        }
    }    
    
    
    public static void searchCategoryByKeyword(List<Case> caseList){
		system.debug('searchCategoryByKeyword+++++++++++-----60');
        Map<String,String> mapKeywordCat1 = new Map<String,String>();
        Map<String,Case_Keyword__c> mapKeywordCat2 = new Map<String,Case_Keyword__c>();
        for(Case_Keyword__c kw : [Select KW_Category__c,Keyword_List__c,KW_Sub_Category_Level1__c from Case_Keyword__c order by Order_Number__c]){
            if(kw.KW_Sub_Category_Level1__c != null){
                mapKeywordCat2.put(kw.KW_Sub_Category_Level1__c,kw);
            }else{
                mapKeywordCat1.put(kw.KW_Category__c,kw.Keyword_List__c);
            }
            
        }

        for(Case c : caseList){
            string cat1;
            string cat2;
            string hnNumberColon;
            string dob;

            if(c.origin !=null && c.origin.contains('Email') && c.subject != null ){
                system.debug('+++++++++++-----61');
                string subjectEmail = c.subject;
                try{
                    //get Category1
                    if(mapKeywordCat1.size() > 0){
                        for(String cat : mapKeywordCat1.keySet()){
                            List<String> lstKey = mapKeywordCat1.get(cat).split(',');//get key from cat and split
                            lstKey.sort();
                            for(String key : lstKey){
                                system.debug('key'+key);
                                if(c.subject.containsIgnoreCase(key) && cat1==null){
                                    cat1 = cat;
                                    break;
                                }
                            }
            
                        }
                    }   
                
                    c.Case_Category_Level1__c = (c.Case_Category_Level1__c==null)?cat1:c.Case_Category_Level1__c;

                    //get Category2
                    if(mapKeywordCat2.size() > 0){
                        for(String category2 : mapKeywordCat2.keySet()){
                            if(mapKeywordCat2.get(category2).Keyword_List__c!=null){
                                List<String> lstKeyCat2 = mapKeywordCat2.get(category2).Keyword_List__c.split(',');//get key from cat and split
                                lstKeyCat2.sort();
                                for(String keyCat2 : lstKeyCat2){
                                    system.debug('keyCat2'+keyCat2);
                                    if(c.subject.containsIgnoreCase(keyCat2) && cat2==null){
                                        cat2 = category2;
                                        break;
                                    }
                                }
                            }
            
                        }
                    }   
                
                    //default cat1 by cat2 keyword
                    /*if(mapKeywordCat2.get(cat2)!=null && cat2!=null){
                        c.Case_Category_Level2__c = (c.Case_Category_Level2__c==null)?cat2:c.Case_Category_Level2__c;
                        c.Case_Category_Level1__c = mapKeywordCat2.get(cat2).KW_Category__c;
                    }*/
                    
                    //Default Priority
                    List<String> priorityValue = BIH_CaseUtility.getPickListValuesCase('Priority');

                    for(string priority : priorityValue){
                        if(c.subject.containsIgnoreCase(priority)){
                        c.Priority  = priority;
                        break;
                        }
                    }
                
                
                    //get HN Number
                    if(c.Hospital_Number_HN__c==null && c.ParentId ==null){

                        string hncolonregex = '((HN)|(HN )|(HN: )|(HN :)|(HN : ))(\\d{8,10})';
                        string hnregex = '\\d{8,10}';
                        Matcher matcherHNColon =Pattern.compile(hncolonregex).matcher(subjectEmail);
                        Boolean resultHNColon = matcherHNColon.find();
                        system.debug('resultHNColon'+resultHNColon);
                        if(resultHNColon && matcherHNColon.group(0)!=null){
                            string matchHN = matcherHNColon.group(0);
                            system.debug('matchHN'+matchHN);
                            Matcher matcherHN =Pattern.compile(hnregex).matcher(matchHN);
                            Boolean resultHN = matcherHN.find();
                            if(resultHN && matcherHN.group(0)!=null){
                                c.Hospital_Number_HN__c = matcherHN.group(0);
                            }
                        }

                    }
                
                
                    //get DOB
                    string dobregex = '((DOB)|(DOB )|(DOB: )|(DOB :)|(DOB : )|(DOB:))(\\d\\d\\/\\d\\d\\/\\d\\d\\d\\d)';
                    Date dateOfBirth = convertStringtoDate(subjectEmail,dobregex);
                    if(dateOfBirth!=null){
                        c.Date_of_Birth__c =(c.Date_of_Birth__c==null)?dateOfBirth:c.Date_of_Birth__c;
                    }

                    /*string dateregex = '(?i)((Date)|(Date )|(Date: )|(Date :)|(Date : )|(Date:))(\\d{1,2} *(?:Jan(?:uary)?|Feb(?:ruary)?|...|Dec(?:ember)?) *\\d{4})';
                    Date appDate = convertStringtoDateByMonthFormat(subjectEmail,dateregex);
                    if(appDate!=null){
                        c.Appointment_Date__c =(c.Appointment_Date__c==null)?appDate:c.Appointment_Date__c;
                    }*/

                }catch(exception ex){
                    system.debug('Error case subject keyword : '+ex);
                }

                try{
                    //check sender email from website email
                    string emailSender = subjectEmail.substringBetween('Sender : ' ,')');
                    if(emailSender != null || emailSender == ''){
                        String regEmailPatten = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
                        Boolean isRegEmail = Pattern.matches(regEmailPatten,emailSender);

                        if(isRegEmail){
                            c.suppliedemail = emailSender;
                        }
                    }
                }catch(exception ex){
                    system.debug('Error case sender email : '+ex);
                }  
                
            }

        }
    }

    public static void updateCaseContactInformation(List<Case> caseList){
        // order 2
		system.debug('updateCaseContactInformation+++++++++++-----62');
        Map<Id,Account> accountMap = new Map<Id,Account>();
        Set<Id> accountIdSet = new Set<Id>();

        for(Case c : caseList){
            //status not close
            //if(c.status != 'Closed'){
                if(c.accountid != null){
                    accountIdSet.add(c.accountid);
                }
                if(c.Patient__c != null){
                    accountIdSet.add(c.Patient__c);
                }
            //}
            
        }

        if(accountIdSet.size() > 0){
            for(Account acc : [Select id,Country_of_Residence__c,PersonBirthdate,FirstName,LastName,Phone,
                                Nationality__c,Hospital_Number_HN__c 
                                FROM Account where id in:accountIdSet]){
                accountMap.put(acc.id,acc);
            }
        }

        system.debug('accountMap'+accountMap);

        for(Case c : caseList){
            //update patient value from patient account
            if(accountMap.get(c.Patient__c)!=null){
                Account patient = accountMap.get(c.Patient__c);
                if(patient !=null){
                    c.Country_of_Residence__c = (patient.Country_of_Residence__c!=null)?patient.Country_of_Residence__c:c.Country_of_Residence__c;
                    c.Date_of_Birth__c = (patient.PersonBirthdate!=null)?patient.PersonBirthdate:c.Date_of_Birth__c;
                    
                    string fullname = (patient.FirstName!=null)?patient.FirstName:'';
                    fullname += ' ';
                    fullname += (patient.LastName!=null)?patient.LastName:'';
                    c.Full_Name__c = (fullname!='')?fullname:c.Full_Name__c;
                    c.Hospital_Number_HN__c = (patient.Hospital_Number_HN__c!=null)?patient.Hospital_Number_HN__c:c.Hospital_Number_HN__c;
                    c.Nationality__c = (patient.Nationality__c!=null)?patient.Nationality__c:c.Nationality__c;
                    c.Phone__c = (patient.Phone!=null)?patient.Phone:c.Phone__c;
                }
            }

            //update sender value from sender account
            if(accountMap.get(c.AccountId)!=null){
                Account sender = accountMap.get(c.AccountId);
                if(sender !=null){
                    c.Sender_HN__c = (sender.Hospital_Number_HN__c!=null)?sender.Hospital_Number_HN__c:c.Sender_HN__c;
                    //c.Phone__c = (sender.Phone!=null)?sender.Phone:c.Phone__c;
                }
            }

            //update lead source
            if(c.Channel__c !=null && c.Channel__c !=''){
                string channelWithOrigin = c.Channel__c+c.origin;
                if(channelWithOrigin !=null && channelWithOrigin!= ''){
                    if(BIH_CaseUtility.mapLeadSource.get(channelWithOrigin)!=null ){
                        c.Lead_Source__c = BIH_CaseUtility.mapLeadSource.get(channelWithOrigin).Source__c;
                    }else if (c.Origin != 'RO Website'){
                        // c.Lead_Source__c =  BIH_CaseUtility.mapLeadSource.get('Default'+c.origin).Source__c;
                        if(BIH_CaseUtility.mapLeadSource.get('Default'+c.origin) != null) {
                            if(BIH_CaseUtility.mapLeadSource.get('Default'+c.origin).Source__c != null) {
                                c.Lead_Source__c = BIH_CaseUtility.mapLeadSource.get('Default'+c.origin).Source__c;
                            }                           
                        }    
                    }
                    
                }
            }
        } 

    }

    @future
    public static void copyEmailBodyHTML(List<Id> cid) {
        system.debug('copyEmailBodyHTML+++++++++++-----63');
        Map<Id,EmailMessage> mapEmail = new Map<Id,EmailMessage>(
                [SELECT id, TextBody, HtmlBody, Headers, Subject, FromName, 
                FromAddress, ToAddress, CcAddress, BccAddress,RelatedToId FROM EmailMessage 
                where RelatedToId in: cid]);
        
        Map<Id,EmailMessage> mapBody = new Map<Id,EmailMessage>();
        System.debug('mapEmail.values(): '+mapEmail);

        if(mapEmail.size() > 0){
            try{
                for(EmailMessage em :mapEmail.values()){
                    System.debug('mapEmail.values(): '+em);
                    mapBody.put(em.RelatedToId,em);              
                }
                
                Map<Id,case> clist = new Map<Id,Case>([Select id,Case_Detail__c,Subject from Case where id in:cid ]);
                
                for(Case c : clist.values()){
                    if(mapBody.get(c.id).HtmlBody !=null && mapBody.get(c.id).Subject!=null){
                        if(mapBody.get(c.id).Subject == c.subject){
                            c.Case_Detail__c = mapBody.get(c.id).HtmlBody;
                        }
                    }
                }
                
                if(clist !=null && clist.size() > 0){
                    update clist.values();
                }
                
            } catch (Exception e) {
                system.debug(e);
            }
        }
        
    }

    //method used for convert string to date
    public static date convertStringtoDate (string txt,string regexFormat) {
        system.debug('convertStringtoDate+++++++++++-----64');
        Date formatDate;
        String dateText;
        string dateregex = '\\d\\d\\/\\d\\d\\/\\d\\d\\d\\d';
        Matcher matcherText =Pattern.compile(regexFormat).matcher(txt);
        Boolean resultText = matcherText.find();
        system.debug('resultText'+resultText);

        if(resultText && matcherText.group(0)!=null){
            system.debug('+++++++++++-----63');
            string matchText = matcherText.group(0);
            system.debug('matchText'+matchText);
            Matcher matcherDate =Pattern.compile(dateregex).matcher(matchText);
            Boolean resultDate = matcherDate.find();
            if(resultDate && matcherDate.group(0)!=null){
                dateText = matcherDate.group(0);
            }
        }

        if(dateText!=null && dateText != ''){
            system.debug('+++++++++++-----64');
            string dateTextConcat = '';
            List<String> dSplit = dateText.split('/');
            
            if(dSplit.size() == 3){
                system.debug('+++++++++++-----65');
                Integer dateYear;
                String dateYearText;

                if(dSplit[0].length() == 4){
                    dateYearText=dSplit[0];
                    dateYear=integer.valueof(dateYearText);
                    if(dateYear >= 1700){//maximun salesforce year
                        dateTextConcat = dSplit[0]+'-'+dSplit[1]+'-'+dSplit[2];//2007/07/21
                    }
                }else if(dSplit[0].length() == 2){
                    dateYearText=dSplit[2];
                    dateYear=integer.valueof(dateYearText);
                        if(dateYear >= 1700){//maximun salesforce year
                            dateTextConcat = dSplit[2]+'-'+dSplit[1]+'-'+dSplit[0];//21/07/2007
                        } 
                }
            }

            if(dateTextConcat != null && dateTextConcat.length() == 10){
                string d = dateTextConcat+' 00:00:00';//2017-07-21 00:00:00
                formatDate = Date.valueOf(d);
                
            }
        }

        return formatDate;
    }

    //method used for convert string to date
    public static date convertStringtoDateByMonthFormat (string txt,string regexFormat) {
        system.debug('convertStringtoDateByMonthFormat+++++++++++-----65');
        Date formatDate;
        String dateText;
        string dateregex = '\\d{1,2} *(?:Jan(?:uary)?|Feb(?:ruary)?|...|Dec(?:ember)?) *\\d{4}';
        Matcher matcherText =Pattern.compile(regexFormat).matcher(txt);
        Boolean resultText = matcherText.find();
        system.debug('resultText'+resultText);

        if(resultText && matcherText.group(0)!=null){
            string matchText = matcherText.group(0);
            system.debug('matchText'+matchText);
            Matcher matcherDate =Pattern.compile(dateregex).matcher(matchText);
            Boolean resultDate = matcherDate.find();
            if(resultDate && matcherDate.group(0)!=null){
                dateText = matcherDate.group(0);
            }
        }

        if(dateText!=null && dateText != ''){
            string dateTextConcat = '';
            List<String> dSplit = dateText.split('\\s+');
            List<String> dSplitTrim = new List<String>();
            for(String s : dSplit) {
                dSplitTrim.add(s.trim());
            }
            
            if(dSplitTrim.size() == 3){
                String dayText = dSplitTrim[0];
                if(dayText!=null && dayText.length()==1){
                    dayText = '0'+dayText;
                }
                String monthText = dSplitTrim[1];
                monthText = (monthText!=null)?monthText.toLowerCase():'';
                string monthToNumber = monthsMap.get(monthText);
                dateTextConcat = dSplitTrim[2]+'-'+monthToNumber+'-'+dayText;
                system.debug('dateTextConcat'+dateTextConcat);
            }

            if(dateTextConcat != null && dateTextConcat.length() == 10){
                string d = dateTextConcat+' 00:00:00';//2017-07-21 00:00:00
                formatDate = Date.valueOf(d);
                
            }
        }

        return formatDate;
    }

    private static Map<String, String> monthsMap = new Map<String, String>{
    'january'  => '01',
    'february' => '02',
    'march' => '03',
    'april' => '04',
    'may' => '05',
    'june' => '06',
    'july' => '07',
    'august' => '08',
    'september' => '09',
    'october' => '10',
    'november' => '11',
    'december' => '12',
    'jan'  => '01',
    'feb' => '02',
    'mar' => '03',
    'apr' => '04',
    'may' => '05',
    'jun' => '06',
    'jul' => '07',
    'aug' => '08',
    'sep' => '09',
    'oct' => '10',
    'nov' => '11',
    'dec' => '12'
    };
        

    
    
    //IIG Fixed SOQL 101
    //Editor: Siwapongsakorn D.
    //Fixed Date: 14/08/2020
    //Description: Change parameter from single value to List of values and change return type from String to Map<String, String>

    /** Start Fix SOQL 101 **/
    public static Map<String,String> editSocialCaseSubject(Set<String> sourceIdList) 
    {
        system.debug('editSocialCaseSubject+++++++++++-----66');
        //System.debug('----- editSocialCaseSubject');
        //System.debug('sourceId = '+sourceId);
        //String subject;

        Map<String, String> mSocialCaseSubjectMap = new  Map<String, String>();

        List<SocialPost> postList = [SELECT Id, Posted, Handle FROM SocialPost WHERE Id IN: sourceIdList];
        System.debug('SocialPost = '+postList.Size());
        
        if(postList.size() > 0) 
        {
            for (SocialPost mSocialPostItem : postList) 
            {
                String mSubject = '';
                String personaName = postList[0].Handle;
                Datetime postDate = postList[0].Posted;
                String strDate = postDate.format('dd/MM/yyyy HH:mm:ss');
                
                mSubject = 'Facebook Post : ' + personaName +' '+ strDate;
                System.debug('subject = '+mSubject);

                mSocialCaseSubjectMap.put(mSocialPostItem.Id, mSubject);
            }
        }
        return mSocialCaseSubjectMap;
    }
    /** End Fix SOQL 101 **/
    
    public static void createAccountAndAssociateCase(List<Case> newCaseList){
        system.debug('createAccountAndAssociateCase+++++++++++-----67');
        List<Account> accList = new List<Account>();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_Account').getRecordTypeId();
        
        Map<String, Account> phoneIdMap = new Map<String, Account>();
        Map<String, Account> emailIdMap = new Map<String, Account>();
        List<Account> accountsToCreate = new List<Account>();
        Map<String, Account> phoneAccountMap = new Map<String, Account>();
        Set<String> phoneSet = new Set<String>();
        Set<String> emailSet = new Set<String>();
       boolean flagcreateAcct = false;
        String tmp_phone = '';
        String tmp_email = '';
        for(Case objCase : newCaseList){
            tmp_phone = objCase.Web_Phone__c;
            tmp_email = objCase.Web_Patient_Email__c;
            if(objCase.Case_From_MB__c){
                if(objCase.Web_Phone__c != '' && objCase.Web_Phone__c != null)
                {
               		System.debug('Web Phone Not Null');
                    phoneSet.add(objCase.Web_Phone__c);
                    System.debug('Web Phone Not Null'+phoneSet);
                }else if(objCase.Web_Patient_Email__c != '' && objCase.Web_Patient_Email__c != null){
                    System.debug('Email Not Null');
                    emailSet.add(objCase.Web_Patient_Email__c);
                    System.debug('Email Not Null'+emailSet);
                }
                
            }
        }
  
        
        if(phoneSet.size() > 0){
            System.debug('phoneSet Not Null'+phoneSet);
            for(Account objAcc : [SELECT Id, Phone, PersonContactId FROM Account WHERE Phone IN: phoneSet AND RecordTypeId=:recordTypeId Order By CreatedDate DESC]){
                phoneIdMap.put(objAcc.Phone, objAcc);
                System.debug('phoneSet Not Null'+phoneIdMap);
                flagcreateAcct = true;
            }
        }else if (emailSet.size() > 0){
            System.debug('emailSet Not Null'+emailSet);
            //SELECT Id,Name, PersonEmail, Phone, PersonContactId FROM Account WHERE PersonEmail ='nebula.montes@gmail.com' AND RecordTypeId= '0122v000001ZspuAAC'
            //for(Account objAcc : [SELECT Id,Name, PersonEmail, Phone, PersonContactId FROM Account WHERE PersonEmail ='jaiauksorn.k@gmail.com' AND RecordTypeId= '0122v000001ZspuAAC']){
            for(Account objAcc : [SELECT Id,PersonEmail, Phone, PersonContactId FROM Account WHERE PersonEmail IN: emailSet AND RecordTypeId=:recordTypeId Order By CreatedDate DESC]){
                System.debug('objAcc Detail0');
                System.debug('objAcc Detail'+objAcc);
                emailIdMap.put(objAcc.PersonEmail, objAcc);
                System.debug('emailSet Not Null'+emailIdMap);
				flagcreateAcct = true;                
            }
        }

        if(flagcreateAcct == false){
            
            if((tmp_email != '' && tmp_email != null)||(tmp_phone != '' && tmp_phone != null)){
                for(Case objCase : newCaseList){
                    Account personAcc = new Account(); 
                    personAcc.RecordTypeID = recordTypeId;
                    personAcc.FirstName = objCase.MB_First_Name__c;
                    personAcc.LastName = objCase.MB_Last_Name__c;
                    personAcc.PersonEmail = objCase.Web_Patient_Email__c;
                    personAcc.Phone = objCase.Web_Phone__c;
                    insert personAcc;
                   	if(objCase.Case_From_MB__c){
                        if(objCase.Web_Phone__c != '' && objCase.Web_Phone__c != null){
                            system.debug('objCase.Web_Phone__c !=null');
                            Case cs = new Case(AccountId = personAcc.Id, Id=objCase.Id,Web_Phone__c = personAcc.Phone,ContactId=phoneIdMap.get(objCase.Web_Phone__c).PersonContactId);
                            update cs;
                        }
                        else if(objCase.Web_Patient_Email__c != '' && objCase.Web_Patient_Email__c != null){
                            system.debug('objCase.Web_Patient_Email__c != null');
                            Case cs = new Case(AccountId = personAcc.Id, Id=objCase.Id, Web_Patient_Email__c = personAcc.PersonEmail,ContactId=emailIdMap.get(objCase.Web_Patient_Email__c).PersonContactId);
                            update cs;
                        }
                    }
                }
            }
        }else{            
            if((tmp_email != '' && tmp_email != null)||(tmp_phone != '' && tmp_phone != null)){
                for(Case objCase : newCaseList){
                   	if(objCase.Case_From_MB__c){
                        if(objCase.Web_Phone__c != '' && objCase.Web_Phone__c != null){
                            if(phoneIdMap.size() > 0){
                                Account tmpObjAcc = phoneIdMap.values();
                                system.debug('tmpObjAcc : '+tmpObjAcc);
                            	system.debug('objCase.Web_Phone__c !=null');
                            	Case cs = new Case(AccountId = tmpObjAcc.Id, Id=objCase.Id,Web_Phone__c = tmpObjAcc.Phone,ContactId=phoneIdMap.get(objCase.Web_Phone__c).PersonContactId);
                            	update cs;
                            }
                        }
                        else if(objCase.Web_Patient_Email__c != '' && objCase.Web_Patient_Email__c != null){
                            if(emailIdMap.size() > 0){
                            	Account tmpObjAcc = emailIdMap.values();
                                system.debug('tmpObjAcc2 : '+tmpObjAcc);
                            	system.debug('objCase.Web_Patient_Email__c != null');
                            	Case cs = new Case(AccountId = tmpObjAcc.Id, Id=objCase.Id, Web_Patient_Email__c = tmpObjAcc.PersonEmail,ContactId=emailIdMap.get(objCase.Web_Patient_Email__c).PersonContactId);
                            	update cs;
                            }
                        }
                    }
                }
            }
            
            
            /*
            for(Case objCase : newCaseList){
                if(objCase.Case_From_MB__c){
                    if(!phoneIdMap.containsKey(objCase.Web_Phone__c)){
                        system.debug('!phoneIdMap.containsKey(objCase.Web_Phone__c)'+objCase.Web_Phone__c);
                        Account objAcc = new Account(RecordTypeId = recordTypeId, LastName = objCase.Full_Name__c, Email__c=objCase.Web_Patient_Email__c, Phone=objCase.Web_Phone__c, PersonEmail = objCase.SuppliedEmail);
                        phoneAccountMap.put(objCase.Web_Phone__c, objAcc);
                        
                    }else if (!emailIdMap.containsKey(objCase.Web_Patient_Email__c)){
                        system.debug('!emailIdMap.containsKey(objCase.Web_Patient_Email__c)'+objCase.Web_Patient_Email__c);
                        Account objAcc = new Account(RecordTypeId = recordTypeId, LastName = objCase.Full_Name__c, Email__c=objCase.Web_Patient_Email__c, Phone=objCase.Web_Phone__c, PersonEmail = objCase.SuppliedEmail);
                        phoneAccountMap.put(objCase.Web_Patient_Email__c, objAcc);
                    }
                    
                }
            }
            insert phoneAccountMap.values();
            
            for(Account objAcc : [SELECT Id, Phone, PersonContactId FROM Account WHERE Phone IN: phoneSet AND RecordTypeId=:recordTypeId]){
                phoneIdMap.put(objAcc.Phone, objAcc);
            }
            
            List<Case> nCase = new List<Case>();
            for(Case objCase : newCaseList){
                if(objCase.Case_From_MB__c){
                    if(phoneIdMap.containsKey(objCase.Web_Phone__c)){
                        Case cs = new Case(AccountId = phoneIdMap.get(objCase.Web_Phone__c).Id, Id=objCase.Id, ContactId=phoneIdMap.get(objCase.Web_Phone__c).PersonContactId);
                        nCase.add(cs);
                    }
                    else{
                        Case cs = new Case(AccountId = phoneAccountMap.get(objCase.Web_Phone__c).Id, Id=objCase.Id, ContactId=phoneIdMap.get(objCase.Web_Phone__c).PersonContactId);
                        nCase.add(cs);
                    }
                }
            }
            update nCase;*/
        }
    }
/**    
    public static void SmsAutoSentPatient(List<Case> newCaseList){
        system.debug('SmsAutoSentPatient --------- ');
        Set<String> phoneSet = new Set<String>();
        //List<Case> nCase = new List<Case>();
        for(Case objCase : newCaseList){
            
            if((objCase.Owner.Name == 'Registration Team' || objCase.Owner_Role__c.contains('Registration'))
               &&(objCase.Primary_Phone_Existing_Patient__c != null || objCase.Primary_Phone_New_Patient__c != null )){
                   //System.debug(' C condition = true');
                   if(objCase.Primary_Phone_New_Patient__c != null){
                       //System.debug('new phone : '+objCase.Primary_Phone_New_Patient__c);
                       objCase.Sent_Regist_SMS__c = true;
                   }
                   else{
                       //System.debug('old phone : '+objCase.Primary_Phone_New_Patient__c);
                       objCase.Sent_Regist_SMS__c = true;
                   }
                   
            }
        }
        //update newCaseList;
    }
   **/ 
}