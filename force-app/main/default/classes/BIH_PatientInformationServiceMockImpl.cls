@isTest

global with sharing class BIH_PatientInformationServiceMockImpl implements HttpCalloutMock {

   global HTTPResponse respond(HTTPRequest req) {
        //System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());
        // Create a fake response.
        System.debug('---testclass---');
        System.debug(req.getEndpoint());
		// System.debug(req.getEndpoint().substringBetween('/list/','/'));
		System.debug('---testclass---');
       	 List<BIH_PatientInformationService.alertMessages> alertlist = new List<BIH_PatientInformationService.alertMessages>();
         BIH_PatientInformationService.alertMessages al = new BIH_PatientInformationService.alertMessages();
           al.type = 1;
           al.hn = '0084138947';
           al.code ='VIP2';
           al.description ='VIP - Gold - Orion';
           al.message = 'test';
           al.createdAt = '2013-09-27T00:00:00';
      	alertlist.add(al);
             
      //   List<BIH_PatientInformationService.patientInfoData> tmpMockList = new List<BIH_PatientInformationService.patientInfoData>();
        BIH_PatientInformationService.patientInfoData tmpMock = new BIH_PatientInformationService.patientInfoData();
       
        tmpMock.hn = '000000001';
        tmpMock.dateOfBirth = '2017-12-23T06:00:00.000Z';
        tmpMock.title = 'Mrs';
        tmpMock.firstName = 'TestFN';
        tmpMock.lastName = 'TestLN';
        tmpMock.sex = 1;
        tmpMock.email = 'test@mail.com';
        tmpMock.mobilePhone = '0800000000';
        tmpMock.homePhone = '0800000000';
       	
       tmpMock.nationality = 'Thai';
       tmpMock.passportNumber= '0000000001';
       tmpMock.country= 'Thailand ';
       tmpMock.countryOfResident= 'Thailand';
       tmpMock.idCardNumber= '0000000001';
       tmpMock.preferredLanguage= 'Thai';
       tmpMock.email2= 'test@mail.com';
       tmpMock.officePhone= '0800000000';
       tmpMock.note= 'Test Note';
       tmpMock.alertMessages = alertlist;
       
       
      //   tmpMockList.add(tmpMock);
     	// Create a fake response

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(tmpMock));
        res.setStatusCode(200);  
        return res;
    }
}