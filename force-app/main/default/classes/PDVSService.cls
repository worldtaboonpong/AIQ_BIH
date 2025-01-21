public class PDVSService {
    public static String getPlatformEventChannel(){
        Integer maxChannel = 10;

        UnitOfWork uow = new UnitOfWork();
        uow.registerSub(Platform_Event_Channel_Mapping__c.sObjectType,new SubUnitOfWork(SubUnitOfWork.WORK_DELETE));
        uow.registerSub('PEINSERT',new SubUnitOfWork(SubUnitOfWork.WORK_INSERT));
        
        Set<Id> sessionId = (new Map<Id,SObject>(new DataSelector().selectOnlineUserSessions())).keySet();
        PlatformEventChannelMappingDomain domain = new PlatformEventChannelMappingDomain(new DataSelector().selectPEMappingThatExpires(sessionId));
        domain.deleteExpires(uow);
        
        List<Platform_Event_Channel_Mapping__c> peList = new DataSelector().selectPEMappingThatActive(sessionId);
        String channel = '';
        for(Platform_Event_Channel_Mapping__c pe : peList){
            if(pe.User_Name__c == UserInfo.getUserName()){
                channel = pe.Channel__c;
                break;
            }
        }

        if(channel==''){

            Map<String,String> result = PDVSService.calculateLogic(peList,maxChannel);
            channel = result.get('toBeChn');
            
            Platform_Event_Channel_Mapping__c peMp = new Platform_Event_Channel_Mapping__c();
            peMp.Session__c = new DataSelector().selectAuthSessionByUsername(UserInfo.getUserName()).Id;
            peMp.User_Name__c = UserInfo.getUserName();
            peMp.Channel__c = channel;

            PlatformEventChannelMappingDomain domain2 = new PlatformEventChannelMappingDomain(peMp);
            domain2.insertNew(uow);
        }
        
        
        uow.commitWork();

        return channel;
    }

    public static Map<String,String> calculateLogic(List<Platform_Event_Channel_Mapping__c> peList, Integer maxChannel){
        Map<String,String> result = new Map<String,String>();

        Map<String,Integer> mapCh = new Map<String,Integer>();
        for(Platform_Event_Channel_Mapping__c pe : peList){
            if(!mapCh.containsKey(pe.Channel__c)){
                mapCh.put(pe.Channel__c, 1);
            }else{
                Integer cnt = mapCh.get(pe.Channel__c);
                cnt++;
                mapCh.put(pe.Channel__c, cnt);
            }
        }

        Integer min = 9999;
        Integer channelMax = -9999;
        String toBeChn = '';
        for(String key :mapCh.keySet()){
            if(mapCh.get(key)<min){
                min = mapCh.get(key);
                toBeChn = key;
            }

            if(Integer.valueOf(key)>channelMax){
                channelMax = Integer.valueOf(key);
            }
        }

        if(channelMax != maxChannel){
            toBeChn = (channelMax == -9999 ? 1 : channelMax+1)+'';
        }

        result.put('toBeChn', toBeChn+'');

        return result;
    }
}