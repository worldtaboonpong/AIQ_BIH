global class DetectionLanguageService {
    public static Map<String,Detection_Language_Mapping__mdt> DetectionLanguageMap {get{        
        if(DetectionLanguageMap==null){
            DetectionLanguageMap = new Map<String,Detection_Language_Mapping__mdt>();
            for (Detection_Language_Mapping__mdt mapRecord :[SELECT DeveloperName, Language__c, Queue__c, RecordType__c FROM Detection_Language_Mapping__mdt]){
                DetectionLanguageMap.put(mapRecord.DeveloperName, mapRecord);
            }          
        }
        return DetectionLanguageMap;
    }set;}

    public static Map<String,Group> QueueMap {get{
        if(QueueMap==null){
            QueueMap = new Map<String,Group>();
            for (Group mapRecord :[Select Id, DeveloperName, Name from Group where Type = 'Queue']){
                QueueMap.put(mapRecord.DeveloperName, mapRecord);
            } 
        }
        return QueueMap;
    }set;}

    @InvocableMethod
    public static void callFromSocialPostProcess(List<SocialPost> postList) {
        for(SocialPost sp : postList) {
            String content = sp.Content;
            if(content == null) {
                content = '';
            }                      
            content = content.replaceAll('(\\r|\\n)+', ' '); // remove line break
            content = content.replaceAll('[^\\p{L}\\p{M}\\p{N}\\p{P}\\p{Z}\\p{Cf}\\p{Cs}\\s]',''); // remove emoji
            if(content.startsWith('Photo reply from') || content.startsWith('Photo post from') || content.startsWith('Photo comment from')) {
                content = '';
            }
            if(sp.IsOutbound == false) {
                if(sp.Detected_Language__c == null || sp.Detected_Language__c == '') {
                    transferMethod(sp.Id, content);
                }
            }           
        }        
    }
    
    @future(callout=true)
    static void transferMethod(String spId, String content) {
    }
   
    
}