public class RequestReplyEmailRegis implements Queueable{
	public void execute(QueueableContext context)
    {
        Set<Id> tmpParentId = new Set<Id>();
        Map<Id,EmailMessage> emailmessageMap = new Map<Id,EmailMessage>();
        List<Case> listReplyMailinCase = new List<Case>();
            
        List<EmailMessage> emailList = [select Parent.Id,MessageDate 
         	From EmailMessage
            Where FromAddress = 'noreply@bumrungrad.com'
            And ToAddress = 'pre-registration@bumrungrad.com'                            
            //Where FromAddress = 'noreply@bumrungrad.com' 
            //And ToAddress = 'registration@leighripley.com'
            ];     
        
        System.debug('Request => emailList size : ' + emailList.size());
        
        if(emailList.size() > 0)
        {
            for (EmailMessage tmpemail : emailList){
            	tmpParentId.add(tmpemail.Parent.Id);
                emailmessageMap.put(tmpemail.Parent.Id , tmpemail);
        	}
            
            listReplyMailinCase = [Select Id, Reply_From_Registration_Patient__c,OwnerId,CaseNumber,Patient_Reply_to_Registration_DateTime__c 
            	From Case                               
            	Where Id IN: tmpParentId
                And Status != 'Closed'                   
            	And Reply_From_Registration_Patient__c = false
                And Patient_Reply_to_Registration_DateTime__c = null];
            
            System.debug('Request => listReplyMailinCase size : ' + listReplyMailinCase.size());
            System.debug('');
            
            List<String> userid = new List<String>();

        	String inbody = 'Reply Email';
        	String inTitle = 'Notify Title';

        	String targetId ;
       	 	System.debug('######## RunTrigger after inbody:' + inbody);
            if(listReplyMailinCase.size() > 0)
        	{
            	for(case tcase : listReplyMailinCase)
            	{
                    
                 	tcase.Reply_From_Registration_Patient__c = true;
                    System.debug('=======> emailmessageMap : ' + emailmessageMap.get(tcase.Id).MessageDate);
                    tcase.Patient_Reply_to_Registration_DateTime__c = emailmessageMap.get(tcase.Id).MessageDate;
                    System.debug('Case Id with reply mail : ' + tcase.Id);
                    userid = new List<String>();
                    userid.add(tcase.OwnerId);
    
                    inbody = 'CaseNumber has reply email from the patient:' + tcase.CaseNumber;
                    inTitle = 'This case number has new reply email from the patient : ' + tcase.CaseNumber;
    
                    targetId = tcase.id ;
                    System.debug('######## RunTrigger after Notification inbody:' + inbody);
                    
                    sendtouser( userid, targetid, inTitle, inbody);
            	}
                update listReplyMailinCase;
            }
        }
    } 
    public class CustomNotificationActionInput
    {
        public String customNotifTypeId { get; set; }
        public List<String> recipientIds { get; set; }
        public String title { get; set; }
        public String body { get; set; }
        public String targetId { get; set; }
    }
    public class CustomNotificationAction
    {
        public List<CustomNotificationActionInput> inputs { get; set; }
    }
    @future(callout=true)
    public static void sendtouser ( List<String> userid,String approvalid ,
        String inTitle,String inbody){
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
            + '/services/data/v47.0/actions/standard/customNotificationAction');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        CustomNotificationActionInput input = new CustomNotificationActionInput();

        

        
        CustomNotificationType[] tNotiId =  
                [select id  from CustomNotificationType where DeveloperName ='New_Registration_Case'];
        String NotiId = tNotiId[0].id;
       
        input.customNotifTypeId = NotiId;
        input.recipientIds =  userid;
        input.title = inTitle;
        input.body = inbody;
        input.targetId = approvalid;

        
        System.debug('######## userid:' + userid[0]);
        System.debug('######## inTitle:' + inTitle);
        System.debug('######## body:' + inbody);
        System.debug('######## targetId:' + approvalid);

        CustomNotificationAction action = new CustomNotificationAction();
        action.inputs = new List<CustomNotificationActionInput>{input};
        req.setBody(JSON.serialize(action));
        HttpResponse res = h.send(req);
        System.debug(res.getBody());
}
}