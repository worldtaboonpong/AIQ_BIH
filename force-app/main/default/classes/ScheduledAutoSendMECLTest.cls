@IsTest
public class ScheduledAutoSendMECLTest {
        @IsTest
    	static void testScheduledAutoSendMECL() {
        
        Test.startTest(); 
        ScheduledAutoSendMECL pp = new ScheduledAutoSendMECL();
        system.schedule('Send Second ME CL Follow Mail',  '0 1 * * * ?', pp);
		Test.stopTest();
            
    }

}