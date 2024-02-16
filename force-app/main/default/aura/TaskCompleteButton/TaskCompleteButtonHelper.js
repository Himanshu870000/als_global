({
    processTask: function(component, taskId) {
        var action = component.get("c.processTaskRecord");
        action.setParams({
            "taskId": taskId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                
                if (result.errorMsg) {
                    
                    component.set("v.errorMsg", result.errorMsg);
                    component.set("v.successMsg", ''); 
                } else {
                    
                    component.set("v.successMsg", "Task marked as completed successfully.");
                    component.set("v.errorMsg", ''); 

                    
                    var notifLib = component.find('notifLib');
                    notifLib.showToast({
                        "title": "Success",
                        "message": "Task marked as completed successfully.",
                        "variant": "success"
                    });

                    
                    $A.get('e.force:refreshView').fire();
                    
                    
                    $A.get("e.force:closeQuickAction").fire();
                }
            } else {
                console.log("Error processing task");
            }
        });

        $A.enqueueAction(action);
    }
})