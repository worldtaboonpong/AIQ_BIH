@IsTest
public class ScheduledStampFirstResponseValueTest {
        @IsTest(SeeAllData=false) 
    	static void testScheduledStampFirstResponseValue() {

        ScheduledStampFirstResponseValue pp = new ScheduledStampFirstResponseValue();
        system.schedule('ScheduledStampFirstResponseValue',  '0 1 * * * ?', pp);
        

    }

}