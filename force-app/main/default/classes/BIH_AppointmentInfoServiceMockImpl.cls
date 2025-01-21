@isTest
global class BIH_AppointmentInfoServiceMockImpl implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        BIH_AppointmentInformationService.AppointmentInfoRequest tmpMock = new BIH_AppointmentInformationService.AppointmentInfoRequest();
        
		System.debug('---testclass---');
        System.debug(req.getEndpoint());
		System.debug(req.getEndpoint().substringBetween('/list/','/'));
		System.debug('---testclass---');
		tmpMock.serviceName = 'Test';
		tmpMock.serviceCode = 'Test';
		tmpMock.updatedUserName = 'Test';
		tmpMock.updatedUserId = 'Test';
		tmpMock.locationName = 'Test';
		tmpMock.doctorName = 'Test';
		tmpMock.visitNumber= 'Test';
		tmpMock.visitDateTime= '2017-12-23T06:00:00.000Z';
		tmpMock.hn= 'Test';
		tmpMock.mdCode= 'Test';
		tmpMock.locationCode= 'Test';
		tmpMock.note= 'Test';
		tmpMock.appointmentDateTime= '2017-12-23T06:00:00.000Z';
		if(req.getEndpoint().substringBetween('/list/','/') == '000000001'){
			tmpMock.hn= 'Test';
			tmpMock.visitStatus= 0;
			tmpMock.visitType= 0;
			tmpMock.appointmentStatus= 0;
		}else if (req.getEndpoint().substringBetween('/list/','/') == '000000002'){
			tmpMock.hn= '000000002';
			tmpMock.visitStatus= 1;
			tmpMock.visitType= 1;
			tmpMock.appointmentStatus= 1;
		}else{
			tmpMock.hn= '000000003';
			tmpMock.visitStatus= 2;
			tmpMock.visitType= 2;
			tmpMock.appointmentStatus= 2;
		}
        

        List<BIH_AppointmentInformationService.AppointmentInfoRequest> tmpList = new List<BIH_AppointmentInformationService.AppointmentInfoRequest>();
        tmpList.add(tmpMock);
		// Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(tmpList));
        res.setStatusCode(200);  
        return res;
    }
}