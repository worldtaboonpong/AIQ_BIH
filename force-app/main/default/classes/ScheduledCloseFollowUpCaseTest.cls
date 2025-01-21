@IsTest
public class ScheduledCloseFollowUpCaseTest {
        @IsTest
    	static void testScheduledCloseFollowUpCase() {
        
        Test.startTest(); 
        ScheduledCloseFollowUpCase pp = new ScheduledCloseFollowUpCase();
        system.schedule('Send ScheduledCloseFollowUpCase Mail',  '0 1 * * * ?', pp);
		Test.stopTest();
            
    }

}