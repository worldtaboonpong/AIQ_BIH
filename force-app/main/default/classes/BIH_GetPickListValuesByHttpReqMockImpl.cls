@isTest
global with sharing class BIH_GetPickListValuesByHttpReqMockImpl implements HttpCalloutMock { 
     global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String bodyTmp = '{"controllerValues":{"New":0,"In Progress":1,"Pending":2,"Closed":3},"defaultValue":null,"url":"/services/data/v41.0/ui-api/object-info/Case/picklist-values/012N000000136juIAA/Close_Case_Reason__c","values":[{"attributes":null,"label":"By Phone / Fax","validFor":[3],"value":"By Phone / Fax"},{"attributes":null,"label":"Completed with support","validFor":[3],"value":"Completed with support"},{"attributes":null,"label":"Complicated case","validFor":[3],"value":"Complicated case"},{"attributes":null,"label":"Multiple apts.","validFor":[3],"value":"Multiple apts."},{"attributes":null,"label":"No need to reply","validFor":[3],"value":"No need to reply"},{"attributes":null,"label":"Junk Mail","validFor":[3],"value":"Junk Mail"},{"attributes":null,"label":"Extra Job","validFor":[3],"value":"Extra Job"},{"attributes":null,"label":"Completed by myself","validFor":[3],"value":"Completed by myself"}]}';
        res.setHeader('Content-Type', 'application/json');
        res.setBody(bodyTmp);
        res.setStatusCode(200);  
        return res;
     }
}