@RestResource(urlMapping='/BIH_WebToCaseAddFile')
global without sharing class BIH_WebToCaseAddFile {
    
    global class BaseResponse {
        global  boolean success {get; set;}
        global  integer code {get; set;}
        global  string message {get; set;}
    }

    @HttpPost
    global static BaseResponse addFiles(){
        
        Case cRelated = new Case();
        try {
            RestRequest req = RestContext.request;
            Map<String, Object> mapJson =(Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());
            
            String caseId = mapJson.get('caseId').toString();
            cRelated = [select id,Web_Relation_To__c,Web_Ref_Id__c,Case_Detail__c,Ownerid from case where id =:caseId limit 1];
            
            if(caseId != null && cRelated!=null){
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
                        cDe.LinkedEntityId = cRelated.id; // you can use objectId,GroupId etc
                        cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                        cDe.Visibility = 'AllUsers';
                        insert cDe;
        
                        }
    
                    }
                }
            }		
            }
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
        resp.message = 'files was create completed, relate to caseId :'+cRelated.id;
        return resp;
    }

}