public with sharing class BIH_EditChildCaseFormCtrl {

  public class pickListValueWrapper {
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
        @AuraEnabled
        public Map<String,List<BIH_PicklistOption>> PickListValue {get; set;}
        @AuraEnabled
        public Map<String,String> mapSLA {get; set;}
        @AuraEnabled
        public Map<String,String> recordTypeMap {get; set;}
        @AuraEnabled
        public Map<String,List<BIH_PicklistOption>> flightMap {get; set;}
        @AuraEnabled
        public Map<String,List<BIH_PicklistOption>> paymentMap {get; set;}
        @AuraEnabled
        public List<String> closeReason {get; set;}
        @AuraEnabled
        public Map<Id,Doctor__c> mapDoctorAll {get; set;}
        
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
        public User StaffCurrentInfo {get; set;}
        @AuraEnabled
        public Doctor__c DoctorObject {get; set;}
        @AuraEnabled
        public Doctor__c DoctorObject2 {get; set;}
        @AuraEnabled
        public Doctor__c DoctorObject3 {get; set;}
        @AuraEnabled
        public Contact PendingPersonObject {get; set;}
        @AuraEnabled
        public string checkInTime{get;set;}
        @AuraEnabled
        public string checkOutTime{get;set;}
        
    }
    public class CampaignWrapper {
        @AuraEnabled
        public Map<String,List<BIH_PicklistOption>> campaignPickList {get;set;}
        @AuraEnabled
        public Map<String,List<BIH_PicklistOption>> interestPickList {get;set;}
    }

   public class CampaignDetailWrapper {
        @AuraEnabled
        public Integer remainCampaign {get;set;}
        @AuraEnabled
        public Case_Campaign_Master__c CampaignObj {get;set;}
       
   }

  public static Map<String,List<BIH_PicklistOption>> getPickListValuesIntoList( List<String> field_name) {
      
      //system.debug('1 st Method called getPickListValuesIntoList');
      
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

    public static Map<Id,Case_Status_with_Record_Type__mdt> mapCaseStatusWithRecordType {get{
        if(mapCaseStatusWithRecordType==null){
            mapCaseStatusWithRecordType = new Map<Id,Case_Status_with_Record_Type__mdt>([
                                            SELECT Id, MasterLabel, Close_Reason__c, Status__c, Record_Type_Developer_Name__c, Order__c 
                                            FROM Case_Status_with_Record_Type__mdt order by Order__c]);
        }
        return mapCaseStatusWithRecordType;
    }set;}
    
    public static Map<String,Contact_Center_Escalation_Rule__mdt> mapContactCenterEscalationRule {get{
        if(mapContactCenterEscalationRule==null){
            Map<String,Contact_Center_Escalation_Rule__mdt> mapContactCenterEscalationRules = new Map<String,Contact_Center_Escalation_Rule__mdt>();
            List<Contact_Center_Escalation_Rule__mdt> mdtList = [SELECT Id, MasterLabel,Record_Type_Name__c, Escalate_To__c, Record_Type_Developer_Name__c FROM Contact_Center_Escalation_Rule__mdt];
            for (Contact_Center_Escalation_Rule__mdt mdt : mdtList){
                mapContactCenterEscalationRules.put(mdt.Escalate_To__c,mdt);
            }
            mapContactCenterEscalationRule = mapContactCenterEscalationRules;
        }
        return mapContactCenterEscalationRule;
    }set;}

    public static Map<String,String> getRecordTypeCaseAPIByName{get;set;}

    public static Map<String,String> GetAvailableRecordTypeCase()
    {  //system.debug('2 nd Method called GetAvailableRecordTypeCase');
        Map<String,String> recordTypeMap = new Map<String,String>();
        Map<String,String> recordTypeMapAPIName = new Map<String,String>();
        Schema.DescribeSObjectResult R = Case.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        for(RecordType rec : [SELECT Id,  Name, DeveloperName, Description FROM RecordType WHERE SobjectType = 'Case']) {
            recordTypeMap.put(rec.Id, rec.Name);
            recordTypeMapAPIName.put(rec.Name, rec.DeveloperName);
            
        }

        getRecordTypeCaseAPIByName = recordTypeMapAPIName;

        return recordTypeMap;
    } 
  public static Map<String,List<BIH_PicklistOption>> getPickListValuesIntoListByVF( List<String> field_name,string recordTypeDevName) {
      //system.debug('3 rd Method called getPickListValuesIntoListByVF');
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

   @AuraEnabled
    public static string getBtnConfig(){
        BIH_Constants__mdt cons = new DataSelector().getBtnConfig();
        return cons.Value_1__c;
    }
    @AuraEnabled
    public static string getPDVSEndpoint(){
        BIH_Constants__mdt cons = new DataSelector().getPDVSEndpoint();
        return cons.Value_1__c;
    }
    @AuraEnabled
    public static string getUserName(){
        return UserInfo.getUserName();
    }
    @AuraEnabled
    public static string getSessionId(){
        //system.debug('USERNAME: '+UserInfo.getUserName());
        String id = [Select Id, Users.Name,Users.Username, SessionType, LoginType From AuthSession AuthSession where (LoginType = 'Application' or LoginType = 'SAML Sfdc Initiated SSO') and SessionType = 'UI' and Users.Username =: UserInfo.getUserName() limit 1]?.Id;
        return id;
    }
    @AuraEnabled
    public static string getClientId(String caseId){
        String id = new DataSelector().selectCaseByCaseId(caseId)?.Patient__c;
        return id;           
        
    }

    @AuraEnabled
    public static CaseAndPatientInformationWrapper getCaseAndPatientInformationUpdated(Id caseId){
       //system.debug('4Th Method');
        CaseAndPatientInformationWrapper cpiWrapper = new CaseAndPatientInformationWrapper();

        Case ca = new DataSelector().selectCaseByCaseId(caseId);

        // ca.Hospital_Number_HN__c = '999123';
        // ca.SuppliedEmail = 'test@test.com';
        // ca.Full_Name__c = 'Test1 Test2';

        cpiWrapper.CaseObject = ca;
        cpiWrapper.PatientObject = new DataSelector().selectAccountById(ca.Patient__c);

        

        return cpiWrapper;
    }

  @AuraEnabled
    public static pickListValueWrapper getPickListValueWrapper(String recordTypeId,string caseId)
    {        //system.debug('5Th Method');
        //system.debug('date is'+datetime.now());
        Case currentCase = new Case();
        pickListValueWrapper ccw = new pickListValueWrapper();

        //system.debug('caseId map wrapper : '+caseId);
        //system.debug('recordTypeId : '+recordTypeId);
        if(caseId!=null&&caseId!=''){
            currentCase = (case) [Select id,recordTypeId from case where id =: caseId];
        }
        
        if(recordTypeId == null || recordTypeId == ''|| recordTypeId == 'undefined' ){
            User user = [SELECT ID,Name,Profile.Name FROM User WHERE ID=:UserInfo.getUserId() LIMIT 1];
            if(user.Profile.Name.contains(System.Label.Airport_Profile)){
                ccw.DefalutRecordId = BIH_Constants.AIRPORT_TRANSFER_CASE_RECORDTYPE;
                
            } else if(user.Profile.Name.contains(System.Label.Pharmacy_Profile)){
                ccw.DefalutRecordId = BIH_Constants.PHARMACY_CASE_RECORDTYPE;
                
            } else if(user.Profile.Name.contains(System.Label.Contact_Center_Profile)){
                ccw.DefalutRecordId = BIH_Constants.CONTACT_CENTER_CASE_RECORDTYPE;
            } else{
                ccw.DefalutRecordId = BIH_Constants.PRIMARY_CASE_RECORDTYPE;
            }

            recordTypeId = ccw.DefalutRecordId;
        }
         //system.debug('recordTypeId : '+recordTypeId);
        Map<Id,Service_Type_Matrix__c> stm = new Map<id,Service_Type_Matrix__c>([SELECT Category_Level1_Thai__c, Category_Level2_Thai__c, Category_Level3_Thai__c, 
                                                                                        Category_Level1_English__c, Category_Level2_English__c, Category_Level3_English__c, 
                                                                                        SLA__c, Id 
                                                                                        FROM Service_Type_Matrix__c 
                                                                                        WHERE Channel__c != 'Contact Center'
                                                                                        ORDER BY  Category_Level1_English__c, Category_Level2_English__c, Category_Level3_English__c ASC]);

        Map<Id,Doctor__c> doctorMap = new Map<Id,Doctor__c>([SELECT Id, Name, MD_Code__c, Doctor_First_Name__c, Doctor_Last_Name__c, 
        Specialty__c, Specialty2__c,
        Doctor_Name_TH__c, Doctor_Note__c FROM Doctor__c]);

        Map<String,Set<BIH_PicklistOption>> cate_lvl1_Map = new Map<String,Set<BIH_PicklistOption>>();
        Map<String,Set<BIH_PicklistOption>> cate_lvl2_Map = new Map<String,Set<BIH_PicklistOption>>();
        Set<BIH_PicklistOption> keyCatelevel1 = new Set<BIH_PicklistOption>();
        Map<String,String> cate_lvl1_MapTH = new Map<String,String>();
        Map<String,Set<String>> cate_lvl2_MapTH = new Map<String,Set<String>>();
        Map<String,String> sla_Map = new Map<String,String>();
        // Map<String,String> sla_CC_Map = new Map<String,String>();
        Map<String,String> serv_detail_THMap = new Map<String,String>();
        Map<String,String> serv_detail_ENMap = new Map<String,String>();
        Set<String> setCat1 = new Set<String>();
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
            //system.debug('cate_lvl2_Map : '+cate_lvl2_Map);
            if(cate_lvl2_Map.containsKey(m.Category_Level2_English__c+':'+m.Category_Level1_English__c)) {
                //system.debug('- '+m.Category_Level2_English__c+':'+m.Category_Level1_English__c);
                Set<BIH_PicklistOption> tmpSet = cate_lvl2_Map.get(m.Category_Level2_English__c+':'+m.Category_Level1_English__c);
                //system.debug('tmpSet : '+tmpSet);
                BIH_PicklistOption pl = new BIH_PicklistOption(m.Category_Level3_English__c,m.Category_Level3_English__c);
                tmpSet.add(pl);
            } else {
                Set<BIH_PicklistOption> tmpSet = new Set<BIH_PicklistOption>();
                BIH_PicklistOption pl = new BIH_PicklistOption(m.Category_Level3_English__c,m.Category_Level3_English__c);
                tmpSet.add(pl);
                cate_lvl2_Map.put(m.Category_Level2_English__c+':'+m.Category_Level1_English__c, tmpSet);
            }
            
            
            sla_Map.put(m.Category_Level3_English__c+':'+m.Category_Level2_English__c+':'+m.Category_Level1_English__c,String.ValueOf(m.SLA__c));
            // sla_CC_Map.put(m.Category_Level3_English__c+':'+m.Category_Level2_English__c+':'+m.Category_Level1_English__c,String.ValueOf(m.SLA_CC__c));
            // serv_detail_ENMap.put(m.Category_Level3_English__c+':'+m.Category_Level2_English__c+':'+m.Category_Level1_English__c,String.ValueOf(m.Service_Detail_ENG__c));
            // serv_detail_THMap.put(m.Category_Level3_English__c+':'+m.Category_Level2_English__c+':'+m.Category_Level1_English__c,String.ValueOf(m.Service_Detail_TH__c));
        }
        Map<String, List<BIH_PicklistOption>> flightMap = getDependencyFieldValues('Flight_Number__c', 'Arrival_Time__c');
        Map<String, List<BIH_PicklistOption>> paymentMap = getDependencyFieldValues('Method_Of_Payment__c', 'Segment__c');
        // Map<String, List<BIH_PicklistOption>> buildingMap = getDependencyFieldValues('Building__c', 'Department__c');
        
    // Map<String, List<BIH_PicklistOption>> cate2Cate3 = getDependencyFieldValues('Case_Category_Level2__c', 'Case_Category_Level3__c');
        // ccw.keyCateLvL1 = cate_lvl1_Map.keySet();
        ccw.keyCateLvL1 = keyCatelevel1;
        // ccw.kemapCaseLvl1yCateLvL1 = setCat1;
        ccw.mapCaseLvl1 = cate_lvl1_MapTH;
        ccw.mapCaseLvl2 = cate_lvl1_Map;
    ccw.keyCateLvL2 = cate_lvl2_Map.keySet();
    ccw.mapCaseLvl3 = cate_lvl2_Map;
        ccw.mapSLA = sla_Map;
        // ccw.mapSLACC = sla_CC_Map;
        // ccw.mapServiceDetailTH = serv_detail_THMap;
        // ccw.mapServiceDetailEN = serv_detail_ENMap;
        ccw.flightMap = flightMap;
        ccw.paymentMap = paymentMap;
        // ccw.buildingMap = buildingMap;

        if(doctorMap.size()>0){
            ccw.mapDoctorAll = doctorMap;
        }

        ccw.recordTypeMap = GetAvailableRecordTypeCase();

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

        //system.debug('recordTypeName'+recordTypeName);
        //system.debug('recordTypeDevName'+recordTypeDevName);
        
        Map<String,List<BIH_PicklistOption>> tmpMapPickList = new  Map<String,List<BIH_PicklistOption>>();
        List<String> fieldPicklist = new List<String>{
            'TH_Template__c','EN_Template__c',
            'Escalate_to__c','Escalate_Date__c',
            'Priority', 'Lead_Source__c','Channel__c', 'Pending_team__c', 'Type_of_payment__c','Method_of_payment_telemed__c','Note_For_At_Home_Payment__c','Amount__c','email_for_link__c','IPT_code__c','Sent_Date__c','Paid_Date__c','Payor_Type__c','Patient_Type__c',
            'Origin','Close_Case_Team__c','Pending_Reason__c',
            'Specialty_Doctor__c','Specialty_Doctor2__c', 'Case_arr_dep__c','Flight_Number__c','Method_Of_Payment__c',
            'Number_Of_Patient__c', 'Number_Of_Relative__c', 'Payment_Method__c',
            'Request_By__c','Vehicle_Type__c','Gate__c','Airport_Appointment__c','To__c','RO__c', 
            'Hotel__c','Note__c','Registration__c','From__c','Hotel_Airport__c','Queue_Card__c','Owner_Change_Reason__c'};
        
        if(recordTypeDevName !=null){
            tmpMapPickList = getPickListValuesIntoListByVF(fieldPicklist,recordTypeDevName);
        }
        ccw.PickListValue = tmpMapPickList;
        tmpMapPickList = getPickListValuesIntoList(new List<String>{
            'Status','Airport_Rep_Name__c'});
        if(recordTypeDevName !=null){
            List<BIH_PicklistOption> picklistStatus = BIH_CaseUtility.getPickListValuesCaseStatus(recordTypeId);
            tmpMapPickList.put('Status', picklistStatus);
        }
        ccw.PickListValue.putAll(tmpMapPickList);
        // //system.debug('ccw : '+ccw);
        String SessionId = BIH_CaseUtility.getUserSessionId();
        //system.debug('SessionId :'+SessionId);

        //system.debug('recordtype name :'+recordTypeName);
        if(recordTypeId!=null){
            // Set<String> closeReasonSet = new Set<String>();
            List<String> picklistValues = BIH_CaseUtility.getPickListValuesCloseCaseReason('Case',recordTypeId,'Close_Case_Reason__c');
            //system.debug('picklistValues: '+picklistValues);
            // closeReasonSet.putAll(picklistValues);
            // //system.debug('close case :'+closeReasonSet);
            ccw.closeReason = picklistValues;
        }
		        //system.debug('date is'+datetime.now());
        return ccw;
    }
   public static Map<String, List<BIH_PicklistOption>> getDependencyFieldValues(String FieldAPIName1st, String FieldAPIName2nd)
    {    //system.debug('6Th Method');
        Schema.sObjectType sobjectType = Case.getSObjectType();
        Schema.DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = sobjectDescribe.fields.getMap();

        Schema.SObjectField ctrlField = fieldMap.get(FieldAPIName1st);
        Schema.SObjectField targetField = fieldMap.get(FieldAPIName2nd);

        Map<String, List<BIH_PicklistOption>> dependencyField = BIH_FieldDescribeUtil.getDependentOptionsImpl(targetField, ctrlField);
        return dependencyField;
    }
        @AuraEnabled
 public static List < String > getselectOptions(sObject objObject, string fld) {
  //system.debug('objObject --->' + objObject);
  //system.debug('fld --->' + fld);
  List < String > allOpts = new list < String > ();
  // Get the object type of the SObject.
  Schema.sObjectType objType = objObject.getSObjectType();
 
  // Describe the SObject using its object type.
  Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
 
  // Get a map of fields for the SObject
  map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
 
  // Get the list of picklist values for this field.
  list < Schema.PicklistEntry > values =
   fieldMap.get(fld).getDescribe().getPickListValues();
 
  // Add these values to the selectoption list.
  for (Schema.PicklistEntry a: values) {
   allOpts.add(a.getValue());
  }
  //system.debug('allOpts ---->' + allOpts);
  allOpts.sort();
  return allOpts;
 }
    @AuraEnabled
    public static Case UpdateCaseRecord(Case caseObj,Account patientObj, Account senderObj){ 
        //system.debug('7Th Method');
        system.debug('Update Case owner ********** test a1');
        try {
            Case tmpCaseObj = (Case)caseObj;
            //system.debug(tmpCaseObj);
            String ownerId,recordTypeId ;
            if(tmpCaseObj.Escalate_To__c != null && tmpCaseObj.Escalate_To__c != ''){

                if (mapContactCenterEscalationRule.containsKey(tmpCaseObj.Escalate_To__c)){
                    String recordTypeDevName = mapContactCenterEscalationRule.get(tmpCaseObj.Escalate_To__c).Record_Type_Developer_Name__c;
                    String recordTypeName = mapContactCenterEscalationRule.get(tmpCaseObj.Escalate_To__c).Record_Type_Name__c;
                    ownerId = [SELECT id ,Name FROM Group WHERE Name =:recordTypeDevName].Id;
                    if (recordTypeName != null && recordTypeName != ''){
                        recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
                        system.debug('Update Case owner ********** test a2 : '+recordTypeId);
                    }else {
                        recordTypeId = tmpCaseObj.recordTypeId;
                        system.debug('Update Case owner ********** test a3 : '+recordTypeId);
                    }
                }else {
                    ownerId = tmpCaseObj.OwnerId;
                    recordTypeId = tmpCaseObj.RecordTypeId;
                }
                tmpCaseObj.OwnerId = ownerId;
                tmpCaseObj.RecordTypeId = recordTypeId;
            }
            
            //system.debug('tmpCaseObj.RecordTypeId : '+tmpCaseObj.RecordTypeId);
            upsert tmpCaseObj;
            // upsert campaignObj;
            // List<Account> tmpAccList = new List<Account>{patientObj,senderObj};
            // upsert tmpAccList;
			system.debug(' Update Case owner complete');
            return tmpCaseObj;
        } catch (Exception e) {
            //system.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

     @AuraEnabled
    public static Account getParentIdOnFocusTab(String accountId){
       //system.debug('8Th Method'); 
        try {
            Account tmpAccObj = [SELECT id,Name,Hospital_Number_HN__c,Email__c,PersonEmail,Phone,IsPersonAccount FROM Account WHERE id=:accountId];
            return tmpAccObj;
        } catch (Exception e) {
            return null;
        }
    }
     @AuraEnabled
    public static CaseAndPatientInformationWrapper getCaseAndPatientInformation(Id caseId){
        //system.debug('9Th Method');
        try {
            CaseAndPatientInformationWrapper cpiWrapper = new CaseAndPatientInformationWrapper();
            // Account accOwnTab = [SELECT id,Name,Hospital_Number_HN__c FROM Account WHERE id=:accountId];
            DescribeSObjectResult describeResult = Case.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
            List<Case> caseObj = new List<Case>();

            String query = 'SELECT ' +
                            String.join( fieldNames, ',' ) +
                            ' ,Parent.CaseNumber,CreatedBy.Name,LastModifiedBy.Name,Account.Name,Patient__r.Name,Account.Hospital_Number_HN__c,Patient__r.Hospital_Number_HN__c'+
                            ' FROM ' +
                            describeResult.getName()  +
                            ' Where id = :caseId ';

            caseObj = Database.query( query );

            List<CasePlatformEventMapping__c> listCase = [select Id,Platform_Event_Channel__c,Case_Id__c from CasePlatformEventMapping__c WHERE Case_Id__c =: caseId];
        
            
            if(caseObj.size()>0){
                if(((String)caseObj[0].OwnerId).startsWith('00G') ){
                    Group user = [SELECT ID,Name FROM Group WHERE ID=:caseObj[0].OwnerId LIMIT 1];
                    cpiWrapper.GroupCurrentInfo = user;
                    if(caseObj[0].Staff_Name__c != null){
                        System.debug('if 2.1');
                        User userstaff = [SELECT ID,Name,Profile.Name FROM User WHERE ID=:caseObj[0].Staff_Name__c LIMIT 1];
                		cpiWrapper.StaffCurrentInfo = userstaff;
                    }else{
                       User user1 = [SELECT ID,Name,Profile.Name FROM User WHERE ID=:UserInfo.getUserId() LIMIT 1];
                	   cpiWrapper.StaffCurrentInfo = user1; 
                    }
                    
                }else{
                    User user = [SELECT ID,Name,Profile.Name FROM User WHERE ID=:caseObj[0].OwnerId LIMIT 1];
                    cpiWrapper.UserCurrentInfo = user;
                    if(caseObj[0].Staff_Name__c != null){
                        System.debug('if 3.1');
                        User userstaff = [SELECT ID,Name,Profile.Name FROM User WHERE ID=:caseObj[0].Staff_Name__c LIMIT 1];
                		cpiWrapper.StaffCurrentInfo = userstaff;
                    }else{
                       User user2 = [SELECT ID,Name,Profile.Name FROM User WHERE ID=:UserInfo.getUserId() LIMIT 1];
                	   cpiWrapper.StaffCurrentInfo = user2; 
                    }
                    // if(cpiWrapper.UserCurrentInfo.Profile.Name == 'BIH Airport Transport'){
                    //      caseObj[0].RecordTypeId = BIH_Constants.AIRPORT_TRANSFER_CASE_RECORDTYPE;
                    // }
                }
                System.debug('if 4');
				//System.debug('if 4.1 = '+caseObj[0].OwnerId);
                //User userStaff = [SELECT ID,Name FROM User WHERE ID=:caseObj[0].OwnerId LIMIT 1];
                //System.debug('if 4.2 = '+userStaff);
                
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
                if(caseObj[0].Doctor_2__c != null){
                    System.debug('caseObj[0].Doctor_2__c=' + caseObj[0].Doctor_2__c);
                    Doctor__c doctor = [SELECT Id, Name FROM Doctor__c WHERE   id =: caseObj[0].Doctor_2__c  ];
                    cpiWrapper.DoctorObject2 = doctor;
                }
                if(caseObj[0].Doctor_3__c != null){
                    System.debug('caseObj[0].Doctor_3__c=' + caseObj[0].Doctor_3__c);
                    Doctor__c doctor = [SELECT Id, Name FROM Doctor__c WHERE   id =: caseObj[0].Doctor_3__c  ];
                    cpiWrapper.DoctorObject3 = doctor;
                }
                if(caseObj[0].Pending_Person__c != null){
                    Contact contact = [SELECT Id, Name FROM Contact WHERE   id =: caseObj[0].Pending_Person__c  ];
                    cpiWrapper.PendingPersonObject = contact;
                }

                cpiWrapper.checkInTime = string.valueof(caseObj[0].Check_In_Time__c);
                cpiWrapper.checkOutTime = string.valueof(caseObj[0].Check_Out_Time__c) ;

            }else{
                System.debug('else 1');
                User user = [SELECT ID,Name,Profile.Name FROM User WHERE ID=:UserInfo.getUserId() LIMIT 1];
                cpiWrapper.UserCurrentInfo = user;
                System.debug('else 2');
                cpiWrapper.StaffCurrentInfo = user;
                System.debug('else 3');
                // if(user.Profile.Name.contains(System.Label.Airport_Profile)){
                //     Case tmpcase = new Case();
                //     tmpcase.RecordTypeId = BIH_Constants.AIRPORT_TRANSFER_CASE_RECORDTYPE;
                //     cpiWrapper.CaseObject = tmpcase;

                // }
            }
            
            return cpiWrapper;
        } catch (Exception e) {
            //system.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
      @AuraEnabled
    public static CampaignWrapper getCampaignList(String hnnumber){
        //system.debug('8Th Method');
        //system.debug(' hnnumber : '+hnnumber);
        CampaignWrapper camWrap = new CampaignWrapper(); 
        
        Map<String,List<BIH_PicklistOption>> camPickList = new Map<String,List<BIH_PicklistOption>> ();
        List<Case_Campaign_Master__c> ccmList = [SELECT Id,Name, HN_List__c, Start_Date__c, Campaign_Code__c, Expire_Date__c, 
                                                         Max__c, Campaign_Detail__c, Campaign_Source__c ,Campaign_Type__c
                                                FROM Case_Campaign_Master__c 
                                                WHERE Campaign_Type__c != 'Offered' and Expire_Date__c > today];
         List<Case_Campaign_Patient__c> ccpList = [SELECT Id, Patient__c, Campaign_Master__c , Patient__r.Hospital_Number_HN__c,
                                                    Campaign_Master__r.Name, Campaign_Master__r.HN_List__c, Campaign_Master__r.Start_Date__c, 
                                                    Campaign_Master__r.Campaign_Code__c, Campaign_Master__r.Expire_Date__c, 
                                                    Campaign_Master__r.Max__c, Campaign_Master__r.Campaign_Detail__c, 
                                                    Campaign_Master__r.Campaign_Source__c, Campaign_Master__r.Campaign_Type__c
                                                    FROM Case_Campaign_Patient__c WHERE Patient__r.Hospital_Number_HN__c =:hnnumber and Campaign_Master__r.Expire_Date__c > today  ];
        List<BIH_PicklistOption> plOptList = new List<BIH_PicklistOption>();
        for(Case_Campaign_Master__c ccm :ccmList){
            String label_picklist = ccm.Campaign_Code__c + ' : '+ ccm.Name ;//+ ' ('+ String.valueOf(ccm.Interest__c == null ? 0 : ccm.Interest__c) +'/'+ String.valueOf(ccm.Max__c)+ ')';
            BIH_PicklistOption pl = new BIH_PicklistOption(ccm.Id,label_picklist);
            plOptList.add(pl);
        }
        camPickList.put('PublicPicklist',plOptList);

        List<BIH_PicklistOption> pl2OptList = new List<BIH_PicklistOption>();
         for(Case_Campaign_Patient__c ccp :ccpList){
            String label_picklist = ccp.Campaign_Master__r.Campaign_Code__c + ' : '+ ccp.Campaign_Master__r.Name ;//+ ' ('+ String.valueOf(ccp.Campaign_Master__r.Interest__c == null ? 0 : ccp.Campaign_Master__r.Interest__c) +'/'+ String.valueOf(ccp.Campaign_Master__r.Max__c)+ ')';
            BIH_PicklistOption pl = new BIH_PicklistOption(ccp.Campaign_Master__r.Id,label_picklist);
            pl2OptList.add(pl);
        }
        camPickList.put('OfferPicklist',pl2OptList);
        //system.debug('camPickList : '+camPickList);
        camWrap.campaignPickList = camPickList;
        Map<String,List<BIH_PicklistOption>> tmpMapPickList = getPickListValuesIntoList(new List<String>{'Campaign_Interest_Type__c'});
        camWrap.interestPickList = tmpMapPickList;
        return camWrap;
    }
     @AuraEnabled
    public static CampaignDetailWrapper getCampaignDetail(String campaign_master_id){
        //system.debug('9Th Method');
        CampaignDetailWrapper campDetailWrap = new CampaignDetailWrapper();
        if(campaign_master_id != null){
            Integer countCampagin =  [SELECT Count() FROM Case WHERE Campaign_Master__c =:campaign_master_id AND Campaign_Interest_Type__c = 'Interest'];
            Case_Campaign_Master__c caseCampMas = [SELECT Id,Name, HN_List__c, Start_Date__c, Campaign_Code__c, Expire_Date__c, 
                                                         Max__c, Campaign_Detail__c, Campaign_Source__c ,Campaign_Type__c
                                                    FROM Case_Campaign_Master__c WHERE id=:campaign_master_id ];
           
            campDetailWrap.remainCampaign = countCampagin;
            campDetailWrap.CampaignObj = caseCampMas;
        }
        return campDetailWrap;
    }
    @AuraEnabled
    public static User getCurrentUserLanguage(){
        User u = [SELECT Id,Language_Skill__c,toLabel(LanguageLocaleKey) FROM User WHERE Id=:UserInfo.getUserId()];
        return u;
    }
    @AuraEnabled
    public static Id getCurrentUserRole(){
        Id u = UserInfo.getUserRoleId();
        return u;
    }
    public class WrapperPROwnername{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<WrapperPROwnername> getPROwnernameDetail() {
        
        System.debug('getPROwnernameDetail********************');
        List<WrapperPROwnername> result = new List<WrapperPROwnername>();
        Schema.DescribeFieldResult fieldResult = Case.Pre_Regis_Case_Owner__c.getDescribe();
        system.debug('fieldResult = '+fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple = '+ple);
        for( Schema.PicklistEntry pickListVal : ple){
            system.debug('--------for----------- ');
            WrapperPROwnername r =new  WrapperPROwnername();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            system.debug('value Pre_Regis_Case_Owner__c  : =========='+r.value);
            system.debug('value Pre_Regis_Case_Owner__c r.item  : =========='+r.item);
            //r.selected = pickListVal.getValue()==gen ? true : false;
            //system.debug(r.selected + ' - ' + gen + '  - ' + pickListVal.getValue());
            result.add(r);
            
        }  
        return result;
    }
    //getPRFollowerDetail
    public class WrapperPRFollowername{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<WrapperPRFollowername> getPRFollowerDetail() {
        
        System.debug('getPRFollowerDetail********************');
        List<WrapperPRFollowername> result = new List<WrapperPRFollowername>();
        Schema.DescribeFieldResult fieldResult = Case.Pre_Regis_Case_follower__c.getDescribe();
        system.debug('fieldResult = '+fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple = '+ple);
        for( Schema.PicklistEntry pickListVal : ple){
            system.debug('--------for----------- ');
            WrapperPRFollowername r =new  WrapperPRFollowername();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            system.debug('value Pre_Regis_Case_follower__c  : =========='+r.value);
            system.debug('value Pre_Regis_Case_follower__c r.item  : =========='+r.item);
            //r.selected = pickListVal.getValue()==gen ? true : false;
            //system.debug(r.selected + ' - ' + gen + '  - ' + pickListVal.getValue());
            result.add(r);
            
        }  
        return result;
    }
    //getInprogressReasonDetail
    public class WrapperInprogressReason{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<WrapperInprogressReason> getInprogressReasonDetail() {
        
        System.debug('getInprogressReasonDetail********************');
        List<WrapperInprogressReason> result = new List<WrapperInprogressReason>();
        Schema.DescribeFieldResult fieldResult = Case.In_progress_reason__c.getDescribe();
        system.debug('fieldResult = '+fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple = '+ple);
        for( Schema.PicklistEntry pickListVal : ple){
            system.debug('--------for----------- ');
            WrapperInprogressReason r =new  WrapperInprogressReason();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            system.debug('value In_progress_reason__c  : =========='+r.value);
            system.debug('value In_progress_reason__c r.item  : =========='+r.item);
            //r.selected = pickListVal.getValue()==gen ? true : false;
            //system.debug(r.selected + ' - ' + gen + '  - ' + pickListVal.getValue());
            result.add(r);
            
        }  
        return result;
    }
      public class WrapperIndiRefferStaff{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<WrapperIndiRefferStaff> getIndiRefferDetail() {
        
        System.debug('getWrapperIndiRefferStaff********************');
        List<WrapperIndiRefferStaff> result = new List<WrapperIndiRefferStaff>();
        Schema.DescribeFieldResult fieldResult = Case.Refferral_and_Individual_Staff__c.getDescribe();
        system.debug('fieldResult = '+fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple = '+ple);
        for( Schema.PicklistEntry pickListVal : ple){
            system.debug('--------for----------- ');
            WrapperIndiRefferStaff r =new  WrapperIndiRefferStaff();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            system.debug('value Refferral_and_Individual_Staff__c  : =========='+r.value);
            system.debug('value Refferral_and_Individual_Staff__c r.item  : =========='+r.item);
            //r.selected = pickListVal.getValue()==gen ? true : false;
            //system.debug(r.selected + ' - ' + gen + '  - ' + pickListVal.getValue());
            result.add(r);
            
        }  
        return result;
    }
     public class WrapperReviewBy{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<WrapperReviewBy> getReviewByDetail() {
        
        System.debug('getmcoprogresslist********************');
        List<WrapperReviewBy> result = new List<WrapperReviewBy>();
        Schema.DescribeFieldResult fieldResult = Case.Reviewed_By__c.getDescribe();
        system.debug('fieldResult = '+fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple = '+ple);
        for( Schema.PicklistEntry pickListVal : ple){
            system.debug('--------for----------- ');
            WrapperReviewBy r =new  WrapperReviewBy();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            system.debug('value Reviewed_By__c  : =========='+r.value);
            system.debug('value Reviewed_By__c r.item  : =========='+r.item);
            //r.selected = pickListVal.getValue()==gen ? true : false;
            //system.debug(r.selected + ' - ' + gen + '  - ' + pickListVal.getValue());
            result.add(r);
            
        }  
        return result;
    }
    public class WrapperSpecialty1{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<WrapperSpecialty1> getSpecialtyDetail() {
        
        System.debug('getmcoprogresslist********************');
        List<WrapperSpecialty1> result = new List<WrapperSpecialty1>();
        Schema.DescribeFieldResult fieldResult = Case.SpecialtyMed__c.getDescribe();
        system.debug('fieldResult = '+fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple = '+ple);
        for( Schema.PicklistEntry pickListVal : ple){
            system.debug('--------for----------- ');
            WrapperSpecialty1 r =new  WrapperSpecialty1();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            system.debug('value SpecialtyMed__c  : =========='+r.value);
            system.debug('value SpecialtyMed__c r.item  : =========='+r.item);
            //r.selected = pickListVal.getValue()==gen ? true : false;
            //system.debug(r.selected + ' - ' + gen + '  - ' + pickListVal.getValue());
            result.add(r);
            
        }  
        return result;
    }
    public class WrapperLikelyPro{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<WrapperLikelyPro> getLikelyProDetail() {
        
        System.debug('getLikelyPrognosislist********************');
        List<WrapperLikelyPro> result = new List<WrapperLikelyPro>();
        Schema.DescribeFieldResult fieldResult = Case.Likely_prognosis_treatment_outcome__c.getDescribe();
        system.debug('fieldResult = '+fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple = '+ple);
        for( Schema.PicklistEntry pickListVal : ple){
            system.debug('--------for----------- ');
            WrapperLikelyPro r =new  WrapperLikelyPro();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            system.debug('value Likely_prognosis_treatment_outcome__c  : =========='+r.value);
            system.debug('value Likely_prognosis_treatment_outcome__c r.item  : =========='+r.item);
            //r.selected = pickListVal.getValue()==gen ? true : false;
            //system.debug(r.selected + ' - ' + gen + '  - ' + pickListVal.getValue());
            result.add(r);
            
        }  
        return result;
    }
     public class WrapperWhenConsult{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<WrapperWhenConsult> getWhenConsultDetail() {
        
        System.debug('getWhenConsultlist********************');
        List<WrapperWhenConsult> result = new List<WrapperWhenConsult>();
        Schema.DescribeFieldResult fieldResult = Case.When_Consult__c.getDescribe();
        system.debug('fieldResult = '+fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple = '+ple);
        for( Schema.PicklistEntry pickListVal : ple){
            system.debug('--------for----------- ');
            WrapperWhenConsult r =new  WrapperWhenConsult();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            system.debug('value When_Consult__c  : =========='+r.value);
            system.debug('value When_Consult__c r.item  : =========='+r.item);
            //r.selected = pickListVal.getValue()==gen ? true : false;
            //system.debug(r.selected + ' - ' + gen + '  - ' + pickListVal.getValue());
            result.add(r);
            
        }  
        return result;
    }
    
     
       public class WrapperGenderNewPatient{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<WrapperGenderNewPatient> getGenderNewPatientDetail() {
        
        List<WrapperGenderNewPatient> result = new List<WrapperGenderNewPatient>();
        Schema.DescribeFieldResult fieldResult = Case.Gender_Patient__c.getDescribe();
        system.debug('fieldResult = '+fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple = '+ple);
        for( Schema.PicklistEntry pickListVal : ple){
            system.debug('--------for----------- ');
            WrapperGenderNewPatient r =new  WrapperGenderNewPatient();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            result.add(r);
            
        }  
        return result;
    }
   
    public class WrapperTitleNewPatient{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<WrapperTitleNewPatient> getTitleNewPatientDetail() {
        
        List<WrapperTitleNewPatient> result = new List<WrapperTitleNewPatient>();
        Schema.DescribeFieldResult fieldResult = Case.Title_Patient__c.getDescribe();
        system.debug('fieldResult = '+fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple = '+ple);
        for( Schema.PicklistEntry pickListVal : ple){
            system.debug('--------for----------- ');
            WrapperTitleNewPatient r =new  WrapperTitleNewPatient();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            result.add(r);
            
        }  
        return result;
    }
/*
   public class WrapperTitleExtPatient{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<WrapperTitleExtPatient> getTitleExtPatientDetail() {
        
        List<WrapperTitleExtPatient> result = new List<WrapperTitleExtPatient>();
        Schema.DescribeFieldResult fieldResult = Case.Title_Existing_Patient__c.getDescribe();
        system.debug('fieldResult = '+fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple = '+ple);
        for( Schema.PicklistEntry pickListVal : ple){
            system.debug('--------for----------- ');
            WrapperTitleExtPatient r =new  WrapperTitleExtPatient();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            result.add(r);
            
        }  
        return result;
    }
    public class WrapperGenderExtPatient{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<WrapperGenderExtPatient> getGenderExtPatientDetail() {
        
        List<WrapperGenderExtPatient> result = new List<WrapperGenderExtPatient>();
        Schema.DescribeFieldResult fieldResult = Case.Gender_Existing_Patient__c.getDescribe();
        system.debug('fieldResult = '+fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple = '+ple);
        for( Schema.PicklistEntry pickListVal : ple){
            system.debug('--------for----------- ');
            WrapperGenderExtPatient r =new  WrapperGenderExtPatient();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            result.add(r);
            
        }  
        return result;
    }

    @AuraEnabled
    public static Case getAccountDetailList(string caseId) {
        System.debug('****************** test 1 case id : '+caseId);
        System.debug('******************');
        System.debug('getAccountDetailList********************');
        try {
            Case tmpCaseObj = [SELECT id,CaseNumber,Account_First_Name__c,First_Name_New_Patient__c,First_Name_Existing_Patient__c,Account_Last_Name__c,Last_Name_New_Patient__c,Last_Name_Existing_Patient__c,Account_Country__c,Country_of_Ressidence_New_Patient__c,Country_of_Residence_Exisiting_Patient__c,Account_Gender__c,Gender_New_Patient__c,Gender_Existing_Patient__c,Account_DOB__c,Date_Of_Birth_New_Patient__c,Date_Of_Birth_Existing_Patient__c,Account_Nationality__c,Nationality_New_Patient__c,Nationality_Existing_Patient__c,Account_Email__c,Email_New_Patient__c,Email_Existing_Patient__c,Account_Primary_Phone__c,Primary_Phone_New_Patient__c,Primary_Phone_Existing_Patient__c FROM Case Where id = :caseId];
            System.debug('******************'+tmpCaseObj.Account_First_Name__c);
            System.debug('******************'+tmpCaseObj.Account_Gender__c);
            return tmpCaseObj;
        } catch (Exception e) {
            return null;
        }
       
    }
    public class NationalityWrapper{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<NationalityWrapper> getNationalityDetail() {
       
        List<NationalityWrapper> result = new List<NationalityWrapper>();
        Schema.DescribeFieldResult fieldResult = Case.Nationality__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            NationalityWrapper r =new  NationalityWrapper();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            result.add(r);
            
        }  
        return result;
    }
    */
   public class PreferLangWrapper{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String item {get;set;}
    }
    @AuraEnabled
    public static List<PreferLangWrapper> getPreferLangDetail() {
       
        List<PreferLangWrapper> result = new List<PreferLangWrapper>();
        Schema.DescribeFieldResult fieldResult = Case.Preferred_Language__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            PreferLangWrapper r =new  PreferLangWrapper();
            r.value = pickListVal.getValue();
            r.item =pickListVal.getLabel();
            result.add(r);
            
        }  
        return result;
    }
    @AuraEnabled
    public static Case getAccountDetailList(string caseId) {
        System.debug('****************** test 1 case id : '+caseId);
        System.debug('******************');
        System.debug('getAccountDetailList********************');
        try {
            Case tmpCaseObj = [SELECT id,CaseNumber,Account_First_Name__c,First_Name_Patient__c,First_Name_Existing_Patient__c,Account_Last_Name__c,Last_Name_Patient__c,Last_Name_Existing_Patient__c,Account_Country__c,Country_of_Ressidence_Patient__c,Country_of_Residence_Exisiting_Patient__c,Account_Gender__c,Gender_Patient__c,Gender_Existing_Patient__c,Account_DOB__c,Date_Of_Birth_Patient__c,Date_Of_Birth_Existing_Patient__c,Account_Nationality__c,Nationality_New_Patient__c,Nationality_Existing_Patient__c,Account_Email__c,Email_New_Patient__c,Email_Existing_Patient__c,Account_Primary_Phone__c,Primary_Phone_New_Patient__c,Primary_Phone_Existing_Patient__c FROM Case Where id = :caseId];
            System.debug('******************'+tmpCaseObj.Account_First_Name__c);
            System.debug('******************'+tmpCaseObj.Account_Gender__c);
            return tmpCaseObj;
        } catch (Exception e) {
            return null;
        }
       
    }
    
}