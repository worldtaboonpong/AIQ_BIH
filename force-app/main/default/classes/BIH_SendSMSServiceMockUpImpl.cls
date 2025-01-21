@isTest

global with sharing class BIH_SendSMSServiceMockUpImpl implements HttpCalloutMock {

   global HTTPResponse respond(HTTPRequest req) {
        System.debug('---testclass---');
        System.debug(req.getEndpoint());
		    System.debug('---testclass---');
        Boolean tmpMock = true;

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(tmpMock));
        res.setStatusCode(200);  
        return res;
    }
}