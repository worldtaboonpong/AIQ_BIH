@RestResource(urlMapping='/BIH_WebToCaseService')
global without sharing class BIH_WebToCaseService  {
    
    global class BaseResponse {
        global  boolean success {get; set;}
        global  integer code {get; set;}
        global  string message {get; set;}
    }
   
    @HttpPost
    global static BaseResponse create() {
         //Declare Variable
        Case caseTmp = new Case();
        Map<String, Schema.SObjectField> M = Schema.SObjectType.Case.fields.getMap();
                           
        try {

             //get data to Map collection
            RestRequest req = RestContext.request;
            Map<String, Object> mapJson =(Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());
            String sub = mapJson.get('subject').toString();
            List<Microsite_Field_Mapping__c> mapField = [SELECT Subject__c,SF_Field_Name__c,JSON_Key__c 
                                                         FROM Microsite_Field_Mapping__c 
                                                         WHERE Subject__c=:sub
                                                        and Website_Type__c  !='Main Website'];
            system.debug('mapField'+mapField);
            System.debug('========= System.debug(mapJson) =========');
            System.debug('mapJson : '+mapJson);
            /*note n = new note();
            n.parentId= '500N000000DXCYeIAP'; 
            n.body= String.valueOf(mapJson);
            n.title= '500N000000DXCYeIAP'+'_JSON'; 
            n.isPrivate=false;
            insert n; //insert the record*/
           	String case_detail = '<table>'; 
            caseTmp.Web_Subject__c = sub;
            //Add request to desc
            //caseTmp.description = req.requestBody.toString();
            
            //put standard fields
            string datetimeComing = Datetime.now().format('dd MMM yyyy hh:mm:ss a');
            string roSource = mapJson.get('ro_source').toString();
            string fullname = '';
            string hnnumber = '';
            try {
                fullname = mapJson.get('full_name').toString();
            } catch (Exception e) {
                fullname = '-';
            }
            if (fullname == '' || fullname == null){
                fullname = '-';
            }

            
            try {
                hnnumber = mapJson.get('hospital_number').toString();
            } catch (Exception e) {
                hnnumber = '-';
            }
            if (hnnumber == '' || hnnumber == null){
                hnnumber = '-';
            }
            
            if(sub!=null && sub.equalsIgnoreCase(System.label.Consult_Online)){
                sub = System.label.Enquiry_Patient ;
            } 
            
            caseTmp.Subject = sub + ' '+fullname+', HN:'+hnnumber;
            // caseTmp.Subject = mapJson.get('subject').toString() + ', '+roSource+ ' (' +datetimeComing+')' ;
            caseTmp.Channel__c = mapJson.get('channel').toString();
            caseTmp.Case_Category_Level1__c = mapJson.get('case_category_lvl_1').toString();
            caseTmp.Case_Category_Level2__c = (mapJson.get('case_category_lvl_2')!=null)?mapJson.get('case_category_lvl_2').toString():'';
            caseTmp.Case_Category_Level3__c = (mapJson.get('case_category_lvl_3')!=null)?mapJson.get('case_category_lvl_3').toString():'';
            caseTmp.Status= mapJson.get('status').toString();
            caseTmp.Origin= mapJson.get('origin').toString();
            caseTmp.Priority= mapJson.get('priority').toString();
            caseTmp.Web_Ref_Id__c= mapJson.get('web_refId').toString();
            caseTmp.RO_Source__c= roSource;
            caseTmp.Web_Relation_To__c = (mapJson.get('hint_relation_to')!=null)?mapJson.get('hint_relation_to').toString():'';
            caseTmp.Web_Additional_Info__c= (mapJson.get('additional_infos')!=null)?mapJson.get('additional_infos').toString():'';
            // caseTmp.Patient_Email__c = mapJson.get('email').toString();
            try {
                caseTmp.Lead_Source__c = mapJson.get('lead_source').toString();
            } catch (Exception e) {
                system.debug(e);
            }

            // caseTmp.Web_Arrival_Time__c = (mapJson.get('arrival_time')!=null)?mapJson.get('additional_infos').toString():'';
            
            if (mapJson.get('arrival_time')!=null){
                String strTimeChange = mapJson.get('arrival_time').toString();
                String[] strTimeSplit = strTimeChange.split(':');
                Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                    ,Integer.valueOf(strTimeSplit[1]) //min
                                                    ,0                                //sec
                                                    ,0);
                caseTmp.Web_Arrival_Time__c = timeChange;
            }
            
            system.debug('caseTmp.RO_Source__c'+caseTmp.RO_Source__c);
            //mapping RO Email
            if(caseTmp.RO_Source__c != null){
                Map<String,String> mappingRoSourceWithEmail = new Map<String,String>();
                    for(Mapping_Referral_Office_Email__c roEmail : [Select Name, RO_Source__c,Email__c from Mapping_Referral_Office_Email__c]){
                        mappingRoSourceWithEmail.put(roEmail.RO_Source__c,roEmail.Email__c);
                    }
               
                string emailRO = (string) mappingRoSourceWithEmail.get(caseTmp.RO_Source__c);
                    if(emailRO!=null){
                        caseTmp.suppliedEmail = emailRO;
                    }
            }else{
               caseTmp.suppliedEmail = 'support@ii.co.th';
            }

            
             //put custom fields following subject
            if(mapField.size() > 0){
                for(Microsite_Field_Mapping__c mf : mapField){
                    //check data type for converting
                    Schema.SObjectField field = M.get(mf.SF_Field_Name__c);
                    Schema.DisplayType FldType = field.getDescribe().getType();
                    System.debug('FieldType of '+mf.SF_Field_Name__c+' : '+FldType);
					string fieldLabel = field.getDescribe().getLabel();
                    case_detail += '<tr><td>';
					case_detail += (fieldLabel!=null)?fieldLabel:mf.SF_Field_Name__c;
                    
                    if(mapJson.get(mf.JSON_Key__c)!=null){
                        
                        if (FldType == Schema.DisplayType.Date){
                            DateTime dt =  Date.valueOf(mapJson.get(mf.JSON_Key__c).toString());
                            String strDatetime  = dt.format('dd MMMM yyyy');
                            case_detail += ' : </td><td>'+ strDatetime + '</td></tr>';
                        }else if (FldType == Schema.DisplayType.TIME){
                            String strTimeChange = mapJson.get(mf.JSON_Key__c).toString();
                            String[] strTimeSplit = strTimeChange.split(':');
                            Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                                ,Integer.valueOf(strTimeSplit[1]) //min
                                                                ,0                                //sec
                                                                ,0);
                            
                            String times = DateTime.newInstance(Date.today(), timeChange).format('HH:mm');
                            case_detail += ' : </td><td>'+ times + '</td></tr>';
                        }
                        else if (mapJson.get('have_insurance') != null && mf.JSON_Key__c =='have_insurance'){
                            string insurance = mapJson.get('have_insurance').toString();
                            if (insurance.equalsIgnoreCase('true')){
                                case_detail += ' : </td><td>'+ 'Yes'  + '</td></tr>';
                            }else {
                                case_detail += ' : </td><td>'+ 'No'  + '</td></tr>';
                            }
                        }
                        else {
                            case_detail += ' : </td><td>'+mapJson.get(mf.JSON_Key__c).toString() + '</td></tr>';
                        }
                        
                        //convert data and put the data to case
                        if(FldType == Schema.DisplayType.Date){
                            caseTmp.put(mf.SF_Field_Name__c , Date.valueOf(mapJson.get(mf.JSON_Key__c).toString()));
                        }else if(FldType == Schema.DisplayType.DateTime){
                            caseTmp.put(mf.SF_Field_Name__c , Datetime.valueOf(mapJson.get(mf.JSON_Key__c).toString()));
                        }else if(FldType == Schema.DisplayType.Double){
                            caseTmp.put(mf.SF_Field_Name__c , Decimal.valueOf(mapJson.get(mf.JSON_Key__c).toString()));
                        }else if(FldType == Schema.DisplayType.Integer){
                            caseTmp.put(mf.SF_Field_Name__c , Integer.valueOf(mapJson.get(mf.JSON_Key__c).toString()));
                        }else if(FldType == Schema.DisplayType.TIME){
                            System.debug('------ TIME ------');
                           System.debug(': mf.JSON_Key__c : '+mf.JSON_Key__c);
                                String strTimeChange = mapJson.get(mf.JSON_Key__c).toString();
                                 String[] strTimeSplit = strTimeChange.split(':');
                                Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                                    ,Integer.valueOf(strTimeSplit[1]) //min
                                                                    ,0                                //sec
                                                                    ,0).addHours(-7);    
                                System.debug(mf.SF_Field_Name__c+': '+timeChange);                          //ms
                                caseTmp.put(mf.SF_Field_Name__c , timeChange);
                        }else if ((mapJson.get(mf.JSON_Key__c).toString() != null && mf.JSON_Key__c == 'have_insurance')){
                            string insurance = mapJson.get('have_insurance').toString();
                            if (insurance.equalsIgnoreCase('true')){
                                caseTmp.put(mf.SF_Field_Name__c , 'Yes');
                            }else {
                                caseTmp.put(mf.SF_Field_Name__c , 'No');
                            }
                        }
                        else{
                                caseTmp.put(mf.SF_Field_Name__c , mapJson.get(mf.JSON_Key__c).toString());
                            
                        }
                        
                    }
                    
                    
 
                }
            }
            
            case_detail += '</table><br>';

            try{
                Case cRelated = [select id,Web_Relation_To__c,Web_Ref_Id__c,Case_Detail__c,Ownerid from case where Web_Ref_Id__c =:caseTmp.Web_Relation_To__c limit 1];
                if(caseTmp.Web_Relation_To__c!=null && caseTmp.Web_Relation_To__c!=''){
                    caseTmp.ParentId = cRelated.id;
                    cRelated.Case_Detail__c += case_detail;

                }
                if(cRelated != null){
                    update cRelated;
                }
            }catch(Exception e){
                system.debug('Web2Case : '+e);
            }

            caseTmp.Case_Detail__c = case_detail;
            
            

            system.debug('caseTmp'+caseTmp);
            insert caseTmp;
			
            if(mapJson.get('file')!=null && mapJson.get('file')!=''){

            
            List<Object> files = (List<Object>) mapJson.get('file');
            System.debug('files : '+files);
            System.debug('files size : '+files.size());
            if(files.size() >0){
                for (Object file_obj : files) {
                    //map object type
                    Map<String,Object> tmpMapObj = ( Map<String,Object>)file_obj;

                    if(tmpMapObj.get('file_name') != ''){
                    Blob tempBlob = EncodingUtil.base64Decode(tmpMapObj.get('file_body').toString());
                    ContentVersion conVer = new ContentVersion();
                    conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
                    conVer.PathOnClient = tmpMapObj.get('file_name').toString(); // The files name, extension is very important here which will help the file in preview.
                    conVer.Title = tmpMapObj.get('file_name').toString(); // Display name of the files
                    conVer.VersionData = tempBlob; // converting your binary string to Blog
                    insert conVer;

                    Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;

                    ContentDocumentLink cDe = new ContentDocumentLink();
                    cDe.ContentDocumentId = conDoc;
                    cDe.LinkedEntityId = caseTmp.id; // you can use objectId,GroupId etc
                    cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                    cDe.Visibility = 'AllUsers';
                    insert cDe;

                    }

                }
            }
        }
            
            System.debug('caseTmp : '+caseTmp);

        } catch (Exception ex) {
            BaseResponse resp = new BaseResponse();
            resp.success =   false;
            resp.code    =   400;
            resp.message = 'transaction was fail. Error : '+ex;
            system.debug('resp'+resp);
            return resp;
        }
        BaseResponse resp = new BaseResponse();
        resp.success =   true;
        resp.code    =   200;
        resp.message = 'transaction was completed : caseId :'+caseTmp.id;
        return resp;
    
    }


}