({
    doInit: function (component, event, helper) {
        debugger;
        component.set("v.showModal", true);
        var action = component.get("c.SetAsyncToFalse"); // Correct method name
        action.setParams({
            quoteId: component.get("v.recordId"),
            markAsSyncing: false
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('>>>>> state' + state);
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: 'Success',
                    message: 'Quote Line Items have been Asynced',
                    duration: ' 3000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();

            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: 'Error',
                    message: 'Error Occurred',
                    duration: ' 2000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            $A.get('e.force:refreshView').fire();
        })
        $A.enqueueAction(action);
    },

    hideModel: function (component, event, helper) {
        component.set("v.showModal", false);
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
})