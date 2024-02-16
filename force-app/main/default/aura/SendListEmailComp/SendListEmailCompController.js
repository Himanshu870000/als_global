({
    onPageReferenceChange : function(component, event, helper) {
        debugger;
        var myPageRef = component.get("v.pageReference");
        
        var ContactsList = myPageRef.state.c__listofContacts; 
        
        component.set("v.conSelectedId" ,ContactsList);
        if (ContactsList.length < 0 || ContactsList == ""){
            helper.showWarning(component, event);
            var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewContactId" : label,
                "listViewName" : "All Contacts",
                "scope" : "Contact"
            });
            navEvent.fire();
        }else{
            var action = component.get("c.LeadsToSendEmail");
            var EmailIdToSend = component.get("v.conSelectedId");
            
            action.setParams({
                "LeadsIds" : EmailIdToSend
            });
            action.setCallback(this, function(response){
                var State = response.getState();
                if(State === "SUCCESS"){
                    var data = response.getReturnValue();
                    console.log("data",data)
                    helper.successMessage(component, event);
                    var navEvent = $A.get("e.force:navigateToList");
                    navEvent.setParams({
                        "listViewContactId" : label,
                        "listViewName" : "All Contacts",
                        "scope" : "Contact"
                    });
                    navEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
    },
})