global class BIH_ApptUtility {


    @AuraEnabled
    public static Appointment__c getSMSCase(String recordId){
        try {
            // case c = new case();
            String CaseId = Null;
            //DescribeSObjectResult describeResult = Case.getSObjectType().getDescribe();
            DescribeSObjectResult describeResult = Appointment__c.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
            //List<Case> caseObj = new List<Case>();
            List<Appointment__c> apptObj = new List<Appointment__c>();

            //Appointment__c obj_appoint = [Select id,Case__c from Appointment__c where id = :recordId ];
            //CaseId = obj_appoint.Case__c;
            String query = 'SELECT ' +
                            String.join( fieldNames, ',' ) +
                            ' FROM ' +
                            describeResult.getName()  +
                            ' Where id = :recordId ';
            
            //Appointment__c apptObj = [select id,account__r.name,account__r.phone,Account_Phone__c, Appointment_Date__c, Appointment_Time__c,App_Time_Format__c,App_Date_Format__c from appointment__c where id = :recordId];
			apptObj =  Database.query(query);
            //apptObj = Database.query(query);
            
        if (apptObj[0].Appointment_Date__c != null){
            DateTime dt =  Date.valueOf(apptObj[0].Appointment_Date__c);
            String strDatetime  = dt.format('dd-MM-yyyy');
            apptObj[0].App_Date_Format__c = strDatetime;
        }if (apptObj[0].Appointment_Time__c != null){
            String strTimeChange = String.valueOf(apptObj[0].Appointment_Time__c);
                            String[] strTimeSplit = strTimeChange.split(':');
                            Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                                ,Integer.valueOf(strTimeSplit[1]) //min
                                                                ,0                                //sec
                                                                ,0);
            String times = DateTime.newInstance(Date.today(), timeChange).format('HH:mm');
            apptObj[0].App_Time_Format__c = times;
        }
            return apptObj[0];
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
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
    
    @AuraEnabled
    public static Map<String,Service_Type_Matrix__c> getSVTM(){
        return mapSVTM;
    }
    
    @AuraEnabled
    public static List<String> getSMSTemplateKey(){
        List<SMS_Template__c> key = [SELECT SMS_Template_Subject__c FROM SMS_Template__c WHERE SMS_TYPE__C = 'Appointment'];
        List<String> keys = new List<String>();
        for (SMS_Template__c a : key){
            keys.add(a.SMS_Template_Subject__c);
        }
        return keys;
    }
        
    @AuraEnabled
    public static Map<String,SMS_Template__c> getSMSTemplate(){
        
        List<SMS_Template__c> sms = [SELECT Id,SMS_Template_Subject__c,Field_Mapping_TH__c,Field_Mapping_EN__c, SMS_TH__c, SMS_EN__c FROM SMS_Template__c WHERE SMS_TYPE__C = 'Appointment'];
        Map<String,SMS_Template__c> a = new Map<String,SMS_Template__c>();
        for (SMS_Template__c s : sms) {
            a.put(s.SMS_Template_Subject__c,s);
        }
        return a;
    }
    
    @AuraEnabled
    public static String sendSMSMessage(String message,Appointment__c apptObj,String contactNumber){
        try {
            String res = BIH_SendSMSService.getAppointmentObjInformation(message,apptObj,contactNumber);
            return res;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
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
    public static List<Case> getCaseInfo(Id appId){
        Appointment__c obj_appoint = [Select id,Case__c from Appointment__c where id = :appId ];
        String CaseId = obj_appoint.Case__c;
        List<Case> caseList = [Select id,IsClosed,CaseNumber,Owner_Change_Reason__c,Subject,RecordTypeId,RecordType.Name,
                               Status,OwnerId,Owner.Name,Owner.Type,Lead_Source__c,
                               AccountId,Account.FirstName,Account.Lastname,Account.Name,
                               Hospital_Number_HN__c,SuppliedEmail,Full_Name__c,
                               Phone__c,Patient_Email__c,Patient__c,
                               Patient__r.FirstName,Patient__r.Lastname,Patient__r.Name,
                               Procedure_1__c,Procedure_2__c,Procedure_3__c ,Channel__c,Origin
                               from case where id =:CaseId];

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

}