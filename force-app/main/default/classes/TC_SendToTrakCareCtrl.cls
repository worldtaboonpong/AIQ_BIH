public class TC_SendToTrakCareCtrl {
	@AuraEnabled
    public static String sendToTrakCare(String recordId) {
        try {
            Case ca = [
                SELECT Id, Hospital_Number_HN__c, First_Name_Patient__c, Middle_Name_Patient__c, Last_Name_Patient__c, Gender_Patient__c, Date_Of_Birth_Patient__c,
                Nationality_New_Patient__c, Thai_ID_Card_Number_Patient__c, Country_of_Ressidence_Patient__c, Primary_Phone_New_Patient__c, Email_New_Patient__c,
                Preferred_Language_Patient__c, Title_Patient__c, First_Name_Thai__c, Middle_Name_Thai__c, Last_Name_Thai__c, Passport_Number_Patient__c, Staying_In_Hotel__c,
                Patient__r.Personal_Email_2__c, Patient__r.Third_Party_Email__c,  Address_Thailand__c, District_Thailand__c, Sub_district_Thailand__c, State_Province_Thailand__c,
                Postcode_Thailand__c, Health_Insurance_Co__c, MemberID__c, PolicyNumber__c, Address_foreign__c, Town_City_foreign__c, State_Province_foreign__c, Postcode_foreign__c  
                FROM Case WHERE Id = :recordId
            ];
            
            Map<String, Object> mapDetails = new Map<String, Object>();
            mapDetails.put('hn', checkNull(ca.Hospital_Number_HN__c));
            mapDetails.put('firstName', checkNull(ca.First_Name_Patient__c));
            mapDetails.put('middleName', checkNull(ca.Middle_Name_Patient__c));
            mapDetails.put('lastName', checkNull(ca.Last_Name_Patient__c));
            mapDetails.put('sex', checkNull(ca.Gender_Patient__c));
            mapDetails.put('dateOfBirth', checkNull(ca.Date_Of_Birth_Patient__c));
            mapDetails.put('nationality', checkNull(ca.Nationality_New_Patient__c));
            mapDetails.put('nationalID', checkNull(ca.Thai_ID_Card_Number_Patient__c));
            mapDetails.put('countryOfResidence', checkNull(ca.Country_of_Ressidence_Patient__c));
            mapDetails.put('phone', checkNull(ca.Primary_Phone_New_Patient__c));
            mapDetails.put('email', checkNull(ca.Email_New_Patient__c));
            mapDetails.put('preferredLanguage', checkNull(ca.Preferred_Language_Patient__c));
            mapDetails.put('title', checkNull(ca.Title_Patient__c));
            mapDetails.put('firstNameTh', checkNull(ca.First_Name_Thai__c));
            mapDetails.put('middleNameTh', checkNull(ca.Middle_Name_Thai__c));
            mapDetails.put('lastNameTh', checkNull(ca.Last_Name_Thai__c));
            mapDetails.put('passportNo', checkNull(ca.Passport_Number_Patient__c));
            mapDetails.put('email2', checkNull(ca.Patient__r.Personal_Email_2__c));
            mapDetails.put('emailThirdParty', checkNull(ca.Patient__r.Third_Party_Email__c));
            if (ca.Country_of_Ressidence_Patient__c == 'Thailand') {
                mapDetails.put('address', checkNull(ca.Address_Thailand__c));
                mapDetails.put('address2', '');
                mapDetails.put('cityarea', checkNull(ca.Sub_district_Thailand__c));
                mapDetails.put('suburb', checkNull(ca.District_Thailand__c));
                mapDetails.put('state', checkNull(ca.State_Province_Thailand__c));
                mapDetails.put('postcode', checkNull(ca.Postcode_Thailand__c));
                mapDetails.put('overseasPostcode', '');
            } else {
                String adr = (ca.Address_Thailand__c != null && ca.Address_Thailand__c != '' ? ca.Address_Thailand__c : '');
                adr += (adr.trim() != '' && ca.District_Thailand__c != null ? ', ' : '') + checkNull(ca.District_Thailand__c);
                adr += (adr.trim() != '' && ca.State_Province_Thailand__c != null ? ', ' : '') + checkNull(ca.State_Province_Thailand__c);
                
                mapDetails.put('address', adr);
                mapDetails.put('address2', '');
                mapDetails.put('cityarea', '');
                mapDetails.put('suburb', '');
                mapDetails.put('state', '');
                mapDetails.put('postcode', '');
                mapDetails.put('overseasPostcode', checkNull(ca.Postcode_Thailand__c));
            }
            
            mapDetails.put('rowidtempAddress', '');
            
            if (ca.Country_of_Ressidence_Patient__c != 'Thailand' && ca.Staying_In_Hotel__c == 'Yes') {
                String adr = (ca.Address_foreign__c != null ? ca.Address_foreign__c : '');
                adr += (adr.trim() != '' && ca.State_Province_foreign__c != null ? ', ' : '') + checkNull(ca.State_Province_foreign__c);
                
                mapDetails.put('tempAddress', adr);
                mapDetails.put('tempSuburb', checkNull(ca.Town_City_foreign__c));
                mapDetails.put('tempState', '');
                mapDetails.put('tempPostcode', checkNull(ca.Postcode_foreign__c));
            } else if (ca.Country_of_Ressidence_Patient__c != 'Thailand' && ca.Staying_In_Hotel__c == 'No') {
                mapDetails.put('tempAddress', checkNull(ca.Address_foreign__c));
                mapDetails.put('tempSuburb', checkNull(ca.Town_City_foreign__c));
                mapDetails.put('tempState', checkNull(ca.State_Province_foreign__c));
                mapDetails.put('tempPostcode', checkNull(ca.Postcode_foreign__c));
            } else {
                mapDetails.put('tempAddress', '');
                mapDetails.put('tempSuburb', '');
                mapDetails.put('tempState', '');
                mapDetails.put('tempPostcode', '');
            }
            
            mapDetails.put('rowidpayor', '');
            mapDetails.put('payor', checkNull(ca.Health_Insurance_Co__c));
            mapDetails.put('memberIDstaffID', checkNull(ca.MemberID__c));
            mapDetails.put('policyno', checkNull(ca.PolicyNumber__c));
            mapDetails.put('freeText4', '');
            
            Map<String, Object> mapData = new Map<String, Object>();
            mapData.put('data', mapDetails);
            
            String dataJson = JSON.Serialize(mapData);
            HttpResponse httpRes = TC_TrakCareService.returnPreRegistrationResponse(dataJson);
            
            String apiResponse = '';
            if (httpRes.getStatusCode() == 200) {
                apiResponse = 'Send To Trak Care successfully.';
            } else {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(httpRes.getBody());
                apiResponse = 'Error: '+ responseMap.get('description');
                system.debug('description ++'+responseMap.get('description'));
            }
            
            Track_Care_Log__c tcl = new Track_Care_Log__c(
                API_Name__c = 'Pre-Registration', Method__c = 'POST', Request__c = dataJson, 
                Status_Code__c = ''+httpRes.getStatusCode(), Status__c = httpRes.getStatus(), Response__c = httpRes.getBody()
            );
            insert tcl;
            
            return apiResponse;
        } catch (Exception ex) {
            return 'Error: ' + ex.getMessage();
        }
    }
    
    public static Object checkNull(Object val) {
        return (val != null ? val : '');
    }
}