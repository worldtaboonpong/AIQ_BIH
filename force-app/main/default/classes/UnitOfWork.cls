public class UnitOfWork {
    
    private Map<String,SubUnitOfWork> subUnitOfWorks;
    private Boolean useSavePoint;
    
    public UnitOfWork(){
        this.subUnitOfWorks = new Map<String,SubUnitOfWork>();
        this.useSavePoint = true;
    }

    public UnitOfWork(Boolean useSavePoint){
        this.subUnitOfWorks = new Map<String,SubUnitOfWork>();
        this.useSavePoint = useSavePoint;
    }
    
    public void registerSub(SObjectType name,SubUnitOfWork subUnitOfWork){
        subUnitOfWorks.put(name+'',subUnitOfWork);
    }

    public void registerSub(String name,SubUnitOfWork subUnitOfWork){
        subUnitOfWorks.put(name+'',subUnitOfWork);
    }
    
    public SubUnitOfWork getSubUnitOfWorkByName(SObjectType name){
        return subUnitOfWorks.get(name+'');
    }

    public SubUnitOfWork getSubUnitOfWorkByName(String name){
        return subUnitOfWorks.get(name+'');
    }

    // public SubUnitOfWork getSubUnitOfWorkByName(String name){
    //     return subUnitOfWorks.get(name+'');
    // }
    
    public void commitWork(){
        if(this.useSavePoint){
            SavePoint sp = Database.setSavePoint();
            try{
                for(String name : subUnitOfWorks.keySet()){
            
                    SubUnitOfWork ss = subUnitOfWorks.get(name);
                    
                    ss.commitWork();
                }            
            }catch(Exception e){
                Database.rollback(sp);
                throw e;
            }
        }else{
            try{
                for(String name : subUnitOfWorks.keySet()){
            
                    SubUnitOfWork ss = subUnitOfWorks.get(name);
                    
                    ss.commitWork();
                }            
            }catch(Exception e){    
                throw e;
            }
        }
        
    }
}