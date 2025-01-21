@isTest
global class MockHttpResponseGenerator2 implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://ws.detectlanguage.com/0.2/detect', req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"controllerValues":{},"defaultValue":{"attributes":{"picklistAtrributesValueType":"CaseStatus"},"label":"New","validFor":[],"value":"New"},"eTag":"6473fe63367bd2aab830f98c27e81ee1","url":"/services/data/v43.0/ui-api/object-info/Case/picklist-values/0122u000000PG9JAAW/Status","values":[{"attributes":{"picklistAtrributesValueType":"CaseStatus"},"label":"New","validFor":[],"value":"New"},{"attributes":{"picklistAtrributesValueType":"CaseStatus"},"label":"In Progress","validFor":[],"value":"In Progress"},{"attributes":{"picklistAtrributesValueType":"CaseStatus"},"label":"Pending","validFor":[],"value":"Pending"},{"attributes":{"picklistAtrributesValueType":"CaseStatus"},"label":"Closed","validFor":[],"value":"Closed"}]}');
        //[{"actionName":"customNotificationAction","errors":null,"isSuccess":true,"outputValues":{"SuccessMessage":"Your custom notification is processed successfully."}}]

        res.setStatusCode(200);
        return res;
    }
}