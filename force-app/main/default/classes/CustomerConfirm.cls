@RestResource(urlMapping='/doconfirm')
global without sharing class CustomerConfirm {

    @HttpGet
    global static void doGetComfirm() {
        //https://bumrungrad--devbih.sandbox.my.salesforce-sites.com/CustomerConfirm/services/apexrest/doconfirm?caseid=500BK000001LJK1YAO
        String caseid = RestContext.request.params.get('caseid');

        try {
            List<Case> caseObj = [SELECT Id, Confirm__c FROM Case WHERE Id =: caseid LIMIT 1]; 
            if (caseObj.size() > 0) {
                caseObj[0].Confirm__c = true;
                update caseObj;
            }
            
            if (caseObj.size() > 0) {
                RestContext.response.statusCode = 200;
                RestContext.response.addHeader('Content-Type', 'text/html');
                RestContext.response.responseBody = Blob.valueOf(
                    '<html>' +
                        '<head>' +
                            '<style>' +
                                'body {' +
                                    'background-color: lightblue;' +
                                    'text-align: center;' +
                                '}' +
                                'h1 {' +
                                    'color: white;' +
                                    'font-size: 64px;' +
                                    'margin: 0;' +
                                    'padding: 20px 0;' +
                                    'background-color: green;' +
                                '}' +
                                'p {' +
                                    'font-size: 24px;' +
                                    'margin: 0;' +
                                    'padding: 20px 0;' +
                                '}' +
                            '</style>' +
                        '</head>' +
                        '<body>' +
                            '<h1>Thank you</h1>' +
                            '<p>Your request has been confirmed</p>' +
                        '</body>' +
                    '</html>'
                );
            } else {
                RestContext.response.statusCode = 400;
                RestContext.response.addHeader('Content-Type', 'text/plain');
                RestContext.response.responseBody = Blob.valueOf('Case not found');
            }
        } catch (Exception ex) {
            RestContext.response.statusCode = 500;
            RestContext.response.addHeader('Content-Type', 'text/plain');
            RestContext.response.responseBody = Blob.valueOf('An error occurred: ' + ex.getMessage());
        }
    }
}