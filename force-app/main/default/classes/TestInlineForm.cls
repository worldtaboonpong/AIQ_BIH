@RestResource(urlMapping='/form/v1/*')
global without sharing class TestInlineForm{
    @HttpPost
    global static String getFormData() { 
        RestRequest req = RestContext.request;
        String first_name = req.params.get('first_name');
        String last_name = req.params.get('last_name');
        String email = req.params.get('email');       
        String caseId = req.params.get('caseId');  
        
        
        Case cs = new Case(Id = caseId);
        cs.Are_you_satisfied__c = first_name;
        cs.Would_you_come_back_again__c = first_name;
        cs.Can_you_recommend_any_improvements__c = email;
        update cs;
        
        return 'Thank You';
   }
}