public class OnlineServiceLog {
    
    public static void generateContentVersionRequest(Online_Service_Log__c targetLog,String reqBody){
        String datetimeStr = DateTime.now().format('yyyy-MM-dd_hh-mm-ss');
        // String yourFiles = reqBody;
        System.debug('reqBody: '+ reqBody);
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = 'Request_'+ datetimeStr +'.txt'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = 'Request_'+ datetimeStr; // Display name of the files
        conVer.VersionData = Blob.valueOf(reqBody); // converting your binary string to Blob
        insert conVer;
        generateLinkContentVersion(conVer,targetLog);
    }
    public static void generateContentVersionResponse(Online_Service_Log__c targetLog,String resBody){
        String datetimeStr = DateTime.now().format('yyyy-MM-dd_hh-mm-ss');
        System.debug('resBody: '+resBody);
        // String yourFiles = resBody;
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = 'Response_'+ datetimeStr +'.txt'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = 'Response_'+ datetimeStr; // Display name of the files
        conVer.VersionData = Blob.valueOf(resBody); // converting your binary string to Blob
        insert conVer;
        generateLinkContentVersion(conVer,targetLog);
    }
    public static void generateLinkContentVersion(ContentVersion conver,Online_Service_Log__c targetLog){
        // First get the content document Id from ContentVersion
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;

        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = targetLog.Id; // you can use objectId,GroupId etc
        cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        cDe.Visibility = 'AllUsers';
        insert cDe;
    }
    // @Future
    // public static void generateFile(String logId,String reqBody){
    //     String datetimeStr = DateTime.now().format('yyyy-MM-dd_hh-mm-ss');
    //     // String yourFiles = reqBody;
    //     System.debug('reqBody: '+ reqBody);
    //     ContentVersion conVer = new ContentVersion();
    //     conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
    //     conVer.PathOnClient = 'Request_'+ datetimeStr +'.txt'; // The files name, extension is very important here which will help the file in preview.
    //     conVer.Title = 'Request_'+ datetimeStr; // Display name of the files
    //     conVer.VersionData = Blob.valueOf(reqBody); // converting your binary string to Blob
    //     insert conVer;
    //     generateLink(conVer.Id,logId);
    // }
    // @Future
    // public static void generateLink(String conVerId,String logId){
    //     // First get the content document Id from ContentVersion
    //     Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVerId].ContentDocumentId;

    //     //Create ContentDocumentLink
    //     ContentDocumentLink cDe = new ContentDocumentLink();
    //     cDe.ContentDocumentId = conDoc;
    //     cDe.LinkedEntityId = logId; // you can use objectId,GroupId etc
    //     cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
    //     cDe.Visibility = 'AllUsers';
    //     insert cDe;
    // }
//     public static ContentVersion generateContentVersionFile(Boolean doInsert) {
//     return generateNewFileResponse(null, doInsert);
// }
//     // @AuraEnabled
//     // public static ContentVersion generateNewFileRequest(Id contentDocId, Boolean doInsert,String Name) {
//     //     ContentVersion cont = new ContentVersion();
//     //     Online_Service_Log__c obj = [SELECT Endpoint__c FROM Online_Service_Log__c WHERE User__c = :Name];
//     //     if (contentDocId != null) {
//     //         cont.ContentDocumentId = contentDocId;
//     //     }

//     //     cont.Title = 'Title for this contentVersion';
//     //     cont.PathOnClient = 'Request_' + Datetime.now().getTime() + '.txt';
//     //     cont.VersionData = Blob.valueOf('Request_' + Datetime.now().getTime() + '.txt');
//     //     cont.Origin = 'H';

//     //     if (doInsert) {
//     //         insert cont;
//     //     }

//     //     return cont;
//     // }
//     public static ContentVersion generateNewFileResponse(Id contentDocId, Boolean doInsert) {
//         String yourFiles = 'Test Log file 123';
//         ContentVersion conVer = new ContentVersion();
//         conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
//         conVer.PathOnClient = 'Test.txt'; // The files name, extension is very important here which will help the file in preview.
//         // conVer.Title = 'Proposal '; // Display name of the files
//         conVer.VersionData = EncodingUtil.base64Decode(yourFiles); // converting your binary string to Blob
//         // generateFileLink(yourFiles);
//         insert conVer;
//         return conVer;
//     }
//     @AuraEnabled
//     public static void generateFileLink(ContentVersion a){
//         // First get the content document Id from ContentVersion
//         Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:a.Id].ContentDocumentId;

//         //Create ContentDocumentLink
//         ContentDocumentLink cDe = new ContentDocumentLink();
//         cDe.ContentDocumentId = conDoc;
//         cDe.LinkedEntityId = '500N000000DW0NKIA1'; // you can use objectId,GroupId etc
//         cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
//         cDe.Visibility = 'InternalUsers';
//         insert cDe;
//     }

}