public class TC_WarningAlertsController {
	@AuraEnabled
    public static Map<String, Object> getPatientDetails(Id recordId) {
        String message = '';
        List<String> iconPaths = new List<String>();
        
        try {
            String hnNumber = '';
            String tcNote = '';
            String sObjName = recordId.getSObjectType().getDescribe().getName();
            if (sObjName == 'Account') {
                List<Account> accounts = [SELECT Hospital_Number_HN__c FROM Account WHERE Id = :recordId AND Hospital_Number_HN__c != null];
                if (accounts.size() > 0) {
                    hnNumber = accounts.get(0).Hospital_Number_HN__c;
                }
            } else if (sObjName == 'Case') {
                List<Case> cases = [SELECT Hospital_Number_HN__c FROM Case WHERE Id = :recordId AND Hospital_Number_HN__c != null];
                if (cases.size() > 0) {
                    hnNumber = cases.get(0).Hospital_Number_HN__c;
                }
            }
            
            if (hnNumber != '') {
                HttpResponse httpRes = TC_TrakCareService.getPatientResponse('?hn='+hnNumber);
                if (httpRes.getStatusCode() == 200) {
                    TC_PatientAlertParser paParser = TC_PatientAlertParser.parse(httpRes.getBody());
                    
                    for (TC_PatientAlertParser.cls_iconProfile iconPro: paParser.data.iconProfile) {
                        iconPaths.add(iconPro.patientDataIcon.iconPath.substringAfterLast('/'));
                    }
                    
                    for (TC_PatientAlertParser.cls_patientAlert pAlert: paParser.data.patientAlert) {
                        tcNote += (tcNote != '' ? '\n' : '') + (pAlert.patientDataAlert.alert+': '+pAlert.patientDataAlert.patientMessage);
                    }
                } else {
                    message = 'Error: ' + httpRes.getStatus();
                }
                
                if (sObjName == 'Account') {
                    List<Account> accList = new List<Account>();
                    accList.add(new Account(Id = recordId, TrakCare_Note__c = tcNote));
                    Database.update(accList, false);
                }
                
                Track_Care_Log__c tcl = new Track_Care_Log__c(
                    API_Name__c = 'Patient', Method__c = 'GET', Request__c = hnNumber, 
                    Status_Code__c = ''+httpRes.getStatusCode(), Status__c = httpRes.getStatus(), Response__c = httpRes.getBody()
                );
                insert tcl;
            }
        } catch(Exception ex) {
            message = 'Error: ' + ex.getMessage();
        }
        
        Map<String, Object> mapObjects = new Map<String, Object>();
        mapObjects.put('Message', message);
        mapObjects.put('IconPaths', iconPaths);
        return mapObjects;
    }
}