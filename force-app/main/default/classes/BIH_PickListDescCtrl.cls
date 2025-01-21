public with sharing class BIH_PickListDescCtrl {
     public Sobject sobj {get;set;}
    public String pickListFieldName {get;set;}        
    
    public BIH_PickListDescCtrl() {
        Map<String, String> reqParams = ApexPages.currentPage().getParameters();
        String sobjId = reqParams.get('id');
        String recordTypeId = reqParams.get('recordTypeId');
        String recordTypeName = reqParams.get('recordTypeName');
        String sobjectTypeName = reqParams.get('sobjectType'); 
        this.pickListFieldName = reqParams.get('picklistFieldName'); 
        
        Schema.SobjectType sobjectType = null;
        
        if (sobjectTypeName != null && sobjectTypeName.trim().length() > 0) {
            sobjectType = Schema.getGlobalDescribe().get(sobjectTypeName);
            // create blank sobject record
            sobj = sobjectType.newSobject();
            
            // if no recordTypeId passed explicitly by user, try loading one from the RecordType table
            if (isBlank(recordTypeId) && !isBlank(recordTypeName)) {
                // queryexception is fine, we don't want to return anything good for bad recordtype
                RecordType recType = [Select Id from RecordType Where SobjectType =:sobjectTypeName 
                                            AND DeveloperName like :recordTypeName];
                recordTypeid = recType.id;                                            
            }
            sobj.put('RecordTypeId', recordTypeid);                                            

        } else if (sobjId != null && sobjId.trim().length() > 0) {
            // find the so
            for (SobjectType sobjType : Schema.getGlobalDescribe().values()){
                String sobjPrefix = sobjType.getDescribe().getKeyPrefix();
                if (sobjPrefix == null) continue;
                System.debug(sobjId);
                System.debug('SobjectType ' + sobjType + ', ' + sobjPrefix);
                if (sobjId.startsWith(sobjPrefix)) {
                    sobjectType = sobjType;
                    break;
                }
            }
            // following not working with input:field
            //sobj = sobjectType.newSobject(sobjId);
            sobj = Database.query ('SELECT ' + pickListFieldName + ' FROM ' + sobjectType + ' WHERE ID =:sobjId');
        }
            
    }  
    
    static boolean isBlank(String val) {
        return val == null || val.trim().length() == 0;
    }
    static final Pattern OPTION_PATTERN = Pattern.compile('<option value="([^"]+).*?>(.+?)</option>'); 
    
    /**
        Desribe a picklist field for an sobject id. RecordType is automatically picked
        based on the record's RecordTypeId field value.
        example usage :
        List<BIH_PicklistOption> options = PicklistDescriber.describe(accountId, 'Industry');
    */
    public static List<BIH_PicklistOption> describe(Id sobjectId, String pickListFieldAPIName) {
        return parseOptions(
                            new Map<String, String> {
                                                     'id' => sobjectId,
                                                     'pickListFieldName'=> pickListFieldAPIName
                                                    }
                            );
    }
    
    /**
        Describe a picklist field for a SobjectType, its given record type developer name and the picklist field
        example usage : 
        List<BIH_PicklistOption> options = PicklistDescriber.describe('Account', 'Record_Type_1', 'Industry'));
    */
    public static List<BIH_PicklistOption> describe(String sobjectType, String recordTypeName, String pickListFieldAPIName) {
        return parseOptions(
                            new Map<String, String> {
                                                     'sobjectType' => sobjectType,
                                                     'recordTypeName' => recordTypeName,
                                                     'pickListFieldName'=> pickListFieldAPIName
                                                    }
                            );
    }
    
    /**
        Describe a picklist field for a SobjectType, its given record type ID and the picklist field
        example usage : 
        Id recType1Id = [Select Id from RecordType Where SobjectType = 'Account' 
                                            AND DeveloperName like 'Record_Type_2'].Id;
        System.assertEquals(REC_TYPE_1_OPTIONS, PicklistDescriber.describe('Account', recType2Id, 'Industry'));
    */
    public static List<BIH_PicklistOption> describe(String sobjectType, Id recordTypeId, String pickListFieldAPIName) {
        return parseOptions(
                            new Map<String, String> {
                                                     'sobjectType' => sobjectType,
                                                     'recordTypeId' => recordTypeId,
                                                     'pickListFieldName'=> pickListFieldAPIName
                                                    }
                            );
    }
    
    /*
        Internal method to parse the OPTIONS
    */
    static List<BIH_PicklistOption> parseOptions(Map<String, String> params) {
        Pagereference pr = Page.BIH_PicklistDesc;
        // to handle development mode, if ON
        pr.getParameters().put('core.apexpages.devmode.url', '1');
        
        for (String key : params.keySet()) {
            pr.getParameters().put(key, params.get(key));   
        }
        if(Test.isRunningTest()) {
            return new List<BIH_PicklistOption>{new BIH_PicklistOption('1', '2')};
        } else {
            String xmlContent = pr.getContent().toString();
            System.debug('xmlContent : '+xmlContent);            
            Matcher mchr = OPTION_PATTERN.matcher(xmlContent);
            List<BIH_PicklistOption> options = new List<BIH_PicklistOption>();
            while(mchr.find()) {
                // insert only if those picklist has value
                if(mchr.group(1) != '') {
                    options.add(new BIH_PicklistOption(mchr.group(1).replace('&#39;', '\'').replace('&amp;', '&'), mchr.group(2).replace('&#39;', '\'').replace('&amp;', '&')));
                }
            }
            return options;
        }
        // return null;
    }
}