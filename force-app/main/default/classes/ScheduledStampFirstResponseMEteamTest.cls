@IsTest
public class ScheduledStampFirstResponseMEteamTest {
     @IsTest(SeeAllData=false) 
    	static void testScheduledStampFirstResponseMEteam() {

        ScheduledStampFirstResponseMEteam pp = new ScheduledStampFirstResponseMEteam();
        system.schedule('ScheduledStampFirstResponseMEteam',  '0 1 * * * ?', pp);
        

    }

}