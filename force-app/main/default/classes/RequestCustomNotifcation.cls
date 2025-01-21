public class RequestCustomNotifcation implements Queueable {
    
    public void execute(QueueableContext context)
    {
        List<case> listNotiCase = [ select id,OwnerId, Escalate_Date__c,Escalate_More_Than_24_Hour__c ,
                                Escalate_Date_Over_Than_24_Hours__c,CaseNumber 
                           from case 
                           where Escalate_Date__c  <    : datetime.now().AddDays(-1)
                           //where Escalate_Date__c  <    : datetime.now().addMinutes(-2)
                           and (Owner.name != 'Medical Enquiry Team' or   
                                Owner.UserRole.name !=  'BIH Medical Enquiry' )
                           and  ( Is_MCO__c = true    or    Is_Escalate_To_MCO__c = true )
                           and (Escalate_More_Than_24_Hour__c = true)
                           and (Status != 'Closed')
                           and Sent_Notify_by_Medical_Enquiry__c = false
                           ];
        List<String> userid = new List<String>();

        String inbody = 'Hello';
        String inTitle = 'Test Title';

        String targetId ;
        System.debug('######## RunTrigger after inbody:' + inbody);
        if(listNotiCase.size() > 0)
        {
            for(case tcase : listNotiCase)
            {
                
                System.debug('######## tcase.id :' + tcase.id );
                //if( tcase.id =='5000k00000DPYiyAAH')
                {
                    tcase.Sent_Notify_by_Medical_Enquiry__c = true;
    
                    userid = new List<String>();
                    userid.add(tcase.OwnerId);
    
                    inbody = 'Greeting from Medical Enquiry, Can we know the progress of this case number :' + tcase.CaseNumber;
                    inTitle = 'Follow up More Than 24 hour escalated case from Medical Enquiry Team Case Number : ' + tcase.CaseNumber;
    
                    targetId = tcase.id ;
                    System.debug('######## RunTrigger after inbody:' + inbody);
                    
                    sendtouser( userid, targetid, inTitle, inbody);

                }
            }
            update listNotiCase;
            
        }
    }

    public  RequestCustomNotifcation() 
    {
       
       
    }

    // private List<String> userid;
    // private String targetid ;
    // private String inTitle;
    // private String inbody;
    // public  RequestCustomNotifcation(List<String> userid,String targetid ,
    // String inTitle,String inbody) 
    // {
    //     this.userid = userid;
    //     this.targetid = targetid;
    //     this.inTitle = inTitle;
    //     this.inbody = inbody;
       
    // }

    
    
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
                [select id  from CustomNotificationType where DeveloperName ='Follow_Up_Clinic_from_MCO'];
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