public class BIH_CustomLookUpController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName,String showField,String FieldNameSearch,String FieldNameSearchAddition1,String FieldNameSearchAddition2,String TypeAPISearch) {
        
        system.debug('TypeAPISearch-->' + TypeAPISearch);
        system.debug('ObjectName-->' + ObjectName);
        system.debug('FieldName-->' + FieldNameSearch);
        system.debug('FieldNameSearchAddition1-->' + FieldNameSearchAddition1);
        system.debug('FieldNameSearchAddition2-->' + FieldNameSearchAddition2);

        if(showField != null && showField != ''){
            showField = ', '+ showField;
        }
        // String searchKey = searchKeyWord + '%';
         String searchKey;
        List < sObject > returnList = new List < sObject > ();
        List < sObject > TmpList = new List < sObject > ();
        
        if(TypeAPISearch == 'SOSL'){

            searchKey = searchKeyWord + '*';
            String searchquery='FIND \''+ searchKey +'\' IN '+FieldNameSearch+' FIELDS RETURNING '+ObjectName+'('+FieldNameSearch+showField+') LIMIT 5' ; 
            // string doctorActive = ' WHERE active__c =true';
            // if(ObjectName == 'Doctor__c'){
            //     searchquery='FIND \''+ searchKey +'\' IN '+FieldNameSearch+' FIELDS RETURNING '+ObjectName+'('+FieldNameSearch+showField+doctorActive+') LIMIT 5' ; 
            
            // }
            List<List<SObject>>searchList=search.query(searchquery);
            System.debug('searchquery : '+searchquery);
            System.debug('searchList : '+searchList);
            
            TmpList = searchList[0];

        }else{
            searchKey = '\''+ searchKeyWord + '%\' ';
            String WhereClause = ''; 
            String RealCondition = FieldNameSearch+' LIKE '+searchKey;
            //start 
            
            WhereClause += '(' +RealCondition;

            if(FieldNameSearchAddition1 != '' && FieldNameSearchAddition1 != null){
                WhereClause += ' OR '+FieldNameSearchAddition1 + ' LIKE '+ searchKey;
            }
            if(FieldNameSearchAddition2 != '' && FieldNameSearchAddition2 != null){
                WhereClause += ' OR '+FieldNameSearchAddition2 + ' LIKE '+ searchKey ;
            }

            WhereClause += ') '; //end clause OR 

            if(ObjectName == 'Doctor__c'){
                WhereClause += ' AND Active__c =true';
            }
            // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
            String sQuery =  'select id, Name '+showField+' from ' +ObjectName + ' where'+WhereClause+' order by createdDate DESC limit 5';
            System.debug('searchquery : '+ sQuery);
            TmpList = Database.query(sQuery);
            System.debug('searchList : '+TmpList);
        }
        


        if(TmpList.size()> 0){
            List < sObject > lstOfRecords = TmpList;
            for (sObject obj: lstOfRecords) {
                returnList.add(obj);
            }
        }
        return returnList;
    }
}