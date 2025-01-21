public class BIH_EditCategories 
{
    public class pickListValueWrapper 
    {
        @AuraEnabled
        public string DefalutRecordId {get; set;}
        @AuraEnabled
        public Set<BIH_PicklistOption> keyCateLvL1 {get; set;}
        @AuraEnabled
        public Map<String, String> mapCaseLvl1 {get; set;}
        @AuraEnabled
        public Map<String, Set<BIH_PicklistOption>> mapCaseLvl2 {get; set;}
        @AuraEnabled
        public Set<String> keyCateLvL2 {get; set;}
        @AuraEnabled
        public Map<String, Set<BIH_PicklistOption>> mapCaseLvl3 {get; set;}
        //@AuraEnabled
        //public Map<String,List<BIH_PicklistOption>> PickListValue {get; set;}
        @AuraEnabled
        public Map<String,String> mapSLA {get; set;}
        @AuraEnabled
        public Map<String,String> mapDynamicGroup {get; set;}
        @AuraEnabled
        public Map<String,String> mapServiceDetailTH {get; set;}
        @AuraEnabled
        public Map<String,String> mapServiceDetailEN {get; set;}
        @AuraEnabled
        public Map<String,String> mapScriptTH {get; set;}
        @AuraEnabled
        public Map<String,String> mapScriptEN {get; set;}
        @AuraEnabled
        public Map<String,String> recordTypeMap {get; set;}
        @AuraEnabled
        public User UserLogInInfo {get; set;}
        @AuraEnabled
        public Map<String,String> mapQuickCase {get; set;}
        @AuraEnabled
        public Set<String> keyQuickCase {get; set;}
        //@AuraEnabled
        @AuraEnabled
        public Map<String,String> mapQuickCase1 {get; set;}
        @AuraEnabled
        public Set<String> keyQuickCase1 {get; set;}
         @AuraEnabled
        public Map<String,String> mapQuickCase2 {get; set;}
        @AuraEnabled
        public Set<String> keyQuickCase2 {get; set;}
        
    }
    public class CaseAndPatientInformationWrapper {
        @AuraEnabled
        public Case CaseObject {get; set;}
        @AuraEnabled
        public Account PatientObject {get; set;}
        @AuraEnabled
        public Account SenderObject {get; set;}
        @AuraEnabled
        public User UserCurrentInfo {get; set;}
        @AuraEnabled
        public Group GroupCurrentInfo {get; set;}
        @AuraEnabled
        public Doctor__c DoctorObject {get; set;}
        @AuraEnabled
        public Contact PendingPersonObject {get; set;}
        @AuraEnabled
        public string checkInTime{get;set;}
        @AuraEnabled
        public string checkOutTime{get;set;}
        
    }
    
    @AuraEnabled
        public static Case UpdateCaseRecord(Case caseObj)
        { 

        try {
            Case tmpCaseObj = (Case)caseObj;
            //system.debug(tmpCaseObj);
            if(tmpCaseObj.Status == 'Pending'){
                tmpCaseObj.Pending_Reason__c = 'N/A';
                
            }

            if(tmpCaseObj.Building__c != null && tmpCaseObj.Building__c != '' &&  
                tmpCaseObj.Department__c != null &&  tmpCaseObj.Department__c != ''){
                List<BIH_Building__c> bulidingList = [SELECT Id, Building_EN__c,BIH_Department__c, Building_TH__c, Department_EN__c, Department_TH__c, Floor__c 
                                                        FROM BIH_Building__c 
                                                        WHERE Building_EN__c=:tmpCaseObj.Building__c AND BIH_Department__c=:tmpCaseObj.Department__c];


                if(bulidingList.size() > 0){
                    BIH_Building__c buildObj = bulidingList[0];
                    tmpCaseObj.Building_TH__c = buildObj.Building_TH__c;
                    tmpCaseObj.Department_EN__c = buildObj.Department_EN__c;
                    tmpCaseObj.Department_TH__c = buildObj.Department_TH__c;
                    tmpCaseObj.Floor__c = buildObj.Floor__c;
                }
            }
            List<Service_Type_Matrix__c> serviceTypeMatrix = [
                SELECT Dynamic_Group__c
                FROM Service_Type_Matrix__c 
                WHERE Category_Level1_English__c = :tmpCaseObj.Case_Category_Level1__c 
                  AND Category_Level2_English__c = :tmpCaseObj.Case_Category_Level2__c 
                  AND Category_Level3_English__c = :tmpCaseObj.Case_Category_Level3__c
                LIMIT 1
            ];

            if (!serviceTypeMatrix.isEmpty()) {
                tmpCaseObj.Dynamic_Group__c = serviceTypeMatrix[0].Dynamic_Group__c;
            }
            
           
            update tmpCaseObj;
            
            return tmpCaseObj;
        } catch (Exception e) {
            system.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        // return null;
    }
    
    
    @AuraEnabled
    public static String getUserTeam() {
        User currentUser = [SELECT Id, user_team__c FROM User WHERE Id = :UserInfo.getUserId()];
        return currentUser.user_team__c;
    }
    
    
    @AuraEnabled
    public static CaseAndPatientInformationWrapper getCaseAndPatientInformation(Id caseId){
        try {
            CaseAndPatientInformationWrapper cpiWrapper = new CaseAndPatientInformationWrapper();
            List<Case> caseObj = new List<Case>();
            String query = 'SELECT Id, ' +
                getFields('Case','EditCaseForContactCenter')+
                ' ,Parent.CaseNumber,CreatedBy.Name,LastModifiedBy.Name,Account.Name,Patient__r.Name,Account.Hospital_Number_HN__c,Patient__r.Hospital_Number_HN__c'+
                ' FROM Case Where id = :caseId ';
            caseObj = Database.query( query );
            
            List<CasePlatformEventMapping__c> listCase = [select Id,Platform_Event_Channel__c,Case_Id__c from CasePlatformEventMapping__c WHERE Case_Id__c =: caseId];
            
            
            if(caseObj.size()>0){
                if(((String)caseObj[0].OwnerId).startsWith('00G') ){
                    Group user = [SELECT ID,Name FROM Group WHERE ID=:caseObj[0].OwnerId LIMIT 1];
                    cpiWrapper.GroupCurrentInfo = user;
                }else{
                    User user = [SELECT ID,Name,Profile.Name FROM User WHERE ID=:caseObj[0].OwnerId LIMIT 1];
                    cpiWrapper.UserCurrentInfo = user;
                }
                
                if(listCase.size()>0){
                    caseObj[0].Platform_Event_Channel__c = listCase.get(0)?.Platform_Event_Channel__c+'';
                    
                }
                
                cpiWrapper.CaseObject = caseObj[0];
                
                List<Account> accList = [SELECT Id, Name, LastName, FirstName, Salutation, RecordTypeId, Phone, 
                                         Hospital_Number_HN__c,PersonBirthdate, PersonMobilePhone , PersonEmail,
                                         Email__c
                                         FROM    Account
                                         WHERE   id =: caseObj[0].Patient__c OR id=: caseObj[0].AccountId  ];
                if(accList.size()> 0){
                    if(accList.size() == 1 && (caseObj[0].Patient__c == caseObj[0].AccountId )){
                        cpiWrapper.PatientObject = accList[0];
                        cpiWrapper.SenderObject = accList[0];
                    }else{
                        for(Account a: accList){
                            if(a.id == caseObj[0].Patient__c){
                                cpiWrapper.PatientObject = a;
                            }else{
                                cpiWrapper.SenderObject = a;
                            }
                        }
                    }
                }
                if(caseObj[0].Doctor__c != null){
                    Doctor__c doctor = [SELECT Id, Name FROM Doctor__c WHERE   id =: caseObj[0].Doctor__c  ];
                    cpiWrapper.DoctorObject = doctor;
                }
                if(caseObj[0].Pending_Person__c != null){
                    Contact contact = [SELECT Id, Name FROM Contact WHERE   id =: caseObj[0].Pending_Person__c  ];
                    cpiWrapper.PendingPersonObject = contact;
                }
                
                cpiWrapper.checkInTime = string.valueof(caseObj[0].Check_In_Time__c);
                cpiWrapper.checkOutTime = string.valueof(caseObj[0].Check_Out_Time__c) ;
                
            }else{
                User user = [SELECT ID,Name,Profile.Name,User_Team__c FROM User WHERE ID=:UserInfo.getUserId() LIMIT 1];
                cpiWrapper.UserCurrentInfo = user;
            }
            
            return cpiWrapper;
        } catch (Exception e) {
            //system.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static string getBtnConfig(){
        BIH_Constants__mdt cons = new DataSelector().getBtnConfig();
        return cons.Value_1__c;
    }
    public static Map<String,String> getRecordTypeCaseAPIByName{get;set;}

    
    @AuraEnabled
    public static pickListValueWrapper getPickListValueWrapper(string caseId){
        Case currentCase = new Case();
        pickListValueWrapper ccw = new pickListValueWrapper();
        String recordTypeId ='';
        //system.debug('caseId map wrapper : '+caseId);
        //system.debug('recordTypeId : '+recordTypeId);
        if(caseId!=null&&caseId!=''){
            currentCase = (case) [Select id,recordTypeId from case where id =: caseId];
            recordTypeId = currentCase.recordTypeId;
        }
        User user = [SELECT ID,Name,Profile.Name,User_Team__c,Language_Skill__c,toLabel(LanguageLocaleKey) FROM User WHERE ID=:UserInfo.getUserId() LIMIT 1];
        if(recordTypeId == null || recordTypeId == ''|| recordTypeId == 'undefined' ){
            if(user.Profile.Name.contains(System.Label.Airport_Profile)){
                ccw.DefalutRecordId = BIH_Constants.AIRPORT_TRANSFER_CASE_RECORDTYPE;
                
            } else if(user.Profile.Name.contains(System.Label.Pharmacy_Profile)){
                ccw.DefalutRecordId = BIH_Constants.PHARMACY_CASE_RECORDTYPE;
                
            } else if(user.Profile.Name.contains(System.Label.Contact_Center_Profile)){
                ccw.DefalutRecordId = BIH_Constants.CONTACT_CENTER_CASE_RECORDTYPE;
            } 
            else{
                ccw.DefalutRecordId = BIH_Constants.PRIMARY_CASE_RECORDTYPE;
            }
            
            recordTypeId = ccw.DefalutRecordId;
        }
        //system.debug('recordTypeId : '+recordTypeId);
       
        String userTeam = '';
		String responseibleTeam = '';
        User user1 = [SELECT ID, Name, Profile.Name, User_Team__c FROM User WHERE ID = :UserInfo.getUserId() LIMIT 1];
        
        
        // Map of user teams to responsible teams
        Map<String, String> teamMap = new Map<String, String>{
            'Airport Transfer Team' => 'Airport Transfer Team',
                'Individual Team' => 'Referral',
                'Referral Team' => 'Referral',
                'Medical Enquiry Team' => 'Medical Enquiry',
                'Registration Team' => 'Registration',
                'Insurance Team' => 'Insurance Team',
                'BH Phuket' => 'BIH Phuket'
                };   
                    // Set the responsible team based on the user team
                    if (teamMap.containsKey(user1.User_Team__c)) {
                        responseibleTeam = teamMap.get(user1.User_Team__c);
                    }
        
        Map<Id, Service_Type_Matrix__c> stm;
       // Execute the appropriate query based on whether responseibleTeam is set
       system.debug('responseibleTeam***'+responseibleTeam);
        if (responseibleTeam != null && responseibleTeam != '' ) {
            system.debug('responseibleTeam 1 ***'+responseibleTeam);
            stm = new Map<Id, Service_Type_Matrix__c>([
                SELECT Category_Level1_Thai__c, Category_Level2_Thai__c, Category_Level3_Thai__c, 
                Category_Level1_English__c, Category_Level2_English__c, Category_Level3_English__c, 
                SLA__c, Service_Detail_ENG__c, Script_TH__c, Service_Detail_TH__c, Id, Script_ENG__c, 
                Dynamic_Group__c, Quick_Case__c, Responsible_Team__c
                FROM Service_Type_Matrix__c 
                WHERE Channel__c != 'Contact Center' AND Responsible_Team__c = :responseibleTeam
                ORDER BY Category_Level1_English__c, Category_Level2_English__c, Category_Level3_English__c
            ]);
        } else {
            system.debug('responseibleTeam 2 ***'+responseibleTeam);
            stm = new Map<Id, Service_Type_Matrix__c>([
                SELECT Category_Level1_Thai__c, Category_Level2_Thai__c, Category_Level3_Thai__c, 
                Category_Level1_English__c, Category_Level2_English__c, Category_Level3_English__c, 
                SLA__c, Service_Detail_ENG__c, Script_TH__c, Service_Detail_TH__c, Id, Script_ENG__c, 
                Dynamic_Group__c, Quick_Case__c, Responsible_Team__c
                FROM Service_Type_Matrix__c 
                WHERE Channel__c != 'Contact Center'
                ORDER BY Category_Level1_English__c, Category_Level2_English__c, Category_Level3_English__c
            ]);
        }
        
               
        /*Map<Id,Doctor__c> doctorMap = new Map<Id,Doctor__c>([SELECT Id, Name, MD_Code__c, Doctor_First_Name__c, Doctor_Last_Name__c, 
                                                             Specialty__c, Specialty2__c,
                                                             Doctor_Name_TH__c, Doctor_Note__c FROM Doctor__c]);*/
        
        Map<String,Set<BIH_PicklistOption>> cate_lvl1_Map = new Map<String,Set<BIH_PicklistOption>>();
        Map<String,Set<BIH_PicklistOption>> cate_lvl2_Map = new Map<String,Set<BIH_PicklistOption>>();
        Set<BIH_PicklistOption> keyCatelevel1 = new Set<BIH_PicklistOption>();
        Map<String,String> cate_lvl1_MapTH = new Map<String,String>();
        Map<String,Set<String>> cate_lvl2_MapTH = new Map<String,Set<String>>();
        Map<String,String> sla_Map = new Map<String,String>();
        Map<String,String> mapDynamicGroup = new Map<String,String>();
        Map<String,String> serv_detail_THMap = new Map<String,String>();
        Map<String,String> serv_detail_ENMap = new Map<String,String>();
        Map<String,String> mapScriptTH = new Map<String,String>();
        Map<String,String> mapScriptEN = new Map<String,String>();
        Set<String> setCat1 = new Set<String>();
        Map<String,String> mapQuickCase = new Map<String,String>();
        Map<String,String> mapQuickCase1 = new Map<String,String>();
        Map<String,String> mapQuickCase2 = new Map<String,String>();
        //system.debug(stm);
        for(Service_Type_Matrix__c m :stm.values()){
            
            if(cate_lvl1_Map.containsKey(m.Category_Level1_English__c)) {
                Boolean isExisting = false; // check have no in set
                Set<BIH_PicklistOption> tmpSet = cate_lvl1_Map.get(m.Category_Level1_English__c);
                for(BIH_PicklistOption plo :tmpSet){
                    if(plo.value == m.Category_Level2_English__c){
                        isExisting = true;
                        break;
                    }
                }
                if(!isExisting){
                    BIH_PicklistOption pl = new BIH_PicklistOption(m.Category_Level2_English__c,m.Category_Level2_English__c);
                    tmpSet.add(pl);
                }
                
            } else {
                Set<BIH_PicklistOption> tmpSet = new Set<BIH_PicklistOption>();
                BIH_PicklistOption pl = new BIH_PicklistOption(m.Category_Level2_English__c,m.Category_Level2_English__c);
                tmpSet.add(pl);
                cate_lvl1_Map.put(m.Category_Level1_English__c, tmpSet);
                
                BIH_PicklistOption keycatepl = new BIH_PicklistOption(m.Category_Level1_English__c,m.Category_Level1_English__c);
                keyCatelevel1.add(keycatepl);
                
            }
            // //system.debug('cate_lvl2_Map : '+cate_lvl2_Map);
            if(cate_lvl2_Map.containsKey(m.Category_Level2_English__c+':'+m.Category_Level1_English__c)) {
                //system.debug('- '+m.Category_Level2_English__c+':'+m.Category_Level1_English__c);
                Set<BIH_PicklistOption> tmpSet = cate_lvl2_Map.get(m.Category_Level2_English__c+':'+m.Category_Level1_English__c);
                //system.debug('tmpSet : '+tmpSet);
                BIH_PicklistOption pl = new BIH_PicklistOption(m.Category_Level3_English__c,m.Category_Level3_English__c );
                tmpSet.add(pl);
            } else {
                Set<BIH_PicklistOption> tmpSet = new Set<BIH_PicklistOption>();
                BIH_PicklistOption pl = new BIH_PicklistOption(m.Category_Level3_English__c,m.Category_Level3_English__c );
                tmpSet.add(pl);
                cate_lvl2_Map.put(m.Category_Level2_English__c+':'+m.Category_Level1_English__c, tmpSet);
            }
            
            sla_Map.put(m.Category_Level3_English__c+':'+m.Category_Level2_English__c+':'+m.Category_Level1_English__c,String.ValueOf(m.SLA__c));
            
            //for dynamuc group
            mapDynamicGroup.put(m.Category_Level3_English__c+':'+m.Category_Level2_English__c+':'+m.Category_Level1_English__c,String.ValueOf(m.Dynamic_Group__c));
            
            //for create map serv_detail
            serv_detail_ENMap.put(m.Category_Level3_English__c+':'+m.Category_Level2_English__c+':'+m.Category_Level1_English__c,String.ValueOf(m.Service_Detail_ENG__c));
            serv_detail_THMap.put(m.Category_Level3_English__c+':'+m.Category_Level2_English__c+':'+m.Category_Level1_English__c,String.ValueOf(m.Service_Detail_TH__c));
            
            //for create map serv_detail
            mapScriptEN.put(m.Category_Level3_English__c+':'+m.Category_Level2_English__c+':'+m.Category_Level1_English__c,String.ValueOf(m.Script_ENG__c));
            mapScriptTH.put(m.Category_Level3_English__c+':'+m.Category_Level2_English__c+':'+m.Category_Level1_English__c,String.ValueOf(m.Script_TH__c));
            
            // for quickcase 
            if(m.Quick_Case__c != null){
                if(m.Category_Level1_English__c.contains('Appointment')) {
                    mapQuickCase.put(m.Quick_Case__c, m.Category_Level3_English__c + ':' + m.Category_Level2_English__c + ':' + m.Category_Level1_English__c);
                    system.debug('mapQuickCase :'+ mapQuickCase);
                } else if(m.Category_Level1_English__c.contains('General')) {
                    mapQuickCase1.put(m.Quick_Case__c, m.Category_Level3_English__c + ':' + m.Category_Level2_English__c + ':' + m.Category_Level1_English__c);
                    system.debug('mapQuickCase1 :'+ mapQuickCase1);
                    
                }
                else if(m.Category_Level1_English__c.contains('Tele')) {
                    mapQuickCase2.put(m.Quick_Case__c, m.Category_Level3_English__c + ':' + m.Category_Level2_English__c + ':' + m.Category_Level1_English__c);
                    system.debug('mapQuickCase2 :'+ mapQuickCase2);
                    
                }
            }
            
         
        }
         
        
        ccw.keyCateLvL1 = keyCatelevel1;
        ccw.mapCaseLvl1 = cate_lvl1_MapTH;
        ccw.mapCaseLvl2 = cate_lvl1_Map;
        ccw.keyCateLvL2 = cate_lvl2_Map.keySet();
        ccw.mapCaseLvl3 = cate_lvl2_Map;
        ccw.mapSLA = sla_Map;
        ccw.mapDynamicGroup = mapDynamicGroup;
        ccw.mapServiceDetailTH = serv_detail_THMap;
        ccw.mapServiceDetailEN = serv_detail_ENMap;
        ccw.UserLogInInfo = user;
        ccw.mapScriptTH = mapScriptTH;
        ccw.mapScriptEN = mapScriptEN;
        //ccw.buildingMap = buildingMap;
        //ccw.keyBuilding = buildingMap.keySet();
        ccw.mapQuickCase = mapQuickCase;
        
        
        List<String> tmpKeyQuickCaseForSort = new List<String>(mapQuickCase.keySet());
        tmpKeyQuickCaseForSort.sort();
        ccw.keyQuickCase =  new Set<String>(tmpKeyQuickCaseForSort);
      	system.debug('ccw.mapQuickCase :'+ ccw.mapQuickCase);
        
        ccw.recordTypeMap = GetAvailableRecordTypeCase();
        
        ccw.mapQuickCase1 = mapQuickCase1;
        
        List<String> tmpKeyQuickCaseForSort1 = new List<String>(mapQuickCase1.keySet());
        tmpKeyQuickCaseForSort1.sort();
        ccw.keyQuickCase1 =  new Set<String>(tmpKeyQuickCaseForSort1);
        system.debug('ccw.mapQuickCase1 :'+ ccw.mapQuickCase1);
        
        
        ccw.mapQuickCase2 = mapQuickCase2;
        
        List<String> tmpKeyQuickCaseForSort2 = new List<String>(mapQuickCase2.keySet());
        tmpKeyQuickCaseForSort2.sort();
        ccw.keyQuickCase2 =  new Set<String>(tmpKeyQuickCaseForSort2);
        system.debug('ccw.mapQuickCase2 :'+ ccw.mapQuickCase2);
        
        string recordTypeName;
        string recordTypeDevName;
        if(recordTypeId!=null){
            recordTypeName = ccw.recordTypeMap.get(recordTypeId);
            recordTypeDevName = getRecordTypeCaseAPIByName.get(recordTypeName);
        }else if(currentCase!=null && currentCase.recordTypeId!=null){
            recordTypeName = ccw.recordTypeMap.get(currentCase.recordTypeId);
            recordTypeDevName = getRecordTypeCaseAPIByName.get(recordTypeName);
            recordTypeId = currentCase.recordTypeId;
        }
        
        
        
        Map<String,List<BIH_PicklistOption>> tmpMapPickList = new  Map<String,List<BIH_PicklistOption>>();
        List<String> fieldPicklist = new List<String>{
            'Contact_Center_Channel__c','Escalate_to__c','Escalate_Date__c', 'Payor_Type__c','Patient_Type__c',
                'Priority','Channel__c', 'Pending_team__c','Not_App_Reason__c',
                'Origin','Close_Case_Team__c','Pending_Reason__c','App_Time_Status__c',
                'Specialty_Doctor__c','Owner_Change_Reason__c','IV_Team_Name__c',
                'Type_of_SMS__c','Contact_Center_Source__c','Interpreter_Language__c'};
                    
                    
                    if(recordTypeDevName !=null){
                        tmpMapPickList = getPickListValuesIntoListByVF(fieldPicklist,recordTypeDevName);
                    }
        //ccw.PickListValue = tmpMapPickList;
        tmpMapPickList = getPickListValuesIntoList(new List<String>{
            'Status'});
        if(recordTypeDevName !=null){
            List<BIH_PicklistOption> picklistStatus = BIH_CaseUtility.getPickListValuesCaseStatus(recordTypeId);
            tmpMapPickList.put('Status', picklistStatus);
        }
       // ccw.PickListValue.putAll(tmpMapPickList);
        String SessionId = BIH_CaseUtility.getUserSessionId();
         
        return ccw;
    }
    
    public static Map<String,String> GetAvailableRecordTypeCase()
    {
        Map<String,String> recordTypeMap = new Map<String,String>();
        Map<String,String> recordTypeMapAPIName = new Map<String,String>();
        List<RecordType> mRecordTypeList = [SELECT Id,  Name, DeveloperName, Description FROM RecordType WHERE SobjectType = 'Case'];
        Schema.DescribeSObjectResult R = Case.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        for(RecordType rec : mRecordTypeList) 
        {
            recordTypeMap.put(rec.Id, rec.Name);
            recordTypeMapAPIName.put(rec.Name, rec.DeveloperName);
        }
        
        getRecordTypeCaseAPIByName = recordTypeMapAPIName;
        
        return recordTypeMap;
    } 
    
    
    public static Map<String,List<BIH_PicklistOption>> getPickListValuesIntoListByVF( List<String> field_name,string recordTypeDevName) {
        Map<String,List<BIH_PicklistOption>> values = new Map<String,List<BIH_PicklistOption>>();
        for(String fn : field_name) {
            List<BIH_PicklistOption> tmpList = BIH_PickListDescCtrl.describe('Case',recordTypeDevName,fn);
            values.put(fn,tmpList);
        }  
        return values;
    }
    
    public static Map<String,List<BIH_PicklistOption>> getPickListValuesIntoListByVFPrimary( List<String> field_name) {
        Map<String,List<BIH_PicklistOption>> values = new Map<String,List<BIH_PicklistOption>>();
        for(String fn : field_name) {
            List<BIH_PicklistOption> tmpList = BIH_PickListDescCtrl.describe('Case',BIH_Constants.PRIMARY_CASE_RECORDTYPE,fn);
            values.put(fn,tmpList);
        }  
        return values;
    }
    
    public static Map<String,List<BIH_PicklistOption>> getPickListValuesIntoList( List<String> field_name) {
        Map<String,List<BIH_PicklistOption>> values = new Map<String,List<BIH_PicklistOption>>();
        Schema.DescribeSobjectResult results = Schema.describeSObjects(new String[]{'Case'})[0];
        for(String fn : field_name) {
            List<BIH_PicklistOption> tmpList = new List<BIH_PicklistOption>();
            for (Schema.PicklistEntry entry : results.fields.getMap().get(fn).getDescribe().getPicklistValues()) {
                if (entry.isActive()) {
                    BIH_PicklistOption pl = new BIH_PicklistOption(entry.getValue(),entry.getValue());
                    // tmpList.add(entry.getValue());
                    tmpList.add(pl);
                }
            }
            values.put(fn,tmpList);
        }  
        return values;
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