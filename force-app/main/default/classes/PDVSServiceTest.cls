@isTest
public class PDVSServiceTest {
    @isTest
    public static void testCase001(){
        List<Platform_Event_Channel_Mapping__c> peList = new List<Platform_Event_Channel_Mapping__c>();

        Map<String,String> result = PDVSService.calculateLogic(peList,2);

        System.assertEquals('1', result.get('toBeChn'));

    }

    @isTest
    public static void testCase002(){
        List<Platform_Event_Channel_Mapping__c> peList = new List<Platform_Event_Channel_Mapping__c>();
        peList.add(new Platform_Event_Channel_Mapping__c(Channel__c = '1'));

        Map<String,String> result = PDVSService.calculateLogic(peList,2);

        System.assertEquals('2', result.get('toBeChn'));

    }

    @isTest
    public static void testCase003(){
        List<Platform_Event_Channel_Mapping__c> peList = new List<Platform_Event_Channel_Mapping__c>();
        peList.add(new Platform_Event_Channel_Mapping__c(Channel__c = '1'));
        peList.add(new Platform_Event_Channel_Mapping__c(Channel__c = '2'));

        Map<String,String> result = PDVSService.calculateLogic(peList,2);

        System.assertEquals('1', result.get('toBeChn'));

    }

    @isTest
    public static void testCase004(){
        List<Platform_Event_Channel_Mapping__c> peList = new List<Platform_Event_Channel_Mapping__c>();
        peList.add(new Platform_Event_Channel_Mapping__c(Channel__c = '1'));
        peList.add(new Platform_Event_Channel_Mapping__c(Channel__c = '1'));
        peList.add(new Platform_Event_Channel_Mapping__c(Channel__c = '2'));

        Map<String,String> result = PDVSService.calculateLogic(peList,2);

        System.assertEquals('2', result.get('toBeChn'));

    }

    @isTest
    public static void testCase005(){
        List<Platform_Event_Channel_Mapping__c> peList = new List<Platform_Event_Channel_Mapping__c>();
        peList.add(new Platform_Event_Channel_Mapping__c(Channel__c = '1'));
        peList.add(new Platform_Event_Channel_Mapping__c(Channel__c = '2'));
        peList.add(new Platform_Event_Channel_Mapping__c(Channel__c = '2'));

        Map<String,String> result = PDVSService.calculateLogic(peList,2);

        System.assertEquals('1', result.get('toBeChn'));

    }

    @isTest
    public static void testCase006(){
        List<Platform_Event_Channel_Mapping__c> peList = new List<Platform_Event_Channel_Mapping__c>();
        peList.add(new Platform_Event_Channel_Mapping__c(Channel__c = '1'));
        peList.add(new Platform_Event_Channel_Mapping__c(Channel__c = '3'));

        Map<String,String> result = PDVSService.calculateLogic(peList,3);

        System.assertEquals('1', result.get('toBeChn'));

    }
}