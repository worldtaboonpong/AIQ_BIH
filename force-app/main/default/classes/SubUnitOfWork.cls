public class SubUnitOfWork {
    
    public static final integer WORK_UPDATE = 1;
    public static final integer WORK_DELETE = 2;
    public static final integer WORK_INSERT = 3;
    
	private List<sObject> sobjects;
    private List<Id> sobjectIds;
    private integer type;
    private Boolean partial;
    public SubUnitOfWork(integer type){
        this.partial = false;
        this.type = type;
        this.sobjects = new List<sObject>();
        this.sobjectIds = new List<Id>();
    }
    public SubUnitOfWork(integer type,Boolean partial){
        this.type = type;
        this.sobjects = new List<sObject>();
        this.sobjectIds = new List<Id>();
        this.partial = partial;
    }
    public void register(sObject obj){
        if(!this.sobjectIds.contains(obj.Id)){
            sobjects.add(obj);
            this.sobjectIds.add(obj.Id);
        }
    }
    public void commitWork(){
        if(type == SubUnitOfWork.WORK_UPDATE){	
            if(this.partial){		
                Database.update(sobjects, false);
            }else{
                update sobjects;
            }
        }else if(type == SubUnitOfWork.WORK_DELETE){	
            if(this.partial){		
                Database.delete(sobjects, false);
            }else{
                delete sobjects;
            }
        }else if(type == SubUnitOfWork.WORK_INSERT){	
            if(this.partial){		
                Database.insert(sobjects, false);
            }else{
                insert sobjects;
            }
        }
    }
}