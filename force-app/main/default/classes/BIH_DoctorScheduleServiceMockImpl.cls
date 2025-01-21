@isTest
global class BIH_DoctorScheduleServiceMockImpl implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        BIH_DoctorScheduleService.TimeSlot tmpMock = new BIH_DoctorScheduleService.TimeSlot();
        
		// System.debug('---testclass---');
        // System.debug(req.getEndpoint());
		// System.debug(req.getEndpoint().substringBetween('/list/','/'));
		// System.debug('---testclass---');
		tmpMock.code = '1234';
		tmpMock.startTime = '2017-12-23T06:00:00.000Z';
		tmpMock.endTime = '2017-12-23T06:10:00.000Z';
		tmpMock.locationCode = '001';
		tmpMock.location = 'Test';
		tmpMock.isAvailable= false;

        BIH_DoctorScheduleService.TimeSlot tmpMock2 = new BIH_DoctorScheduleService.TimeSlot();
        tmpMock2.code = '1235';
		tmpMock2.startTime = '2017-12-23T06:20:00.000Z';
		tmpMock2.endTime = '2017-12-23T06:30:00.000Z';
		tmpMock2.locationCode = '002';
		tmpMock2.location = 'Test';
		tmpMock2.isAvailable= true;
		// tmpMock.visitDateTime= '2017-12-23T06:00:00.000Z';
		// tmpMock.hn= 'Test';
		// tmpMock.mdCode= 'Test';
		// tmpMock.locationCode= 'Test';
		// tmpMock.note= 'Test';
		// tmpMock.appointmentDateTime= '2017-12-23T06:00:00.000Z';
		// if(req.getEndpoint().substringBetween('/list/','/') == '000000001'){
		// 	tmpMock.hn= 'Test';
		// 	tmpMock.visitStatus= 0;
		// 	tmpMock.visitType= 0;
		// 	tmpMock.appointmentStatus= 0;
		// }else if (req.getEndpoint().substringBetween('/list/','/') == '000000002'){
		// 	tmpMock.hn= '000000002';
		// 	tmpMock.visitStatus= 1;
		// 	tmpMock.visitType= 1;
		// 	tmpMock.appointmentStatus= 1;
		// }else{
		// 	tmpMock.hn= '000000003';
		// 	tmpMock.visitStatus= 2;
		// 	tmpMock.visitType= 2;
		// 	tmpMock.appointmentStatus= 2;
		// }
        

        List<BIH_DoctorScheduleService.TimeSlot> tmpList = new List<BIH_DoctorScheduleService.TimeSlot>();
        tmpList.add(tmpMock);
        tmpList.add(tmpMock2);
		// Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(tmpList));
        res.setStatusCode(200);  
        return res;
    }
}