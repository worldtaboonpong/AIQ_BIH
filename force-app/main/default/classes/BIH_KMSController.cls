public class BIH_KMSController {
    @AuraEnabled(cacheable=true)
    public static List<Knowledge__kav> fetchLookUpUserValues(String searchKeyWord, String title) {
        
        String searchKey = '%' + searchKeyWord + '%';
        String searchtitle = '%' + title + '%';
        
        List < Knowledge__kav > returnList = new List < Knowledge__kav > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        //String sQuery =  'select Id,Title,Summary from Knowledge__kav where Title LIKE: searchKey and Title LIKE: searchtitle order by createdDate DESC limit 10';
        //String sQuery =  'select id,Name from User where Name LIKE: searchKey order by createdDate DESC limit 10';
        String sQuery =  'select Id,Title,Summary,UrlName,ValidationStatus,ArticleCreatedDate from Knowledge__kav where Title LIKE: searchKey order by createdDate DESC limit 10';
        system.debug('Query -->' + sQuery);
        List < Knowledge__kav > lstOfRecords = Database.query(sQuery);
        
        
        
        for (Knowledge__kav obj: lstOfRecords) {
            //system.debug('id : '+obj.id);
            //system.debug('Title : '+obj.Title);
            returnList.add(obj);
        }
        return returnList;
    }

}