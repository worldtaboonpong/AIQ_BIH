({
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
         var forOpen = component.find("searchRes");
             $A.util.addClass(forOpen, 'slds-is-open');
             $A.util.removeClass(forOpen, 'slds-is-close');
         // Get Default 5 Records order by createdDate DESC  
          var getInputkeyWord = '';
          helper.searchHelper(component,event,getInputkeyWord);
     },
     onblur : function(component,event,helper){       
         component.set("v.listOfSearchRecords", null );
         var forclose = component.find("searchRes");
         $A.util.addClass(forclose, 'slds-is-close');
         $A.util.removeClass(forclose, 'slds-is-open');
     },
     keyPressController : function(component, event, helper) {
        // get the search Input keyword   
          var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
         if( getInputkeyWord.length > 0 ){
              var forOpen = component.find("searchRes");
                $A.util.addClass(forOpen, 'slds-is-open');
                $A.util.removeClass(forOpen, 'slds-is-close');
             helper.searchHelper(component,event,getInputkeyWord);
         }
         else{  
              component.set("v.listOfSearchRecords", null ); 
              var forclose = component.find("searchRes");
                $A.util.addClass(forclose, 'slds-is-close');
                $A.util.removeClass(forclose, 'slds-is-open');
           }
     },
     
   // function for clear the Record Selaction 
     clear :function(component,event,heplper){
          var pillTarget = component.find("lookup-pill");
          var lookUpTarget = component.find("lookupField"); 
         
          $A.util.addClass(pillTarget, 'slds-hide');
          $A.util.removeClass(pillTarget, 'slds-show');
         
          $A.util.addClass(lookUpTarget, 'slds-show');
          $A.util.removeClass(lookUpTarget, 'slds-hide');
       
          component.set("v.SearchKeyWord",null);
          component.set("v.listOfSearchRecords", null );
          component.set("v.selectedRecord", {} );
          component.set("v.knowledgeid","");
          component.set("v.knowledgetitle","");
          component.set("v.booleanShowKMS",false);

          console.log('clear account occured');
          var cmpEvent = component.getEvent("cmpClearAddressDataEvent");
          cmpEvent.setParams({
              "val" : 1 
          });
          cmpEvent.fire();

          var tabEvent =  $A.get("e.c:tabActiveCustomerSearchEvent");
          tabEvent.setParam("tabActive","ClearValue");
          tabEvent.fire();

          component.set("v.selectedRecord", {} );
          component.set("v.knowledgeid","");
          component.set("v.knowledgetitle","");
          component.set("v.booleanShowKMS",false);
          //alert('Clear1');
     },
     clearPills : function(component,event){
          var pillTarget = component.find("lookup-pill");
          var lookUpTarget = component.find("lookupField"); 
         
          $A.util.addClass(pillTarget, 'slds-hide');
          $A.util.removeClass(pillTarget, 'slds-show');
         
          $A.util.addClass(lookUpTarget, 'slds-show');
          $A.util.removeClass(lookUpTarget, 'slds-hide');
       
          component.set("v.SearchKeyWord",null);
          component.set("v.listOfSearchRecords", null );
          component.set("v.selectedRecord", {} );
          component.set("v.knowledgeid","");
          component.set("v.knowledgetitle","");
          component.set("v.booleanShowKMS",false);

          console.log('clear pill user occured');
          //alert('Clear2 pill');
    },

     showPills : function(component,event,helper){
      var forclose = component.find("lookup-pill");
      $A.util.addClass(forclose, 'slds-show');
      $A.util.removeClass(forclose, 'slds-hide');

      var forclose = component.find("searchRes");
          $A.util.addClass(forclose, 'slds-is-close');
          $A.util.removeClass(forclose, 'slds-is-open');
   
      var lookUpTarget = component.find("lookupField");
          $A.util.addClass(lookUpTarget, 'slds-hide');
          $A.util.removeClass(lookUpTarget, 'slds-show'); 
      console.log('Showpills in User method call');
     },
     
   // This function call when the end User Select any record from the result list.   
     handleComponentEvent : function(component, event, helper) {
     // get the selected User record from the COMPONETN event   
        var selectedUserGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedUserGetFromEvent); 
        if (selectedUserGetFromEvent.Id != undefined){
          component.set("v.knowledgeid",selectedUserGetFromEvent.Id);
          component.set("v.knowledgetitle",selectedUserGetFromEvent.Title);
        }else{
          component.set("v.knowledgeid","");
          component.set("v.knowledgetitle","");
          component.set("v.booleanShowKMS",false);
        }        
        
         var forclose = component.find("lookup-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
   
         var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
         
         var lookUpTarget = component.find("lookupField");
             $A.util.addClass(lookUpTarget, 'slds-hide');
             $A.util.removeClass(lookUpTarget, 'slds-show');  
       
     },
 })