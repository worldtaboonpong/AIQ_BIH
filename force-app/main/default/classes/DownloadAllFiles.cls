public without sharing class DownloadAllFiles {

    public DownloadAllFiles() {

    }

    @AuraEnabled
    public static String generateDownloadAllFiles(String caseId) {
        
//    //https://salesforceInstanceURL/sfc/servlet.shepherd/document/download/contentdocumentIds

        System.debug('test generateDownloadAllFiles ,  caseId : '+caseId);
        String url = '';
        String urlInstance = String.valueOf(System.URL.getSalesforceBaseUrl().gethost());
        String ids =  '';
        
        System.debug('caseId : '+caseId);
        List<ContentDocumentLink> cdlList = [Select ContentdocumentId from ContentDocumentLink where LinkedEntityId =:caseId];
        System.debug('size : '+cdlList.size());
        if(cdlList != null && cdlList.size() > 0){
            for (ContentDocumentLink cdl :cdlList){
                 System.debug('cdl   : '+cdl);
                if(ids != ''){
                    ids = ids+'/'+cdl.ContentdocumentId;
                }else{
                    ids = cdl.ContentDocumentId;
                }
            }
        }
        
        List<ContentDocumentLink> cdlList2 = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId in (SELECT id FROM EmailMessage WHERE ParentId =: caseId)];
        if(cdlList2 != null && cdlList2.size() > 0){
            for (ContentDocumentLink cdl :cdlList2){
                if(ids != ''){
                    ids = ids+'/'+cdl.ContentdocumentId;
                }else{
                    ids = cdl.ContentDocumentId;
                }
            }
        }

        Boolean flag = false;
        set<id> TaskIDs = new set<id>();
        List<Task> taskList = [select id from Task where WhatId =: caseId];
        if(taskList != null && taskList.size() > 0){
            for(Task t : taskList){
                TaskIDs.add(t.id);
                flag = true;
            }
        }

        /*set<id> TaskIDs = new set<id>();
        for(Task t:[select id from Task where WhatId =: caseId ]){
            TaskIDs.add(t.id);
            }*/

        if(flag == true){
            //ContentDocumentLink[] cdlarray3 = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE ParentId in :TaskIDs];
            List<ContentDocumentLink> cdlList3 = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId in :TaskIDs];
            if(cdlList3 != null && cdlList3.size() > 0){
                for (ContentDocumentLink cdl :cdlList3){
                    if(ids != ''){
                        ids = ids+'/'+cdl.ContentdocumentId;
                    }else{
                        ids = cdl.ContentDocumentId;
                    }
                }
            }
        }

        List<ContentDocumentLink> cdlList4 = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId in (SELECT id  FROM Work_Duration__c WHERE Case__c =: caseId)];
        if(cdlList4 != null && cdlList4.size() > 0){
            for (ContentDocumentLink cdl :cdlList4){
                if(ids != ''){
                    ids = ids+'/'+cdl.ContentdocumentId;
                }else{
                    ids = cdl.ContentDocumentId;
                }
            }
        }

        if(ids != null && ids != ''){
            return 'https://'+urlInstance+'/sfc/servlet.shepherd/document/download/'+ids+'?';
        }else{
            return 'No Documents Found';
        }
    }
}