@istest
public class PublishVerifyButtonEventTest {
	@istest
    public static void test(){
        Test.startTest();
        PublishVerifyButtonEvent.publish('caseId');
        Test.stopTest();
    }
}