@IsTest
public class ScheduledAutoSendMECLTest {
        @IsTest(SeeAllData=true) static void testScheduledAutoSendMECL() {

        ScheduledAutoSendMECL pp = new ScheduledAutoSendMECL();
        system.schedule('Send Second ME CL Follow Mail',  '0 1 * * * ?', pp);
        

    }

}