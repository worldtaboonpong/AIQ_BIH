({
 searchHelper : function(component,event,getInputkeyWord) {
     
     var title = component.get("v.knowledgetitle");
   // call the apex class method 
     var action = component.get("c.fetchLookUpUserValues");
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord, /*,
            'ObjectName' : component.get("v.objectAPIName")*/
            'title' : title
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
                //alert('storeResponse : '+storeResponse);
                //alert('id : '+storeResponse[0].Id + '   Title : '+storeResponse[0].Title);
                //alert('id : '+storeResponse[1].Id + '   Title : '+storeResponse[1].Title);
                //alert('id : '+storeResponse[2].Id + '   Title : '+storeResponse[2].Title);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
 },
})