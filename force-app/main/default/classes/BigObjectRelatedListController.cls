public with sharing class BigObjectRelatedListController {
    // ----- START BUSINESS LOGIC -----
	@AuraEnabled(cacheable=true)
	public static List<Map<String, String>> getBigObjectFieldDisplay(String bigObjectApi){
		List<Big_Object_Field_Display__mdt> fieldDisplayConfigs = [
            SELECT Field_API__c, Order__c
            FROM Big_Object_Field_Display__mdt
            WHERE Big_Object_API__c = :bigObjectApi
            ORDER BY Order__c
        ];
        List<Map<String, String>> columns = new List<Map<String, String>>();
        for (Big_Object_Field_Display__mdt config : fieldDisplayConfigs) {
            columns.add(new Map<String, String>{
                'fieldApiName' => config.FieldAPI__c,
                'label' => config.FieldLabel__c
            });
        }
        return columns;
	}

	@AuraEnabled(cacheable=true)
	public static List<Object> getBigObjectRecords(
        String bigObjectApi,
        String parentFieldApi,
        String parentId,
        List<String> fields
    ) {
        if (!fields.contains('Id')) {
            fields.add('Id');
        }
        String fieldList = String.join(fields, ', ');
        String query = 'SELECT ' + fieldList + ' FROM ' + bigObjectApi + ' WHERE ' + parentFieldApi + ' = :parentId';
        try {
            List<Object> bigObjectRecords = Database.query(query);
            return bigObjectRecords;
        } catch (Exception e) {
            System.debug('Error querying Big Object: ' + e.getMessage() + ' ' + e.getStackTraceString());
			throw new AuraHandledException('Error retrieving Big Object records: ' + e.getMessage());
        }
    }
    // ----- END BUSINESS LOGIC -----
}
