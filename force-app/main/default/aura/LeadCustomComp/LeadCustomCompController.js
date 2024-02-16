({
    handleSelect : function (component, event, helper) {
        debugger;
        var stepName = event.getParam("detail").value;
        var toastEvent = $A.get("e.force:showToast");
        if(stepName == 'Convert'){
            toastEvent.setParams({
                title : 'Error',
                message:'Please use the Convert Lead Button to convert the lead.',
                type: 'error',
            });
            toastEvent.fire();
            return;
        }else{
            component.set("v.PicklistField.Lead_Status__c", stepName);
            component.find("record").saveRecord($A.getCallback(function(response) {
                if (response.state === "SUCCESS") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Status Successfullly Updated!!',
                        type: 'success',
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: response.error[0].message,
                        type: 'error',
                    });
                    toastEvent.fire();
                }
            }));    
        }
    }
})