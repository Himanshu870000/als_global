({
    doInit: function(component, event, helper) {
        var taskId = component.get("v.recordId");

        // Call the server-side controller method to handle the reopen logic
        helper.processReopenTask(component, taskId);
    }
})