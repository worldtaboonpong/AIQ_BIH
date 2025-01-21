public class PlatformEventChannelMappingDomain {
	private List<Platform_Event_Channel_Mapping__c> objs;
    public PlatformEventChannelMappingDomain(List<Platform_Event_Channel_Mapping__c> objs){
        this.objs = objs;
    }

    public PlatformEventChannelMappingDomain(Platform_Event_Channel_Mapping__c obj){
        this.objs = new List<Platform_Event_Channel_Mapping__c>();
        this.objs.add(obj);
    }
    
    public void deleteExpires(UnitOfWork uow){
        if(objs.size()>0){
            for(Platform_Event_Channel_Mapping__c mapping : objs){
                uow.getSubUnitOfWorkByName(Platform_Event_Channel_Mapping__c.sObjectType).register(mapping);
            }
        }
    }

    public void insertNew(UnitOfWork uow){
        if(objs.size()>0){
            for(Platform_Event_Channel_Mapping__c mapping : objs){
                uow.getSubUnitOfWorkByName('PEINSERT').register(mapping);
            }
        }
    }
}