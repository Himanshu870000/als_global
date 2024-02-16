({
	doInit:function(component,event,helper){  
         debugger;
        var action = component.get("c.CopyBillingAddressData");
        action.setParams({  
            "AccountId":component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            if(state==='SUCCESS'){
                if(storeResponse=='SUCCESS'){
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Shipping Address Updated',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    window.location.reload();  
                }else{
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:storeResponse,
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire(); 
                }
               
            }else{
                $A.get("e.force:closeQuickAction").fire();
            }    
        });
        $A.enqueueAction(action);
    }
})