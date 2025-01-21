public class EmailMessageTriggerHandler {

    public static List<Mapping_Channel_with_User_Team__mdt> mappingChannelList {get{
        if(mappingChannelList==null){
            mappingChannelList = new List<Mapping_Channel_with_User_Team__mdt>([SELECT Id, Owner_Type__c, Channel__c, Queue_Name__c, User_Team__c FROM Mapping_Channel_with_User_Team__mdt]);
        }
        return mappingChannelList;
    }set;}

    public static Map<Id,Group> mapQueue {get{
        if(mapQueue==null){
            mapQueue = new Map<Id,Group>([Select ID, DeveloperName, Name  from Group where Type = 'Queue']);
        }
        return mapQueue;
    }set;}

    public static Map<String,Mapping_Close_Case_Record_Type__mdt> mapChannelWithClosedCase {get{
        if(mapChannelWithClosedCase==null){
            mapChannelWithClosedCase = new Map<String,Mapping_Close_Case_Record_Type__mdt>();
            for(Mapping_Close_Case_Record_Type__mdt mapClose : [Select MasterLabel, Channel__c, Close_Record_Type__c,Active_Record_Type__c  from Mapping_Close_Case_Record_Type__mdt]){
                mapChannelWithClosedCase.put(mapClose.Channel__c,mapClose);
            }
        }
        return mapChannelWithClosedCase;
    }set;}

    public static Map<String,RecordType> recordTypeMap {get{
        if(recordTypeMap == null){
            recordTypeMap = new Map<String,RecordType>();
            for (RecordType mapRecord :[SELECT Id, DeveloperName, Name FROM RecordType]){
                recordTypeMap.put(mapRecord.Name, mapRecord);
            }
        }
        return recordTypeMap;
    }set;}

    public static Map<String,Mapping_Email_To_Team_Set__c> mapEmailToTeam {get{
        if(mapEmailToTeam==null){
            mapEmailToTeam = new Map<String,Mapping_Email_To_Team_Set__c>();
            for(Mapping_Email_To_Team_Set__c mapTeam : [Select ID, Name ,Email__c,Channel__c  from Mapping_Email_To_Team_Set__c]){
                mapEmailToTeam.put(mapTeam.Name,mapTeam);
            }
        }
        return mapEmailToTeam;
    }set;}

    public static List<Mapping_Email_To_Team_Set__c> listEmailToTeam {get{
        if(listEmailToTeam==null){
            listEmailToTeam = new List<Mapping_Email_To_Team_Set__c>([Select ID, Name ,Email__c,Channel__c  from Mapping_Email_To_Team_Set__c]);
        }
        return listEmailToTeam;
    }set;}

    static final String CASE_RECORD_ID = [select Id from RecordType where (DeveloperName='Primary_Case') and (SobjectType='Case')].Id;
    
    public static void handleAfterInsert(List<EmailMessage> emailList) {
        Set<Id> relatedIdSet = new Set<Id>();
        List<Case> updateCaselist = new List<Case>();
        List<Case> updateCaseCClist = new List<Case>();
        List<Case> closeCaselist = new List<Case>();
        List<Case> cloneCloseCaselist = new List<Case>();
        Set<Id> refCaseIdSet = new Set<Id>();
        System.debug(' 1****** updateCaselist'+updateCaselist);
        System.debug(' 1****** updateCaseCClist'+updateCaseCClist);
        System.debug(' 1****** closeCaselist'+closeCaselist);
        System.debug(' 1****** cloneCloseCaselist'+cloneCloseCaselist);
        System.debug(' 1****** refCaseIdSet'+refCaseIdSet);
        for(EmailMessage eml : emailList){
            if(eml.RelatedToId !=null){
                relatedIdSet.add(eml.RelatedToId);
            }
        }
        
        Map<Id,Case> caseMaps = new Map<Id,Case>();
        List<Case> caseRelated = new List<Case>();
        //DescribeSObjectResult describeResult = Case.getSObjectType().getDescribe();
        //List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        //Query All Case Fields
        String query = 'SELECT Id,'+  getFields('Case','EmailMessageTrigger')+
                       ' FROM Case Where id = :relatedIdSet';

        caseRelated = Database.query( query );
        if(caseRelated.size() > 0){
            for(Case c : caseRelated){
                caseMaps.put(c.id,c);
            }
        }

        //get existing clone case
        Map<String,Case> existingCloneCase = new Map<String,Case>();
        List<Case> listexistingcase = new List<Case>();

        DescribeSObjectResult describeResult2 = Case.getSObjectType().getDescribe();
        List<String> fieldNames2 = new List<String>( describeResult2.fields.getMap().keySet() );
		System.debug(' 2****** relatedIdSet'+relatedIdSet);
        String query2 = 'SELECT ' + String.join( fieldNames2, ',' ) +
                       ' FROM ' +  describeResult2.getName()  +
                       ' Where Close_Case_Ref__c = :relatedIdSet and Close_Case_Ref__c!=null and status != \'Closed\'';

        listexistingcase = Database.query( query2 );
        if(listexistingcase.size() > 0){
            for(Case c : listexistingcase){
                string closeIdwithChannel  = c.Close_Case_Ref__c+c.Channel__c;
                System.debug(' 3****** Close_Case_Ref__c'+c.Close_Case_Ref__c);
                System.debug(' 3****** Channel__c'+c.Channel__c);
                existingCloneCase.put(closeIdwithChannel,c);
            }
        }
        
        Map<String,User> mapUserTeam = new Map<String,User>();
        for(User u :[Select Id,User_Team__c from User]){
            mapUserTeam.put(u.id,u);
        }
        
        Map<String,Group> mapQueueTeam = new Map<String,Group>();
        for(Group g :[Select Id,Name from Group where type = 'Queue']){
            mapQueueTeam.put(g.Name,g);
        }

        Map<String,String> mapUserTeamwithQueue = new Map<String,String>();
        if(mappingChannelList.size() > 0){
            for(Mapping_Channel_with_User_Team__mdt mdtChannel : mappingChannelList){
                mapUserTeamwithQueue.put(mdtChannel.User_Team__c,mdtChannel.Queue_Name__c);
            }
        }
                
        
        if(caseMaps.size() > 0){
            System.debug(' 4****** caseMaps'+caseMaps.size());
            for(EmailMessage eml : emailList){
                //check new email is found existing case and incoming from external email
                if(caseMaps.get(eml.RelatedToId) !=null && eml.Incoming){//&& mapEmailList.get(eml.FromAddress)!=null
                    System.debug(' 4****** eml.RelatedToId'+eml.RelatedToId);
                    System.debug(' 4****** eml.Incoming'+eml.Incoming);
                    Case c = caseMaps.get(eml.RelatedToId);

                    if(c.Status == 'Pending'){
                        System.debug(' 5****** c.Status'+c.Status);
                        c.Status = 'In Progress';
                        c.Pending_team__c = null;
                    	c.Pending_Reason__c = null;
                        c.Pending_Person__c = null;
                    	updateCaselist.add(c);
                    }

                    //Check CC mail for not auto response
                    if(c.CC_Address__c == null && mapQueue.get(c.ownerid) !=null){
                        System.debug(' 6****** c.CC_Address__c'+c.CC_Address__c);
                        System.debug(' 6****** mapQueue.get(c.ownerid)'+mapQueue.get(c.ownerid));
                        c.CC_Address__c  = (eml.CcAddress!=null)?eml.CcAddress:'-';

                        if(eml.CcAddress !=null){ 
                            System.debug(' 7****** eml.CcAddress'+eml.CcAddress);
                            //map mapEmailToTeam for check CC email
                            string ownerName = mapQueue.get(c.ownerid).Name;
                            if(ownerName !=null &&  mapEmailToTeam.get(ownerName)!=null){
                                System.debug(' 8****** ownerName'+ownerName);
                                System.debug(' 8****** mapEmailToTeam.get(ownerName)'+mapEmailToTeam.get(ownerName));
                                string emailToList = mapEmailToTeam.get(ownerName).Email__c;
                                List<String> lstEmail = emailToList.split(';');//get email team list

                                if(!lstEmail.contains(eml.ToAddress)){
                                    System.debug(' 9****** lstEmail.contains(eml.ToAddress)'+eml.ToAddress);
                                    //not found cc from email ToAddress => case create from cc 
                                    c.Is_From_CC__c = true;
                                }
                            }

                        }
                        
                        updateCaseCClist.add(c);
                    }
                        
                }
                
                //check case status is closed.
                if(caseMaps.get(eml.RelatedToId) !=null){
                    System.debug(' 10****** check case status is closed.'+eml.RelatedToId);
                    Case c = caseMaps.get(eml.RelatedToId);
                    if(c.IsClosed && eml.Incoming){
                        System.debug(' 11****** c.IsClosed'+c.IsClosed);
                        System.debug(' 11****** eml.Incoming'+eml.Incoming);
                        String OwnerID = c.OwnerId;    
                        System.debug('@@' + OwnerID);
                        if (OwnerID.startsWith('005')) {
                            System.debug(' 12****** Owner005');
                            //If Owner is user auto assign user team to owner
                            String userTeam;
                            String queueName;
                            if(mapUserTeam.get(OwnerId)!=null){
                                System.debug(' 13****** User');
                                userTeam = mapUserTeam.get(OwnerId).User_Team__c;
                                queueName = mapUserTeamwithQueue.get(userTeam);
                            }
                            
                            if(queueName!=null && mapQueueTeam.get(queueName)!=null){
                                System.debug(' 14****** Owner');
                                c.OwnerId = mapQueueTeam.get(queueName).Id;
                            }
                            
                        }

                        //get email ToAddress list
                        string toAddressEmail = eml.ToAddress != null? eml.ToAddress : '';
                        List<String> lstToAdressEmail = toAddressEmail.split(';');//split toAddress
                        //string firstEmail = lstToAdressEmail.get(0); => change to check all email.
                        System.debug(' 15****** listEmailToTeam'+listEmailToTeam);
                        //check queue not match email ToAddress change channel&owner to right queue
                            for(Mapping_Email_To_Team_Set__c lstMailTeam : listEmailToTeam){
                                System.debug(' 16****** lstMailTeam'+lstMailTeam);
                                //check channel & mail is matching,If not modify channel and owner queue
                                List<String> lstEmail = lstMailTeam.Email__c.split(';');
                                Boolean foundEmail = false; 

                                for(String tomail : lstToAdressEmail){
                                    System.debug(' 17****** tomail'+tomail);
                                    string trimToAddress = tomail.trim();
                                    if(lstEmail.contains(trimToAddress) && !foundEmail){
                                        System.debug(' 18****** trimToAddress'+trimToAddress);
                                        foundEmail = true;
                                        System.debug('Check team '+lstMailTeam.channel__c+'Email :'+tomail);
                                        
                                        if(lstMailTeam.channel__c!= c.channel__c){
                                            System.debug(' 19****** lstMailTeam.channel__c'+lstMailTeam.channel__c);
                                            System.debug(' 19****** c.channel__c'+c.channel__c);
                                            c.channel__c = lstMailTeam.channel__c; //modify channel
                                            //change owner of case to right queue
                                            if (lstMailTeam.Name != null && mapQueueTeam.containsKey(lstMailTeam.Name)) { // Added by Tej | 2nd Jan 2024 | Null Check
                                                c.ownerid = mapQueueTeam.get(lstMailTeam.Name).id;
                                            }
                                        }
                                    }
                                }
                               
                                if(foundEmail){
                                    System.debug(' 20****** ');
                                    closeCaselist.add(c);
                                    break;
                                }
                            }
                    }
                }
                
            }
            
            if(updateCaselist.size()>0){
                System.debug(' 21****** ');
                try{
                    update updateCaselist;
                }catch(Exception e){
                    system.debug('Email Error : '+e);
                }
                
            }

            if(updateCaseCClist.size()>0){
                System.debug(' 22****** ');
                try{
                    update updateCaseCClist;
                }catch(Exception e){
                    system.debug('Email Error : '+e);
                }
                
            }
            system.debug('@@ ===>' + closeCaselist.size());
            if(closeCaselist.size()>0){
				System.debug(' 23****** ');
                for(Case c : closeCaselist){
                    


                    //check existing channel before create new case.
                    //get existing case if found case channel
                    
                    Case cloneCase = new Case();
                    if(c.Channel__c !=null){
                        System.debug(' 24******c.Channel__c '+c.Channel__c);
                        String activeRecordTypeDevName;
                        Id activeRecordTypeId;
                        String channelCase = c.Channel__c;
                        
                        String closeIdwithChannel  = c.Id+c.Channel__c;

                        
                        //get channel mapping active record type
                        if(mapChannelWithClosedCase.get(channelCase)!=null){
                            System.debug(' 25******mapChannelWithClosedCase.get(channelCase) '+mapChannelWithClosedCase.get(channelCase));
                            activeRecordTypeDevName = mapChannelWithClosedCase.get(channelCase).Active_Record_Type__c;
                        }else{
                            System.debug(' 26******Else');
                            channelCase = 'Default';
                            activeRecordTypeDevName = mapChannelWithClosedCase.get(channelCase).Active_Record_Type__c;
                        }

                        //get record type id from activeRecordType
                        if(activeRecordTypeDevName !=null &&  recordTypeMap.get(activeRecordTypeDevName) !=null){
                            System.debug(' 27******activeRecordTypeDevName'+activeRecordTypeDevName);
                            System.debug(' 27******recordTypeMap.get(activeRecordTypeDevName)'+recordTypeMap.get(activeRecordTypeDevName));
                            activeRecordTypeId = recordTypeMap.get(activeRecordTypeDevName).Id;
                        }

                        //find out existing clone case
                        System.debug(' 28.0******existingCloneCase.get(closeIdwithChannel)'+existingCloneCase.get(closeIdwithChannel));
                        if(existingCloneCase.get(closeIdwithChannel)!=null){
                            System.debug(' 28******existingCloneCase.get(closeIdwithChannel)'+existingCloneCase.get(closeIdwithChannel));
                            cloneCase = existingCloneCase.get(closeIdwithChannel);
                            cloneCase.id = existingCloneCase.get(closeIdwithChannel).id;
                            cloneCase.RecordTypeId = (activeRecordTypeId!=null)?activeRecordTypeId:CASE_RECORD_ID;
                            cloneCase.Pass_to_Doctor_Date__c = null;
                            cloneCase.Reply_from_Doctor_Date__c = null;
                            cloneCase.Close_Case_Reason__c = null;
                            cloneCase.Case_Detail__c = null;
                            cloneCase.Reactivated__c = false;
                            cloneCase.Reactivated_By__c = null;
                            cloneCase.Reactivated_Date__c = null;
                            cloneCase.Campaign_Interest_Type__c = null;
                            cloneCase.Campaign_Master__c = null;
                            cloneCase.Escalate_Date__c = null;
                            cloneCase.Escalate_to__c = null;
                            cloneCase.Case_Solution__c = null;

                        }else{
                            System.debug(' 29******Else');
                            cloneCase = c.clone();
                            cloneCase.Status = 'New';
                            cloneCase.origin = 'Email';
                            //cloneCase.isCloneClosedCase__c = false;
                            cloneCase.Pass_to_Doctor_Date__c = null;
                            cloneCase.Reply_from_Doctor_Date__c = null;
                            cloneCase.Close_Case_Ref__c  = c.id;
                            cloneCase.RecordTypeId = (activeRecordTypeId!=null)?activeRecordTypeId:CASE_RECORD_ID;
                            cloneCase.Close_Case_Reason__c = null;
                            cloneCase.Case_Detail__c = null;
                            cloneCase.Reactivated__c = false;
                            cloneCase.Reactivated_By__c = null;
                            cloneCase.Reactivated_Date__c = null;
                            cloneCase.Campaign_Interest_Type__c = null;
                            cloneCase.Campaign_Master__c = null;
                            cloneCase.Escalate_Date__c = null;
                            cloneCase.Escalate_to__c = null;
                            cloneCase.Case_Solution__c = null;
                        }

                        refCaseIdSet.add(c.id);
                        System.debug(' 29******refCaseIdSet'+refCaseIdSet);
                        cloneCloseCaselist.add(cloneCase);
                    
                    }
                    
                }
                
                if(cloneCloseCaselist.size() > 0){
                    System.debug(' 30******cloneCloseCaselist.size()'+cloneCloseCaselist.size());
                    try{
                        upsert cloneCloseCaselist;
                    }catch(Exception e){
                        system.debug('Email Error : '+e);
                    }
                   
                }
                
            }

            
            if(refCaseIdSet.size() > 0 && cloneCloseCaselist.size() >0){
                System.debug(' 30******refCaseIdSet.size()'+refCaseIdSet.size());
                System.debug(' 30******cloneCloseCaselist.size()'+cloneCloseCaselist.size());
                //Auto close email from closed case.
                system.debug('refCaseIdSet'+refCaseIdSet);
                BIH_CloneEmailFromClosedCase cloneEmail2Case = new BIH_CloneEmailFromClosedCase();
                cloneEmail2Case.cloneCase(refCaseIdSet);

            }
        }
        
        
        
    }

    public static String getFields(String ObjectName,String fieldSetName){
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        String fields ='';
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        for(Schema.FieldSetMember fm:fieldSetObj.getFields()){
            if(fields != '' && fields != null){
                fields += ',' +  String.valueOf( fm.getSObjectField());   
            }else{
                fields = String.valueOf( fm.getSObjectField());   
            }
        }
        return fields;
    }
    
        
}