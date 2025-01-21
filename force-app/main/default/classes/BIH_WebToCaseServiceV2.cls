@RestResource(urlMapping='/BIH_WebToCaseServiceV2')
global without sharing class BIH_WebToCaseServiceV2  {
    
    global class BaseResponse {
        global  boolean success {get; set;}
        global  string message {get; set;}
        global  Id caseId {get; set;}
        global  integer code {get; set;}
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
            String subj = mapJson.get('subject').toString();
            List<Microsite_Field_Mapping__c> mapField = [SELECT Subject__c,SF_Field_Name__c,JSON_Key__c 
                                                        FROM Microsite_Field_Mapping__c 
                                                        WHERE Subject__c=:subj and Website_Type__c = 'Main Website' ORDER BY Order_Number__c];
            
           	String case_detail = '<table>'; 
            String web2case_log = '';
            caseTmp.Web_Subject__c = subj+' Main Website';


            System.debug('mapJson : '+mapJson);

            //subject concat date 
                        
            string email = mapJson.get('email').toString();
            caseTmp.Web_to_Case_Log__c = req.requestBody.toString();
            caseTmp.Subject = mapJson.get('subject').toString() +' (Sender : '+email+')';
            caseTmp.Channel__c = mapJson.get('channel').toString();
            caseTmp.Case_Category_Level1__c = mapJson.get('case_category_lvl_1').toString();
            caseTmp.Case_Category_Level2__c = (mapJson.get('case_category_lvl_2')!=null)?mapJson.get('case_category_lvl_2').toString():'';
            caseTmp.Case_Category_Level3__c = (mapJson.get('case_category_lvl_3')!=null)?mapJson.get('case_category_lvl_3').toString():'';
            
            caseTmp.Telemed__c = (mapJson.get('telemed_c')==true)?true:false;
            caseTmp.CC_Email__c = (mapJson.get('cc_email')!=null)?mapJson.get('cc_email').toString():'';
            
            //caseTmp.BCC_Email__c = mapJson.get('bcc_email').toString();
            //caseTmp.Sender_First_Name__c = mapJson.get('first_name').toString();
            //caseTmp.Sender_Last_Name__c = mapJson.get('last_name').toString();
            //caseTmp.Telemed__c = (mapJson.get('telemed_c')!=null)?mapJson.get('telemed_c').toString():'';
            
            caseTmp.Status= mapJson.get('status').toString();
            caseTmp.Origin= mapJson.get('origin').toString();
            caseTmp.Priority= 'High'; //fig value to High
            caseTmp.Web_Ref_Id__c= mapJson.get('web_refid').toString();
            caseTmp.Web_Relation_To__c = (mapJson.get('hint_relation_to')!=null)?mapJson.get('hint_relation_to').toString():'';
            caseTmp.Web_Additional_Info__c= (mapJson.get('additional_infos')!=null)?mapJson.get('additional_infos').toString():'';
            
             //put custom fields following subject
            if(mapField.size() > 0){
                for(Microsite_Field_Mapping__c mf : mapField){
                    //check data type for converting
                    Schema.SObjectField field = M.get(mf.SF_Field_Name__c);

                    if(M.get(mf.SF_Field_Name__c)!=null){

                    Schema.DisplayType FldType = field.getDescribe().getType();
                    System.debug('FieldType of '+mf.SF_Field_Name__c+' : '+FldType);
                    
					string fieldLabel = field.getDescribe().getLabel();
                    case_detail += '<tr><td>';
                    web2case_log +=(fieldLabel!=null)?fieldLabel:mf.SF_Field_Name__c;
                    case_detail += (fieldLabel!=null)?fieldLabel:mf.SF_Field_Name__c;
                    if(mapJson.get(mf.JSON_Key__c)!=null && mapJson.get(mf.JSON_Key__c) != ''){
                        System.debug('mf.JSON_Key__c :' + mf.JSON_Key__c + ' values: '+mapJson.get(mf.JSON_Key__c));
                    
                    //convert data and put the data to case
                    if(FldType == Schema.DisplayType.Date){
                        try{
                        caseTmp.put(mf.SF_Field_Name__c , Date.valueOf(mapJson.get(mf.JSON_Key__c).toString()));
                        DateTime dt =  Date.valueOf(mapJson.get(mf.JSON_Key__c).toString());
                        String strDatetime  = dt.format('dd MMMM yyyy');
                        web2case_log += strDatetime + '|' + '\n';
                        case_detail += ' : </td><td>'+ strDatetime + '</td></tr>';
                        }catch (Exception e){
                        case_detail += ' : </td><td>'+ mapJson.get(mf.JSON_Key__c).toString() + '</td></tr>';
                        web2case_log += mapJson.get(mf.JSON_Key__c).toString() + '|' + '\n';
                        }
                    }else if(FldType == Schema.DisplayType.DateTime){
                        caseTmp.put(mf.SF_Field_Name__c , Datetime.valueOf(mapJson.get(mf.JSON_Key__c).toString()));
                        case_detail += ' : </td><td>'+ Datetime.valueOf(mapJson.get(mf.JSON_Key__c).toString()) + '</td></tr>';
                        web2case_log += mapJson.get(mf.JSON_Key__c).toString() + '|' + '\n';
                    
                    }else if(FldType == Schema.DisplayType.Double){
                        caseTmp.put(mf.SF_Field_Name__c , Decimal.valueOf(mapJson.get(mf.JSON_Key__c).toString()));
                        case_detail += ' : </td><td>'+ Decimal.valueOf(mapJson.get(mf.JSON_Key__c).toString()) + '</td></tr>';
                        web2case_log += mapJson.get(mf.JSON_Key__c).toString() + '|' + '\n';

                    }else if(FldType == Schema.DisplayType.Integer){
                        caseTmp.put(mf.SF_Field_Name__c , Integer.valueOf(mapJson.get(mf.JSON_Key__c).toString()));
                        case_detail += ' : </td><td>'+ Integer.valueOf(mapJson.get(mf.JSON_Key__c).toString()) + '</td></tr>';
                        web2case_log += mapJson.get(mf.JSON_Key__c).toString() + '|' + '\n';

                    }else if(FldType == Schema.DisplayType.TIME){
                        try{
                            String strTimeChange = mapJson.get(mf.JSON_Key__c).toString();
                            String[] strTimeSplit = strTimeChange.split(':');
                            Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                                ,Integer.valueOf(strTimeSplit[1]) //min
                                                                ,0                                //sec
                                                                ,0);                              //ms
                            Time timeChange2 = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                                ,Integer.valueOf(strTimeSplit[1]) //min
                                                                ,0                                //sec
                                                                ,0).addHours(-7);
                            caseTmp.put(mf.SF_Field_Name__c , timeChange);
                            String times = DateTime.newInstance(Date.today(), timeChange).format('HH:mm');
                            web2case_log += mapJson.get(mf.JSON_Key__c).toString() + '|' + '\n';
                            case_detail += ' : </td><td>'+ times + '</td></tr>';
                        }catch (Exception e){
                            case_detail += ' : </td><td>'+ mapJson.get(mf.JSON_Key__c).toString() + '</td></tr>';
                            web2case_log += mapJson.get(mf.JSON_Key__c).toString() + '|' + '\n';
                        }
                    }else{
                        if (mapJson.get(mf.JSON_Key__c).toString().equalsIgnoreCase('true')){
                            caseTmp.put(mf.SF_Field_Name__c , 'Yes');
                            case_detail += ' : </td><td>'+ 'Yes' + '</td></tr>';
                            web2case_log += mapJson.get(mf.JSON_Key__c).toString() + '|' + '\n';

                        }else if (mapJson.get(mf.JSON_Key__c).toString().equalsIgnoreCase('false')){
                            case_detail += ' : </td><td>'+ 'No' + '</td></tr>';
                            caseTmp.put(mf.SF_Field_Name__c , 'No');
                            web2case_log += mapJson.get(mf.JSON_Key__c).toString() + '|' + '\n';
                            
                        }else {
                            caseTmp.put(mf.SF_Field_Name__c , mapJson.get(mf.JSON_Key__c).toString());
                            case_detail += ' : </td><td>'+ mapJson.get(mf.JSON_Key__c).toString() + '</td></tr>';
                            web2case_log += mapJson.get(mf.JSON_Key__c).toString() + '|' + '\n';
                        
                        }
                    }
                    }
                    }
                }
            }
            
            case_detail += '</table><br>';
            web2case_log += '|';
            caseTmp.Web_to_Case_Log__c = web2case_log;
            system.debug('caseTmp.Web_to_Case_Log__c'+caseTmp.Web_to_Case_Log__c);

            //concat fullname
            caseTmp.Full_name__c = caseTmp.Sender_First_Name__c+' '+caseTmp.Sender_Last_Name__c;

            //add date to subject
            if(caseTmp.Appointment_Date__c!=null){
                DateTime appDate =  Date.valueOf(caseTmp.Appointment_Date__c);
                caseTmp.Subject += ' (Appointment Date : '+ appDate.format('dd MMM yyyy')+')';
            }else if(caseTmp.Appointment_Time_Period__c!= null &&
                    caseTmp.Appointment_Time_Period__c.containsignorecase('Any Times')){
                caseTmp.Subject += ' (Appointment Date : Earliest date available)';
            }
            // else{
            //     DateTime today = Date.today();
            //     caseTmp.Subject += ' ('+today.format('dd MMM yyyy hh:mm:ss a')+')';
            // }

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

        } catch (Exception ex) {
            BaseResponse resp = new BaseResponse();
            resp.success =   false;
            resp.code    =   400;
            resp.message = 'transaction was fail. Error : '+ex;
            system.debug('resp'+resp);
            return resp;
        }
        BaseResponse resp = new BaseResponse();
        resp.caseId = caseTmp.id;
        resp.success =  true;
        resp.message = 'transaction was completed';
        resp.code    =  200;
        return resp;
    
    }


}