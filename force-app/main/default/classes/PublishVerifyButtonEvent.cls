@RestResource(urlMapping='/PublishVerifyButtonEvent/*')
global class PublishVerifyButtonEvent {

    @HttpPost
    global static String publish(String caseId){
            try{
                            List<CasePlatformEventMapping__c> listCase = [select Id,Platform_Event_Channel__c,Case_Id__c from CasePlatformEventMapping__c WHERE Case_Id__c =: caseId];
                        
                            String s2 = listCase.get(0).Platform_Event_Channel__c+'';
                            Case c = [select Id,Platform_Event_Channel__c from Case where Id =: caseId];

                            String s = c.Platform_Event_Channel__c;
                            //s = '1';
                            s = s2;

                            if(s == '1'){
                                List<Publish_Verify_Button1__e> inkEvents = new List<Publish_Verify_Button1__e>();
                                inkEvents.add(new Publish_Verify_Button1__e(	Case_Id__c=caseId));


                                EventBus.publish(inkEvents);
                            }else if(s == '2'){
                                List<Publish_Verify_Button2__e> inkEvents = new List<Publish_Verify_Button2__e>();
                                inkEvents.add(new Publish_Verify_Button2__e(	Case_Id__c=caseId));


                                EventBus.publish(inkEvents);
                            }else if(s == '3'){
                                List<Publish_Verify_Button3__e> inkEvents = new List<Publish_Verify_Button3__e>();
                                inkEvents.add(new Publish_Verify_Button3__e(	Case_Id__c=caseId));


                                EventBus.publish(inkEvents);
                            }else if(s == '4'){
                                List<Publish_Verify_Button4__e> inkEvents = new List<Publish_Verify_Button4__e>();
                                inkEvents.add(new Publish_Verify_Button4__e(	Case_Id__c=caseId));


                                EventBus.publish(inkEvents);
                            }else if(s == '5'){
                                List<Publish_Verify_Button5__e> inkEvents = new List<Publish_Verify_Button5__e>();
                                inkEvents.add(new Publish_Verify_Button5__e(	Case_Id__c=caseId));


                                EventBus.publish(inkEvents);
                            }else if(s == '6'){
                                List<Publish_Verify_Button6__e> inkEvents = new List<Publish_Verify_Button6__e>();
                                inkEvents.add(new Publish_Verify_Button6__e(	Case_Id__c=caseId));


                                EventBus.publish(inkEvents);
                            }else if(s == '7'){
                                List<Publish_Verify_Button7__e> inkEvents = new List<Publish_Verify_Button7__e>();
                                inkEvents.add(new Publish_Verify_Button7__e(	Case_Id__c=caseId));


                                EventBus.publish(inkEvents);
                            }else if(s == '8'){
                                List<Publish_Verify_Button8__e> inkEvents = new List<Publish_Verify_Button8__e>();
                                inkEvents.add(new Publish_Verify_Button8__e(	Case_Id__c=caseId));


                                EventBus.publish(inkEvents);
                            }else if(s == '9'){
                                List<Publish_Verify_Button9__e> inkEvents = new List<Publish_Verify_Button9__e>();
                                inkEvents.add(new Publish_Verify_Button9__e(	Case_Id__c=caseId));


                                EventBus.publish(inkEvents);
                            }else if(s == '10'){
                                List<Publish_Verify_Button10__e> inkEvents = new List<Publish_Verify_Button10__e>();
                                inkEvents.add(new Publish_Verify_Button10__e(	Case_Id__c=caseId));


                                EventBus.publish(inkEvents);
                            }



                            return caseId;
            }catch(Exception ex){
                return '';
                }
                

    }
}