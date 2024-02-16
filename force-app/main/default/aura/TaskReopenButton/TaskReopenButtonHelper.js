({
    processReopenTask: function(component, taskId) {
        var action = component.get("c.processReopenTaskRecord");
        action.setParams({
            "taskId": taskId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Reopen success case, handle it accordingly
                var notifLib = component.find('notifLib');
                notifLib.showToast({
                    "title": "Success",
                    "message": "Task reopened successfully!",
                    "variant": "success"
                });
                
                // Refresh the view to reflect the changes in real-time
                $A.get('e.force:refreshView').fire();

                // Close the quick action modal
                $A.get("e.force:closeQuickAction").fire();

                
            } else {
                console.log("Error reopening task");
            }
        });

        $A.enqueueAction(action);
    }
})